class RegistrationsController < Devise::RegistrationsController

  def create
    super
    UserMailer.welcome_email(@user).deliver unless @user.invalid?
  end
  
  def destroy
    super
    UserMailer.expire_email(@user).deliver
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
