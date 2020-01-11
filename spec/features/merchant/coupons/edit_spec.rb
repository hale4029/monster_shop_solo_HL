require 'rails_helper'

RSpec.describe "Coupon Edit Page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @coupon_1 = create(:coupon, merchant_id: @merchant_1.id)
    @coupon_2 = create(:coupon, merchant_id: @merchant_1.id)
    @coupon_3 = create(:coupon, merchant_id: @merchant_2.id)

    @merchant_employee = create(:user, role: 1, merchant: @merchant_1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  it "edit new coupon page" do
    visit merchant_coupons_path

    within "#coupon-#{@coupon_1.id}" do
      expect(page).to have_content(@coupon_1.name)
      expect(page).to have_content(@coupon_1.code)
      expect(page).to have_content(@coupon_1.discount)
      expect(page).to have_content(@coupon_1.merchant_id)
      click_on "Edit"
    end

    expect(current_path).to eq(edit_merchant_coupon_path(@coupon_1))
  end

  it "cannot create without correct/missing information -- info remains after error attempt" do
    visit edit_merchant_coupon_path(@coupon_1)

    expect(find_field('Name').value).to eq @coupon_1.name
    expect(find_field('Discount').value).to eq(@coupon_1.discount.to_s)
    expect(find_field('Code').value).to eq @coupon_1.code

    fill_in 'Name', with: ""
    fill_in 'Discount', with: 60
    fill_in 'Code', with: "crazy1234"
    click_button "Submit"

    expect(page).to have_content("Name can't be blank")
    expect(find_field('Name').value).to eq ''
    expect(find_field('Discount').value).to eq('60.0')
    expect(find_field('Code').value).to eq "crazy1234"
    expect(page).to have_button("Submit")

    fill_in 'Name', with: "Huge Discount"
    fill_in 'Discount', with: 60
    fill_in 'Code', with: "crazy1234"
    click_button "Submit"

    expect(current_path).to eq(merchant_coupons_path)
    expect(page).to have_content("Huge Discount created!")
    within "#coupon-#{@coupon_1.id}" do
      expect(page).to have_content("Huge Discount")
      expect(page).to have_content("crazy1234")
      expect(page).to have_content('60.0')
      expect(page).to have_content(@coupon_1.merchant_id)
    end
  end
end
