200.times do |i|
  Recipe.seed do |p|
    p.id = i+1
    p.name          = Faker::Lorem.sentence
    p.instructions  = Faker::Lorem.paragraph
  end
end
