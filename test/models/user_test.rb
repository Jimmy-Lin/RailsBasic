require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
  	@user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  def randomWord(length = 10)
  	word = ""
  	length.times do
  		word = word + ('a'..'z').to_a[rand(('a'..'z').to_a.length-1)]
  	end
  	return word
  end

  # One of possibly many test cases by QA
  test "should be valid" do 
  	assert @user.valid?
  end

  test "name should be present" do
  	@user.name = "     "
  	assert_not @user.valid?
  end

  test "email should be present" do
  	@user.name = "     "
  	assert_not @user.valid?
  end

  test "name should not be too long" do
  	@user.name = randomWord(100)
  	assert_not@user.valid?
  end

  test "email should not be too long" do
  	@user.email = randomWord(255) + "@example.com"
  	assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
  	valid_addresses = ["user@example.com", "USER@foo.COM", "A_US-ER@foo.bar.org", "first.last@foo.jp", "alice+bob@baz.cn"]
  	valid_addresses.each do |addr|
  		@user.email = addr
  		assert @user.valid?, "#{addr.inspect} should be valid"
  	end
  end

  test "email validation should reject invalid addresses" do
  	valid_addresses = ["user@example,com", "user_at_foo.org", "user.name@example.", "foo@bar_baz.com", "foo@bar+baz.com"]
  	valid_addresses.each do |addr|
  		@user.email = addr
  		assert_not @user.valid?, "#{addr.inspect} should be invalid"
  	end
  end

  test "email addresses should be unique" do
  	duplicate_user = @user.dup
  	duplicate_user.email = @user.email.upcase
  	@user.save
  	assert_not duplicate_user.valid?
  end

  test "email addresses should be saved as lower-case" do
  	mixed_case_email = "Foo@ExAMPle.CoM"
  	@user.email = mixed_case_email
  	@user.save
  	assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present (nonblank)" do
  	@user.password = @user.password_confirmation = " " * 6
  	assert_not @user.valid?
  end

  test "password should have a minimum length" do
  	@user.password = @user.password_confirmation = "a" * 5
  	assert_not @user.valid?
  end

  test "authenticated? should return false for a user with a nil digest" do
    assert_not @user.authenticated?(:remember, nil)
  end

end
