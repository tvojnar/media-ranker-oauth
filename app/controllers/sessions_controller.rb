class SessionsController < ApplicationController
  def login_form
  end

# NOTE: moved the login and logout functionality to the UserController! 
  # def login
  #   auth_hash = request.env['omniauth.auth']
  #
  #   if auth_hash['uid']
  #     user = User.find_by(provider: params[:provider ], uid: auth_hash['uid'])
  #     if user.nil?
  #       # create a new user using a method in the User model
  #       user = User.from_auth_hash(params[:provider], auth_hash)
  #       save_flash(user)
  #       session[:user_id] = user.id
  #     else
  #       session[:user_id] = user.id
  #       flash[:status] = :success
  #       flash[:message] = "Successfully logged in as existing user #{user.name}"
  #     end # if/else
  #   else
  #     flash[:status] = :failure
  #     flash[:message] = "An error occurred: could not create a new user from the information GitHub supplied"
  #   end # if/else
  #   redirect_to root_path
  # end # login

# NOTE: below is old log in and log out methods for just using session
  # def login
  #   username = params[:username]
  #   if username and user = User.find_by(username: username)
  #     session[:user_id] = user.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing user #{user.username}"
  #   else
  #     user = User.new(username: username)
  #     if user.save
  #       session[:user_id] = user.id
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
  #     else
  #       flash.now[:status] = :failure
  #       flash.now[:result_text] = "Could not log in"
  #       flash.now[:messages] = user.errors.messages
  #       render "login_form", status: :bad_request
  #       return
  #     end
  #   end
  #   redirect_to root_path
  # end
  #
  # def logout
  #   session[:user_id] = nil
  #   flash[:status] = :success
  #   flash[:result_text] = "Successfully logged out"
  #   redirect_to root_path
  # end
end
