module V1
  class Mounter < Grape::API

    mount Projects => '/projects'
    mount Users    => '/users'
    mount Messages => '/messages'

    add_swagger_documentation(
      base_path: '/api/v1',
      api_version: Rails.application.version,
      hide_documentation_path: true
    )
  end
end
