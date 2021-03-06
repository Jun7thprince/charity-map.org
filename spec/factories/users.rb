# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  full_name              :string(255)
#  address                :string(255)
#  city                   :string(255)
#  bio                    :text
#  phone                  :string(255)
#  staff                  :boolean
#  avatar                 :string(255)
#  verified_by_phone      :boolean
#  provider               :string(255)
#  uid                    :string(255)
#  facebook_credentials   :hstore
#  org                    :boolean
#  figures                :hstore
#  latitude               :float
#  longitude              :float
#  facebook_friends       :hstore
#  api_token              :string(255)
#  website                :string(255)
#  notify_via_email       :boolean
#  notify_via_sms         :boolean
#  notify_via_facebook    :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email                 'team@charity-map.org'
    password              'CharityMap@2013'
    password_confirmation 'CharityMap@2013'
  end
end
