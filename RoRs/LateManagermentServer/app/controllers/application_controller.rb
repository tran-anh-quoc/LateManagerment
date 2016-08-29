class ApplicationController < ActionController::Base
  include Pundit
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # Avoid error "Can't verify CSRF token authenticity"
  protect_from_forgery with: :exception unless :json_request?

  def set_flash(key, message)
    flash[key] = message
  end

  private
    def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore

      flash[:danger] = I18n.t "#{policy_name}.#{exception.query}", scope: "pundit", default: :default
      redirect_to(request.referrer || root_path)
    end

    def json_request?
      request.format.json?
    end
end
