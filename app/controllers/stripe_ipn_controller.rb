class StripeIpnController < ApplicationController
  protect_from_forgery except: :create
  skip_before_action :verify_authenticity_token, only: :create
  before_action :authenticate_user!, except: :create


  def create
    event = Stripe::Event.retrieve params[:id]

    if event.type == "charge.succeeded" && event.data.object.paid
      # Xác nhận thanh toán thành công
      # ở bước này ta sẽ tạo hóa đơn cho sản phẩm mà user mới thanh toán
      # Gửi mail thông báo cho user các kiểu
    else
      # Xác nhận thanh thoán không thành công
      # Ta gửi email thông báo cho user
    end

    render :nothing => true
  end
end
