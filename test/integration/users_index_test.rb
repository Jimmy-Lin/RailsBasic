require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
  	@user = users(:mike)
    @kanye = users(:kanye)
  end

  test "index including pagination" do
  	log_in_as(@user)
  	get users_path
  	assert_template 'users/index'
  	assert_select 'div.pagination'
  	User.paginate(page: 1).each do |user|
  		assert_select 'a[href=?]', user_path(user), text: "Show"
  	end
  end

  test "index as admin include edit and delete linsk" do
    log_in_as(@kanye, password: 'iamyeezus')
    get users_path
    assert_template 'users/index'
    first_page_of_users = User.paginate(page:1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', edit_user_path(user), text: 'Edit'
      assert_select 'a[href=?]', user_path(user), text: 'Destroy'
    end
  end

  test "index as non-admin" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    first_page_of_users = User.paginate(page:1)
    assert_select 'a[href=?]', edit_user_path(@user), text: 'Edit'
    assert_select 'a[href=?]', user_path(@user), text: 'Destroy'
  end
end
