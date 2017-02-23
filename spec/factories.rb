FactoryGirl.define do
  factory :login do
    sequence(:user_login) { |n| random_name }
    sequence(:password)   { |n| random_name }
  end
  factory :user do
    first_name "John"
    second_name "Bravo"
  end
end

def random_name
  ('a'..'t').to_a.shuffle.join
end
