FactoryGirl.define do
  factory :article do
    title "#{FFaker::CheesyLingo.title} #{FFaker::HipsterIpsum.words} #{Random.rand(10_000)}"
    content { "#{title} #{FFaker::HipsterIpsum.paragraph}" }
    association :user, strategy: :build
  end
end
