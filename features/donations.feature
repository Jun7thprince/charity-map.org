Feature: Donation

	Scenario: User without contact info to be asked to update
		Given the date is "2013-09-10"
			And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Vu Manh Cuong"
			And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-14" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the amount "10000" and the description "reward description" with the project above
	 		And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass"
	 	Given the date is "2013-09-13"
	 	When I login as "donor@man.net"
		 	And I go to the project page of "Push The World"
	 		And I follow "Ủng Hộ Dự Án"
	 	Then I should see "Vui lòng điền đầy đủ thông tin liên hệ trước khi ủng hộ dự án Push The World"
	 		And I fill in "Full name" with "Hoang Minh Tus"
	 		And I fill in "Address" with "This is my address"
	 		And I fill in "Phone" with "+123456"
	 		And I press "Cập nhật Thông Tin"
	 	Then I should see "Cập nhật thành công."
 		When I go to the project page of "Push The World"
	 		And I follow "Ủng Hộ Dự Án"
	 	Then I should see "Vu Manh Cuong"

	Scenario: Email with bank account info to be sent for Bank Transfer donations
		Given the date is "2013-09-10"
			And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Vu Manh Cuong"
			And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-14" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the amount "10000" and the description "reward description" with the project above
	 		And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456"
	 	Given the date is "2013-09-13"
	 	When I login as "donor@man.net"
	 		And I go to the project page of "Push The World"
	 		And I follow "Ủng Hộ Dự Án"
	 		And I fill in "donation_amount" with "12345"
	 		And I fill in "donation_note" with "Nothing"
	 		And I select "Chuyển khoản ngân hàng" from "donation_collection_method"
	 		And I press "Tiếp Tục"
	 	Then an email should have been sent with:
		  """
		  From: tu@charity-map.org
		  To: donor@man.net
		  """
		When I follow the first link in the email
		Then I should see "Yêu cầu tra soát hệ thống đã được gửi. Chúng tôi sẽ liên lạc trong thời gian sớm nhất."
			And an email should have been sent with:
			  """
			  From: tu@charity-map.org
			  To: testing@man.net
			  """
		When I follow the first link in the email
		Then the URL should contain "dashboard"

	Scenario: Request verification for bank transfer on dashboard
	  Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the amount "12340" the description "reward description" with the project above
	  	And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456"
  	Given the date is "2013-09-12"
	 	When I login as "donor@man.net"
	 		And I go to the project page of "Push The World"
	 		And I follow "Ủng Hộ Dự Án"
	 		And I fill in "donation_amount" with "12345"
	 		And I fill in "donation_note" with "Nothing"
	 		And I select "Chuyển khoản ngân hàng" from "donation_collection_method"
	 		And I press "Tiếp Tục"
	  When I go to the dashboard
  	Then I should see "Chờ CK"
	  	And I follow "Đã Chuyển?"
	  Then  I should see "Yêu cầu tra soát hệ thống đã được gửi. Chúng tôi sẽ liên lạc trong thời gian sớm nhất."
	  Then  an email should have been sent with:
			"""
			From: tu@charity-map.org
			To: testing@man.net
			"""

	Scenario: Donation list for normal user
		Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the id "1"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the amount "10000" and the description "reward description" and the id "1" with the project above
	  	And there is a donation with the amount "10000" and the status "SUCCESSFUL" and the collection method "BANK_TRANSFER" and the user id "1"and the project reward id "1" with the project above
	 		And there is a donation with the amount "12666" and the status "PENDING" and the collection method "COD" and the user id "1" and the project reward id "1" with the project above
	 	When I go to the donation page of the project "Push The World"
	 	Then I should see "Chuyển Khoản Ngân Hàng"
	 		And I should see "10.000 đ"
	 		And I should see "Thành Công"
	 		And I should not see "12.666 đ"

	Scenario: Donation list for project creator
		Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the id "1"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the amount "10000" and the description "reward description" and the id "1" with the project above
	  	And there is a donation with the amount "10000" and the status "SUCCESSFUL" and the collection method "BANK_TRANSFER" and the user id "2" and the project reward id "1" with the project above
	  	And there is a donation with the amount "11000" and the status "PENDING" and the collection method "BANK_TRANSFER" and the user id "2" and the project reward id "1" with the project above
	  	And there is a donation with the amount "21000" and the status "REQUEST_VERIFICATION" and the collection method "BANK_TRANSFER" and the user id "2" and the project reward id "1" with the project above
	 		And there is a donation with the amount "12666" and the status "PENDING" and the collection method "COD" and the user id "2" and the project reward id "1" with the project above
	 		And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456" and the id "2"
	 	When I login as "testing@man.net"
	 	Then I go to the donation page of the project "Push The World"
	 		And I should see "Chuyển Khoản Ngân Hàng"
	 		And I should see "10.000 đ"
	 		And I should see "Thành Công"
	 		And I should see "Chuyển Khoản Ngân Hàng"
	 		And I should see "11.000 đ"
	 		And I should see "Chờ CK"
	 		And I should see "12.666 "
	 		And I should see "Đợi Xác Nhận"
	 		And I should see "Xác nhận"
	 		And I should see "Thu Tiền Mặt"
	 		And I should see "12.666 đ"
	 		And I should see "Đợi Liên Hệ"
	 		
	Scenario: Donation list for CM staff
		Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the id "1"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the amount "10000" and the description "reward description" and the id "1" with the project above
	  	And there is a donation with the amount "10000" and the status "SUCCESSFUL" and the collection method "BANK_TRANSFER" and the user id "1"and the project reward id "1" with the project above
	 		And there is a donation with the amount "12666" and the status "PENDING" and the collection method "COD" and the user id "1" and the project reward id "1" with the project above
	 		And there is a donation with the amount "21000" and the status "REQUEST_VERIFICATION" and the collection method "BANK_TRANSFER" and the user id "2" and the project reward id "1" with the project above
	 		And there is a user with the email "staff@man.net" and the password "secretpass" and the password confirmation "secretpass" and the staff "1"
	 	When I login as "staff@man.net"
	 	Then I go to the donation page of the project "Push The World"
	 		And I should see "Chuyển Khoản Ngân Hàng"
	 		And I should see "10.000 đ"
	 		And I should see "Thành Công"
	 		And I should see "Thu Tiền Mặt"
	 		And I should see "12.666 đ"
	 		And I should see "Đợi Liên Hệ"
	 		And I should see "Phụ trách"
	 		And I should not see "Chờ CK"

	Scenario: Filter donation by created_at
		Given the date is 2013-09-11
	  	And there is a user with the email "testing@man.net" and the password "secretpass" and the password confirmation "secretpass" and the id "1"
	  	And there is a project with the title "Push The World" and the description "test slug" and the start date "2013-09-11" and the end date "2013-09-13" and the funding goal "234234" and the location "HCM" and the status "REVIEWED" with the user above
	  	And there is a project reward with the amount "10000" and the description "reward description" and the id "1" with the project above
	  	And there is a donation with the amount "10000" and the status "SUCCESSFUL" and the collection method "BANK_TRANSFER" and the user id "2" and the project reward id "1" and the updated at "2013-09-11" and the created_at "2013-09-11" with the project above
	  	And there is a donation with the amount "11000" and the status "PENDING" and the collection method "BANK_TRANSFER" and the user id "2" and the project reward id "1" and the updated at "2013-09-11" and the created_at "2013-09-11" with the project above
	  	And there is a donation with the amount "21000" and the status "REQUEST_VERIFICATION" and the collection method "BANK_TRANSFER" and the user id "2" and the project reward id "1" and the updated at "2013-09-12" and the created_at "2013-09-12" with the project above
	 		And there is a donation with the amount "12666" and the status "PENDING" and the collection method "COD" and the user id "2" and the project reward id "1" and the updated at "2013-09-12" and the created_at "2013-09-12" with the project above
	 		And there is a user with the email "donor@man.net" and the password "secretpass" and the password confirmation "secretpass" and the full name "Nguoi Ung Ho" and the address "HCM" and the city "HCM" and the phone "123456" and the id "2"
	 	When I login as "testing@man.net"
	 	Then I go to the donation page of the project "Push The World"
	 		And I select "created_at" from "donation_filter"
	 		And I submit the "filter" form
	 	Then I should see "11/09/2013" within ".created_at"
	 		And I should see "12/09/2013" within ".created_at"

	
	
