require 'rails_helper'

RSpec.describe "Coupon Show Page" do
  before :each do
    @merchant = create(:merchant)
    @item_1 = create(:item, merchant: @merchant)
    @item_2 = create(:item, merchant: @merchant)
    @merchant_employee = create(:user, role: 1, merchant: @merchant)
    @coupon_1 = create(:coupon, merchant_id: @merchant.id)
    @coupon_2 = create(:coupon, merchant_id: @merchant.id)
    @coupon_3 = create(:coupon, merchant_id: @merchant.id)
    @coupon_4 = create(:coupon, merchant_id: @merchant.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant_employee)
  end

  it "access merchant coupon show page" do
    visit merchant_path
    click_on "Manage Coupons"
    expect(path).to eq(merchant_coupon_path(@merchant))
  end




end
