class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit_profile, :update_profile]

  def edit_profile
  end

  def update_profile
    if @user.update(update_params)
      redirect_to root_url, notice: 'Your profile has been updated!'
    else
      render action: :edit_profile
    end
  end

  private
  def set_user
    @user = current_user
  end

  def update_params
    params.require(:user).permit(:address, :job_title)
  end
end
