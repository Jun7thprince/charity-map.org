@api-call
Feature: Gift Card
  Scenario: validates card token all the time!
    When I go to the gift card page
      And I fill in "card_token" with "123"
      And I press "Bắt đầu sử dụng thẻ"
    Then I should see "Mã không hợp lệ."
    Given there is a user with the full name "MixUP" and the email "mixup@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "mixup@gmail.com"
      And I go to the gift card page
      And I fill in "card_token" with "123"
      And I press "Bắt đầu sử dụng thẻ"
    Then I should see "Mã không hợp lệ."

  Scenario: Dashboard to be rendered given a user whose (Charitio) token exists
    Given there is a user with the full name "MixUP" and the email "mixup@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "mixup@gmail.com"
    # API: User Category from INDIVIDUAL to MERCHANT upon visiting Dashboard::GiftCard#index
    And I go to the users settings page
    And I should see "mixup@gmail.com" in the "user_email" input
    When I go to the gift cards dashboard
    Then I should see "+ Tạo gift card"
  
  Scenario: To be created successfully
    Given there is a user with the full name "MixUP" and the email "mixup@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "mixup@gmail.com"
      And I go to the gift cards dashboard
      And I follow "+ Tạo gift card"
      And I go to the create-new-card page
      And I fill in "gift_card_recipient_email" with "rebyn@me.com"
      And I fill in "gift_card_amount" with "100000"
      And I press "submit"
    And an email should have been sent with:
      """
      From: team@charity-map.org
      To: rebyn@me.com
      Subject: MixUP vừa gửi bạn một thẻ quà tặng charity-map.org!
      """
    And "rebyn@me.com" should receive an email
    When I open the email
    Then I should see "Bạn vừa nhận được một thẻ quà tặng từ" in the email body
    # Recipient to redeem the card
    And I am not authenticated
    When I follow "đường dẫn này" in the email
    Then the URL should contain "/gifts"
      And I press "Bắt đầu sử dụng thẻ"
      And I should see "Đăng ký tài khoản (chỉ tốn 5s) để bắt đầu sử dụng thẻ quà tặng từ MixUP!"
      And I should see "rebyn@me.com" in the "user_email" input
      And I fill in "user_password" with "secretpass"
      And I fill in "user_password_confirmation" with "secretpass"
    And I press "Đăng Ký"
    Then I should see "Xin chào! Bạn đã đăng ký thành công."
      And I follow "Hồ Sơ"
    Then I should see "TK: 100.000 VNĐ"
    # Card giver to see cards redeemed on the dashboard
    And I am not authenticated
    When I login as "mixup@gmail.com"
    And I go to the gift cards dashboard
    Then I should see "100,000" within "#total-value"
    And I should see "ACTIVE"
    # Case: Card code being used for more than one time
    When I am not authenticated
    And I open the email
    Then I should see "đường dẫn này" in the email body
    When I follow "đường dẫn này" in the email
      And I press "Bắt đầu sử dụng thẻ"
      Then I should see "Mã không hợp lệ."

  Scenario: To be created successfully, final recipient email != original one
    Given there is a user with the full name "MixUP" and the email "mixup@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "mixup@gmail.com"
      And I go to the gift cards dashboard
      And I follow "+ Tạo gift card"
      And I go to the create-new-card page
      And I fill in "gift_card_recipient_email" with "rebyn@me.com"
      And I fill in "gift_card_amount" with "100000"
      And I press "submit"
    And "rebyn@me.com" should receive an email
    When I open the email
    And I am not authenticated
    When I follow "đường dẫn này" in the email
      And I press "Bắt đầu sử dụng thẻ"
      And I fill in "user_email" with "saidrebyn@gmail.com"
      And I fill in "user_password" with "secretpass"
      And I fill in "user_password_confirmation" with "secretpass"
    And I press "Đăng Ký"
      And I follow "Hồ Sơ"
    Then I should see "TK: 100.000 VNĐ"
    And I am not authenticated
    When I login as "mixup@gmail.com"
    And I go to the gift cards dashboard
    Then I should see "saidrebyn@gmail.com"

  Scenario: Redeem gift card (signup via Facebook)
    Given there is a user with the full name "MixUP" and the email "mixup@gmail.com" and the password "secretpass" and the password confirmation "secretpass"
    When I login as "mixup@gmail.com"
      And I go to the gift cards dashboard
      And I follow "+ Tạo gift card"
      And I go to the create-new-card page
      And I fill in "gift_card_recipient_email" with "rebyn@me.com"
      And I fill in "gift_card_amount" with "100000"
      And I press "submit"
    And an email should have been sent with:
      """
      From: team@charity-map.org
      To: rebyn@me.com
      Subject: MixUP vừa gửi bạn một thẻ quà tặng charity-map.org!
      """
    And "rebyn@me.com" should receive an email
    When I open the email
    Then I should see "Bạn vừa nhận được một thẻ quà tặng từ" in the email body
    # Redeem card and signup via Facebook
    And I am not authenticated
    When I follow "đường dẫn này" in the email
    Then the URL should contain "/gifts"
      And I press "Bắt đầu sử dụng thẻ"
      And I should see "Đăng ký tài khoản (chỉ tốn 5s) để bắt đầu sử dụng thẻ quà tặng từ MixUP!"
    When Facebook login is mocked
    And I follow "Đăng Ký Bằng Facebook"
    Then I should see "Đăng nhập thành công bằng tài khoản Facebook."
    And I follow "Hồ Sơ"
    Then I should see "TK: 100.000 VNĐ"
    And I am not authenticated
    When I login as "mixup@gmail.com"
    And I go to the gift cards dashboard
    Then I should see "100,000" within "#total-value"
    Then I should see "user@man.net"