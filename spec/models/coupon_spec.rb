require 'rails_helper'

describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :discount }
    it { should validate_presence_of :merchant_id }
    it { should validate_uniqueness_of :code}
    it { should validate_uniqueness_of :name}
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it { should have_many :orders }
  end

  describe "model methods" do
    before :each do
      mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @coupon = create(:coupon, discount: 50, merchant_id: mike.id)
    end
    
    it "self.coupon_lookup(code)" do
      result = Coupon.coupon_lookup(@coupon.code)
      expect(result).to eq(@coupon)
    end

    it "self.change_status(id)" do
      expect(@coupon.status).to eq('inactive')
      Coupon.change_status(@coupon.id)
      expect(Coupon.find(@coupon.id).status).to eq('active')
    end
  end

end
