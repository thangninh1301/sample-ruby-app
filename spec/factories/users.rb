FactoryBot.define do
  factory :user_without_password, class: User do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
  end
end
