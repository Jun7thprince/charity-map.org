require 'sms'

class UsersController < ApplicationController
  include SessionsHelper
  before_filter :authenticate_user!, except: :profile

  def dashboard 
    @messages = current_user.messages
    @count_unreaded_messages = current_user.messages.unreaded.count
  end

  def profile
    @user = User.find(params[:id]) || current_user
  end

  def settings
  	@user = current_user
  end

  def update_settings
  	@user = User.find(params[:user][:id])
  	if @user.update params[:user]
      if session_exist
        redirect_back
      else
        redirect_to users_settings_path
      end
      flash[:notice] = "Cập nhật thành công."
  	else
  		render :action => :settings, alert: "Cập nhật không thành công."
  	end
  end

  def verification_code_via_phone
    if params[:phone_number]
      @phone_number = params[:phone_number].gsub(/\D/, '').to_i.to_s
      @verification = Verification.new(user_id: current_user.id)
      if @verification.save
        sms = SMS.send(@phone_number, "Ma so danh cho viec xac nhan danh tinh tai charity-map.org: #{@verification.code}") if Rails.env.production?
        current_user.update(phone: @phone_number) if current_user.phone.blank?  
        redirect_to users_settings_path, notice: "Mã xác nhận vừa được gửi tới số +84#{@phone_number}. Mời bạn điền mã vào ô dưới để hoàn tất quá trình xác nhận."
      else
        redirect_to users_settings_path, alert: "Không thành công. Vui lòng thử lại."
      end
    elsif params[:phone_code]
      @verification = Verification.where(user_id: current_user.id, code: params[:phone_code], status: "UNUSED").first
      unless current_user.verified_by_phone
        current_user.update verified_by_phone: true
        @verification.update status: "USED"
        redirect_to users_settings_path, notice: "Xác nhận danh tính bằng số điện thoại hoàn tất."
      else
        redirect_to users_settings_path, alert: "Permission denied."
      end
    end
  end

  def show_message    
    @message = current_user.messages.with_id(params[:message_id]).first
    @message.mark_as_read
  end

  def new_message
    @to_email = params[:receiver]
    @message = ActsAsMessageable::Message.new
  end

  def create_message
    to_email = params[:acts_as_messageable_message][:receiver]
    @receiver = User.find_by_email(to_email)
    current_user.send_message(@receiver, params[:acts_as_messageable_message][:body])
    redirect_to :dashboard, notice: "Tin nhắn đã được gửi đi."
  end

  def new_reply_message
    @parent_message_id = params[:message_id]
    @parent_message = current_user.messages.with_id(params[:message_id]).first
    @parent_message.mark_as_read
    @message = ActsAsMessageable::Message.new
  end

  def reply_message
    @message = current_user.messages.with_id(params[:acts_as_messageable_message][:parent_message_id].to_i)
    @message.first.reply(params[:acts_as_messageable_message][:body])
    # redirect_to :back, notice: "Tin nhắn đã được gửi đi"
    redirect_to :dashboard, notice: "Tin nhắn đã được gửi đi."
  end

  private
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to new_user_session_path, alert: "Bạn cần đăng nhập để tiếp tục."
      end
    end
end