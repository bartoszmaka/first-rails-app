FactoryGirl.define do
  factory :user do
    name 'FactoryGuy'
    email 'factoryguy@example.com'
    password '123123'
    password_confirmation '123123'
  end
end
