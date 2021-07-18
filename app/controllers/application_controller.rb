class ApplicationController < ActionController::API
  def cannot_process(errors)
    render json: {
      message: 'Can not process',
      errors: errors
    }, status: :bad_request
  end

  def not_found(errors)
    render json: {
      message: 'Not Found',
      errors: errors
    }, status: :not_found
  end
end
