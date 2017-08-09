class RegistrationsController < Devise::RegistrationsController

  def create
    if params[:user][:plan].present? and ["pro5","pro11"].include?(params[:user][:plan])
      super
      MessageMailer.welcome_email(@user).deliver unless @user.invalid?
    else
      redirect_to "/", notice: "Sorry, wrong plan. Please try again!"
    end
  end
  
  def destroy
    super
    MessageMailer.expire_email(@user).deliver
  end

  def update_card
    @user = current_user
    @user.stripe_token = params[:user][:stripe_token]
    if @user.save
      redirect_to edit_user_registration_path, :notice => 'Thanks - we updated your card.'
    else
      flash.alert = 'Unable to update card.'
      render :edit
    end
  end

end
