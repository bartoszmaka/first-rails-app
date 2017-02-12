FactoryGirl.define do
  factory :tag do
    name "#{FFaker::HipsterIpsum.word.delete(' ')}#{Random.rand(10_000)}"
  end
end
