receta = angular.module('receta',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'angular-flash.service',
  'angular-flash.flash-alert-directive',
  'ng-admin'
])

receta.config([ '$routeProvider', 'flashProvider','NgAdminConfigurationProvider',
  ($routeProvider,flashProvider,NgAdminConfigurationProvider)->

    flashProvider.errorClassnames.push("alert-danger")
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")

    $routeProvider
      .when('/',
        templateUrl: "index.html"
        controller: 'RecipesController'
      ).when('/recipes/new',
        templateUrl: "form.html"
        controller: 'RecipeController'
      ).when('/recipes/:recipeId',
        templateUrl: "show.html"
        controller: 'RecipeController'
      ).when('/recipes/:recipeId/edit',
        templateUrl: "form.html"
        controller: 'RecipeController'
      )
      
    nga = NgAdminConfigurationProvider

    truncate = (value) ->
      if !value
        return ''
      if value.length > 50 then value.substr(0, 50) + '...' else value
      
    # set the main API endpoint for this admin
    app = nga.application('My backend').baseApiUrl('http://localhost:3001/')
    # define an entity mapped by the http://localhost:3000/posts endpoint
    recipe = nga.entity('recipes')
    app.addEntity recipe
    # set the list of fields to map in each post view
    
    recipe.dashboardView().title('Recent Recipes').order(1).perPage(5).fields [ nga.field('name').isDetailLink(true).map(truncate) ]
    
    recipe.listView().title('All Recipes').description('List of Recipes with infinite pagination').infinitePagination(true).fields([
      nga.field('id').label('ID')
      nga.field('name')
      nga.field('instructions')
    ])
    .listActions [ ]
    # .listActions [
    #   'show'
    #   'edit'
    #   'delete'
    # ]
    
    # recipe.creationView().fields [
    #   nga.field('name').attributes(placeholder: 'the Recipe title').validation(
    #     required: true
    #     minlength: 3
    #     maxlength: 100)
    #   nga.field('instructions', 'text')
    # ]
    #
    # recipe.editionView().title('Edit Recipe "{{ entry.values.name }}"').actions([
    #   'list'
    #   'show'
    #   'delete'
    # ]).fields [
    #   recipe.creationView().fields()
    #   nga.field('name', 'text').cssClasses('col-sm-4')
    #   nga.field('instructions', 'text').cssClasses('col-sm-4')
    # ]
    #
    # recipe.showView().fields [
    #   nga.field('id')
    #   recipe.editionView().fields()
    #   nga.field('custom_action', 'template').template('<other-page-link></other-link-link>')
    # ]
        
    nga.configure app
        
])

controllers = angular.module('controllers',[])
