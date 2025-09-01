class Users::SessionsController < Devise::SessionsController
    respond_to :json

    private

    # after login
    def respond_with(resource, opt={})
      render json: { message: "Logged in Successfully", user: resource }, status: :ok
    end

    # after logout
    def respond_to_on_destroy
      if current_user
        render json: { message: "Logged out successsfully." }, status: :no_content
      else
        render json: { error: "User not found." }, status: :unauthorized
      end
    end

    def sign_in(resource_name, resource)
      # do nothing - avoids disabled session error
    end
end
