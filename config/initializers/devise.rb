# frozen_string_literal: true

Devise.setup do |config|
  config.mailer_sender = "please-change-me@example.com"
  require "devise/orm/active_record"

  # Load JWT
  require "devise/jwt"

  config.jwt do |jwt|
    jwt.secret = Rails.application.credentials.devise_jwt_secret_key!
    jwt.dispatch_requests = [
      ["POST", %r{^/api/v1/users/sign_in$}]
    ]
    jwt.revocation_requests = [
      ["DELETE", %r{^/api/v1/users/sign_out$}]
    ]
    jwt.expiration_time = 24.hours.to_i
  end

  # config.skip_session_storage = %i[http_auth params_auth]
  # config.navigational_formats = []
  # config.parent_controller = "ActionController::API"
end
