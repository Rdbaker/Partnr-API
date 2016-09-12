class RegistrationsController < Devise::RegistrationsController
  alias :super_create :create
  respond_to :json
  before_action :set_default_response_format, :set_headers

  def new
    render :json => {
      'csrfParam' => request_forgery_protection_token,
      'csrfToken' => form_authenticity_token
    }
  end

  def create
    super_create
  end

  protected

  def set_default_response_format
      request.format = :json
  end

  def sign_up(resource_name, resource)
    true
  end

  def set_headers
    headers['Access-Control-Allow-Origin'] = 'partnr-up.com'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS, HEAD'
    headers['Access-Control-Allow-Headers'] = 'DNT,X-Mx-ReqToken,Keep-Alive,User-Agent,X-Requested-With,If-Modified-Since,Cache-Control,Content-Type,X-CSRF-Token'
    headers['Access-Control-Allow-Credentials'] = true
  end
end
