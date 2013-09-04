class ApplicationController < ActionController::Base
  include GDS::SSO::ControllerMethods

  protect_from_forgery

  rescue_from MongoMapper::DocumentNotFound, :with => :error_404

  private

  def error_404
    error 404, "not found"
  end

  def error(code, message)
    render :json => {:_response_info => {:status => message}}, :status => code
  end
end
