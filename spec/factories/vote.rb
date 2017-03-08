FactoryGirl.define do
  factory :vote do
    association :user

    trait :for_article do
      association :votable, factory: :article
    end

    trait :for_comment do
      association :votable, factory: :comment
    end

    factory :article_vote, traits: [:for_article]
    factory :comment_vote, traits: [:for_comment]
  end
end
