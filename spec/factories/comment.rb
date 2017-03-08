FactoryGirl.define do
  factory :comment do
    content { FFaker::HipsterIpsum.phrase }
    association :article
    association :user
  end
end
