class CreateLinks < ActiveRecord::Migration[5.0]
  def change
    create_table :links do |t|
      t.string :title
      t.string :source
      t.references :user, foreign_key: true
      t.references :folder, foreign_key: true

      t.timestamps
    end
  end
end
