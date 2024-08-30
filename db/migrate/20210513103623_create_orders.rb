class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :customer_name, null: false
      t.belongs_to :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
