angular.module('partnr.core').factory('routeUtils', function($rootScope, $http, $log, $q, $state, principal) {
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

	var findStates = function(search, exact) {
		var states = $state.get();

		if (exact) {
			return states.filter(function(el) {
				return el.name === search;
			});
		} else {
			return states.filter(function(el) {
				var matches = false;
				matches = el.name.indexOf(search) > -1;

				if (el.data && el.data.entities) {
					matches |= (el.data.entities.indexOf(search) > -1);
				}

				return matches;
			});
		}
	};
 
	var extractParams = function(url) {
		var pattern = new RegExp("{(\\w+):\\w+}");
		var matches = pattern.exec(url);
		var result = {};

		for (var i = 1; i < matches.length; i++) {
			result[matches[i]] = "";
		}

		return result;
	};

	var getObject = function(link) {
		$log.debug("[ROUTE UTILS] GET " + link);
		return $http({
			method: 'GET',
			url: link,
			headers: principal.getHeaders()
		});
	};

	var constructRouteObject = function(state, apiLink) {
		var route = new routeObject();
		var deferred = $q.defer();

		route.name = state.name;
		route.links.ui = state.url;
		route.params = extractParams(state.url);

		if (Object.keys(route.params).length > 0) {
			getObject(apiLink).then(function(result) {
				for (var key in route.params) {
					if (key.indexOf("_") > -1) {
						var pattern = new RegExp("^(\\w+)_(\\w+)$");
						var matches = pattern.exec(key);
						var dependencyName = matches[1];
						var dependencyAttr = matches[2];

						var attrValue = result.data[dependencyName][dependencyAttr];
						route.params[key] = attrValue;
					} else {
						var pattern = new RegExp("^(\\w+)_?")
						var matches = pattern.exec(route.name);
						var parentEntity = matches[1];

						if (apiLink.indexOf(parentEntity) > -1) {
							route.params[key] = result.data[key];
						} else {
							route.params[key] = result.data[parentEntity][key];
						}
					}

					route.links.ui.replace("{" + key + "}", attrValue);

					if (route.params[key] === undefined) {
						$log.debug("[ROUTE UTILS] Error retrieving URL parameter for " + key + " from REST object");
					}
				}

				route.sref = route.name + "(" + angular.toJson(route.params) + ")";

				$log.debug("[ROUTE UTILS] Route resolved");
				$log.debug(route);

				deferred.resolve(route);
			});
		} else {
			route.sref = route.name + "()";

			$log.debug("[ROUTE UTILS] Route resolved");
			$log.debug(route);

			deferred.resolve(route);
		}

		return deferred.promise;
	};

	var entityStateResolveStrategy = function(apiLink, entity, entityId) {
		var entitySingular = entity.substring(0, entity.length - 1);
		var states = findStates(entitySingular, false);
		var chosenState = null;

		if (states.length === 1) {
			chosenState = states[0];
		} else if (states.length > 1) {
			var specificState = findStates(entitySingular, true);
			chosenState = specificState[0];
		} else {
			$log.debug("[ROUTE UTILS] entity path could not be resolved");
		}

		if (chosenState == null) {
			$log.debug("[ROUTE UTILS] resolving to home");
			chosenState = $state.get("home");
		}

		return constructRouteObject(chosenState, apiLink);
	};

	var resolveEntityLink = function(apiLink) {
		var pattern = new RegExp("^\/api\/" + $rootScope.apiVersion + "\/(\\w+)\/(\\d+)");
		var matches = pattern.exec(apiLink);
		var entity = matches[1];
		var entityId = matches[2];

		$log.debug("[ROUTE UTILS] Extracted entity: " + entity);

		return entityStateResolveStrategy(apiLink, entity, entityId);
	};

	return {
		resolveEntityLink : resolveEntityLink,
		resolveEntityLinkAndGo : function(apiLink) {
			resolveEntityLink(apiLink).then(function(route) {
				$state.go(route.name, route.params);
			});
		}
	};
});