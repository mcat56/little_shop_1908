require 'rails_helper'

RSpec.describe ItemOrder do
  describe 'validations' do
    it { should validate_presence_of :item_quantity }
    it { should validate_presence_of :item_subtotal }
  end

  describe 'relationships' do
    it { should belong_to :item }
    it { should belong_to :order }
  end

  describe 'attributes' do
    it 'has attributes' do
      bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      chain = bike_shop.items.create(name: "Chain", description: "Great chain!", price: 25.05, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      pump = bike_shop.items.create(name: "Pump", description: "Best pump on the market!", price: 50, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      order = Order.create(name: 'Mary', address: '42 Wallaby Way', city: 'Denver', state: 'CO', zip: '80202', grand_total: 275.05, creation_date: "10/12/2019")
      item_order_1 = order.item_orders.create(item_quantity: 2, item_subtotal: 100, item_id: tire.id)
      item_order_2 = order.item_orders.create(item_quantity: 1, item_subtotal: 25.05, item_id: chain.id)
      item_order_3 = order.item_orders.create(item_quantity: 3, item_subtotal: 150, item_id: pump.id)

      expect(item_order_1.item_quantity).to eq(2)
      expect(item_order_1.item_subtotal).to eq(100)
      expect(item_order_2.item_quantity).to eq(1)
      expect(item_order_2.item_subtotal).to eq(25.05)
      expect(item_order_3.item_quantity).to eq(3)
      expect(item_order_3.item_subtotal).to eq(150)
    end 
  end
end
