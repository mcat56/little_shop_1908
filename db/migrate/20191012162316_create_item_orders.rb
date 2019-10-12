class CreateItemOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :item_orders do |t|
      t.references :item, foreign_key: true
      t.references :order, foreign_key: true
      t.integer :item_quantity
      t.float :item_subtotal

      t.timestamps
    end
  end
end
