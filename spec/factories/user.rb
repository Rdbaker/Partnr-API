FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    email "jdoe@test.com"
    password "example_password"
  end

  factory :user2, class: User do
    first_name "Bob"
    last_name "Jones"
    email "bjones@test.com"
    password "example_password"
  end
end
