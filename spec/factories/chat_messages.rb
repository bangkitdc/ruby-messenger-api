FactoryBot.define do
  factory :chat_message do
    content { Faker::Lorem.sentence }
    user
    conversation
  end
end
