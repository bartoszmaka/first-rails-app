FactoryGirl.define do
  factory :archivement do
    name { "#{FFaker::BaconIpsum.word} #{Random.rand(10_000)}" }
    description { FFaker::HipsterIpsum.phrase }

    trait :with_icon do
      icon { FFaker::Avatar.image }
    end

    factory :archivement_with_icon, traits: [:with_icon]
  end
end
