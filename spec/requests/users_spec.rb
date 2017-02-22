require "rails_helper"
describe "Users API" , :type => :request do

    context 'Get list of users' do
        before(:all) do
            User.delete_all
            FactoryGirl.create_list(:user, 10)
        end

        it 'status 403 without authenticity_token' do
            get '/users.json'

            expect(response).to have_http_status(403)
        end

        it 'sends users and status 200 with authenticity_token' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            get '/users.json', json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(200)

            expect(json_resp.length).to eq(10)
        end
   end

    context 'Get user' do
        before(:all) do
            @user = FactoryGirl.create(:user)
            user_id = @user.id
            @path = "/users/#{user_id}.json"
        end

        it 'status 403 without authenticity_token' do
            get @path

            expect(response).to have_http_status(403)
        end

        it 'send user and status 200 with authenticity_token' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            get @path, json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(200)
            expect(User.new(json_resp)).to eq(@user)
        end

        it 'empty body and status 403 for not existing user' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            User.delete_all

            get @path, json

            expect(response).to have_http_status(404)
            expect(response.body).to be_empty
        end
   end

  context 'Create user' do

    before(:all) do
        @user = FactoryGirl.build(:user)
        @path = "/users.json"
    end

        it 'status 403 without authenticity_token' do
            post @path

            expect(response).to have_http_status(403)
        end

        it 'send user and status 201 with authenticity_token' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], user: @user.as_json.except("id","created_at","updated_at")}

            post @path, json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(201)
            expect(json_resp["first_name"]).to eq(@user.first_name)
            expect(json_resp["id"]).not_to be_nil
        end

   end
end