FactoryGirl.define do
  factory :state do
    name "Idea"
    project nil
  end

  factory :state2, class: State do
    name "Design"
    project nil
  end

  factory :state3, class: State do
    name "Prototype"
    project nil
  end

  factory :state4, class: State do
    name "Showpiece"
    project nil
  end
end
