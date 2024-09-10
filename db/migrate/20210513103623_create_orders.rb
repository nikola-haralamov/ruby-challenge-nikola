class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.string :customer_name, null: false
      t.belongs_to :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
