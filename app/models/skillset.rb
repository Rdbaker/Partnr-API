class Skillset < ActiveRecord::Base
  belongs_to :user

  def calculate
    @skillscore ||= calculate_score
  end

  def tasks
    @tasks ||= user.tasks
  end

  def completed_tasks
    @completed_tasks ||= tasks.complete
  end

  def skills
    @skills ||= tasks.collect { |t| t.skills }.flatten
  end

  def categories
    @categories ||= tasks.collect { |t| t.categories }.flatten
  end

  def scored_skills
    @scored_skills ||= primitive_score(completed_tasks.collect { |t| t.skills}.flatten, :skill)
  end

  def scored_categories
    @scored_categories ||= primitive_score(completed_tasks.collect { |t| t.categories }.flatten, :category)
  end

  private

  def primitive_score(collection, symbol)
    # count the entities
    counted_hash = Hash.new(0)
    collection.each do |entity|
      counted_hash[entity] += 1
    end

    # put each entity and score in an array to return
    scored_entity_array = []
    counted_hash.each do |entity, count|
      scored_entity_array.push({ symbol => entity, :score => count })
    end
    scored_entity_array
  end

  def calculate_score
    skillcount = skills.each_with_object(Hash.new(0)) { |skill,counts| counts[skill.title] += 1 }
    catcount = categories.each_with_object(Hash.new(0)) { |cat,counts| counts[cat.title] += 1 }
    {
      :skills => skillcount,
      :categories => catcount
    }
  end
end
