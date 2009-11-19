# Sample localization file for English. Add more files in this directory for other locales.
# See http://github.com/svenfuchs/rails-i18n/tree/master/rails%2Flocale for starting points.
{
  :'en' => {
     :stores => {
       :text => {
         :title => 'Register',
         :header => 'Store Information',
         :payment_needed => '* The position you selected for your referral will be taken as soon as payment is complete',
         :position => '* This user will be positioned automatically with your selected logic'
       },
       :labels => {
          :name => 'Store Name',
          :language => 'Language',
          :sponsor_name => 'Sponsor Name or ID (If you have one)',
          :positioning => 'Positioning',
          :submit => 'Save User'
        }
     },
     :users => {
        :text => {
          :title => 'Register',
          :header => 'User Information',
          :account_header => 'Account Information'
        },
        :labels => {
           :names => 'Names',
           :last_names => 'Last Names',
           :city => 'City',
           :address1 => 'Address 1',
           :address2 => 'Address 2',
           :zip => 'Zip Code',
           :phone => 'Phone Number',
           :fax => 'Fax Number',
           :cell => 'Cell Phone Number',
           :email => 'E-mail',
           :password => 'Password',
           :confirm_password => 'Confirm Password',
           :account_type => 'Account Type',
           :account_type_check => 'Check',
           :account_type_savings => 'Savings',
           :account_number => 'Account Number',
           :routing => 'Bank Routing',
           :submit => 'Save User'
         }
      },
      :orders => {
          :text => {
            :title => 'Register',
            :header => 'Confirm suscription and complete payment',
            :store_name => 'Store Name',
            :amount => 'Amount',
            :contact_me1 => 'If you want us to contact you personally to complete your transaction.',
            :contact_me2 => 'Please click on the following button.',
            :success => {
              :title_payment_successful => 'Payment Successful',
              :header_payment_successful => 'Your Payment was processed successfully!',
              :title_register_successful => 'Register Successful',
              :header_register_successful => 'Your Order was registered successfully!',
              :confirmation_number => 'Your order confirmation number is: ',
              :credit_card_1 => 'You will receive a confirmation E-mail to activate your account and start selling',
              :deposit1 => "We will be waiting for your deposit",
              :deposit2 => "You will receive a confirmation E-mail to activate your account",
              :contact1 => "You will receive a confirmation E-mail to activate your account",
              :contact2 => "We will be in touch with you soon to complete this transaction"
              
            },
            :declined => {
              :title => 'Payment Declined',
              :header => 'Your Payment was declined',
              :declined1 => "Don't Worry, we haven't deducted any money from your credit card.",
              :declined2 => "Please check with your bank and try again."
            }
          },
          :labels => {
             :payment_type => 'Payment Type',
             :credit_card => 'Credit/Debit Card',
             :bank_deposit => 'Bank Deposit',
             :other => 'Other',
             :first_name => 'First Name',
             :last_name => 'Last Name',
             :card_type => 'Card Type',
             :card_number => 'Card Number',
             :cvv => 'Card Verification Value(CVV)',
             :expires_on => 'Card Expires On',
             :submit_credit => 'Complete Payment',
             :account_type => 'Account Type',
             :account_type_check => 'Check',
             :account_type_savings => 'Savings',
             :account_number => 'Account Number',
             :routing => 'Bank Routing',
             :submit_deposit => 'Finish Suscription',
             :submit_contact => 'Contact Me'
           }
        }
  }
}