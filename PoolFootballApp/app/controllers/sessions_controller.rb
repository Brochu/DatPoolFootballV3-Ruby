class SessionsController < ApplicationController
  def login
  end

  def goodbye
    reset_session
    redirect_to :action => "login"
  end

  def omniauth
    # Get access tokens from the google server
    access_token = request.env["omniauth.auth"]
    @user = User.from_omniauth(access_token)
    # Access_token is used to authenticate request made from the rails application to the google server
    @user.token = access_token.credentials.token
    # Refresh_token to request new access_token
    # Note: Refresh_token is only sent once during the first request
    refresh_token = access_token.credentials.refresh_token
    @user.refreshtoken = refresh_token if refresh_token.present?
    @user.save
    session[:userId] = @user.id
    redirect_to pools_path
  end
end
