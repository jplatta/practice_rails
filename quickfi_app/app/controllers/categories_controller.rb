class CategoriesController < ApplicationController

  def index
    @categories = Category.where(user_id: current_user)
  end

  def new
    @user = User.find(params[:user_id])
    @category = @user.categories.build
  end

  def create
    @category = current_user.categories.build(category_params)
    if @category.save
      flash[:success] = "Category saved!"
      redirect_to user_categories_path
    else
      render 'new'
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update_attributes(category_params)
      flash[:success] = "Category updated."
      redirect_to user_categories_path(current_user)
    else
      render 'edit'
    end
  end

  def destroy
    Category.find(params[:id]).destroy
    flash[:success] = "Category deleted."
    redirect_to user_categories_path(current_user)
  end

  private
    def category_params
      params.require(:category).permit(:name,:user_id)
    end
end
