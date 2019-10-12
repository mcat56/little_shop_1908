class CreateOrders < ActiveRecord::Migration[5.1]
  def change
    create_table :orders do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.float :grand_total
      t.string :creation_date

      t.timestamps
    end
  end
end
