class AddSupplierToOrders < ActiveRecord::Migration[7.2]
  def change
    change_table :orders, bulk: true do |t|
      t.belongs_to :supplier, null: true
      t.string :supplier_reference
    end
  end
end
