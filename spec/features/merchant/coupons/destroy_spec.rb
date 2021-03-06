require 'rails_helper'

RSpec.describe "Coupon Delete" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @coupon_1 = create(:coupon, merchant_id: @merchant_1.id)
    @coupon_2 = create(:coupon, merchant_id: @merchant_1.id)
    @coupon_3 = create(:coupon, merchant_id: @merchant_2.id)
  end

  it "delete coupon with no orders" do
    merchant_employee = create(:user, role: 1, merchant: @merchant_1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

    visit merchant_coupons_path

    within "#coupon-#{@coupon_1.id}" do
      click_on "Delete"
    end

    expect(current_path).to eq(merchant_coupons_path)
    expect(page).to have_content("#{@coupon_1.name} has been deleted.")
    expect(page).to_not have_css("#coupon-#{@coupon_1.id}")
  end

  it "cannot delete coupon that used in an order" do
    mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
    meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
    tire = meg.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    paper = mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 3)
    pencil = mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    user = create(:user)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

    visit "/items/#{paper.id}"
    click_on "Add To Cart"
    visit "/items/#{tire.id}"
    click_on "Add To Cart"
    visit "/items/#{pencil.id}"
    click_on "Add To Cart"
    visit "/cart"
    fill_in 'Code', with: @coupon_1.code
    click_button("Add Coupon")
    click_on "Checkout"

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

    merchant_employee = create(:user, role: 1, merchant: @merchant_1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(merchant_employee)

    visit merchant_coupons_path

    within "#coupon-#{@coupon_1.id}" do
      click_on "Delete"
    end

    expect(current_path).to eq(merchant_coupons_path)
    expect(page).to have_content("Coupon used in an order, unable to delete.")
    expect(page).to have_css("#coupon-#{@coupon_1.id}")
  end
end
