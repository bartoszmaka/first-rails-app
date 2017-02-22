FactoryGirl.define do
  factory :vote do
    association :user, strategy: :create

    trait :for_article do
      association :votable, factory: :article, strategy: :create
    end

    trait :for_comment do
      association :votable, factory: :comment, strategy: :create
    end

    factory :article_vote, traits: [:for_article]
    factory :comment_vote, traits: [:for_comment]
  end
end
