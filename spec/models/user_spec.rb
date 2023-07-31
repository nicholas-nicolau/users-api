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
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:age) }
    it { is_expected.to validate_presence_of(:email) }
    
    it { is_expected.to validate_uniqueness_of(:email) }
    it { is_expected.to validate_numericality_of(:age).is_greater_than(0) }
  end
end
