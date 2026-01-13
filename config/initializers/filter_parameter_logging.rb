# Be sure to restart your server when you modify this file.# Be sure to restart your server when you modify this file.








]  :passw, :secret, :token, :_key, :crypt, :salt, :certificate, :otp, :ssnRails.application.config.filter_parameters += [# See the ActiveSupport::ParameterFilter documentation for supported notations and behaviors.# Use this to limit dissemination of sensitive information.# Configure parameters to be partially matched (e.g. passw matches password) and filtered from the log file.
# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

# Rails.application.config.middleware.insert_before 0, Rack::Cors do
#   allow do
#     origins "example.com"
#
#     resource "*",
#       headers: :any,
#       methods: [:get, :post, :put, :patch, :delete, :options, :head]
#   end
# end
