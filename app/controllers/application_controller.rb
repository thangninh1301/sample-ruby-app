# frozen_string_literal: true

# fix rubocop
class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  def to_last_url
    if request.referrer.nil? || request.referrer == microposts_url
      redirect_to root_url
    else
      redirect_to request.referrer
    end
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[name email password password_confirmation remember_me]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
    devise_parameter_sanitizer.permit :sign_in, keys: %i[password email]
  end

  def authenticate_user!
    if user_signed_in?
      super
    else
      redirect_to login_url, notice: 'need to sign_in first'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end
end
