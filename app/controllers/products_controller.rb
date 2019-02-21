class ProductsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :list, :show]
  before_action :set_product, only: [:edit, :update]

  def index
    @products = Product.sort_new_id.limit(3)
    @user = current_user
  end

  def list
    @products = Product.sort_new_id.page(params[:page]).per(12)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to action: 'index'
    else
      render 'new'
    end
  end

  def edit
  end

  def show
    @product = Product.find(params[:id])
    @products = @product.seller.selling_products.where.not(id: @product.id).sort_new_id.limit(6)
    @user = current_user
  end

  def update
    @product.update(product_params)
    redirect_to product_path
  end

  def destroy
    @product = Product.find_by(id: params[:id])
    @product.destroy
    redirect_to root_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :status, :shipping_method, :shipping_burden, :region, :shipping_timetable, :price, :description, :image, :image_cache).merge(seller_id: current_user.id)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
