class SessionsController < Devise::SessionsController
  alias :super_destroy :destroy

  respond_to :json
  before_action :set_default_response_format

  def new
    render :json => {
      'csrfParam' => request_forgery_protection_token,
      'csrfToken' => form_authenticity_token
    }
  end

  def create
    self.resource = warden.authenticate!({
      scope: :user,
    })
    sign_in(:resource, resource)
    render :json => {
      'user' => resource.serializable_hash,
      'csrfParam' => request_forgery_protection_token,
      'csrfToken' => form_authenticity_token
    }
  end

  def destroy
    super_destroy
  end

  protected

  def set_default_response_format
      request.format = :json
  end

  # Devise method, only changes what it responds with
  def require_no_authentication
    assert_is_devise_resource!
    return unless is_navigational_format?
    no_input = devise_mapping.no_input_strategies

    authenticated = if no_input.present?
      args = no_input.dup.push scope: resource_name
      warden.authenticate?(*args)
    else
      warden.authenticated?(resource_name)
    end

    if authenticated && resource = warden.user(resource_name)
      render :json => {
        "error" => I18n.t("devise.failure.already_authenticated"),
        "user" => resource.serializable_hash,
        "csrfParam" => request_forgery_protection_token,
        "csrfToken" => form_authenticity_token
      }
    end
  end
end
