class UserSessionsController < ApplicationController
  skip_before_filter :require_login
  before_filter :require_logout, :only => [:new, :create, :auth_fb_connect]

  def index
    redirect_to login_path
  end

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session ||= UserSession.new(params[:user_session])
    if @user_session.save
      flash[:success] = "Come on in, the water's fine!"
      redirect_to(cookies[:redirect] || root_path)
      cookies[:redirect] = nil
    else
      flash[:failure] = "Wow, how'd you mess that one up? Try farther left."
      render "new"
    end
  end

  def destroy
    current_user_session && current_user_session.destroy
    if facebook_session
      clear_fb_cookies!
      clear_facebook_session_information
    end

    flash[:notice] = "And, we're out."
    redirect_to login_path
  end

  def auth_fb_connect
    if facebook_session && facebook_session.user && !facebook_session.expired?
      @employee = Employee.find_by_facebook_uid(facebook_session.user.id)
      if @employee
        @user_session = UserSession.new(@employee)
        create
      end
    else
      clear_fb_cookies!
      clear_facebook_session_information
      redirect_to root_path
    end
  end
end
