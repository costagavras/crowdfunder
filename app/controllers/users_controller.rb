class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new
    @user.first_name = params[:user][:first_name]
    @user.last_name = params[:user][:last_name]
    @user.email = params[:user][:email]
    @user.password = params[:user][:password]
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.save
      session[:user_id] = @user.id
      redirect_to projects_url
    else
      error_message = @user.errors.full_messages.first
      if(error_message)
        flash[:alert] = "Error: #{error_message}"
      end
      render 'new'
    end
  end


  def show
    @user = User.find(params[:id])
    # @projects = Project.all
    @my_projects = @user.projects
    # @my_projects = Project.where(user_id: @user.id) #projects I own
    if @user.pledges
      @pledges = @user.pledges
      @my_pledged_projects = @user.my_pledged_projects
    end
  end

end
