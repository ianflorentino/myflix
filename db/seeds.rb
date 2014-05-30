# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Video.create(title: "Title of Video", description: "Lipsum Lipsum Lipsum Lipsum Lipsum. Lipsum Lipsum Lipsum Lipsum Lipsum")
# Video.create(title: "Title of Video", description: "Lipsum Lipsum Lipsum Lipsum Lipsum. Lipsum Lipsum Lipsum Lipsum Lipsum")
# Video.create(title: "Title of Video", description: "Lipsum Lipsum Lipsum Lipsum Lipsum. Lipsum Lipsum Lipsum Lipsum Lipsum")
# Video.create(title: "Title of Video", description: "Lipsum Lipsum Lipsum Lipsum Lipsum. Lipsum Lipsum Lipsum Lipsum Lipsum")
# Video.create(title: "Title of Video", description: "Lipsum Lipsum Lipsum Lipsum Lipsum. Lipsum Lipsum Lipsum Lipsum Lipsum")

# Category.create(name: "TV Comedies")
# Category.create(name: "TV Drama")
# Category.create(name: "Movie Comedies")
# Category.create(name: "Movie Drama")
# Category.create(name: "Popular Movies")

5.times {Video.create(title: "Suits", description: "Lipsum Lipsum Lipsum Lipsum Lipsum. Lipsum Lipsum Lipsum Lipsum Lipsum", category_id: 1)}
5.times {Video.create(title: "The Simpsons", description: "Lipsum Lipsum Lipsum Lipsum Lipsum. Lipsum Lipsum Lipsum Lipsum Lipsum", category_id: 2)}
5.times {Video.create(title: "Friends", description: "Lipsum Lipsum Lipsum Lipsum Lipsum. Lipsum Lipsum Lipsum Lipsum Lipsum", category_id: 3)}
5.times {Video.create(title: "Family Matters", description: "Lipsum Lipsum Lipsum Lipsum Lipsum. Lipsum Lipsum Lipsum Lipsum Lipsum", category_id: 4)}
5.times {Video.create(title: "Community", description: "Lipsum Lipsum Lipsum Lipsum Lipsum. Lipsum Lipsum Lipsum Lipsum Lipsum", category_id: 5)}
