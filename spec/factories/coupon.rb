FactoryBot.define do
  factory :coupon do
    sequence(:name) { |n| "Discount: #{n}"}
    code { SecureRandom.hex(10) }
    discount { rand(0.00..1.00).round(2) }
    merchant
  end
end
