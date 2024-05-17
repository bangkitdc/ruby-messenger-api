class RenameContentToMessageInChatMessages < ActiveRecord::Migration[6.1]
  def change
    rename_column :chat_messages, :content, :message
  end
end
