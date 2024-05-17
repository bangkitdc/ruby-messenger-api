FactoryBot.define do
  factory :conversation do
    title { Faker::Name.name }
  end
end
