# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.perform_deliveries = false
config.action_mailer.raise_delivery_errors = false

  
config.after_initialize do
  ActiveMerchant::Billing::Base.mode = :test
  
  paypal_options = {
    :login => "wsell_1257058028_biz_api1.innku.com",
    :password => "1257058061",
    :signature => "A8vRYyLBrwgszDoaGl7GW6XElR-6Aco-MRZNFvTcS4QLMyKGEqUXHMg8"
  }
  
  ::STANDARD_GATEWAY = ActiveMerchant::Billing::PaypalGateway.new(paypal_options)
  ::EXPRESS_GATEWAY = ActiveMerchant::Billing::PaypalExpressGateway.new(paypal_options)
end