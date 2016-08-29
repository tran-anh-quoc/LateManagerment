class Api::BaseController < ApplicationController

  rescue_from Exception,                      with: :error_500 unless Rails.env.development?
  rescue_from StandardError,                  with: :error_500 unless Rails.env.development?
  rescue_from ActiveRecord::RecordNotFound,   with: :error_404 unless Rails.env.development?
  rescue_from ActionController::RoutingError, with: :error_404 unless Rails.env.development?

  def error_500 e=nil
    msg = e.try(:message) || 'Error'
    handle_error(msg, 500)
  end

  def error_404 e=nil
    msg = e.try(:message) || 'Error'
    handle_error(msg, 404)
  end

  def error_400 e=nil
    msg = e.try(:message) || 'Error'
    handle_error(msg, 400)
  end

  def handle_error msg, code
    logger.error msg

    @errors = [{ message: msg, code: code }]
    render template: 'api/shared/error', formats: [:json],
      handlers: [:jbuilder], status: code
  end

  protected
    def authenticate_error(message)
      if message.nil?
        set_authenticate_error_header("realm=\"Application\"")
      else
        set_authenticate_error_header("error=\"#{message}\"")
      end
    end

    def set_authenticate_error_header(message)
      response.headers['WWW-Authenticate'] = "Token #{message}"
    end
end
