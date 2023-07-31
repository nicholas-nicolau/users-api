require 'rails_helper'

RSpec.describe UserService, type: :service do
  describe 'creation' do
    let(:service) { described_class.new(parameters) }

    context 'with invalid parameters' do
      let(:parameters) { { 'name' => '' } }

      it 'does not create a new contact' do
        expect { service.create }.to_not change(User, :count)
      end

      it 'returns false' do
        service.create

        expect(service.success?).to be_falsy
      end

      it 'returns the errors' do
        service.create

        expect(service.errors).to_not be_empty
      end
    end

    context 'with valid parameters' do
      let(:parameters) { { 'name' => 'name1', 'email' => 'email@email.com', 'age' => '123' } }

      it 'creates a new user' do
        expect { service.create }.to change(User.all, :count).by(1)
      end

      it 'returns the created user' do
        service.create

        expect(service.record).to eq(User.last)
      end

      it 'returns true' do
        service.create

        expect(service.success?).to be_truthy
      end
    end
  end

  describe 'update' do
    let(:service) { described_class.new(parameters) }

    before(:each) { @user = create(:user) }

    context 'with invalid parameters' do
      let(:parameters) { { 'name' => '' } }

      it 'does not create a new user' do
        expect { service.update(@user.id) }.to_not change(User, :count)
      end

      it 'returns false' do
        service.update(@user.id)

        expect(service.success?).to be_falsy
      end

      it 'returns the errors' do
        service.update(@user.id)

        expect(service.errors).to_not be_empty
      end
    end

    context 'with valid parameters' do
      let(:parameters) { { 'name' => 'name2' } }

      it 'updates the user' do
        service.update(@user.id)

        user = service.record

        expect(user.name).to eq('name2')
      end
    end
  end

  describe 'destroy' do
    let(:service) { described_class.new }

    before(:each) { @user = create(:user) }

    context 'with valid parameters' do
      it 'destroys the user' do
        expect { service.destroy(@user.id) }.to change(User.all, :count).by(-1)
      end

      it 'returns true' do
        service.destroy(@user.id)

        expect(service.success?).to be_truthy
      end
    end
  end
end
