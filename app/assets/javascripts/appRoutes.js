angular.module('partnr').config(function($stateProvider, $urlRouterProvider) {
	
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
				roles: ['Admin']
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
				roles: []
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
				roles: []
			}
		})

		.state('inbox', {
			parent: 'site',
			url: '/inbox',
			views: {
				'content@': { 
					templateUrl: 'messaging/messageList.html',
					controller: 'MessageController',
				}
			},
			data: {
				roles: ['Admin']
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
				roles: ['Admin']
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
				roles: ['Admin']
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
				roles: ['Admin']
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
				roles: ['Admin']
			}
		})

		.state('project', {
			parent: 'site',
			url: '/projects/{id}',
			views: {
				'content@': {
					templateUrl: 'projects/project.html',
					controller: 'ProjectController'
				}
			},
			data: {
				roles: ['Admin']
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
				roles: ['Admin']
			}
		});

	$urlRouterProvider.otherwise('/');
});