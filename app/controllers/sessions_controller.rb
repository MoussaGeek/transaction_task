class SessionsController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      log_in(user)
      redirect_to items_path
    else
      flash.now[:danger] = 'échec de la connexion'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = 'déconnecté'
    redirect_to new_session_path
  end
end
