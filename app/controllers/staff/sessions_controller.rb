module Staff
  class SessionsController < ApplicationController
    layout "staff_auth"

    def new
      redirect_to root_path if user_signed_in?
    end

    def create
      user = User.find_by(username: params[:username])
      if user.nil? || !user.staff? || !user.active?
        flash.now[:alert] = "Invalid username or password"
        return render :new, status: :unprocessable_entity
      end

      if user.valid_password?(params[:password])
        sign_in(user)
        redirect_to root_path, notice: "Signed in as #{user.name}"
      else
        flash.now[:alert] = "invalid username or password"
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      sign_out(current_user) if user_signed_in?
      redirect_to staff_login_path, notice: "Signed out"
    end
  end
end
