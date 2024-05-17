class AddCascadeDeleteToForeignKeys < ActiveRecord::Migration[6.1]
  def change
    # Remove existing foreign keys
    remove_foreign_key :chat_messages, :conversations
    remove_foreign_key :chat_messages, :users
    remove_foreign_key :participants, :conversations
    remove_foreign_key :participants, :users

    # Add new foreign keys with ON DELETE CASCADE
    add_foreign_key :chat_messages, :conversations, on_delete: :cascade
    add_foreign_key :chat_messages, :users, on_delete: :cascade
    add_foreign_key :participants, :conversations, on_delete: :cascade
    add_foreign_key :participants, :users, on_delete: :cascade
  end
end
