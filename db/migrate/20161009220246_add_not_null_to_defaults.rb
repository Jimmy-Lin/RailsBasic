class AddNotNullToDefaults < ActiveRecord::Migration[5.0]
  def change
  	change_column_null :events, :is_public, false
  	change_column_null :announcements, :is_public, false
  	change_column_null :memberships, :is_requested, false
  	change_column_null :memberships, :is_invited, false
  end
end
