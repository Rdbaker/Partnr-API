FactoryGirl.define do
  factory :project do
    factory :good_project do
      title "A great project!"
      owner 1
      creator 1
    end

    factory :good_project2 do
      title "A fine project"
      owner 2
      creator 2
    end

    factory :invalid_project do
      title "A not so great project"
      owner nil
      creator nil
    end
  end
end
