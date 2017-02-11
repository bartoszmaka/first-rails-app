FactoryGirl.define do
  factory :comment do
    content 'sample content'
    association :article, strategy: :build
    association :user, strategy: :build
  end
end
