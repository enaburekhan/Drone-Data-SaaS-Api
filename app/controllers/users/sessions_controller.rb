class Users::SessionsController < Devise::SessionsController
    respond_to :json

    private

    def respond_with(resource, opt={})
      render json: { message: "Logged in Successfully", user: resource }, status: :ok
    end

    def respond_to_on_destroy
      head :no_content
    end
end
