FactoryGirl.define do
  factory :article_tag do
    association :article, strategy: :create
    association :tag, strategy: :create
  end
end
