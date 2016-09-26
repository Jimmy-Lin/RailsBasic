require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  # What the actual fuck is this? Why even expose this when UserController should be in charge of follow/unfollow?
  # Seriously, WHAT. THE. FUCK.
  # Oh wait fuck.
  # I forgot, the user actions followers and following is to display the list of existing relationships
  # God dammit I'm retarded.
  test "create should require logged-in user" do
  	assert_no_difference 'Relationship.count' do
  		post relationships_path
  	end
  	assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
  	assert_no_difference "Relationship.count" do
  		delete relationship_path(relationships(:one))
  	end
  	assert_redirected_to login_url
  end

end
