# app/controllers/omniauth_callbacks_controller.rb
class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def google_oauth2
    auth = request.env['omniauth.auth']
    if auth.blank?
      flash[:danger] = I18n.t 'errors.messages.login_failed'
      redirect_to root_path
    else
      begin
        auth[:ip_address] = request.remote_ip
        @user = User.find_or_create_user_for_oauth(auth)
        flash[:success] = I18n.t 'devise.omniauth_callbacks.success', kind:'Google'
        sign_in_and_redirect @user, event: :authentification
      rescue ActiveRecord::RecordInvalid
        flash[:danger] = I18n.t 'errors.messages.login_failed'
        redirect_to root_path
      end
    end
  end
end
