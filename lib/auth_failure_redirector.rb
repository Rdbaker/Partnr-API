class AuthFailureRedirector < Devise::FailureApp

  # redirect to the 'welcome' page if auth fails
  def redirect_url
    root_path
  end

  def respond
    root_path
  end
end
