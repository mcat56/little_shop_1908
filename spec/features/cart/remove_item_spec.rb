require 'rails_helper'

RSpec.describe 'as a visitor I can remove an item from the cart' do
  before(:each) do
    @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: "80203")
    @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
    @dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    @pull_toy = @dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @dog_bone = @dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
  end
  it 'displays the cart without the item we deleted' do
    visit "items/#{@chain.id}"
    click_button "Add to Cart"

    visit "items/#{@dog_bone.id}"
    click_button 'Add to Cart'

    visit "items/#{@dog_bone.id}"
    click_button 'Add to Cart'

    visit "items/#{@pull_toy.id}"
    click_button 'Add to Cart'

    visit '/cart'

    within "#cart_item-#{@dog_bone.id}" do
      click_button "Remove Item"
    end

    expect(current_path).to eq('/cart')
    expect(page).to_not have_content("Dog Bone")
    expect(page).to have_content("Chain")
    expect(page).to have_content("Pull Toy")
  end
end
