FactoryGirl.define do
  factory :project do
    factory :good_project do
      title "A great project!"
      owner 1
      creator 1
      status 0
    end

    factory :good_project2 do
      title "A fine project"
      owner 2
      creator 2
      status 0
    end

    factory :invalid_project do
      title "A not so great project"
      owner nil
      creator nil
      status 0
    end
  end
end
