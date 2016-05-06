class Skillset < ActiveRecord::Base
  belongs_to :user

  def calculate
    @skillscore ||= calculate_score
  end

  private

  def calculate_score
    tasks = user.tasks
    skills = tasks.collect { |t| t.skills }.flatten
    cats = tasks.collect { |t| t.categories }.flatten
    skillcount = skills.each_with_object(Hash.new(0)) { |skill,counts| counts[skill.title] += 1 }
    catcount = cats.each_with_object(Hash.new(0)) { |cat,counts| counts[cat.title] += 1 }
    {
      :skills => skillcount,
      :categories => catcount
    }
  end
end
