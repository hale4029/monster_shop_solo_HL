require 'rails_helper'

RSpec.describe Cart do
  describe "methods" do
    before(:each) do
      @mike = Merchant.create(name: "Mike's Print Shop", address: '123 Paper Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @paper = @mike.items.create(name: "Lined Paper", description: "Great for writing on!", price: 20, image: "https://cdn.vertex42.com/WordTemplates/images/printable-lined-paper-wide-ruled.png", inventory: 25)
      @pencil = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 100)
    end

    it 'add_item(item)' do
      cart = Cart.new(Hash.new(0), Hash.new(0))
      result = cart.add_item(@paper)
      expect(result).to eq(1)
    end

    it 'total_items' do
      cart = Cart.new(Hash.new(0), Hash.new(0))
      cart.add_item(@paper)
      cart.add_item(@pencil)
      result = cart.total_items
      expect(result).to eq(2)
    end

    it 'items' do
      cart = Cart.new(Hash.new(0), Hash.new(0))
      cart.add_item(@paper.id.to_s)
      cart.add_item(@pencil.id.to_s)
      result = cart.items
      expect(result.length).to eq(2)
    end

    it 'subtotal(item)' do
      cart = Cart.new(Hash.new(0), Hash.new(0))
      cart.add_item(@paper.id.to_s)
      cart.add_item(@pencil.id.to_s)
      cart.add_item(@pencil.id.to_s)
      result = cart.subtotal(@pencil)
      expect(result).to eq(4)
    end

    it 'total' do
      cart = Cart.new(Hash.new(0), Hash.new(0))
      cart.add_item(@paper.id.to_s)
      cart.add_item(@pencil.id.to_s)
      cart.add_item(@pencil.id.to_s)
      result = cart.total
      expect(result).to eq(24)
    end

    it 'add_quantity(item_id)' do
      cart = Cart.new(Hash.new(0), Hash.new(0))
      cart.add_item(@paper.id.to_s)
      cart.add_item(@pencil.id.to_s)
      cart.add_item(@pencil.id.to_s)
      result = cart.add_quantity(@pencil.id.to_s)
      expect(result).to eq(3)
    end

    it 'subtract_quantity(item_id)' do
      cart = Cart.new(Hash.new(0), Hash.new(0))
      cart.add_item(@paper.id.to_s)
      cart.add_item(@pencil.id.to_s)
      cart.add_item(@pencil.id.to_s)
      result = cart.subtract_quantity(@pencil.id.to_s)
      expect(result).to eq(1)
    end

    it 'limit_reached?(item_id)' do
      pencil_1 = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 2)
      cart = Cart.new(Hash.new(0), Hash.new(0))
      cart.add_item(@paper.id.to_s)
      cart.add_item(@pencil.id.to_s)
      cart.add_item(pencil_1.id.to_s)
      result = cart.limit_reached?(@pencil.id.to_s)
      expect(result).to eq(false)
      result = cart.limit_reached?(pencil_1.id.to_s)
      expect(result).to eq(false)
      cart.add_item(pencil_1.id.to_s)
      result = cart.limit_reached?(pencil_1.id.to_s)
      expect(result).to eq(true)
    end

    it 'quantity_zero?(item_id)' do
      pencil_1 = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 2, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 2)
      cart = Cart.new(Hash.new(0), Hash.new(0))
      cart.add_item(pencil_1.id.to_s)
      cart.add_item(pencil_1.id.to_s)
      result = cart.quantity_zero?(pencil_1.id.to_s)
      expect(result).to eq(false)
      cart.subtract_quantity(pencil_1.id.to_s)
      result = cart.quantity_zero?(pencil_1.id.to_s)
      expect(result).to eq(false)
      cart.subtract_quantity( pencil_1.id.to_s)
      result = cart.quantity_zero?(pencil_1.id.to_s)
      expect(result).to eq(true)
    end

    it "discounted total" do
      pencil_1 = @mike.items.create(name: "Yellow Pencil", description: "You can write on paper with it!", price: 10, image: "https://images-na.ssl-images-amazon.com/images/I/31BlVr01izL._SX425_.jpg", inventory: 2)
      cart = Cart.new(Hash.new(0), Hash.new(0))
      coupon = create(:coupon, discount: 50, merchant_id: @mike.id)
      cart.add_item(pencil_1.id.to_s)
      cart.add_coupon(coupon.id)
      result = cart.discounted_total
      expect(result).to eq(5)
    end

    it 'add_coupon(coupon_id)' do
      coupon = create(:coupon)
      cart = Cart.new(Hash.new(0), Hash.new(0))
      cart.add_coupon(coupon.id)
      expect(cart.coupon['coupon']).to eq(coupon.id)
    end

    it 'coupon_object' do
      coupon = create(:coupon)
      cart = Cart.new(Hash.new(0), Hash.new(0))
      cart.add_coupon(coupon.id)
      expect(cart.coupon_object).to eq(coupon)
    end


  end
end
