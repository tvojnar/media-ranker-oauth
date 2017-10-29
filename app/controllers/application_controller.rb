class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_user
  before_action :require_login




  def render_404
    # DPR: supposedly this will actually render a 404 page in production
    raise ActionController::RoutingError.new('Not Found')
  end

protected
def save_flash(model)
  saved = model.save

  if saved
    flash[:status] = :success
    # TODO: get this to actually print out the name of the user that was logged in!
    flash[:message] = "Successfully created a new user, #{model.name}"
  else
    flash[:status] = :success
    flash[:message] = "A problem occurred: Could not create a new user}"
    flash[:details] = model.errors.messages
  end # if/else

  return saved
end # save and flash

def require_login
  @user = User.find_by(id: session[:user_id])
  unless @user
    flash[:status] = :failure
    flash[:message] = "You must be logged in to do that"
    redirect_to root_path
  end
end # require_login

private
  def find_user
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
  end
end
