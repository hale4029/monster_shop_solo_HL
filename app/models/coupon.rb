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

  def self.coupon_lookup(code)
    where(code: code).first
  end
end
