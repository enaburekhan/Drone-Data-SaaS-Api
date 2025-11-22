module Users
  class SessionsController < Devise::SessionsController
    respond_to :json

    private

    # Extract jWT token from warden after login
    def respond_with(resource, _opts = {})
      token = request.env["warden-jwt_auth.token"]

      render json: {
        message: "Logged in Successfully",
        token: token,
        user: {
          id: resource.id,
          email: resource.email
        }
      }, status: :ok
    end

    # after logout
    def respond_to_on_destroy
      render json: { message: "Logged out successsfully." }, status: :ok
    end
  end
end
