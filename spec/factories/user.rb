FactoryGirl.define do
  factory :user do
    first_name "John"
    last_name  "Doe"
    email "ryan.da.baker@gmail.com"
    password "example_password"
  end

  factory :user2, class: User do
    first_name "Bob"
    last_name "Jones"
    email "kzizza@gmail.com"
    password "example_password"
  end

  factory :user3, class: User do
    first_name "Sean"
    last_name "TheTester"
    email "tylerstonephoto@gmail.com"
    password "example_password"
  end
end
