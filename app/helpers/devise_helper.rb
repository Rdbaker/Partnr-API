module DeviseHelper
  def devise_error_messages!
    puts User.errors
    'KABOOM!'
  end
end
