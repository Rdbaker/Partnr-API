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
				roles: [],
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

		.state('profile', {
			parent: 'site',
			url: '/profile/{id:int}',
			views: {
				'content@': {
					templateUrl: 'user/profile/profile.html',
					controller: 'ProfileController'
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

		.state('conversation_list', {
			parent: 'site',
			url: '/conversations',
			views: {
				'content@': {
					templateUrl: 'conversations/list_conversation.html',
					controller: 'ListConversationController',
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

		.state('user_project_list', {
			parent: 'site',
			url: '/projects/me',
			views: {
				'content@': {
					templateUrl: 'projects/user_list_project.html',
					controller: 'UserListProjectController'
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
				roles: [],
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

		.state('project_wrapper', {
			parent: 'site',
			url: '/projects/{project_id:int}',
			abstract: true,
			views: {
				'content@': {
					templateUrl: 'projects/project_wrapper.html',
					controller: 'ProjectWrapperController'
				}
			}
		})

		.state('project', {
			parent: 'project_wrapper',
			url: '',
			views: {
				'projectinfo': {
					templateUrl: 'projects/project.html',
					controller: 'ProjectController'
				}
			},
			data: {
				roles: [],
				entities: ['project', 'comment', 'role', 'benchmark']
			}
		})

		.state('project_edit', {
			parent: 'project_wrapper',
			url: '/edit',
			views: {
				'projectinfo': {
					templateUrl: 'projects/edit_project.html',
					controller: 'EditProjectController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: ['project']
			}
		})

		.state('project_conversation', {
			parent: 'project_wrapper',
			url: '/messages',
			views: {
				'projectinfo': {
					templateUrl: 'conversations/project_conversation.html',
					controller: 'ProjectConversationController'
				}
			},
			data: {
				roles: ['Admin'],
				entities: ['conversation']
			}
		})

		.state('application_list', {
			parent: 'project_wrapper',
			url: '/applications',
			views: {
				'projectinfo': {
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

		.state('search', {
			parent: 'site',
			url: '/search?q&entities',
			views: {
				'content@': {
					templateUrl: 'search/search_page.html',
					controller: 'SearchController'
				}
			},
			data: {
				roles: [],
				entities: []
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
