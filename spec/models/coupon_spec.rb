require 'rails_helper'

describe Coupon, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :code }
    it { should validate_presence_of :discount }
    it { should validate_presence_of :merchant_id }
    it { should validate_uniqueness_of :code}
  end

  describe "relationships" do
    it {should belong_to :merchant}
  end

end
