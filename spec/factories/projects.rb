FactoryGirl.define do
  factory :project do
    factory :good_project do
      name "A great project!"
      owner 1
      creator 1
    end

    factory :invalid_project do
      name "A not so great project"
      owner nil
      creator nil
    end
  end
end
