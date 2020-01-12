class CartController < ApplicationController
  before_action :require_not_admin

  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def show
    if current_user
      @items = cart.items
    else
      @items = cart.items
      flash.now[:error] = "You must #{view_context.link_to 'register', '/users/register'} or #{view_context.link_to 'log in', login_path} to checkout.".html_safe
    end
    if !(params[:code].nil?)
      coupon = Coupon.coupon_lookup(params[:code])
      cart.add_coupon(coupon.id)
      @discounted_total = cart.discounted_total
    elsif !(cart.coupon == {})
      @discounted_total = cart.discounted_total
    end
  end

  def empty
    session.delete(:cart)
    session.delete(:coupon)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end

  def update
    if params[:increment_decrement] == "increment"
      cart.add_quantity(params[:item_id]) unless cart.limit_reached?(params[:item_id])
    elsif params[:increment_decrement] == "decrement"
      cart.subtract_quantity(params[:item_id])
      return remove_item if cart.quantity_zero?(params[:item_id])
    end
    redirect_to "/cart"
  end

  private

  def require_not_admin
    render file: '/public/404'unless !current_admin?
  end
end
