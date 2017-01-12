FactoryGirl.define do
  factory :project do
    name "MyString"
    conclusion_at "2017-03-20 08:00:00"
    state "started"
    client
  end
end
