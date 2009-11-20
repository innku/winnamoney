# Sample localization file for English. Add more files in this directory for other locales.
# See http://github.com/svenfuchs/rails-i18n/tree/master/rails%2Flocale for starting points.
{
  :'en' => {
     :stores => {
       :text => {
         :title => 'Create your store',
         :header => 'Store Information',
         :payment_needed => '* The position you selected for your referral will be taken as soon as payment is complete',
         :position => '* This user will be positioned automatically with your selected logic',
         :home => {
           :welcome => 'Welcome to',
           :register => 'Register',
           :or => 'or',
           :signin => 'Signin',
           :listing => 'Listing',
           :of => 'of',
           :products => 'products',
           :available => 'This store is available in'
         }
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
          :title => 'Create your store',
          :header => 'User Information',
          :account_header => 'Account Information'
        },
        :labels => {
           :names => 'Names',
           :last_names => 'Last Names',
           :city => 'City Name',
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
            :title => {
              :suscription => 'Create your store',
              :product_purchase => 'Checkout'
            },
            :header => 'Confirm suscription and complete payment',
            :header_checkout => 'Complete your payment', 
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
              :credit_card1 => 'You will receive a confirmation E-mail to activate your account and start selling',
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
        },
      :carts => {
        :no_items => 'You have no items on your cart',
        :title => 'Checkout',
        :header => 'Review your order',
        :table => {
          :name => 'Name',
          :unit => 'Unit Price',
          :quantity => 'Quantity',
          :remove => 'Remove',
          :price => 'Price',
          :shipping => 'Shipping',
          :handling => 'Handling',
        }
      },
      :addresses => {
        :text => {
         :header => 'Delivery and Billing',
         :billing => 'Billing Address',
         :shipping => 'Shipping Address',
        },
        :labels => {
           :names => 'Names',
           :last_names => 'Last Names',
           :full_name => 'Full Name',
           :city => 'City Name',
           :address => 'Address',
           :address1 => 'Address 1',
           :address2 => 'Address 2',
           :zip => 'Zip Code',
           :phone => 'Phone Number',
           :email => 'E-mail',
        }
      },
      :images => {
        :search => 'search.png',
        :checkout => 'checkoutcart.png',
        :sac => 'savecontinue.png',
      },
      :steps => {
        :step1 => 'Step One',
        :step2 => 'Step Two',
        :step3 => 'Step Three',
        :step4 => 'Step Four',
        :confirmation => 'Confirmation',
        :suscription => {
          :store_info => 'Enter your store information',
          :contact_info => 'Enter your contact and account information',
          :payment_info => 'Complete payment',
        },
        :checkout => {
          :review => 'Review your order',
          :payment => 'Complete payment',
        }
      }
  }
}