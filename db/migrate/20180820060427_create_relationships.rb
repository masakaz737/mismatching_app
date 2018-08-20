class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.integer :follower_id
      t.integer :followed_id
      t.integer :total_score
      t.integer :positive
      t.integer :faithful
      t.integer :cooperative
      t.integer :mental
      t.integer :curious
      t.integer :background

      t.timestamps
    end
    add_index :relationships, :follower_id
    add_index :relationships, :followed_id
    add_index :relationships, [:follower_id, :followed_id], unique: true
  end
end
