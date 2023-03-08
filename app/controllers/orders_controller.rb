class OrdersController < ApplicationController
  def index
    @orders = Order.where(user_id: current_user.id).order(created_at: :desc)
  end

  def new
    @order = Order.new
    @order.ordered_lists.build
    @items = Item.all.order(:created_at)
  end

  def create
    @order = current_user.orders.build(order_params)
    @order.save
    @order.update_total_quantity
    # La méthode update_total_quantity est définie dans le modèle Order pour refléter le montant total des commandes passées.
    redirect_to orders_path
  end

  private

  def order_params
    params.require(:order).permit(ordered_lists_attributes: [:item_id, :quantity])
  end

end
