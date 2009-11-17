class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
    @body[:url]  = "http://#{APP_CONFIG[:domain]}/activate/#{user.activation_code}"
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = "http://#{APP_CONFIG[:domain]}/"
  end
  
  def unsubscribe_request(user)
    setup_email(user)
    @subject    += 'You have requested to unsubscribe'
  end

  def product_purchase_confirmation(user, order)
    user = user || User.new(:email => order.cart.addresses.find_by_address_type('billing').email)
    setup_email(user, User.admin)
    @subject += 'Payment Confirmation'
    @body[:order] = order
    @body[:cart] = order.cart
  end
  
  def suscription_confirmation(user, order)
    setup_email(user, User.admin)
    @subject += 'Suscription Confirmation'
    @body[:order] = order
    @body[:user] = user
  end
  
  def product_purchase_declined(user, order)
    user = user || User.new(:email => order.cart.addresses.find_by_address_type('billing').email)
    setup_email(user, User.admin)
    @subject += 'Payment Declined'
    @body[:order] = order
    @body[:cart] = order.cart
  end
  
  def suscription_confirmation_declined(user, order)
    setup_email(user, User.admin)
    @subject += 'Suscription Declined'
    @body[:order] = order
    @body[:user] = user
  end
  
  protected
    def setup_email(user, copy_to=nil)
      @recipients  = "#{user.email}"
      @recipients += ", #{copy_to.email}" unless copy_to.nil?
      @from        = "contacto@#{APP_CONFIG[:domain]}"
      @subject     = "[Winnamoney] "
      @sent_on     = Time.now
      @content_type = "text/html"
      @body[:user] = user
    end
end
