module V1
  class Mounter < Grape::API

    mount Projects      => '/projects'
    mount Users         => '/users'
    mount Roles         => '/roles'
    mount Applications  => '/applications'
    mount Benchmarks    => '/benchmarks'
    mount Posts         => '/posts'
    mount Comments      => '/comments'
    mount Notifications => '/notifications'
    mount Profiles      => '/profiles'
    mount Conversations => '/conversations'
    mount Categories    => '/categories'

    add_swagger_documentation(
      base_path: '/api/v1',
      api_version: Rails.application.version,
      hide_documentation_path: true
    )
  end
end
