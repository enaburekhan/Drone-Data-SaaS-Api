module Users
  class RegistrationsController < Devise::RegistrationsController
    respond_to :json

    private

    def respond_with(resource, _opts = {})
      if resource.persisted?
        token = request.env["warden-jwt_auth.token"]

        render json: {
          message: "Signed up successfully.",
          token: token,
          user: {
            id: resource.id,
            email: resource.email
          }
        }, status: :ok
      else
        render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
end
