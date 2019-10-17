require 'rails_helper'

RSpec.describe 'As a visitor I can change the item quantity on the cart index page' do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    visit "items/#{@chain.id}"
    click_button "Add to Cart"
  end

  it 'when I click the add button it updates the cart and item quantity' do
    visit '/cart'

    within "#cart_item-#{@chain.id}" do
      click_button '+'

      expect(page).to have_content("2")

      click_button '+'

      expect(page).to have_content("3")
      click_button '+'

      expect(page).to have_content("4")

      click_button '+'

      expect(page).to have_content("5")

      click_button '+'

      expect(page).to have_content(" 5")
    end

    expect(page).to have_content('You have reached the Chain inventory limit.')
  end

  it 'when I click the delete button it updates the cart and item quantity' do
    visit '/cart'

    within "#cart_item-#{@chain.id}" do
      click_button '-'

      expect(page).to have_content("0")

      click_button '-'

      expect(page).to have_content("0")
    end

    expect(page).to have_content('There are no more Chains to remove.')
  end
end
