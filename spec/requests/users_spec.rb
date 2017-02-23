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

        it 'without user json - empty body and status 422' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            post @path, json

            expect(response).to have_http_status(422)
            expect(response.body).to be_empty
        end        

        context 'Validate' do
            it 'get status 422 without a first_name' do
                @user.first_name = ''
                json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], user: @user.as_json.except("id","created_at","updated_at")}

                post @path, json

                expect(response).to have_http_status(422)
            end

        end           

    end


    context 'Update user' do

        before(:all) do
            @user = FactoryGirl.create(:user)
            user_id = @user.id
            @path = "/users/#{user_id}.json"
        end

        it 'without authenticity_token - status 403' do
            put @path
            expect(response).to have_http_status(403)
        end

        it 'with authenticity_token - send user and status 200 ' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], user: @user.as_json.except("id","created_at","updated_at")}

            put @path, json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(200)
            expect(json_resp["first_name"]).to eq(@user.first_name)
            expect(json_resp["id"]).not_to be_nil
        end

        it 'not existing user - empty body and status 403' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], user: @user.as_json.except("id","created_at","updated_at")}

            User.delete_all

            put @path, json

            expect(response).to have_http_status(404)
            expect(response.body).to be_empty
        end

        it 'without user json - empty body and status 422' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            put @path, json

            # json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(422)
            expect(response.body).to be_empty
        end

    end


    context 'Delete user' do

        before(:all) do
            @user = FactoryGirl.create(:user)
            user_id = @user.id
            @path = "/users/#{user_id}.json"
        end

        it 'without authenticity_token - status 403' do
            delete @path
            expect(response).to have_http_status(403)
        end

        it 'with authenticity_token - status 200 ' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            delete @path, json

            expect(response).to have_http_status(200)
        end

        it 'not existing user - empty body and status 403' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}
            User.delete_all

            delete @path, json

            expect(response).to have_http_status(404)
            expect(response.body).to be_empty
        end

   end   
end

describe User, :type => :model do
    let(:user) {FactoryGirl.build(:user)}

    it "is valid with valid attributes" do
        expect(user).to be_valid
    end
    it "is not valid without a first_name" do
        user.first_name = ''
        expect(user).not_to be_valid
    end

end