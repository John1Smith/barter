FactoryGirl.define do
  factory :login do
    user_login "John Bravo"
    password  "qe12f4gg"
  end
  factory :user do
    first_name "John"
    second_name "Bravo"
  end
end