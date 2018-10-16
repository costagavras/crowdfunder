class ProjectsController < ApplicationController
  # before_action :require_login, only: [:new, :create]

  def index
    @projects = Project.all
    @projects = @projects.order(:end_date)
    @total_projects = Project.projects_count
    @total_project_funds_true = Project.fund_count
    @total_pledge = Project.pledge_count
  end




  def show
    @project = Project.find(params[:id])
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
    @project.user_id = current_user.id

    if @project.save
      redirect_to projects_url
    else
      error_message = ""
      @project.errors.full_messages.each do |message|
        if message == @project.errors.full_messages.last
          error_message += "#{message}"
        else
          error_message += "#{message} and "
        end

      end
      if(error_message != "")
        flash[:notice] = "Error: #{error_message}"
      end

      render :new
    end
   end

end
