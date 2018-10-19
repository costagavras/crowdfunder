class CommentsController < ApplicationController
before_action :ensure_logged_in
before_action :load_comment, only: [:edit, :update, :destroy]
before_action :ensure_user_has_backed_project, only: [:create]


  def create
    @comment = Comment.new
    @comment.review = params[:comment][:review]
    @comment.project_id = params[:project_id]

    if current_user
      @comment.user_id = current_user.id
      @comment.save
      redirect_to project_url(params[:project_id])
    else
      flash[:notice] = "Hi, please sign in"
    end
  end

  def edit
    @project = Project.find(params[:project_id])
  end

  def update
    @comment.review = params[:comment][:review]

    @comment.save
      redirect_to project_url(params[:project_id])
    end


  def destroy
    @comment.destroy
    redirect_to project_url(@comment.project_id)
  end

  private

  def load_comment
    @comment = Comment.find(params[:id])
  end

  def ensure_user_has_backed_project
  @project = Project.find(params[:project_id])
  @backed_users = @project.users
    if @backed_users.include?(current_user)
    else
      flash[:alert] = "Please Pledge2Me first before commenting"
      redirect_to project_url(@project)
    end
  end


end
