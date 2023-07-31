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
  
class User < ApplicationRecord
  validates :email, :age, :name, presence: true, allow_blank: false

  validates :email, uniqueness: true
  validates :age, numericality: { greater_than: 0 }
end
