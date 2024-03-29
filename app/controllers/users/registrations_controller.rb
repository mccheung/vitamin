class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]
  after_filter :remove_openid_from_session, only: [:create]

  # GET /resource/sign_up
  def new
    openid = params['oid']
    user = User.find_for_authentication(:openid => openid)
    if user
      sign_in(:user, user)
      redirect_to items_path
    else
      if openid
        session[:openid] = openid
      end
      super
    end
  end

  # POST /resource
  def create
    params['user']['openid'] = session[:openid]
    params['user']['password'] = Devise.friendly_token.first(8)
    super
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def remove_openid_from_session
    if resource.persisted?
      session.delete(:openid)
      PushHelper.push_signups(resource)
    end
  end

  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up) { |u|
      u.permit(:openid, :password, profile_attributes: [:nickname])
    }
  end

  def after_sign_in_path_for(resource)
    items_path
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
