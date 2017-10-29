class UsersController < ApplicationController
  skip_before_action :require_login, only: [:login]
  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])
    render_404 unless @user
  end

  def login
    auth_hash = request.env['omniauth.auth']
    
    if auth_hash['uid']
      user = User.find_by(provider: params[:provider ], uid: auth_hash['uid'])
      if user.nil?
        # create a new user using a method in the User model
        user = User.from_auth_hash(params[:provider], auth_hash)
        save_flash(user)
        session[:user_id] = user.id
      else
        session[:user_id] = user.id
        flash[:status] = :success
        flash[:message] = "Successfully logged in as existing user #{user.name}"
      end # if/else
    else
      flash[:status] = :failure
      flash[:message] = "An error occurred: could not create a new user from the information GitHub supplied"
    end # if/else
    redirect_to root_path
  end # login

  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:message] = "You have been logged out"
    redirect_to root_path
  end #logout
end
