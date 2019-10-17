require 'rails_helper'

RSpec.describe 'As a visitor' do
  describe 'when I visit my cart index page I see all the items I have added' do
    before(:each) do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: "80210")
      @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
    end

    it 'shows all item information and total cost of the items in cart' do
      visit "items/#{@chain.id}"

      expect(page).to have_link("Cart: 0")
      click_button 'Add to Cart'

      expect(page).to have_link("Cart: 1")
      visit "items/#{@chain.id}"
      click_button 'Add to Cart'

      expect(page).to have_link("Cart: 2")
      visit "items/#{@pull_toy.id}"
      click_button 'Add to Cart'

      expect(page).to have_link("Cart: 3")
      visit "items/#{@dog_bone.id}"
      click_button 'Add to Cart'

      expect(page).to have_link("Cart: 4")
      visit "items/#{@dog_bone.id}"
      click_button 'Add to Cart'

      expect(page).to have_link("Cart: 5")
      visit "items/#{@dog_bone.id}"
      click_button 'Add to Cart'

      expect(page).to have_link("Cart: 6")
      visit '/cart'

      expect(page).to have_content("Chain")
      expect(page).to have_css("img[src*='#{@chain.image}']")
      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("$50.00")
      expect(page).to have_content("2")
      expect(page).to have_content("$100.00")

      expect(page).to have_content("Pull Toy")
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      expect(page).to have_content("Brian's Dog Shop")
      expect(page).to have_content("$10.00")
      expect(page).to have_content("1")
      expect(page).to have_content("$10.00")

      expect(page).to have_content("Dog Bone")
      expect(page).to have_css("img[src*='#{@dog_bone.image}']")
      expect(page).to have_content("Brian's Dog Shop")
      expect(page).to have_content("$21.00")
      expect(page).to have_content("3")
      expect(page).to have_content("$63.00")

      expect(page).to have_content("Grand Total: $173.00")
    end

    it 'displays message that cart is empty and doesnt show link to empty cart' do
      visit '/cart'

      expect(page).to have_content("Your cart is empty!")
      expect(page).to_not have_link("Empty Cart")
    end
    it 'shows all item information and total cost of the items in cart' do
      visit "items/#{@chain.id}"
      click_button 'Add to Cart'
      visit "items/#{@chain.id}"
      click_button 'Add to Cart'
      visit "items/#{@pull_toy.id}"
      click_button 'Add to Cart'
      visit "items/#{@dog_bone.id}"
      click_button 'Add to Cart'
      visit "items/#{@dog_bone.id}"
      click_button 'Add to Cart'
      visit "items/#{@dog_bone.id}"
      click_button 'Add to Cart'
      visit '/cart'

      expect(page).to have_button("Empty Cart")

      click_button 'Empty Cart'


      expect(current_path).to eq('/cart')
      expect(page).to have_link("Cart: 0")
      expect(page).to_not have_button("Empty Cart")
      expect(page).to_not have_content("Dog Bone")
      expect(page).to_not have_content("Pull Toy")
      expect(page).to_not have_content("Chain")
    end
  end
end
