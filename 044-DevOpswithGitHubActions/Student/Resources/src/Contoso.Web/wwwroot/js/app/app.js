'use strict';
angular.module('policyConnect', ['ngRoute'])
    .config(['$routeProvider', function ($routeProvider) {

        $routeProvider.when('/policyHolders', {
            title: 'PolicyHolders',
            templateUrl: '/Static/PolicyHolders',
            controller: 'PolicyHolders'
        })
        .when('/policyHolders/:id', {
            title: 'PolicyHolder',
            templateUrl: '/Static/PolicyHolder',
            controller: 'PolicyHolder'
        })
        .when('/policies', {
            title: 'Policies',
            templateUrl: '/Static/Policies',
            controller: 'Policies'
        })
        .when('/policies/:id', {
            title: 'Policy',
            templateUrl: '/Static/Policy',
            controller: 'Policy'
        })
        .when('/people', {
            title: 'People',
            templateUrl: '/Static/People',
            controller: 'People'
        })
        .when('/people/:id', {
            title: 'Person',
            templateUrl: '/Static/Person',
            controller: 'Person'
        })
        .when('/dependents', {
            title: 'Dependents',
            templateUrl: '/Static/Dependents',
            controller: 'Dependent'
        })
        .when('/dependents/:id', {
            title: 'Dependent',
            templateUrl: '/Static/Dependent',
            controller: 'Dependent'
        }).otherwise({ redirectTo: '/Static/PolicyHolders' });
    }]);