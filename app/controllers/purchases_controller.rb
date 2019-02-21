class PurchasesController < ApplicationController

  Payjp.api_key = ENV["PAYJP_SECRET_KEY"]

  before_action :authenticate_user!
  before_action :set_product, only: [:show, :update]

  def show
    customer = Payjp::Customer.retrieve(id: current_user.id.to_s)
    @card = customer.cards.data[0]
    @user = User.find(current_user.id)
  end

  def update
    ActiveRecord::Base.transaction do
      @product.update(buyer_id: current_user.id)
      Payjp::Charge.create(
        currency: "jpy",
        amount:   @product.price,
        customer: current_user.id
      )
    end
  end

private
  def set_product
    @product = Product.find(params[:id])
  end

end
