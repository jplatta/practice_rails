class UsersController < ApplicationController

  def show
  end

  def destroy
  end

  private
    def user_params
      params.require(:user).permit(:name, :last_login)
    end
end
