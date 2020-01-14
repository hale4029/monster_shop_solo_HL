require 'rails_helper'

RSpec.describe "Create Coupon Page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @coupon_1 = create(:coupon, merchant_id: @merchant_1.id)
    @coupon_2 = create(:coupon, merchant_id: @merchant_1.id)
    @coupon_3 = create(:coupon, merchant_id: @merchant_2.id)

    @merchant_employee = create(:user, role: 1, merchant: @merchant_1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  it "create new coupon" do
    visit merchant_coupons_path
    click_on "Create New Coupon"

    expect(current_path).to eq(new_merchant_coupon_path)
    fill_in 'Name', with: "Huge Discount"
    fill_in 'Discount', with: 60
    fill_in 'Code', with: "crazy1234"
    click_button "Submit"

    coupon = Coupon.last

    expect(current_path).to eq(merchant_coupons_path)
    expect(page).to have_content("#{coupon.name} created!")
    within "#coupon-#{coupon.id}" do
      expect(page).to have_content(coupon.name)
      expect(page).to have_content(coupon.code)
      expect(page).to have_content(coupon.discount)
      expect(page).to have_content(coupon.merchant_id)
    end
  end

  it "cannot create without correct/missing information -- info remains after error attempt" do
    coupon_4 = create(:coupon, name: "Test", merchant_id: @merchant_2.id)
    visit merchant_coupons_path
    click_on "Create New Coupon"
    expect(current_path).to eq(new_merchant_coupon_path)

    fill_in 'Name', with: ''
    fill_in 'Discount', with: 60
    fill_in 'Code', with: "crazy1234"
    click_button "Submit"

    expect(page).to have_content("Name can't be blank")
    expect(find_field('Name').value).to eq ''
    expect(find_field('Discount').value).to eq('60.0')
    expect(find_field('Code').value).to eq "crazy1234"
    expect(page).to have_button("Submit")

    fill_in 'Name', with: "Test"
    fill_in 'Discount', with: 60
    fill_in 'Code', with: "crazy1234"
    click_button "Submit"

    expect(page).to have_content("Name has already been taken")
    expect(find_field('Name').value).to eq "Test"
    expect(find_field('Discount').value).to eq('60.0')
    expect(find_field('Code').value).to eq "crazy1234"
    expect(page).to have_button("Submit")

    fill_in 'Name', with: "Discount Big"
    fill_in 'Discount', with: -1
    fill_in 'Code', with: "crazy1234"
    click_button "Submit"

    expect(page).to have_content("Discount is not included in the list")
    expect(find_field('Name').value).to eq "Discount Big"
    expect(find_field('Discount').value).to eq('-1.0')
    expect(find_field('Code').value).to eq "crazy1234"
    expect(page).to have_button("Submit")
  end

  it "five coupon creation max" do
    create(:coupon, merchant_id: @merchant_1.id)
    create(:coupon, merchant_id: @merchant_1.id)
    create(:coupon, merchant_id: @merchant_1.id)

    visit merchant_coupons_path
    click_on "Create New Coupon"

    fill_in 'Name', with: "Huge Discount"
    fill_in 'Discount', with: 60
    fill_in 'Code', with: "crazy1234"
    click_button "Submit"

    expect(current_path).to eq(merchant_coupons_path)
    expect(page).to have_content("Coupon creation limit of five reached.")
  end
end
