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
    # endpoint = 'http://localhost:3001/'
    endpoint = 'https://daves-recipes.herokuapp.com/'

    app = nga.application('Admin').baseApiUrl(endpoint)


    recipe = nga.entity('recipes')
    
    place = nga.entity('places')
               .baseApiUrl('https://rocky-cove-3528.herokuapp.com/')
               # .baseApiUrl('http://localhost:3300/')
               .identifier(nga.field('id'))

    
    app.addEntity(recipe)
       .addEntity(place)
    
    place.dashboardView()
          .title('Recent Places')
          .order(1)
          .perPage(5)
          .fields([nga.field('address').isDetailLink(true).map(truncate)])

    place.listView()
         .title('All Places')
         .description('List of Places')
         .perPage(5)
	       .fields([
	         nga.field('id'),
	         nga.field('latitude'),
	         nga.field('longitude'),
	         nga.field('address'),
	         nga.field('country'),
	         nga.field('zip')
	       ])
	       .listActions([ ])
    
    
    # set the list of fields to map in each post view
    
    recipe.dashboardView().title('Recent Recipes').order(1).perPage(5).fields [ nga.field('name').isDetailLink(true).map(truncate) ]
    
    recipe.listView()
      .title('All Recipes')
      .description('List of Recipes')
      .perPage(10)
      .fields([
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
