# Be sure to restart your server when you modify this file.

# ElStudycenter::Application.config.session_store :cookie_store, :key => '_el_studycenter_session'
 # ElStudycenter::Application.config.session_store :cookie_store, :key => '_eleutian_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
ActiveRecord::SessionStore::Session.acts_as_remote :el_user, :readonly => false
ElStudycenter::Application.config.session_store :active_record_store

