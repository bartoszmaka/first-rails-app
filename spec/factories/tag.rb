FactoryGirl.define do
  factory :tag do
    name { "#{FFaker::CheesyLingo.word.gsub(/[^a-z0-9]/i, '')}#{Random.rand(10_000)}" }
  end
end
