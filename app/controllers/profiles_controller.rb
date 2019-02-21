class ProfilesController < ApplicationController
  before_action :set_user, only: [:edit, :update, :show]
  before_action :authenticate_user!, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update(profile_params)
      redirect_to user_path(params[:user_id])
    else
      render action: :edit
    end
  end

  def show
    @products = @user.selling_products.sort_new_id.page(params[:page]).per(6)
  end

  private
  def profile_params
    params.require(:user).permit(:nickname, :profile)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end
