class Coupon < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name,
                        :code,
                        :discount,
                        :merchant_id

  validates :code, uniqueness: true, presence: true
end
