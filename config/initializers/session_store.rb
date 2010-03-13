# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_recruitr_session',
  :secret      => '13a28d0ddb8969a9930d65ddc6f744ebaffcbe30f3b9bd7398d5a7714658d88ae097a27f406f8a309d5b37c9f36eb929642d15aef4eea85c79b1903d5e7e0aed'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
