# == Schema Information
#
# Table name: users
#
#  id    :bigint           not null, primary key
#  age   :integer          not null
#  email :string           not null
#  name  :string           not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#  index_users_on_name   (name)
#
FactoryBot.define do
  factory :user do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    age { rand(1..80) }
  end
end
