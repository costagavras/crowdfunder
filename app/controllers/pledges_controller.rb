class PledgesController < ApplicationController
  # before_action :require_login
  before_action :load_project

  def create
    #@project = Project.find(params[:project_id])
    puts "============================"
    puts "I HERE"
    puts "============================"
    @project = Project.find(params[:project_id])
    @comment = Comment.new

    new_pledge = Pledge.new(dollar_amount: params[:pledge][:dollar_amount],
                            user: current_user,
                            project: @project)
    # new_pledge = @project.pledges.build
    # new_pledge.dollar_amount = params[:pledge][:dollar_amount]
    # new_pledge.user = current_user

      if new_pledge.save
        @pledge = new_pledge
        redirect_to project_url(@project), notice: "You have successfully backed #{@project.title}!"
      else
        flash.now[:alert] = new_pledge.errors.full_messages.first
        render 'projects/show'
      end
  end

  def load_project

  end


end
