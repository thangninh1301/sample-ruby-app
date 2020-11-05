class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    generic_callback('facebook')
  end

  def google_oauth2
    generic_callback('google_oauth2')
  end

  def generic_callback(_provider)
    @user = User.from_omniauth(request.env['omniauth.auth'],_provider)
    if @user.persisted?
      reset_session
      log_in resource
    end
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end
end