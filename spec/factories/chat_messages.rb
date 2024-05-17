FactoryBot.define do
  factory :chat_message do
    message { Faker::Lorem.sentence }
    user
    conversation
  end
end
