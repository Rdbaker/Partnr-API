# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
categories = [
  {
    :title => "Engineering",
    :description => "The application of science and math principles to design and construct useful products",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Life Science",
    :description => "Any science that deals directly with living organisms and their mechanisms",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Physical Science",
    :description => "Any science that explores non-living systems",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Mathematics",
    :description => "The abstract science concerned with number, quantity, and space",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Software",
    :description => "Anything to do with programs that run on computational technology",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Medicine",
    :description => "The science or practice of the diagnosis, treatment, and prevention of disease",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Public Health",
    :description => "Having to do with the health of a population",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Agriculture",
    :description => "The science or practice of farming",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Education",
    :description => "Anything having to do with the process of giving instruction",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Writing",
    :description => "Having to do with creatin, analyzing, or editing text",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Visual Art",
    :description => "Anything to do with arts created for the purpose of visual perception",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Music",
    :description => "Anything to do with arts created for the purpose of aural perception",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Film",
    :description => "Things having to do with motion pictures",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Theatre",
    :description => "The activity of acting in, producing, directing, or writing plays",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Policy & Law",
    :description => "Things having to do with the governance or procedures or a society or group",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Culture",
    :description => "The belief, customs, arts, and language of a particular society or group",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Economics",
    :description => "Things having to do with the productio, consumption, and transfer of goods and services",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
  {
    :title => "Business",
    :description => "The strategies and principles surrounding the engagement of people in commerce",
    :color_hex => "#dddddd",
    :icon_class => "placeholder"
  },
]

categories.each do |c|
  Category.create(c)
end
