class WorksController < ApplicationController
  # We should always be able to tell what category
  # of work we're dealing with
  skip_before_action :require_login, only: [:root]
  before_action :category_from_work, except: [:root, :index, :new, :create]

  def root
    @albums = Work.best_albums
    @books = Work.best_books
    @movies = Work.best_movies
    @best_work = Work.order(vote_count: :desc).first
  end

  def index
    @works_by_category = Work.to_category_hash
  end

  def new
    # QUESTION: Do I need to add extra protection here since a user can't get to this page unless they are logged in??
    @work = Work.new
  end

  def create
    @work = Work.new(media_params)
    @work.user_id = session[:user_id]
    @media_category = @work.category
    if @work.save
      flash[:status] = :success
      flash[:result_text] = "Successfully created #{@media_category.singularize} #{@work.id}"
      redirect_to work_path(@work)
    else
      flash[:status] = :failure
      flash[:result_text] = "Could not create #{@media_category.singularize}"
      flash[:messages] = @work.errors.messages
      render :new, status: :bad_request
    end
  end

  def show
    @votes = @work.votes.order(created_at: :desc)
  end

  def edit
    # the current logged in user will be returned (@login_user)
    find_user

    # TODO: move this find_by into a method in the Work model?
    # check that the user created the work they are trying to edit
    unless Work.find_by(id: params[:id]).user_id == @login_user.id
      # if they did not create the work, then give them a flash message and redirect them to the works_path
      flash[:ststus] = :failure
      flash[:message] = "You can only edit works that you created"
      redirect_to works_path
    end
    # if they did create the work they will be able to view to edit view and edit the work!
  end # edit

  def update
    @work.update_attributes(media_params)
    if @work.save
      flash[:status] = :success
      flash[:result_text] = "Successfully updated #{@media_category.singularize} #{@work.id}"
      redirect_to work_path(@work)
    else
      flash.now[:status] = :failure
      flash.now[:result_text] = "Could not update #{@media_category.singularize}"
      flash.now[:messages] = @work.errors.messages
      render :edit, status: :not_found
    end
  end

  def destroy
    find_user
    if Work.find_by(id: params[:id]).user_id == @login_user.id
      @work.destroy
      flash[:status] = :success
      flash[:result_text] = "Successfully destroyed #{@media_category.singularize} #{@work.id}"
      redirect_to root_path
    else
      flash[:status] = :failure
      flash[:message] = "You can only delete works that you created"
      redirect_to works_path
    end



  end

  def upvote
    # Most of these varied paths end in failure
    # Something tragically beautiful about the whole thing
    # For status codes, see
    # http://stackoverflow.com/questions/3825990/http-response-code-for-post-when-resource-already-exists
    flash[:status] = :failure
    if @login_user
      vote = Vote.new(user: @login_user, work: @work)
      if vote.save
        flash[:status] = :success
        flash[:result_text] = "Successfully upvoted!"
        status = :found
      else
        flash[:result_text] = "Could not upvote"
        flash[:messages] = vote.errors.messages
        status = :conflict
      end
    else
      flash[:result_text] = "You must log in to do that"
      status = :unauthorized
    end

    # Refresh the page to show either the updated vote count
    # or the error message
    redirect_back fallback_location: work_path(@work), status: status
  end

private
  def media_params
    params.require(:work).permit(:title, :category, :creator, :description, :publication_year)
  end

  def category_from_work
    @work = Work.find_by(id: params[:id])
    render_404 unless @work
    @media_category = @work.category.downcase.pluralize
  end
end
