Given /^I am not authenticated$/ do
  visit('/users/sign_out')
end

Given /^I am a new, authenticated user$/ do
  email = 'testing@man.net'
  password = 'secretpass'
  full_name = 'charitymap'
  User.new(:email => email, :password => password, :password_confirmation => password,
    :full_name => full_name).save!

  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Đăng Nhập"
end

Given /^I login as "(.*?)"$/ do |email|
  password = 'secretpass'
  visit '/users/sign_in'
  fill_in "user_email", :with => email
  fill_in "user_password", :with => password
  click_button "Đăng Nhập"
end

Then(/^the URL should contain "(.*?)"$/) do |string|
  current_url.should include(string)
end

Then(/^the URL should not contain "(.*?)"$/) do |string|
  current_url.should_not include(string)
end

Given /^I login via Facebook$/ do 
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    :provider => 'facebook',
    :uid => '123545',
    :info => {
      "email" => "user@man.net"
    },
    :credentials => {
      :token => 'AAA',
      :expires_at => '1609286400',
      :expires => true
    }
  })
  visit('/users/sign_in')
  click_link_or_button 'Đăng Nhập Bằng Facebook'
end

When /^I connect my Facebook account$/ do 
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    :provider => 'facebook',
    :uid => '123545',
    :info => {
      "email" => "user@man.net"
    },
    :credentials => {
      :token => 'AAA',
      :expires_at => '1609286400',
      :expires => true
    }
  })
  visit('/users/settings')
  click_link_or_button 'Kết nối TK Facebook'
end

When /^Facebook login is mocked$/ do 
  OmniAuth.config.test_mode = true
  OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
    :provider => 'facebook',
    :uid => '123545',
    :info => {
      "email" => "user@man.net"
    },
    :credentials => {
      :token => 'AAA',
      :expires_at => '1609286400',
      :expires => true
    }
  })
end