# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create some sample todos
Todo.find_or_create_by!(title: "Learn Ruby on Rails") do |todo|
  todo.description = "Go through Rails guides and build a simple application"
  todo.completed = true
end

Todo.find_or_create_by!(title: "Master ActiveRecord") do |todo|
  todo.description = "Understand models, associations, and database queries"
  todo.completed = false
end

Todo.find_or_create_by!(title: "Explore Hotwire/Turbo") do |todo|
  todo.description = "Learn about Turbo Frames and Turbo Streams for reactive UIs"
  todo.completed = false
end

puts "Created #{Todo.count} sample todos!"
