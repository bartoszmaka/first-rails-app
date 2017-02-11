FactoryGirl.define do
  factory :article do
    title 'testing articles'
    content 'testing articles blabla'
    association :user, strategy: :build
  end
end
