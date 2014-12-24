class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def after_sign_in_path_for(res_or_scope)
    root_path
  end

  def after_sign_up_path_for(res)
    root_path
  end

  def after_sign_out_path_for(res_or_scope)
    root_path
  end
end
