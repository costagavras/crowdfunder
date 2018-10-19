class RewardsController < ApplicationController
  before_action :load_project

  def new
    @reward = Reward.new
  end

  def create
    @reward = @project.rewards.build
    @reward.dollar_amount = params[:reward][:dollar_amount]
    @reward.description = params[:reward][:description]

    if @reward.save
      redirect_to project_url(@project), notice: 'Reward created'
    else
      render :new
    end
  end

  def destroy
    @reward = Reward.find(params[:id])

    if(@reward.project.user == current_user)
      @reward.destroy
      redirect_to project_url(@project), notice: 'Reward successfully removed'
    else
      @project = Project.find(params[:project_id])
      @comment = Comment.new
      flash[:error] = "You are not the owner; you cannot delete this reward"
      render "/projects/show"
    end

  end

  private

  def load_project
    @project = Project.find(params[:project_id])
  end
end
