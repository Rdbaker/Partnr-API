FactoryGirl.define do
  factory :state do
    title "Idea"
    project nil
  end

  factory :state2, class: State do
    title "Design"
    project nil
  end

  factory :state3, class: State do
    title "Prototype"
    project nil
  end

  factory :state4, class: State do
    title "Showpiece"
    project nil
  end
end
