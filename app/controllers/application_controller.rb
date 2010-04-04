# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :require_login

  helper_method :current_user

private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.employee
  end

  def require_logout
    redirect_to root_url if (UserSession.find.employee rescue false)
  end

  def require_login
    unless current_user
      cookies[:redirect] = request.path
      redirect_to login_path
    end
  end

  def d(s)
    Rails.logger.info ">> " + s.inspect
  end

end
