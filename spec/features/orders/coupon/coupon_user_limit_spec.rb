require 'rails_helper'

RSpec.describe("New Order Page") do
  describe "When I check out from my cart" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
      @coupon_1 = create(:coupon, discount: 50, merchant_id: @mike.id)
      @coupon_2 = create(:coupon, merchant_id: @mike.id)
      @coupon_3 = create(:coupon, discount: 25, merchant_id: @meg.id)
      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"
    end

    it "I see all the information about my current cart" do
      user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      visit "/cart"

      fill_in 'Code', with: @coupon_1.code
      click_button("Add Coupon")
      expect(current_path).to eq('/cart')
      expect(page).to have_content("Discounted Total: $111.00")

      click_on "Checkout"

      within "#order-item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_link("#{@tire.merchant.name}")
        expect(page).to have_content("$#{@tire.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$100")
      end

      within "#order-item-#{@paper.id}" do
        expect(page).to have_link(@paper.name)
        expect(page).to have_link("#{@paper.merchant.name}")
        expect(page).to have_content("$#{@paper.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$20")
      end

      within "#order-item-#{@pencil.id}" do
        expect(page).to have_link(@pencil.name)
        expect(page).to have_link("#{@pencil.merchant.name}")
        expect(page).to have_content("$#{@pencil.price}")
        expect(page).to have_content("1")
        expect(page).to have_content("$2")
      end

      expect(page).to have_content("Total: $122")
      expect(page).to have_content("Discounted Total: $111.00")
      expect(page).to have_content("Coupon Name: #{@coupon_1.name}")
      expect(page).to have_content("Coupon Discount: #{@coupon_1.discount}")

      name = "Bert"
      address = "123 Sesame St."
      city = "NYC"
      state = "New York"
      zip = 10001

      fill_in :name, with: name
      fill_in :address, with: address
      fill_in :city, with: city
      fill_in :state, with: state
      fill_in :zip, with: zip

      click_on "Create Order"

      order = Order.last
      expect(order.coupon_id).to eq(@coupon_1.id)

      visit "/items/#{@paper.id}"
      click_on "Add To Cart"
      visit "/items/#{@tire.id}"
      click_on "Add To Cart"
      visit "/items/#{@pencil.id}"
      click_on "Add To Cart"

      visit "/cart"

      fill_in 'Code', with: @coupon_1.code
      click_button("Add Coupon")
      expect(current_path).to eq('/cart')
      expect(page).to have_content("Coupon code perviously used by user.")

    end
  end
end
