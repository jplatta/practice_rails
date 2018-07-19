class SvnController < ApplicationController
  include SvnHelper
  before_action :logged_in_user, only: [:show]
  before_action :session_reset, only: [:show]

  def show
    begin
      set_curr_path(params[:path])

      @c_path = session[:curr_path]

      @list = SvnRuby.list(auth: {  "user" => session[:name],
                                    "pass" => session[:password],
                                    "repo_url" => session[:repo_root] + session[:curr_path].join("/")},
                               opts: ["non-interactive"])

      log = SvnRuby.log(auth: {  "user" => session[:name],
                                          "pass" => session[:password],
                                          "repo_url" => session[:repo_root] + session[:curr_path].join("/")},
                                  opts: ["non-interactive", "limit 1"])

      @log_msgs = parse_svn_log(log)

    rescue StandardError => e

      if session[:curr_path] == start_path
        flash[:danger] = "Error reading from SVN. Please login again."
        logout
        redirect_to login_path
      else
        flash[:danger] = "Error reading path: " + session[:curr_path][-1]
        redirect_to svn_path(start_path)
      end
    end
  end

  private

    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please login."
        redirect_to login_path
       end
    end

    def session_reset
      user = User.find_by(id: session[:user_id])

      if user.last_login + 10.minute < Time.now
        logout
        flash[:danger] = "Session expired. Please login."
        redirect_to login_path
      end
    end
end
