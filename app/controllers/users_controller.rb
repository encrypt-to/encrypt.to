class UsersController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  
  # GET /users/1/edit
  def edit
    @uid = params[:uid]
    @user = User.where("lower(username) = ?", @uid.downcase).first 
    redirect_to "/" if current_user != @user
  end

  # PUT /users/1
  def update
    @uid = params[:uid]
    @user = User.where("lower(username) = ?", @uid.downcase).first
    respond_to do |format|
      if current_user != @user
        redirect_to "/"
      elsif @user.update_attributes(user_params)
        if params[:user].present? && params[:user][:stripe_token].present?
          format.html { redirect_to "/", notice: 'Credit card was successfully updated.' }
        elsif params[:user].present? && params[:user][:public_key].present?
          format.html { redirect_to "/", notice: 'Public key was successfully updated.' }
        else
          format.html { redirect_to "/", notice: 'Successfully updated.' }
        end
      else
        format.html { redirect_to "/", notice: 'Not allowed.' }
      end
    end
  end
  
  def show
    @user = User.where("lower(username) = ?", params[:uid]).first
  end
  
  private
  
  def user_params
    params.require(:user).permit(:name, :uid, :public_key, :login, :username, :email, :password, :password_confirmation, :remember_me, :css_form_background, :css_form_color, :form_attachment, :form_advanced_mode, :stripe_token, :thanks_message, :plan)
  end
end
