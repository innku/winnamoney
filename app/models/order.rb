class Order < ActiveRecord::Base
  
  SUSCRIPTION = 189.00
  
  belongs_to  :user
  belongs_to  :cart
  has_many    :transactions, :class_name => "OrderTransaction"
  has_many    :payments
  
  validates_presence_of :account_number, :if => :deposit?
  validates_presence_of :account_type, :if => :deposit?
  validates_presence_of :routing, :if => :deposit? 
  validates_presence_of :ssn, :if => :deposit?
                             
  validate_on_create    :validate_card, :if => :credit_card?            
                        
  attr_accessor         :card_number, :card_verification
    
  def contact_me?
    contact_me
  end 
  
  def complete_with_user_info()
    unless user.nil?
      self.account_type = user.account_type
      self.account_number = user.account_number
      self.routing = user.routing
      self.ssn = user.ssn
      return self 
    end
    nil
  end 
  
  def deposit?
    self.payment_method == "deposit"
  end
  
  def credit_card?
    self.payment_method == "credit_card"
  end
  
  def contact_later?
    self.payment_method == "contact_later"
  end
  
  def suscription?
    self.order_type == "suscription"
  end
  
  def product_purchase?
    self.order_type == "product_purchase"
  end
  
  def purchase!
    if self.status != 'complete'
      response = process_purchase
      transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
      response.success?
    else
      return false
    end
  end

  def complete!
    self.status = 'complete'
    self.payments.create(:payment_method => 'credit_card', :amount => price_in_cents)
    if self.product_purchase?
      self.cart.complete!
      UserMailer.deliver_product_purchase_confirmation(self.user, self)
    elsif self.suscription?
      self.user.store.activate!
      UserMailer.deliver_suscription_confirmation(self.user, self)
    end
    self.save
  end
  
  def stand_by!
    self.status = 'stand_by'
    self.user.store.stand_by! if suscription?
    UserMailer.deliver_product_purchase_confirmation(self.user, self)
    self.save
  end
  
  def contact_me!
    self.status = 'contact_me'
    UserMailer.deliver_product_purchase_confirmation(self.user, self)
    self.user.store.contact_me! if suscription?
    self.save
  end
  
  def decline!
    self.status = 'declined'
    if self.product_purchase?
      UserMailer.deliver_product_purchase_declined(self.user, self.cart)
    elsif self.suscription?
      UserMailer.deliver_suscription_declined(self.user)
    end
    self.save
  end
  
  def express_token=(token)
    self[:express_token] = token
    if new_record? && !token.blank?
      details = EXPRESS_GATEWAY.details_for(token)
      self.express_payer_id = details.payer_id
      self.first_name = details.params["first_name"]
      self.last_name = details.params["last_name"]
    end
  end
  
  def price_in_cents
    if self.cart.nil?
      (SUSCRIPTION * 100).round
    else
      (self.cart.price * 100).round
    end
  end
  
  protected
  
  def process_purchase
    if express_token.blank?
      STANDARD_GATEWAY.purchase(price_in_cents, credit_card, standard_purchase_options)
    else
      EXPRESS_GATEWAY.purchase(price_in_cents, express_purchase_options)
    end
  end
  
  def standard_purchase_options
    {
      :ip => ip_address
    }
  end
  
  def express_purchase_options
    {
      :ip => ip_address,
      :token => express_token,
      :payer_id => express_payer_id
    }
  end
  
  def validate_card
    logger.warn "TOKEN: #{express_token}"
    if express_token.blank? && !credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors.add_to_base message
      end
    end
  end
  
  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :type               => card_type,
      :number             => card_number,
      :verification_value => card_verification,
      :month              => card_expires_on.month,
      :year               => card_expires_on.year,
      :first_name         => first_name,
      :last_name          => last_name
    )
  end
  
end