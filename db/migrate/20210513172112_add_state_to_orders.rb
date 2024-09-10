class AddStateToOrders < ActiveRecord::Migration[7.2]
  def change
    add_column :orders, :state, :integer, default: Order.states[:pending]
  end
end