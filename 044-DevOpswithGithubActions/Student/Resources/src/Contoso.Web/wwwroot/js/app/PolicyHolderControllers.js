var modules = modules || [];
var contoso = contoso || {};
(function () {
    'use strict';
    var rootPath = contoso.policyconnect.vars.rootPath;
    var proxyPath = contoso.policyconnect.vars.azureFunctionsProxyUrl;
    var apimKey = contoso.policyconnect.vars.apimKey;
    var headers = { headers: { 'Ocp-Apim-Subscription-Key': apimKey } };

    angular.module('policyConnect')
        .controller('PolicyHolders',
            [
                '$scope', '$http', function ($scope, $http) {
                    $http.defaults.useXDomain = true;
                    delete $http.defaults.headers.common['X-Requested-With'];

                    $http.get(rootPath + '/api/policyholders/', headers)
                        .then(function (response) {
                            if (response.statusCode === 401) {
                                alert('Authentication failed. You need to sign in first!');
                            }
                            $scope.data = response.data;
                        });
                }
            ])
        .controller('PolicyHolder',
            [
                '$scope', '$http', '$routeParams', function ($scope, $http, $routeParams) {
                    $http.defaults.useXDomain = true;
                    delete $http.defaults.headers.common['X-Requested-With'];
                    $http.defaults.headers.common.get = { 'Ocp-Apim-Subscription-Key': apimKey };

                    $scope.data = {};
                    $http.get(rootPath + '/api/policyholders/' + $routeParams.id, headers)
                        .then(function (response) {
                            $scope.data = response.data;
                            //$scope.azureFunctionsProxyUrl = proxyPath.replace("{policyHolder}", $scope.data.person.lName).replace("{policyNumber}", $scope.data.policyNumber);
                            $scope.azureFunctionsProxyUrl = 'download/' + $scope.data.person.lName + '/' + $scope.data.policyNumber;
                        });
                }
            ]);
})();