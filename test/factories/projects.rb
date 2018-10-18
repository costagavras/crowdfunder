FactoryBot.define do

  factory :project do
    title       {'Cool new boardgame'}
    description {'Trade sheep'}
    start_date  {DateTime.now + 1.day}
    end_date    {DateTime.now + 1.month}
    goal        {50000}
  end
end
