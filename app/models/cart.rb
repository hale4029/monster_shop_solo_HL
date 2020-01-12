class Cart
  attr_reader :contents
  attr_accessor :coupon

  def initialize(cart, coupon)
    @contents = cart
    @coupon = coupon
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def add_coupon(coupon_id)
    @coupon['coupon'] = coupon_id
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def discounted_total
    coupon = Coupon.find(@coupon['coupon'])
    @contents.sum do |item_id,quantity|
      item = Item.find(item_id)
      if item.merchant_id == coupon.merchant_id
        (item.price * (1 - (coupon.discount/100))) * quantity
      else
        item.price * quantity
      end
    end
  end

  def add_quantity(item_id)
    @contents[item_id] += 1
  end

  def subtract_quantity(item_id)
    @contents[item_id] -= 1
  end

  def limit_reached?(item_id)
    @contents[item_id] == Item.find(item_id).inventory
  end

  def quantity_zero?(item_id)
    @contents[item_id] == 0
  end
end
