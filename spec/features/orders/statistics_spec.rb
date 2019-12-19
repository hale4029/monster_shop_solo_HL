RSpec.describe("Order Statistics") do
  describe "Index page show most and least popular items" do
    it "shows top 5 purchases by quantity" do
      item_1 = create(:item)
      item_2 = create(:item)
      item_3 = create(:item)
      item_4 = create(:item)
      item_5 = create(:item)
      item_6 = create(:item)
      item_7 = create(:item)
      item_8 = create(:item)
      item_9 = create(:item)
      item_10 = create(:item)
      order_1 = create(:order)
      order_2 = create(:order)
      order_3 = create(:order)
      cart_1 = {item_1 => 10, item_2 => 9, item_3 => 8, item_6 => 5}
      cart_2 = {item_4 => 7, item_5 => 6, item_6 => 5}
      cart_3 = {item_7 => 4, item_8 => 3, item_9 => 2, item_10 => 1, item_6 => 5}

      cart_1.each do |item,quantity|
        order_1.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      cart_2.each do |item,quantity|
        order_2.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end
      cart_3.each do |item,quantity|
        order_3.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price
          })
      end

      expect(page).to have_content("1. #{@item_6.name}  Quantity: 15")
      expect(page).to have_content("1. #{@item_1.name}  Quantity: 10")
      expect(page).to have_content("1. #{@item_2.name}  Quantity: 9")
      expect(page).to have_content("1. #{@item_3.name}  Quantity: 8")
      expect(page).to have_content("1. #{@item_4.name}  Quantity: 7")

      expect(page).to have_content("1. #{@item_5.name}  Quantity: 6")
      expect(page).to have_content("1. #{@item_7.name}  Quantity: 4")
      expect(page).to have_content("1. #{@item_8.name}  Quantity: 3")
      expect(page).to have_content("1. #{@item_9.name}  Quantity: 2")
      expect(page).to have_content("1. #{@item_10.name}  Quantity: 1")
    
    end
  end
end
