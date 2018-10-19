class CommentsController < ApplicationController

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
    @comment = Comment.find(params[:id])
    @project = Project.find(params[:project_id])
  end

  def update
    @comment = Comment.find(params[:id])
    @comment.review = params[:comment][:review]

    @comment.save
      redirect_to project_url(params[:project_id])
    end


  def destroy

    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to project_url(@comment.project_id)
  end

end
