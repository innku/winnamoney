class PaymentInformation < ActiveRecord::Base
  set_table_name  "payment_information"
  belongs_to  :user
  
  validates_presence_of :account_number, :message => 'Debes proporcionar tu n&uacute;mero de cuenta',
                        :unless => :skip_validation
  validates_presence_of :account_type, :message => 'Debes proporcionar tu tipo de cuenta',
                        :unless => :skip_validation
  validates_presence_of :routing, :message => 'Debes proporcionar el routing del banco',
                        :unless => :skip_validation                        
  before_create         :contact_me
    
  def contact_me?
    contact_me
  end  
  
  protected
  
  def skip_validation
    contact_me
  end
  
end