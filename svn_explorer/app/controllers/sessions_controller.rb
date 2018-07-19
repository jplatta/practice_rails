class SessionsController < ApplicationController
  def new
  end

  def create

    if svn_auth_test(params[:session][:name], params[:session][:password], params[:session][:repo_url])
      unless User.find_by(name: params[:session][:name])
        user = User.new(name: params[:session][:name])
        user.save
      else
        user = User.find_by(name: params[:session][:name])
      end

      login(user, params[:session][:password], params[:session][:repo_url])

      redirect_to svn_path(start_path)
    else
      flash.now[:danger] = "Invalid url/name/password combination."
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
