 var  modules = modules || [];
(function () {
    'use strict';
    var rootPath = contoso.policyconnect.vars.rootPath;
    var apimKey = contoso.policyconnect.vars.apimKey;
    var headers = { headers: { 'Ocp-Apim-Subscription-Key': apimKey } };

    angular.module('policyConnect')
        .controller('Policies', ['$scope', '$http', function ($scope, $http) {
            $http.defaults.useXDomain = true;
            delete $http.defaults.headers.common['X-Requested-With'];

            $http.get(rootPath + '/api/policies/', headers)
                .then(function (response) { $scope.data = response.data; });

        }])
        .controller('Policy', ['$scope', '$http', '$routeParams', function ($scope, $http, $routeParams) {
            $http.defaults.useXDomain = true;
            delete $http.defaults.headers.common['X-Requested-With'];

            $http.get(rootPath + '/api/policies/' + $routeParams.id, headers)
                .then(function (response) { $scope.data = response.data; });

        }]);
})();