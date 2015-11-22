angular.module('partnr.core').factory('routeUtils', function($rootScope, $http, $log, $state, principal) {
	var supportedEntities = [
		'applications',
		'projects'
	];

	var routeObject = function() {
		this.name = "";
		this.params = {};
		this.sref = "";
		this.links = {
			ui: ""
		};
	};

	var resolveToHome = function() {
		return constructRouteObject($state.get("home"), null);
	};

	var findStates = function(search, fuzzy) {
		var states = $state.get();

		if (fuzzy) {
			return states.filter(function(el) {
				return el.name.contains(search);
			});
		} else {
			return states.filter(function(el) {
				return el.name === search;
			});
		}
	};

	var extractParams = function(url) {
		var pattern = new RegExp("{(\w+)}");
		var matches = pattern.exec(url);
		var result = {};

		for (var i = 0; i < matches.length; i++) {
			result[matches[i]] = "";
		}

		return result;
	};

	var getObject = function(link) {
		return $http({
			method: 'GET',
			url: link,
			headers: principal.getHeaders()
		});
	};

	var constructRouteObject = function(state, apiLink) {
		var route = new routeObject();

		route.name = state.name;
		route.links.ui = state.url;
		route.params = extractParams(state.url);

		if (Object.keys(route.params).length > 0) {
			getObject(apiLink).then(function(result) {
				for (var key in route.params) {
					var pattern = new RegExp("^(\w+)_(\w+)$");
					var matches = pattern.exec(key);
					var dependencyName = matches[0];
					var dependencyAttr = matches[1];

					var attrValue = result.data[dependency][dependencyAttr];
					route.params[key] = attrValue;
					route.links.ui.replace("{" + key + "}", attrValue);

					if (route.params[key] === undefined) {
						$log.debug("[ROUTE UTILS] Error retrieving URL parameter for " + key + " from REST object");
					}
				}
			});
		}

		route.sref = route.name + "(" + angular.toJson(route.params) + ")";

		$log.debug("[ROUTE UTILS] Route resolved");
		$log.debug(route);

		return route;
	};

	var entityStateResolveStrategy = function(apiLink, entity, entityId) {
		var entitySingular = entity.substring(0, entity.length - 1);
		var states = findStates(entitySingular, true);
		var chosenState = null;

		if (states.length === 1) {
			chosenState = states[0];
		} else if (states.length > 1) {
			var specificState = findStates(entitySingular, false);
			chosenState = specificState[0];
		} else {
			$log.debug("[ROUTE UTILS] entity path could not be resolved, resolving to home");
			chosenState = $state.get("home");
		}

		return constructRouteObject(apiLink, chosenState);
	};

	return {
		resolveEntityLink : function(apiLink) {
			var pattern = new RegExp("^\/api\/" + $rootScope.apiVersion + "\/(\w+)\/(\d+)");
			var matches = pattern.exec(apiLink);
			var entity = matches[0];
			var entityId = matches[1];

			$log.debug("[ROUTE UTILS] entity extracted: " + entity);

			if (supportedEntities.indexOf(entity) > -1) {
				return entityStateResolveStrategy(apiLink, entity, entityId);
			} else {
				$log.debug("[ROUTE UTILS] Error, unsupported entity extracted from API link: " + apiLink);
				$log.debug("[ROUTE UTILS] Extracted entity: " + entity);
			}
		}
	};
});