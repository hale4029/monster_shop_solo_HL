class Coupon < ApplicationRecord
  belongs_to :merchant
  has_many :orders

  validates_presence_of :name,
                        :code,
                        :discount,
                        :merchant_id

  validates :code, uniqueness: true, presence: true
  validates :name, uniqueness: true, presence: true
  validates_inclusion_of :discount, in: 1..100

  enum status: [:inactive, :active]

  def self.coupon_lookup(code)
    where(code: code).first
  end

  def self.change_status(id)
    where(id: id).update(status: 1)
  end

  def self.check_single_usage(code, user_id)
    id = self.coupon_lookup(code).id
    Order.where(user_id: user_id).where(coupon_id: id).length > 0
  end

  def self.max_coupon_amount(merchant_id)
    where(merchant_id: merchant_id).count <= 5
  end
end
