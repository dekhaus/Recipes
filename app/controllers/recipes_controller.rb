class RecipesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  respond_to :json

  def index
    @recipes = if params[:keywords]
                 Recipe.where('name ilike ?',"%#{params[:keywords]}%")
               else
                 if params[:_page]
                   page    = params[:_page].to_i
                   perPage = (params[:_perPage] || 25).to_i
                   Recipe.all.page(page).per_page(perPage)
                 else
                   Recipe.all
                 end
               end
    response.headers['X-Total-Count'] = @recipes.count.to_s
    render json: @recipes
  end

  def show
    @recipe = Recipe.find(params[:id])
    render json: @recipe
  end

  def create
    @recipe = Recipe.new(params.require(:recipe).permit(:name,:instructions))
    @recipe.save
    render 'show', status: 201
  end

  def update
    recipe = Recipe.find(params[:id])
    recipe.update_attributes(params.require(:recipe).permit(:name,:instructions))
    head :no_content
  end

  def destroy
    recipe = Recipe.find(params[:id])
    recipe.destroy
    head :no_content
  end
end
