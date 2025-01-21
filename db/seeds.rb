# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create a test user
user = User.create!(
  email: 'test@example.com',
  password: 'password',
  password_confirmation: 'password'
)

# Create a sample blank form
form = Form.create!(
  user: user,
  title: 'My Custom Form',
  description: 'A customizable form for collecting responses.',
  completion_message: 'Thank you for your response!'
)
