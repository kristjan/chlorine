class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery
  before_filter :require_login, :except => :oops
  helper_method :current_user

  include ApplicationHelper

  def oops
    raise "You should really clean the filters every once in a while."
  end

private

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return Employee.first if ENV['IGNORE_CONNECT'] == 'true'
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.employee
  end

  def require_logout
    if (UserSession.find.employee rescue false)
      flash[:notice] = "No extra points for signing in twice."
      redirect_to root_path
    end
  end

  def require_login
    unless current_user
      flash[:notice] = "You know the drill."
      cookies[:redirect] = request.path
      redirect_to login_path
    end
  end
end
