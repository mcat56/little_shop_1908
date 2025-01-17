require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: "23137")
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end

    it 'shows a flash message that the merchant does not exist if I type an unknown id in the url' do
      visit '/merchants/506'

      expect(current_path).to eq('/merchants')
      expect(page).to have_content('This merchant does not exist. Please select an existing merchant.')
    end

    it 'I see merchant statistics ' do
      @tire = @bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 50.00, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 25.05, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @bike_shop.items.create(name: "Shimano Shifters", description: "It'll always shift!", active?: false, price: 75.00, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 4)
      items = { "#{@tire.id}" => 2, "#{@chain.id}" => 1, "#{@shifter.id}" => 3}
      cart = Cart.new(items)
      order_1 = Order.create!(name: 'Richy Rich', address: '102 Main St', city: 'NY', state: 'New York', zip: '10221', grand_total: 350.05, creation_date: '10/22/2019')
      cart = Cart.new(items)
      order_2 = Order.create!(name: 'Jeff Casimir', address: '102 Main St', city: 'Denver', state: 'Colorado', zip: '80218', grand_total: 350.05, creation_date: '10/22/2019')
      cart = Cart.new(items)
      order_3 = Order.create!(name: 'Bessie Coleman', address: '102 Main St', city: 'San Antonio', state: 'Texas', zip: '78240', grand_total: 350.05, creation_date: '10/22/2019')
      @tire.item_orders.create(item_quantity: 2, item_subtotal: 100.00, order_id: order_1.id)
      @chain.item_orders.create(item_quantity: 1, item_subtotal: 25.05, order_id: order_2.id)
      @shifter.item_orders.create(item_quantity: 3, item_subtotal: 225.00, order_id: order_3.id)

      visit "/merchants/#{@bike_shop.id}"

      within '#stats' do
        expect(page).to have_content('Merchant Statistics:')
        expect(page).to have_content("Number of items sold by Brian's Bike Shop: 3")
        expect(page).to have_content('Average item price: $50.02')
        expect(page).to have_content('Cities where merchant has sold: NY, Denver, San Antonio')
      end
    end

    it "I see the merchant's top three items" do
      pawty_city = Merchant.create(name: "Paw-ty City", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
      hot_dog = pawty_city.items.create(name: "Hot Dog Costume", description: "Purfect for your small to medium sized dog.", price: 17.00, image: "https://i.imgur.com/UQ8MPHd.jpg", inventory: 5)
      banana = pawty_city.items.create(name: "Banana Costume", description: "Don't let this costume slip by you!", price: 13.50, image: "https://i.imgur.com/Eg0lBXd.jpg", inventory: 7)
      shark = pawty_city.items.create(name: "Baby Shark Costume", description: "Baby shark, doo doo doo doo doo doo doo... ", price: 23.75, image: "https://i.imgur.com/gzRbKT2.jpg", inventory: 2)
      harry_potter = pawty_city.items.create(name: "Harry Potter Costume", description: "Look who got into Hogwarts.", price: 16.00, image: "https://i.imgur.com/GC4ppbA.jpg", inventory: 13)
      review_1 = hot_dog.reviews.create!(title: "Worst costume!", content: "NEVER buy this costume.", rating: 1)
      review_2 = hot_dog.reviews.create!(title: "Awesome costume!", content: "This was a great costume! Would buy again.", rating: 2)
      review_3 = banana.reviews.create!(title: "Meh", content: "I probably wouldn't buy this again.", rating: 3)
      review_4 = banana.reviews.create!(title: "Really Good Costume", content: "Can't wait to order more. I gave it a 4 because the order took long to process.", rating: 5)
      review_5 = shark.reviews.create!(title: "Disappointed", content: "Super disappointed in this costume. It broke after one use! Don't buy.", rating: 4)
      review_6 = shark.reviews.create!(title: "Best costume EVER!", content: "I'm ordering this costume for everyone I know with a dog. That's how much I loved it!", rating: 5)
      review_7 = harry_potter.reviews.create!(title: "Disappointed", content: "Super disappointed in this costume. It broke after one use! Don't buy.", rating: 2)
      review_8 = harry_potter.reviews.create!(title: "Best costume EVER!", content: "I'm ordering this costume for everyone I know with a dog. That's how much I loved it!", rating: 5)

      visit "/merchants/#{pawty_city.id}"

      within '#topitems' do
        expect(page).to have_content("Top 3 Items:")
        expect(page.find_all('.item')[0]).to have_link("Baby Shark Costume")
        expect(page.find_all('.item')[1]).to have_link("Banana Costume")
        expect(page.find_all('.item')[2]).to have_link("Harry Potter Costume")
      end
    end
  end
end
