FactoryGirl.define do
  factory :user_archivement do
    association :user
    association :archivement
  end
end
