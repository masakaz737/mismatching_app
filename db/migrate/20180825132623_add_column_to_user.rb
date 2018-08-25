class AddColumnToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :message_recipient_id, :integer
    add_index :messages, :message_recipient_id
    add_foreign_key :messages, :users, column: :message_recipient_id
  end
end
