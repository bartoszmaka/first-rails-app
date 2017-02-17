FactoryGirl.define do
  factory :article do
    title { "#{FFaker::CheesyLingo.title} #{FFaker::HipsterIpsum.word} #{Random.rand(10_000)}" }
    content { "#{title} #{FFaker::HipsterIpsum.paragraph}" }
    association :user, strategy: :create
  end
end
