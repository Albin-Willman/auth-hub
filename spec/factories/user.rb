FactoryGirl.define do
  factory :user, class: User do
    name 'Albin'
    email 'test@example.com'
    password '123456'
  end
end