require "rails_helper"
describe "Logins API" , :type => :request do

    context 'Get list of logins' do
        before(:all) do
            Login.delete_all
            FactoryGirl.create_list(:login, 10)
        end

        it 'status 403 without authenticity_token' do
            get '/logins.json'

            expect(response).to have_http_status(403)
        end

        it 'sends logins and status 200 with authenticity_token' do
            json = { :format => 'json', :authenticity_token =>  "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A=="}

            get '/logins.json', json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(200)

            expect(json_resp.length).to eq(10)
        end
   end

    context 'Get login' do
        before(:all) do
            Login.delete_all
            @login = FactoryGirl.create(:login)
            login_id = @login.id
            @path = "/logins/#{login_id}.json"
        end

        it 'status 403 without authenticity_token' do
            get @path

            expect(response).to have_http_status(403)
        end

        it 'send login and status 200 with authenticity_token' do
            json = { :format => 'json', :authenticity_token =>  "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A=="}

            get @path, json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(200)
            expect(Login.new(json_resp)).to eq(@login)
        end

        it 'empty body and status 403 for not existing login' do
            json = { :format => 'json', :authenticity_token =>  "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A=="}

            Login.delete_all

            get @path, json

            expect(response).to have_http_status(404)
            expect(response.body).to be_empty
        end
   end

end