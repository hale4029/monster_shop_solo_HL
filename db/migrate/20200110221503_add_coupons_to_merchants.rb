class AddCouponsToMerchants < ActiveRecord::Migration[5.1]
  def change
    add_reference :merchants, :coupon, foreign_key: true
  end
end
