class APIController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  before_action :set_default_response_format

  def not_found
    render :json => {:error => "not-found"}, :status => 404
  end

  def set_default_response_format
    request.format = :json
  end
end
