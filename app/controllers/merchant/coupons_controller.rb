class Merchant::CouponsController < Merchant::BaseController
  def index
    @coupons = Coupon.where(merchant_id: current_user.merchant_id)
  end

  def new
    merchant = Merchant.find(current_user.merchant_id)
    @coupon = merchant.coupons.new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    coupon = merchant.coupons.create(coupon_params)
    if coupon.save
      flash[:success] = "#{coupon.name} created!"
      redirect_to merchant_coupons_path
    else
      flash[:error] = coupon.errors.full_messages.to_sentence
      render :new
    end
  end



  private

  def coupon_params
    params.require(:coupon).permit(:name, :discount, :code, :merchant_id)
  end

end
