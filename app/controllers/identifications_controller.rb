class IdentificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:edit, :update]

  def edit
  end

  def update
    if @user.update(indentification_params)
      redirect_to user_path(params[:user_id])
    else
      render action: :edit
    end
  end

  private
  def indentification_params
    params.require(:user).permit(:family_name, :family_name, :first_name, :family_katakana, :first_katakana, :postal_code, :domicile_pref, :domicile_city, :domicile_add, :building, :birthday_year, :birthday_month, :birthday_day)
  end

  def set_user
    @user = User.find(params[:user_id])
  end
end

