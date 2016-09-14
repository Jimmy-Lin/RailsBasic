require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

	test "should reject invalid sign-up and redirect to /new" do
		get signup_path
		assert_no_difference "User.count" do
	  		post users_path, params: { user: { name: "", email: "invalid@user", password: "foo", password_confirmation: "bar" } }
		end
		assert_template "users/new"
	end

	test "should accept valid sign-up and redirect to /show" do
		get signup_path
		assert_difference "User.count", 1 do
			post users_path, params: { user: { name: "Valid User", email: "user@valid.com", password: "foobar", password_confirmation: "foobar" } }
		end
		follow_redirect!
		assert_template "users/show"
		assert is_logged_in?
	end

end
