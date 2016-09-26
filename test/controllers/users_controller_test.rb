require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:mike)
    @other_user = users(:steven)
    @kanye = users(:kanye)
    @new_user = User.new
    @new_user.name = "Joseph Gordon Levitt"
    @new_user.email = "joseph@hitrecord.com"
    @new_user.password = "password"
    @new_user.password_confirmation = "password"
  end

  test "should get index" do
    log_in_as(@user)
    get users_url
    assert_response :success
  end

  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count', 1) do
      post users_url, params: { user: { email: @new_user.email, name: @new_user.name, password: @new_user.password, password_confirmation: @new_user.password_confirmation} }
    end

    @new_user = User.find_by(email: @new_user.email)
    # assert_redirected_to user_path(@new_user)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end

  test "should get edit" do
    log_in_as(@user)
    get edit_user_url(User.find_by(email: @user.email))
    assert_response :success
  end

  # test "should update user" do
  #   log_in_as(@other_user)
  #   patch user_path(@other_user), params: { user: { email: @user.email, name: @user.name, password: @user.password, password_confirmation: @user.password_confirmation } }
  #   assert_redirected_to @other_user
  # end

  test "should redirect index when not logged in" do 
    get users_path
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when underprivileged" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end

  test "should destroy user when privileged" do
    log_in_as(@kanye, password: 'iamyeezus')
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end
    assert_redirected_to users_url
  end

  test "should destroy user if it is a self access" do
    log_in_as(@user)
    assert_difference('User.count', -1) do
      delete user_url(@user)
    end
    assert_redirected_to users_url
  end

  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end
