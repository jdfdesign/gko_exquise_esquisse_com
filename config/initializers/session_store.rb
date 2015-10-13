# Be sure to restart your server when you modify this file.
# If you wish to maintain sessions between the main site and subdomain-hosted sites, modify the configuration file to add the parameter :domain => :all
GkoExquiseExquisseCom::Application.config.session_store :cookie_store, :key => "#{APP_CONFIG["session_store_key"]}", :domain => :all
                                   
# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# GkoExquiseExquisseCom::Application.config.session_store :active_record_store

