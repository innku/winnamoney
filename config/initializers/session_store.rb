# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_winnamoney_session',
  :secret      => '5fc0547833198b50e563b93ace2ca4e9e5c3de15e65999cafb5295b79ca531bebfed0041b27a26ac3c0509a3edbaf61a7021562f6b71257012d626c0528ab5e5'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
