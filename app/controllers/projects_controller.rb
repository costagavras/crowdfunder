class ProjectsController < ApplicationController
  # before_action :require_login, only: [:new, :create]

  def index
    @projects = Project.all
    @projects = @projects.order(:end_date)
    @total_projects = Project.projects_count
    @total_project_funds_true = Project.fund_count
    @total_pledge = Project.total_pledge_value
  end

  def show
    @project = Project.find(params[:id])
    @comments = Comment.where(project_id: @project.id)
    @comments = @project.comments
    @comment = Comment.new
  end

  def new
    @project = Project.new
    @project.rewards.build
  end

  def create
    @project = Project.new
    @project.title = params[:project][:title]
    @project.description = params[:project][:description]
    @project.goal = params[:project][:goal]
    @project.start_date = params[:project][:start_date]
    @project.end_date = params[:project][:end_date]
    @project.image = params[:project][:image]

    if(current_user)
      @project.user_id = current_user.id
    end


    if @project.save
      redirect_to projects_url
    else
      error_message = @project.errors.full_messages.first
      if(error_message)
        flash[:alert] = "Error: #{error_message}"
      end

      render :new
    end
   end

end
