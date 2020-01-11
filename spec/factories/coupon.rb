FactoryBot.define do
  factory :coupon do
    sequence(:name) { |n| "Discount: #{n}"}
    code { SecureRandom.hex(10) }
    discount { rand(1..100) }
    merchant
  end
end
