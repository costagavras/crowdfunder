FactoryBot.define do

  factory :user do
    email {"bettymaker@gmail.com"}
    first_name {"Johnnie"}
    last_name {"Torrance"}
    password {"12345678"}
    password_confirmation {"12345678"}
    admin {false}
  end
end
