FactoryGirl.define do
  factory :token, class: Token do
    service 'rspec'
    user { FactoryGirl.create(:user, active: true) }
  end
end
