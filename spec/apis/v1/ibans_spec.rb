require 'rails_helper'

RSpec.describe '/api/v1/ibans', type: :request do
  context 'With no IBANs' do
    let(:valid_attributes) {
      [
        {
          name: 'FR1420041010050500013M02606',
          region: 'FRANCE'
        },
        {
          name: 'GB26MIDL40051512345678',
          region: 'UK'
        }
      ]
    }

    let(:invalid_attributes) {
      {
        name: nil,
        region: nil
      }
    }

    let(:valid_headers) {
      {
        content_type: "application/json"
      }
    }

    context 'with a single IBAN' do
      let!(:iban) { create(:iban) }
    
      describe 'GET /index' do
        it 'renders a successful response' do
          get api_v1_ibans_path, headers: valid_headers, as: :json
          expect(response).to be_successful
        end
      end

      describe 'GET /show' do
        it 'renders a successful response' do
          get api_v1_iban_path(iban), as: :json
          expect(response).to be_successful
        end

        it 'renders a successful response with a name instead of an id' do
          get "#{api_v1_ibans_path}/#{iban.name}", as: :json
          expect(response).to be_successful
          json = JSON::parse(response.body)
          expect(json['data']['name']).to eq iban.name
        end
      end

      describe 'Get /random_pick' do
        it 'renders a successful response' do
          get api_v1_ibans_random_pick_path, as: :json
          expect(response).to be_successful
        end
      end

      describe 'PATCH /update' do
        context 'with valid parameters' do
          let(:new_attributes) {
            {
              name: 'FR 14 20041 01605 0500013M026 06',
              region: 'FRANCE'
            }
          }
    
          it 'updates the requested iban' do
            patch api_v1_iban_path(iban),
                  params: new_attributes, headers: valid_headers, as: :json
            iban.reload
            expect(iban.name).to eq new_attributes[:name].gsub(/\s+/, '')
            expect(iban.region).to eq new_attributes[:region]
          end
    
          it 'renders a JSON response with the iban' do
            patch api_v1_iban_path(iban),
                  params: new_attributes, headers: valid_headers, as: :json
            expect(response).to have_http_status(:ok)
            expect(response.content_type).to match(a_string_including('application/json'))
          end
        end
    
        context 'with invalid parameters' do
          it 'renders a JSON response with errors for the iban' do
            patch api_v1_iban_path(iban),
                  params: invalid_attributes, headers: valid_headers, as: :json
            expect(response).to have_http_status(:unprocessable_entity)
            expect(response.content_type).to match(a_string_including('application/json'))
          end
        end
      end

      describe 'DELETE /destroy' do
        it 'destroys the requested iban' do
          expect {
            delete api_v1_iban_path(iban), headers: valid_headers, as: :json
          }.to change(Iban, :count).by(-1)
        end
      end
    end

    describe 'POST /create' do
      context 'with valid parameters' do
        it 'creates a new Iban' do
          valid_attributes.each do |attributes|
            expect {
              post api_v1_ibans_path,
                  params: attributes, headers: valid_headers, as: :json
            }.to change(Iban, :count).by(1)
          end
        end

        it 'renders a JSON response with the new iban' do
          valid_attributes.each do |attributes|
            post api_v1_ibans_path,
                params: attributes, headers: valid_headers, as: :json
            expect(response).to have_http_status(:created)
            expect(response.content_type).to match(a_string_including('application/json'))
          end
        end
      end

      context 'with invalid parameters' do
        it 'does not create a new Iban' do
          expect {
            post api_v1_ibans_path,
                params: invalid_attributes, as: :json
          }.to change(Iban, :count).by(0)
        end

        it 'renders a JSON response with errors for the new iban' do
          post api_v1_ibans_path,
              params: invalid_attributes, headers: valid_headers, as: :json
          expect(response).to have_http_status(:unprocessable_entity)
          expect(response.content_type).to match(a_string_including('application/json'))
        end
      end
    end
  end

  context 'With multiple IBANs' do
    before(:all) { create_list(:iban, 50) }

    describe 'verify pagination' do
      headers = {
        content_type: "application/json"
      }

      context 'without page set but with per_page' do
        before(:all) { get api_v1_ibans_path + '?per_page=10', headers: headers, as: :json }

        it 'should has pagination within its headers' do
          expect(response.headers['Total']).to eq '50'
          expect(response.headers['Per-Page']).to eq '10'
          expect(response.headers['Link']).to match(/.*page=5.*rel="last".*page=2.*rel="next"/)
        end
      end

      context 'with page and per_page set' do
        before(:all) { get api_v1_ibans_path + '?page=2&per_page=10', headers: headers, as: :json }

        it 'should has pagination within its headers' do
          expect(response.headers['Total']).to eq '50'
          expect(response.headers['Per-Page']).to eq '10'
          expect(response.headers['Link']).to match(/.*page=1.*rel="first".*page=1.*rel="prev".*page=5.*rel="last".*page=3.*rel="next"/)
        end
      end
    end
  end
end
