# == Schema Information
#
# Table name: projects
#
#  id                   :integer          not null, primary key
#  title                :string(255)
#  description          :text
#  created_at           :datetime
#  updated_at           :datetime
#  start_date           :datetime
#  end_date             :datetime
#  funding_goal         :float
#  location             :string(255)
#  photo                :string(255)
#  user_id              :integer
#  status               :string(255)
#  slug                 :string(255)
#  brief                :text
#  video                :string(255)
#  unlisted             :boolean
#  address              :string(255)
#  latitude             :float
#  longitude            :float
#  invite_email_content :text
#  invite_sms_content   :string(255)
#  short_code           :string(255)
#  bank_info            :text
#  item_based           :boolean
#

require 'spec_helper'

describe Project do
  it "should have a defaulted status before_create" do
    project = Project.create(:title => "Test", :brief => "This is a brief to be put here", :description => "Help me to put something here",
      start_date: Time.parse('2013-05-23'), end_date: Time.parse('2013-05-30'), funding_goal: 3000000,
      location: "Ho Chi Minh", user_id: 1)
    project.status.should eq("DRAFT")
  end

  it "should have a start date > Date.today" do
    project = Project.create(:title => "Test", :brief => "This is a brief to be put here", :description => "Help me to put something here",
      start_date: Time.parse('2013-05-23'), end_date: Time.parse('2013-05-30'), funding_goal: 3000000,
      location: "Ho Chi Minh", user_id: 1)
    project.errors.full_messages.should eq(["Start date can't be in the past"])
  end

  it "should not have fundraising duration > 6 months" do
    project = Project.create(:title => "Test", :brief => "This is a brief to be put here", :description => "Help me to put something here",
      start_date: Time.parse('2015-05-23'), end_date: Time.parse('2016-05-30'), funding_goal: 3000000,
      location: "Ho Chi Minh", user_id: 1)
    project.errors.full_messages.should eq(["End date can't be more than 6 months from start date"])
  end
end
