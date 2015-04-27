angular.module('partnr').config(function($stateProvider, $urlRouterProvider) {
	
	$stateProvider
		.state('site', {
			'abstract': true
			// resolve: {
			// 	authorize: ['authorization', function(authorization) {
			// 		return authorization.authorize();
			// 	}]
			// }
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