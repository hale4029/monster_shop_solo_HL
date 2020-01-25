require 'rails_helper'

RSpec.describe "Coupon Show Page" do
  before :each do
    @merchant_1 = create(:merchant)
    @merchant_2 = create(:merchant)
    @coupon_1 = create(:coupon, merchant_id: @merchant_1.id)
    @coupon_2 = create(:coupon, merchant_id: @merchant_1.id)
    @coupon_3 = create(:coupon, merchant_id: @merchant_2.id)

    @merchant_employee = create(:user, role: 1, merchant: @merchant_1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  it "access merchant coupon show page" do
    visit '/merchant'
    click_on "Manage Coupons"
    expect(current_path).to eq(merchant_coupons_path)
  end

  it "show all coupons for only the merchant associated with the merch_employee" do
    visit merchant_coupons_path

    within "#coupon-#{@coupon_1.id}" do
      expect(page).to have_content(@coupon_1.name)
      expect(page).to have_content(@coupon_1.code)
      expect(page).to have_content(@coupon_1.discount)
      expect(page).to have_content(@coupon_1.merchant_id)
    end

    within "#coupon-#{@coupon_2.id}" do
      expect(page).to have_content(@coupon_2.name)
      expect(page).to have_content(@coupon_2.code)
      expect(page).to have_content(@coupon_2.discount)
      expect(page).to have_content(@coupon_2.merchant_id)
    end

    #sad-test
    expect(page).to_not have_css("#coupon-#{@coupon_3.id}")
    expect(page).to_not have_content(@coupon_3.code)
  end
end
