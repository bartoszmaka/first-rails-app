FactoryGirl.define do
  factory :vote do
    association :user, strategy: :create

    trait :for_article do
      association :votable, factory: :article, strategy: :create
    end

    trait :for_comment do
      association :votable, factory: :comment, strategy: :create
    end

    trait :positive do
      positive true
    end

    trait :negative do
      positive false
    end

    factory :positive_article_vote, traits: [:for_article, :positive]
    factory :negative_article_vote, traits: [:for_article, :negative]
    factory :positive_comment_vote, traits: [:for_comment, :positive]
    factory :negative_comment_vote, traits: [:for_comment, :negative]
  end
end
