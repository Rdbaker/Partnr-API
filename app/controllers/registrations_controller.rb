class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :set_default_response_format

  def new
    render :json => {
      'csrfParam' => request_forgery_protection_token,
      'csrfToken' => form_authenticity_token
    }
  end

  protected

  def set_default_response_format
      request.format = :json
  end
end
