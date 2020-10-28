class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    params.inspec
    generic_callback('facebook')
  end

  def google_oauth2
    generic_callback('google_oauth2')
  end

  def generic_callback(_provider)
    @user = User.from_omniauth(request.env['omniauth.auth'])
    return unless @user.persisted?

    reset_session
    log_in resource
    redirect_to root_path
  end

  def failure
    redirect_to root_path
  end
end
# def after_sign_in_path_for(resource)
#   if resource.class == User
#     reset_session
#     log_in resource
#   else
#     super
#   end
# end

# def sign_in_and_redirect(resource_or_scope, *args)
#   options  = args.extract_options!
#   scope    = Devise::Mapping.find_scope!(resource_or_scope)
#   resource = args.last || resource_or_scope
#   sign_in(scope, resource, options)
#   redirect_to after_sign_in_path_for(resource)
# end

# def after_sign_up_path_for(staff_user)
#   flash[:notice] = 'Welcome! You have signed up successfully.'
#   root_path
# end
#
# def after_sign_out_path_for(resource_or_scope)
#   root_path
# end

# def create
#     user = User.find_by(email: params[:session][:email].downcase)
#     if user && user.authenticate(params[:session][:password])
#       if user.activated?
#         forwarding_url = session[:forwarding_url]
#         reset_session
#         log_in user
#         params[:session][:remember_me] == '1' ? remember(user) : forget(user)
#         redirect_to forwarding_url || user
#       else
#         message = "Account not activated. "
#         message += "Check your email for the activation link."
#         flash[:warning] = message
#         redirect_to root_url
#       end
#     else
#       flash.now[:danger] = 'Invalid email/password combination'
#       render 'new'
#     end
#   end
