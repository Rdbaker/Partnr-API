class AuthFailureRedirector < Devise::FailureApp

  # redirect to the 'welcome' page if auth fails
  def redirect_url
    root_path
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect_to root_path
    end
  end
end
