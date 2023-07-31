require 'rails_helper'

RSpec.describe UsersController, type: :request do
  context 'GET api/v1/users' do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let(:page_number) { 0 }
    let(:page_size) { 1 }
    let(:sort_by) { 'id' }
    let(:sort_direction) { 'asc' }
    let(:total_of_pages) { 2 }
    let(:total_of_registers) { 2 }
    let(:term){ ''}
    let(:parameters) { { "page_size" => "1", "page_number" => "0" } }
    let(:searcher) do 
      instance_double(
        UserSearcher,
        search: [user],
        page_number: page_number,
        page_size: page_size,
        sort_by: sort_by,
        sort_direction: sort_direction,
        total_of_pages: total_of_pages,
        total_of_registers: total_of_registers,
        term: term
      )
    end

    def do_get
      get '/api/v1/users', params: parameters
    end

    before { allow(UserSearcher).to receive(:new).and_return(searcher) }

    it 'creates a new instance of UserSearcher' do
      expect(UserSearcher).to receive(:new).with(ActionController::Parameters.new(parameters).permit!)
      
      do_get
    end

    it 'calls the search method on UserSearcher instance' do
      expect(searcher).to receive(:search)

      do_get
    end

    it 'renders the user data according to the parameters' do
      do_get
      data = JSON.parse(response.body)['users']
      
      expect(data[0]['id']).to eq(user.id)
      expect(data[0]['name']).to eq(user.name)
      expect(data[0]['email']).to eq(user.email)
      expect(data[0]['age']).to eq(user.age)
    end

    it 'renders the meta data according to the database' do
      do_get
      data = JSON.parse(response.body)['meta']
      
      expect(data['page_number']).to eq(page_number)
      expect(data['page_size']).to eq(page_size)
      expect(data['sort_by']).to eq(sort_by)
      expect(data['sort_direction']).to eq(sort_direction)
      expect(data['total_of_pages']).to eq(total_of_pages)
      expect(data['total_of_registers']).to eq(total_of_registers)
    end

    it 'returns the successful status' do
      do_get
      
      expect(response.status).to eq(200)
    end
  end

  context 'GET api/v1/users/:id' do
    let(:user) { create(:user) }
    let(:parameters) { { "id" => user.id } }

    def do_get
      get "/api/v1/users/#{user.id}", params: parameters
    end

    before { allow(User).to receive(:find).and_return(user) }

    it 'finds the user' do
      expect(User).to receive(:find).with(user.id.to_s)
      
      do_get
    end

    it 'renders the user data' do
      do_get
      data = JSON.parse(response.body)
      
      expect(data['id']).to eq(user.id)
      expect(data['name']).to eq(user.name)
      expect(data['email']).to eq(user.email)
      expect(data['age']).to eq(user.age)
    end

    it 'returns the successful status' do
      do_get
      
      expect(response.status).to eq(200)
    end
  end

  context 'POST api/v1/users' do
    let(:user) { create(:user) }
    let(:parameters) { { name: 'foobar', age: '25', email: 'foobar@gmail.com' } }
    let(:service) { instance_double(UserService, create: true, success?: true, record: user) }

    def do_post
      post '/api/v1/users', params: parameters
    end

    before { allow(UserService).to receive(:new).and_return(service) }

    it 'creates a new instance of UserService' do
      expect(UserService).to receive(:new).with(ActionController::Parameters.new(parameters).permit!)

      do_post
    end

    it 'calls the create method on UserService' do
      expect(service).to receive(:create)

      do_post
    end

    it 'returns the created status' do
      do_post

      expect(response.status).to eq(201)
    end

    it 'returns the user id' do
      do_post
      data = JSON.parse(response.body)

      expect(data['id']).to eq(user.id)
    end

    context 'when the service fails' do
      let(:service) { instance_double(UserService, create: true, success?: false, errors: ['errors']) }

      it 'returns the unprocessable status' do
        do_post

        expect(response.status).to eq(422)
      end

      it 'returns the errors' do
        do_post
        data = JSON.parse(response.body)

        expect(data['errors']).to eq(['errors'])
      end
    end
  end

  context 'PATCH api/v1/users/:id' do
    let(:user) { create(:user) }
    let(:parameters) { { name: 'foobar', age: '25', email: 'foobar@gmail.com' } }
    let(:service) { instance_double(UserService, update: true, success?: true) }

    def do_patch
      patch "/api/v1/users/#{user.id}", params: parameters.merge( id: user.id)
    end

    before { allow(UserService).to receive(:new).and_return(service) }

    it 'creates a new instance of UserService' do
      expect(UserService).to receive(:new).with(ActionController::Parameters.new(parameters).permit!)

      do_patch
    end

    it 'calls the update method on UserService' do
      expect(service).to receive(:update).with(user.id.to_s)

      do_patch
    end

    it 'returns the ok status' do
      do_patch

      expect(response.status).to eq(200)
    end

    context 'when the service fails' do
      let(:service) { instance_double(UserService, update: true, success?: false, errors: ['errors']) }

      it 'returns the unprocessable status' do
        do_patch

        expect(response.status).to eq(422)
      end

      it 'returns the errors' do
        do_patch
        data = JSON.parse(response.body)

        expect(data['errors']).to eq(['errors'])
      end
    end
  end

  context 'DELETE api/v1/users/:id' do
    let(:user) { create(:user) }
    let(:parameters) { { name: 'foobar', age: '25', email: 'foobar@gmail.com' } }
    let(:service) { instance_double(UserService, destroy: true, success?: true) }

    def do_delete
      delete "/api/v1/users/#{user.id}", params: parameters.merge(id: user.id)
    end

    before { allow(UserService).to receive(:new).and_return(service) }

    it 'creates a new instance of UserService' do
      expect(UserService).to receive(:new)

      do_delete
    end

    it 'calls the destroy method on UserService' do
      expect(service).to receive(:destroy).with(user.id.to_s)

      do_delete
    end

    it 'returns the no_content status' do
      do_delete

      expect(response.status).to eq(204)
    end

    context 'when the service fails' do
      let(:service) { instance_double(UserService, destroy: true, success?: false, errors: ['errors']) }

      it 'returns the unprocessable status' do
        do_delete

        expect(response.status).to eq(422)
      end

      it 'returns the errors' do
        do_delete
        data = JSON.parse(response.body)

        expect(data['errors']).to eq(['errors'])
      end
    end
  end
end