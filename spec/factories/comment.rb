FactoryGirl.define do
  factory :comment do
    content FFaker::HipsterIpsum.phrase
    association :article, strategy: :build
    association :user, strategy: :build
  end
end
