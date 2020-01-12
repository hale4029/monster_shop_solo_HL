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
      click_on "Delete"
    end

    expect(current_path).to eq(merchant_coupons_path)

    expect(page).to_not have_css("#coupon-#{@coupon_1.id}")
  end
end
