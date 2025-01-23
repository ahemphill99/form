class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!
  protect_from_forgery with: :exception
  
  before_action :debug_session
  
  private
  
  def debug_session
    if Rails.env.development?
      Rails.logger.debug "Session: #{session.inspect}"
      Rails.logger.debug "Warden: #{warden.inspect}"
      reset_session if current_user.is_a?(Array) # Clear corrupted session
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
