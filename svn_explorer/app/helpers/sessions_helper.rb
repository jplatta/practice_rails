module SessionsHelper

  def login(user, pass, repo_url)
    session[:user_id]    = user.id
    session[:name]       = user.name
    session[:password]   = pass
    session[:repo_root]  = get_repo_root(repo_url)
    session[:repo_url]   = repo_url
    session[:curr_path]  = []
    session[:expires_at] = Time.current + 10.minutes
    user.update_last_login
  end

  def logout
    session.delete(:user_id)
    session.delete(:name)
    session.delete(:password)
    session.delete(:repo_root)
    session.delete(:repo_url)
    session.delete(:curr_path)
    session.delete(:expires_at)
    @current_user = nil
  end

  def start_path
    @start_path ||= session[:repo_url][session[:repo_url].rindex("/")+1, session[:repo_url].length]
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !current_user.nil?
  end

  def set_curr_path(new_path)
    if session[:curr_path].include?(new_path)

      old_path = session[:curr_path].dup
      session[:curr_path]= []

      old_path.each do |p|
        session[:curr_path].push(p)
        if p == new_path
          break
        end
      end
    else
      session[:curr_path].push(new_path)
    end
    puts "new path: " + session[:curr_path].join("/")
  end

  def get_repo_root(repo_url)
    i = repo_url.rindex("/")
    return repo_url[0, i+1]
  end

  def svn_auth_test(user, repo_pass, repo_url)
    svn_pass = false

    begin
      SvnRuby.info(auth: {"user" => user, "pass" => repo_pass, "repo_url" => repo_url }, opts: ["non-interactive"])

      svn_pass = true

    rescue StandardError => e
      puts e.message
    end

    return svn_pass
  end
end
