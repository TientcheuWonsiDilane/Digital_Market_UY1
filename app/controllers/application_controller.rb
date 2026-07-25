class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :authenticate_user!, unless: :devise_or_public?
  before_action :redirect_authenticated_from_home
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def devise_or_public?
    devise_controller? || 
    (controller_name == "pages" && action_name == "home") ||
    (controller_name == "products") ||
    (controller_name == "stores" && (action_name == "index" || action_name == "show")) ||
    (controller_name == "items" && (action_name == "index" || action_name == "show"))
  end

  def redirect_authenticated_from_home
    if user_signed_in? && controller_name == "pages" && action_name == "home"
      redirect_to items_path
    end
  end

  def after_sign_in_path_for(resource)
    items_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
    devise_parameter_sanitizer.permit(:account_update, keys: [:username])
  end
end
