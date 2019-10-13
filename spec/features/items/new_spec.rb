require 'rails_helper'

RSpec.describe "Create Merchant Items" do
  describe "When I visit the merchant items index page" do
    before(:each) do
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)
    end

    it 'I see a link to add a new item for that merchant' do
      visit "/merchants/#{@brian.id}/items"

      expect(page).to have_link "Add New Item"
    end

    it 'I can add a new item by filling out a form' do
      visit "/merchants/#{@brian.id}/items"

      name = "Chamois Buttr"
      price = 18.00
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = 25

      click_on "Add New Item"

      expect(page).to have_link(@brian.name)
      expect(current_path).to eq("/merchants/#{@brian.id}/items/new")
      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_button "Create Item"

      new_item = Item.last

      expect(current_path).to eq("/merchants/#{@brian.id}/items")
      expect(new_item.name).to eq(name)
      expect(new_item.price).to eq(price)
      expect(new_item.description).to eq(description)
      expect(new_item.image).to eq(image_url)
      expect(new_item.inventory).to eq(inventory)
      expect(Item.last.active?).to be(true)
      expect(page).to have_css("#item-#{Item.last.id}")
      expect(page).to have_content(name)
      expect(page).to have_content("Price: $#{new_item.price}")
      expect(page).to have_css("img[src*='#{new_item.image}']")
      expect(page).to have_content("Active")
      expect(page).to_not have_content(new_item.description)
      expect(page).to have_content("Inventory: #{new_item.inventory}")
    end

    it 'I see a flash message when I try to create a new item without all fields filled out' do
      visit "/merchants/#{@brian.id}/items"

      click_on "Add New Item"

      fill_in :name, with: " "
      fill_in :price, with: " "
      fill_in :description, with: " "
      fill_in :image, with: " "
      fill_in :inventory, with: " "

      click_on 'Create Item'

      expect(current_path).to eq("/merchants/#{@brian.id}/items/new")
      expect(page).to have_content("Name can't be blank, Description can't be blank, Price can't be blank, Image can't be blank, and Inventory can't be blank")
    end
  end
end
