class CreateParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :participants, id: false do |t|
      t.references :user, null: false, foreign_key: true
      t.references :conversation, null: false, foreign_key: true
      t.datetime :last_read_at, null: false, default: Time.now

      t.timestamps
    end

    add_index :participants, [:user_id, :conversation_id], unique: true
  end
end
