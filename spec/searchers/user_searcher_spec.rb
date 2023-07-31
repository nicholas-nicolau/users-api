require 'rails_helper'

RSpec.describe UserSearcher, type: :searcher do
  describe '#search' do
    subject { described_class.new(parameters) }

    let!(:user) { create(:user, age: 1, name: 'KKK', email: 'KKKA@gmail.com') }
    let!(:user2) { create(:user, age: 2, name: 'JJJ', email: 'JJJ@gmail.com') }
    let!(:user3) { create(:user, age: 3, name: 'III', email: 'III@gmail.com') }
    let!(:user4) { create(:user, age: 4, name: 'HHH', email: 'HHH@gmail.com') }
    let!(:user5) { create(:user, age: 5, name: 'GGG', email: 'GGG@gmail.com') }
    let!(:user6) { create(:user, age: 6, name: 'FFFw', email: 'FFF@gmail.com') }
    let!(:user7) { create(:user, age: 7, name: 'EEEw', email: 'EEE@gmail.com') }
    let!(:user8) { create(:user, age: 8, name: 'DDDw', email: 'DDD@gmail.com') }
    let!(:user9) { create(:user, age: 9, name: 'CCCw', email: 'CCC@gmail.com') }
    let!(:user10) { create(:user, age: 10, name: 'BBBw', email: 'BBB@gmail.com') }
    let!(:user11) { create(:user, age: 11, name: 'AAAw', email: 'AAA@gmail.com') }

    context 'when the user request from the db' do
      context 'when there are no parameters' do
        let(:parameters) { {} }

        it 'returns the first ten registers' do
          expect(subject.search).to match_array([user, user2, user3, user4, user5, user6, user7, user8, user9, user10])
        end

        it 'sorts by id asc' do
          expect(subject.search).to eq([user, user2, user3, user4, user5, user6, user7, user8, user9, user10])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(10)
          expect(subject.page_number).to eq(0)
          expect(subject.sort_by).to eq('id')
          expect(subject.sort_direction).to eq('asc')
          expect(subject.total_of_pages).to eq(2)
          expect(subject.total_of_registers).to eq(11)
          expect(subject.term).to eq(nil)
        end
      end


      context 'when there is a page_size parameter' do
        let(:parameters) { {page_size: 2 } }

        it 'returns the first two registers' do
          expect(subject.search).to match_array([user, user2])
        end

        it 'sorts by id asc' do
          expect(subject.search).to eq([user, user2])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(2)
          expect(subject.page_number).to eq(0)
          expect(subject.sort_by).to eq('id')
          expect(subject.sort_direction).to eq('asc')
          expect(subject.total_of_pages).to eq(6)
          expect(subject.total_of_registers).to eq(11)
          expect(subject.term).to eq(nil)
        end
      end

      context 'when there is a page_number parameter' do
        let(:parameters) { {page_number: 1 } }

        it 'returns the 11º register' do
          expect(subject.search).to match_array([user11])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(10)
          expect(subject.page_number).to eq(1)
          expect(subject.sort_by).to eq('id')
          expect(subject.sort_direction).to eq('asc')
          expect(subject.total_of_pages).to eq(2)
          expect(subject.total_of_registers).to eq(11)
          expect(subject.term).to eq(nil)
        end
      end

      context 'when there is a sort_by parameter' do
        let(:parameters) { {sort_by: 'name' } }

        it 'returns the first ten registers' do
          expect(subject.search).to match_array([user2, user3, user4, user5, user6, user7, user8, user9, user10, user11])
        end

        it 'sorts by name asc' do
          expect(subject.search).to eq([user11, user10, user9, user8, user7, user6, user5, user4, user3, user2])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(10)
          expect(subject.page_number).to eq(0)
          expect(subject.sort_by).to eq('name')
          expect(subject.sort_direction).to eq('asc')
          expect(subject.total_of_pages).to eq(2)
          expect(subject.total_of_registers).to eq(11)
          expect(subject.term).to eq(nil)
        end
      end

      context 'when there is a sort_direction parameter' do
        let(:parameters) { {sort_direction: 'desc'} }

        it 'returns the first ten registers' do
          expect(subject.search).to match_array([user2, user3, user4, user5, user6, user7, user8, user9, user10, user11])
        end

        it 'sorts by id desc' do
          expect(subject.search).to eq([user11, user10, user9, user8, user7, user6, user5, user4, user3, user2])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(10)
          expect(subject.page_number).to eq(0)
          expect(subject.sort_by).to eq('id')
          expect(subject.sort_direction).to eq('desc')
          expect(subject.total_of_pages).to eq(2)
          expect(subject.total_of_registers).to eq(11)
          expect(subject.term).to eq(nil)
        end
      end

      context 'when there is a term parameter' do
        let(:parameters) { {term: 'w'} }

        it 'returns all registers that contains \'w\'' do
          expect(subject.search).to match_array([user6, user7, user8, user9, user10, user11])
        end

        it 'sorts by id desc' do
          expect(subject.search).to eq([user6, user7, user8, user9, user10, user11])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(10)
          expect(subject.page_number).to eq(0)
          expect(subject.sort_by).to eq('id')
          expect(subject.sort_direction).to eq('asc')
          expect(subject.total_of_pages).to eq(1)
          expect(subject.total_of_registers).to eq(6)
          expect(subject.term).to eq('w')
        end
      end
    end

    context 'when the user request from the api' do

      let(:body){ { users: User.all.to_a } }
      let!(:api_stub) { 
        stub_request(:get, "https://run.mocky.io/v3/ce47ee53-6531-4821-a6f6-71a188eaaee0/").
        with(
          headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Ruby'
          }).
        to_return(status: 200, body: body.to_json, headers: {})
      }

      context 'when there are no parameters' do
        let(:parameters) { { request_from_api: true } }

        it 'issues a get request' do
          subject.search

          expect(api_stub).to have_been_requested.once
        end

        it 'returns the first ten registers' do
          expect(subject.search).to match_array([user.as_json, user2.as_json, user3.as_json, user4.as_json, user5.as_json, user6.as_json, user7.as_json, user8.as_json, user9.as_json, user10.as_json])
        end

        it 'sorts by id asc' do
          expect(subject.search).to eq([user.as_json, user2.as_json, user3.as_json, user4.as_json, user5.as_json, user6.as_json, user7.as_json, user8.as_json, user9.as_json, user10.as_json])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(10)
          expect(subject.page_number).to eq(0)
          expect(subject.sort_by).to eq('id')
          expect(subject.sort_direction).to eq('asc')
          expect(subject.total_of_pages).to eq(2)
          expect(subject.total_of_registers).to eq(11)
          expect(subject.term).to eq(nil)
        end
      end


      context 'when there is a page_size parameter' do
        let(:parameters) { {page_size: 2, request_from_api: true } }

        it 'issues a get request' do
          subject.search

          expect(api_stub).to have_been_requested.once
        end

        it 'returns the first two registers' do
          expect(subject.search).to match_array([user.as_json, user2.as_json])
        end

        it 'sorts by id asc' do
          expect(subject.search).to eq([user.as_json, user2.as_json])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(2)
          expect(subject.page_number).to eq(0)
          expect(subject.sort_by).to eq('id')
          expect(subject.sort_direction).to eq('asc')
          expect(subject.total_of_pages).to eq(6)
          expect(subject.total_of_registers).to eq(11)
          expect(subject.term).to eq(nil)
        end
      end

      context 'when there is a page_number parameter' do
        let(:parameters) { {page_number: 1, request_from_api: true } }

        it 'issues a get request' do
          subject.search

          expect(api_stub).to have_been_requested.once
        end

        it 'returns the 11º register' do
          expect(subject.search).to match_array([user11.as_json])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(10)
          expect(subject.page_number).to eq(1)
          expect(subject.sort_by).to eq('id')
          expect(subject.sort_direction).to eq('asc')
          expect(subject.total_of_pages).to eq(2)
          expect(subject.total_of_registers).to eq(11)
          expect(subject.term).to eq(nil)
        end
      end

      context 'when there is a sort_by parameter' do
        let(:parameters) { {sort_by: 'name', request_from_api: true } }

        it 'issues a get request' do
          subject.search

          expect(api_stub).to have_been_requested.once
        end

        it 'returns the first ten registers' do
          expect(subject.search).to match_array([user2.as_json, user3.as_json, user4.as_json, user5.as_json, user6.as_json, user7.as_json, user8.as_json, user9.as_json, user10.as_json, user11.as_json])
        end

        it 'sorts by name asc' do
          expect(subject.search).to eq([user11.as_json, user10.as_json, user9.as_json, user8.as_json, user7.as_json, user6.as_json, user5.as_json, user4.as_json, user3.as_json, user2.as_json])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(10)
          expect(subject.page_number).to eq(0)
          expect(subject.sort_by).to eq('name')
          expect(subject.sort_direction).to eq('asc')
          expect(subject.total_of_pages).to eq(2)
          expect(subject.total_of_registers).to eq(11)
          expect(subject.term).to eq(nil)
        end
      end

      context 'when there is a sort_direction parameter' do
        let(:parameters) { {sort_direction: 'desc', request_from_api: true} }

        it 'issues a get request' do
          subject.search

          expect(api_stub).to have_been_requested.once
        end

        it 'returns the first ten registers' do
          expect(subject.search).to match_array([user2.as_json, user3.as_json, user4.as_json, user5.as_json, user6.as_json, user7.as_json, user8.as_json, user9.as_json, user10.as_json, user11.as_json])
        end

        it 'sorts by id desc' do
          expect(subject.search).to eq([user11.as_json, user10.as_json, user9.as_json, user8.as_json, user7.as_json, user6.as_json, user5.as_json, user4.as_json, user3.as_json, user2.as_json])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(10)
          expect(subject.page_number).to eq(0)
          expect(subject.sort_by).to eq('id')
          expect(subject.sort_direction).to eq('desc')
          expect(subject.total_of_pages).to eq(2)
          expect(subject.total_of_registers).to eq(11)
          expect(subject.term).to eq(nil)
        end
      end

      context 'when there is a term parameter' do
        let(:parameters) { {term: 'w', request_from_api: true} }

        it 'issues a get request' do
          subject.search

          expect(api_stub).to have_been_requested.once
        end

        it 'returns all registers that contains \'w\'' do
          expect(subject.search).to match_array([user6.as_json, user7.as_json, user8.as_json, user9.as_json, user10.as_json, user11.as_json])
        end

        it 'sorts by id desc' do
          expect(subject.search).to eq([user6.as_json, user7.as_json, user8.as_json, user9.as_json, user10.as_json, user11.as_json])
        end

        it 'returns the meta data' do
          subject.search

          expect(subject.page_size).to eq(10)
          expect(subject.page_number).to eq(0)
          expect(subject.sort_by).to eq('id')
          expect(subject.sort_direction).to eq('asc')
          expect(subject.total_of_pages).to eq(1)
          expect(subject.total_of_registers).to eq(6)
          expect(subject.term).to eq('w')
        end
      end
    end
  end
end