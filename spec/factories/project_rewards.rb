# == Schema Information
#
# Table name: project_rewards
#
#  id          :integer          not null, primary key
#  value       :float
#  description :text
#  project_id  :integer
#  created_at  :datetime
#  updated_at  :datetime
#  name        :string(255)
#  photo       :string(255)
#  quantity    :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :project_reward do
    value 1.5
    description "MyText"
    project nil
  end
end
