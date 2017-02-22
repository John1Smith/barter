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
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            get '/logins.json', json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(200)

            expect(json_resp.length).to eq(10)
        end
   end

    context 'Get login' do
        before(:all) do
            @login = FactoryGirl.create(:login)
            login_id = @login.id
            @path = "/logins/#{login_id}.json"
        end

        it 'status 403 without authenticity_token' do
            get @path

            expect(response).to have_http_status(403)
        end

        it 'send login and status 200 with authenticity_token' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            get @path, json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(200)
            expect(Login.new(json_resp)).to eq(@login)
        end

        it 'empty body and status 403 for not existing login' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            Login.delete_all

            get @path, json

            expect(response).to have_http_status(404)
            expect(response.body).to be_empty
        end
   end

  context 'Create login' do

    before(:all) do
        @login = FactoryGirl.build(:login)
        # login_id = @login.id
        @path = "/logins.json"
    end

        it 'status 403 without authenticity_token' do
            post @path

            expect(response).to have_http_status(403)
        end

        it 'send login and status 201 with authenticity_token' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], login: @login.as_json.except("id","created_at","updated_at")}

            post @path, json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(201)
            expect(json_resp["user_login"]).to eq(@login.user_login)
            expect(json_resp["id"]).not_to be_nil
        end

   end
end