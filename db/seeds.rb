# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# 5.times do |i|
#  Category.create(name: "Global category ##{i}", color: 1)
# end

Category.create(name: "Work")
Category.create(name: "Hobby")
Category.create(name: "School")