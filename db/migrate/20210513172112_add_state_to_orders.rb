class AddStateToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :state, :string, default: 'pending'
  end
end