angular.module('partnr').config(function($stateProvider, $urlRouterProvider) {
	
	$stateProvider
		.state('home', {
			url: '/',
			templateUrl: 'home/home.html',
			controller: 'HomeController'
		})

		.state('login', {
			url: '/login',
			templateUrl: 'auth/login.html',
			controller: 'LoginController'
		})

		.state('inbox', {
			url: '/inbox',
			templateUrl: 'messaging/messageList.html',
			controller: 'MessageController'
		})

		.state('partners', {
			url: '/partners',
			templateUrl: 'partners/partners.html',
			controller: 'PartnersController'
		})

		.state('portfolio', {
			url: '/portfolio',
			templateUrl: 'portfolio/portfolio.html',
			controller: 'PortfolioController'
		})

		.state('settings', {
			url: '/settings',
			templateUrl: 'settings/settings.html',
			conroller: 'SettingsController'
		});

	$urlRouterProvider.otherwise('/');
});