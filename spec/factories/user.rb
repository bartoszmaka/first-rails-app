FactoryGirl.define do
  factory :user do
    email do
      "#{FFaker::Internet.user_name.gsub(/[^a-zA-Z0-9]/, '')}_#{Random.rand(10_000)}_#{Random.rand(10_000)}@factory.com"
    end
    password '123123'
    password_confirmation { password }

    before(:create) do |user|
      user.skip_confirmation!
    end

    trait :with_avatar do
      avatar { FFaker::Avatar.image }
    end

    trait :admin_role do
      after(:create) do |user|
        user.add_role 'admin'
      end
    end

    factory :admin, traits: [:admin_role]
    factory :user_with_avatar, traits: [:with_avatar]
    factory :admin_with_avatar, traits: [:with_avatar, :admin_role]
  end
end
