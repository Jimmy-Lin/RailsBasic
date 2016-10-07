class CreateMemberships < ActiveRecord::Migration[5.0]
  def change
    create_table :memberships do |t|
      t.references :user, foreign_key: true
      t.references :group, foreign_key: true
      t.boolean :is_requested
      t.boolean :is_invited

      t.timestamps
    end
    add_index :memberships, [:user_id, :group_id], unique:true
  end
end
