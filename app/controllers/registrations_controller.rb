class RegistrationsController < Devise::RegistrationsController

  def create
    params[:user][:plan] = "pro11"
    super
    MessageMailer.welcome_email(@user).deliver_now unless @user.invalid?
  end
  
  def destroy
    super
    MessageMailer.expire_email(@user).deliver_now
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
