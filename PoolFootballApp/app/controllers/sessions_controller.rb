class SessionsController < ApplicationController
  def login
    if (session.key?(:user_token))
      @user = User.where(token: session[:user_token]).first
      @pooler = Pooler.where(user_id: @user.id).first

      redirect_to_home(@user, @pooler)
    end
  end

  def goodbye
    reset_session
    redirect_to :action => "login"
  end

  def omniauth
    access_token = request.env["omniauth.auth"]

    # Attempt to find user or setup a new user if needed
    # Save tokens we got from the auth service
    @user = User.from_omniauth(access_token)
    @user.token = access_token.credentials.token
    refresh_token = access_token.credentials.refresh_token
    @user.refreshtoken = refresh_token if refresh_token.present?
    @user.save

    set_user_info(@user)
  end

  private

  def set_user_info(user)
    # Try to find pooler related to this user
    # If we can't find one, redirect to new pooler page
    session[:user_token] = @user.token
    @pooler = Pooler.where(user_id: @user.id).first

    redirect_to_home(user, @pooler)
  end

  def redirect_to_home(user, pooler)
    if (@pooler != nil)
      redirect_to pools_path
    else
      redirect_to new_pooler_path
    end
  end
end
