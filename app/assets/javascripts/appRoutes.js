angular.module('partnr.core').config(function($stateProvider, $urlRouterProvider) {
	
	$stateProvider
		.state('site', {
			'abstract': true,
			resolve: {
				authorize: ['authorization', function(authorization) {
					return authorization.authorize();
				}]
			}
		})

		.state('home', {
			parent: 'site',
			url: '/',
			views: {
				'content@': { 
					templateUrl: 'home/home.html',
					controller: 'HomeController',
				}
			},
			data: {
				roles: ['Admin'],
				entities: []
			}
		})

		.state('login', {
			parent: 'site',
			url: '/account/login',
			views: {
				'content@': { 
					templateUrl: 'auth/login.html',
					controller: 'LoginController',
				}
			},
			data: {
				roles: [],
				entities: []
			}
		})

		.state('account_create', {
			parent: 'site',
			url: '/account/create',
			views: {
				'content@': { 
					templateUrl: 'user/create.html',
					controller: 'CreateUserController',
				}
			},
			data: {
				roles: [],
				entities: []
			}
		})

		.state('account_forgot_password', {
			parent: 'site',
			url: '/account/forgot_password',
			views: {
				'content@': {
					templateUrl: 'user/forgot_password.html',
					controller: 'ForgotPasswordController'
				}
			},
			data: {
				roles: [],
				entities: []
			}
		})

		.state('account_reset_password', {
			parent: 'site',
			url: '/account/reset_password?reset_password_token',
			views: {
				'content@': {
					templateUrl: 'user/reset_password.html',
					controller: 'ResetPasswordController'
				}
			},
			data: {
				roles: [],
				entities: []
			}
		})

		.state('profile_create', {
			parent: 'site',
			url: '/profile/create',
			views: {
				'content@': {
					templateUrl: 'user/profile/create_profile.html',
					controller: 'CreateProfileController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: []
			}
		})

		.state('profile_edit', {
			parent: 'site',
			url: '/profile/edit',
			views: {
				'content@': {
					templateUrl: 'user/profile/edit_profile.html',
					controller: 'EditProfileController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: []
			}
		})

		.state('inbox', {
			parent: 'site',
			url: '/inbox',
			views: {
				'content@': { 
					templateUrl: 'messaging/list_message.html',
					controller: 'MessageController',
				}
			},
			data: {
				roles: ['Admin'],
				entities: []
			}
		})

		.state('partners', {
			parent: 'site',
			url: '/partners',
			views: {
				'content@': { 
					templateUrl: 'partners/partners.html',
					controller: 'PartnersController',
				}
			},
			data: {
				roles: ['Admin'],
				entities: []
			}
		})

		.state('portfolio', {
			parent: 'site',
			url: '/portfolio',
			views: {
				'content@': { 
					templateUrl: 'portfolio/portfolio.html',
					controller: 'PortfolioController',
				}
			},
			data: {
				roles: ['Admin'],
				entities: []
			}
		})

		.state('owner_project_list', {
			parent: 'site',
			url: '/projects/me',
			views: {
				'content@': {
					templateUrl: 'projects/owner_list_project.html',
					controller: 'OwnerListProjectController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: ['project']
			}
		})

		.state('project_list', {
			parent: 'site',
			url: '/projects',
			views: {
				'content@': {
					templateUrl: 'projects/list_project.html',
					controller: 'ListProjectController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: ['project']
			}
		})
		
		.state('project_create', {
			parent: 'site',
			url: '/projects/create',
			views: {
				'content@': {
					templateUrl: 'projects/create_project.html',
					controller: 'CreateProjectController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: ['project']
			}
		})

		.state('project', {
			parent: 'site',
			url: '/projects/{id:int}',
			views: {
				'content@': {
					templateUrl: 'projects/project.html',
					controller: 'ProjectController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: ['project', 'comment', 'role', 'benchmark']
			}
		})

		.state('project_edit', {
			parent: 'site',
			url: '/projects/{project_id:int}/edit',
			views: {
				'content@': {
					templateUrl: 'projects/edit_project.html',
					controller: 'EditProjectController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: ['project']
			}
		})

		.state('application_list', {
			parent: 'site',
			url: '/projects/{project_id:int}/applications',
			views: {
				'content@': {
					templateUrl: 'projects/applications/list_applications.html',
					controller: 'ListApplicationsController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: ['application']
			}
		})

		.state('notification_list', {
			parent: 'site',
			url: '/notifications',
			views: {
				'content@': {
					templateUrl: 'notifications/list_notifications.html',
					controller: 'ListNotificationsController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: ['notification']
			}
		})

		.state('settings', {
			parent: 'site',
			url: '/settings',
			views: {
				'content@': { 
					templateUrl: 'settings/settings.html',
					conroller: 'SettingsController',
				}
			},
			data: {
				roles: ['Admin'],
				entities: []
			}
		});

	$urlRouterProvider.otherwise('/');
});