module V1
  class Mounter < Grape::API

    mount Projects     => '/projects'
    mount Users        => '/users'
    mount Messages     => '/messages'
    mount Roles        => '/roles'
    mount Applications => '/applications'
    mount States       => '/states'
    mount Posts        => '/posts'
    mount Comments     => '/comments'

    add_swagger_documentation(
      base_path: '/api/v1',
      api_version: Rails.application.version,
      hide_documentation_path: true
    )
  end
end
