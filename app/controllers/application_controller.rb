class ApplicationController < ActionController::API
  # @params errors Array
  def cannot_process(errors)
    render json: {
      message: 'Can not process',
      errors: errors
    }, status: :bad_request
  end

  # @params errors Array
  def not_found(errors)
    render json: {
      message: 'Not Found',
      errors: errors
    }, status: :not_found
  end

  def param_is_integer(param)
    param && param.to_i <= 0
  end
end
