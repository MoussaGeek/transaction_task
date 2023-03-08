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
    ActiveRecord::Base.transaction do
    @order = current_user.orders.build(order_params)
    unless @order.save
      raise ActiveRecord::Rollback
    end
    @order.update_total_quantity
  end  
    # La méthode update_total_quantity est définie dans le modèle Order pour refléter le montant total des commandes passées.
    redirect_to orders_path
  end

  private

  def order_params
    params.require(:order).permit(ordered_lists_attributes: [:item_id, :quantity])
  end

end
