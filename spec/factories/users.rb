FactoryBot.define do
  factory :user_without_password, class: User do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
  end

  factory :user_mike, class: User do
    name { 'mike' }
    email { Faker::Internet.email }
    password { 'password' }
    before(:create, &:confirm)
  end

  factory :another_user, class: User do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
    password { 'password' }
    before(:create, &:confirm)
  end

  factory :new_user, class: User do
    name { Faker::Name.unique.name }
    email { Faker::Internet.email }
    password { '' }
  end
end
