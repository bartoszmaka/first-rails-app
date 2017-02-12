FactoryGirl.define do
  factory :user do
    name FFaker::Internet.user_name
    email { "#{name.gsub(/[^a-zA-Z0-9]/, '')}_#{Random.rand(10_000)}_#{Random.rand(10_000)}@factory.com" }
    password '123123'
    password_confirmation '123123'
  end
end
