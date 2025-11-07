class PaymentsController < ApplicationController
  before_action :authenticate_user!

  # list all payments for current_user
  def index
    @payments = current_user.payments.includes(:project)
    render json: @payments
  end

  # create a mock payment (later replaced by stripe checkout)
  def create
    # Rails.logger.info "Received params: #{params.inspect}"
    @payment = current_user.payments.build(payment_params)

    if @payment.save
      render json: { message: "Payment Created", payment: @payment }, status: :created
    else
      render json: { errors: @payment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def payment_params
    params.expect(payment: %i[project_id amount provider])
  end
end
