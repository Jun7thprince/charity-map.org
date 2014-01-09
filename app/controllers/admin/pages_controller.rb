class Admin::PagesController < ApplicationController
  before_filter :http_authenticate

  def projects
    @projects = Project.all
  end

  def donations
    @donations = Donation.all.order("created_at DESC")
    @ext_donations = ExtDonation.all.order("created_at DESC")
  end

  def users
    @users = User.all.order("created_at DESC")
  end

  protected

  def http_authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["HTTP_USERNAME"] && password == ENV["HTTP_PASSWORD"]
    end
  end
end