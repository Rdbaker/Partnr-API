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
end
