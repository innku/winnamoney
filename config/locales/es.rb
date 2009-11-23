# Sample localization file for English. Add more files in this directory for other locales.
# See http://github.com/svenfuchs/rails-i18n/tree/master/rails%2Flocale for starting points.
{
  :'es' => {
     :stores => {
       :text => {
         :title => 'Crea tu tienda',
         :header => 'Informaci&oacute;n de la tienda',
         :payment_needed => '* La posici&oacute;n que escofiste para tu referido ser&aacute; asignada apenas se complete el pago',
         :position => '* Este usuario ser&aacute; posicionado autom&aaacute;ticamente con la l&oacute;gica que seleccionaste',
         :home => {
           :welcome => 'Bienvenido a',
           :register => 'Reg&iacute;strate aqu&iacute;',
           :or => 'o',
           :signin => 'Ingresa',
           :listing => 'Listando',
           :of => 'de',
           :products => 'productos',
           :available => 'Esta tienda esta disponible en'
         }
       },
       :labels => {
          :name => 'Nombre de la tienda',
          :language => 'Idioma',
          :sponsor_name => 'Nombre o ID de tu sponsor (Si cuentas con uno)',
          :positioning => 'Posicionamiento',
          :submit => 'Guardar Usuario'
        }
     },
     :users => {
        :text => {
          :title => 'Crea tu tienda',
          :header => 'Informaci&oacute;n del Usuario',
          :account_header => 'Informaci&oacute;n de la Cuenta'
        },
        :labels => {
           :names => 'Nombres',
           :last_names => 'Apellidos',
           :city => 'Ciudad',
           :address1 => 'Direcci&oacute;n 1',
           :address2 => 'Direcci&oacute;n 2',
           :zip => 'C&oacute;digo Postal',
           :phone => 'N&uacute;mero Telef&oacute;nico',
           :fax => 'N&uacute;mero de Fax',
           :cell => 'N&uacute;mero Celular',
           :email => 'Correo Electr&oacute;nico',
           :password => 'Contrase&ntilde;a',
           :confirm_password => 'Confirmar Contrase&ntilde;a',
           :account_type => 'Tipo de cuenta',
           :account_type_check => 'Cheques',
           :account_type_savings => 'Ahorros',
           :account_number => 'N&uacute;mero de cuenta',
           :routing => 'Routing del banco',
           :submit => 'Guardar Usuario'
         }
      },
      :orders => {
          :text => {
            :title => {
              :suscription => 'Crea tu tienda',
              :product_purchase => 'Comprar'
            },
            :header => 'Confirmar suscripci&oacute;n y completar pago',
            :header_checkout => 'Completa tu pago', 
            :store_name => 'Nombre de la tienda',
            :amount => 'Cantidad',
            :contact_me1 => 'Si quieres que te contactemos personalmente para completar tu transacci&oacute;n',
            :contact_me2 => 'Por favor haz click en el siguiente bot&oacute;n',
            :paypal => 'Para finalizar la compra utilizando Paypal Express, haz click en el siguiente bot&oacute;n.',
            :success => {
              :title_payment_successful => 'Pago Exitoso',
              :header_payment_successful => 'Tu pago se ha procesado con &eacute;xito!',
              :title_register_successful => 'Registro Exitoso',
              :header_register_successful => 'Tu ord&eacute;n se ha guardado con &eacute;xito!',
              :confirmation_number => 'El n&uacute;mero de confirmaci&oacute;n de tu orden es: ',
              :credit_card1 => 'Recibir&aacute;s un correo electr&oacute;nico para activar tu cuenta y comenzar a vender',
              :deposit1 => "Estaremos esperando tu dep&oacute;sito",
              :deposit2 => "Recibir&aacute;s un correo electr&oacute;nico para activar tu cuenta",
              :contact1 => "Recibir&aacute;s un correo electr&oacute;nico para activar tu cuenta",
              :contact2 => "Estaremos en contacto contigo muy pronto para completar tu transacci&oacute;n"
              
            },
            :declined => {
              :title => 'Pago Declinado',
              :header => 'Tu pago ha sido declinado',
              :declined1 => "No te preocupes, no hemos deducido dinero de tu tarjeta de cr&eacute;dito.",
              :declined2 => "Por favor ponte en contacto con tu banco e intenta la transacci&oacute;n nuevamente."
            }
          },
          :labels => {
             :payment_type => 'Tipo de pago',
             :credit_card => 'Tarjeta de Cr&eacute;dito/D&eacute;bito',
             :bank_deposit => 'Dep&oacute;sito Bancario',
             :other => 'Otro',
             :first_name => 'Nombre',
             :last_name => 'Apellido',
             :card_type => 'Tipo de tarjeta',
             :card_number => 'N&uacute;mero de la tarjeta',
             :cvv => 'Valor de Verificaci&oacute;n de la tarjeta(CVV)',
             :expires_on => 'La tarjeta expira en',
             :submit_credit => 'Completar Pago',
             :account_type => 'Tipo de Cuenta',
             :account_type_check => 'Cheques',
             :account_type_savings => 'Ahorros',
             :account_number => 'N&uacute;mero de Cuenta',
             :routing => 'Routing del Banco',
             :submit_deposit => 'Completar Suscripci&oacute;n',
             :submit_contact => 'Cont&aacute;ctenme'
           }
        }   ,
       :carts => {
         :no_items => 'No tienes items en tu carrito',
         :title => 'Comprar',
         :header => 'Revisa tu &oacute;rden',
         :table => {
           :name => 'Nombre',
           :unit => 'Precio unitario',
           :quantity => 'Cantidad',
           :remove => 'Quitar',
           :price => 'Precio',
           :shipping => 'Env&iacute;o',
           :handling => 'Manejo',
         }
       },
       :addresses => {
         :text => {
          :header => 'Env&iacute;o y Facturaci&oacute;n',
          :billing => 'Direcci&oacute;n de facturaci&oacute;n',
          :shipping => 'Direcci&oacute;n de env&iacute;o',
         },
         :labels => {
            :names => 'Nombres',
            :last_names => 'Apellidos',
            :full_name => 'Nombre Completo',
            :city => 'Ciudad',
            :address => 'Direcci&oacute;n',
            :address1 => 'Direcci&oacute;n 1',
            :address2 => 'Direcci&oacute;n 2',
            :zip => 'C&oacute;digo Postal',
            :phone => 'N&uacute;mero de tel&eacute;fono',
            :email => 'Correo Electr&oacute;nico',
         }
       },
       :images => {
         :search => 'buscar.png',
         :checkout => 'comprarcarrito.png',
         :sac => 'gyc.png',
         :add => 'agregarchico.png',
         :bigadd => 'agregar.png',
         :complete => "completar.png",
         :finish => 'susc.png',
       },
       :classes => {
         :cart => 'spanish_cart'
       },
       :steps => {
         :step1 => 'Paso uno',
         :step2 => 'Paso dos',
         :step3 => 'Paso tres',
         :step4 => 'Paso cuatro',
         :confirmation => 'Confirmaci&oacute;n',
         :suscription => {
           :store_info => 'Ingresa la informaci&oacute;n de tu tienda',
           :contact_info => 'Ingresa tu informaci&oacute;n de contacto y de cuenta',
           :payment_info => 'Completa tu pago',
         },
         :checkout => {
           :review => 'Revisa tu &oacute;rden',
           :payment => 'Completa tu pago',
         }
       },
       :number => {
         :format => {
           :precision => 3,
           :separator => '.',
           :delimiter => '.'
         },
         :currency => {
           :format => {
             :unit => '$',
             :precision => 2,
             :format => '%u %n'
           }
         }
       },
       :activerecord => {
         :errors => {
           :template => {
             :header => 'Se encontraron errores en la forma',
             :body => 'Hubo problemas con los siguientes campos:'
           }
         }
       }
  }
}