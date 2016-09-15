require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  	def setup
  		ActionMailer::Base.deliveries.clear
  	end

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
		assert_equal 1, ActionMailer::Base.deliveries.size
		user = assigns(:user)
		assert_not user.activated?
		log_in_as(user)
		assert_not is_logged_in?
		get edit_account_activation_path("invalid token", email: "wrong")
		assert_not is_logged_in?
		get edit_account_activation_path(user.activation_token, email: "wrong")
		assert_not is_logged_in?
		get edit_account_activation_path(user.activation_token, email: user.email)
		assert user.reload.activated?
		follow_redirect!
		assert_template "users/show"
		assert is_logged_in?
	end

end
