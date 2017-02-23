require "rails_helper"
describe "Logins API" , :type => :request do

    context 'Get list of logins' do
        before(:all) do
            Login.delete_all
            FactoryGirl.create_list(:login, 10)
        end    


        it ' without authenticity_token - status 403' do
            get '/logins.json'

            expect(response).to have_http_status(403)
        end

        it 'with authenticity_token - sends logins and status 200' do
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

        it 'without authenticity_token - status 403' do
            get @path

            expect(response).to have_http_status(403)
        end

        it 'with authenticity_token - send login and status 200' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            get @path, json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(200)
            expect(Login.new(json_resp)).to eq(@login)
        end

        it 'not existing login - empty body and status 403' do
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

        it 'without authenticity_token - status 403' do
            post @path

            expect(response).to have_http_status(403)
        end

        it 'with authenticity_token - send login and status 201' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], login: @login.as_json.except("id","created_at","updated_at")}

            post @path, json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(201)
            expect(json_resp["user_login"]).to eq(@login.user_login)
            expect(json_resp["id"]).not_to be_nil
        end

        it 'without login json - empty body and status 422' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            post @path, json

            # json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(422)
            expect(response.body).to be_empty
        end
        context 'Validate' do
            it 'get status 422 without a user_login' do
                @login.user_login = ''
                json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], login: @login.as_json.except("id","created_at","updated_at")}

                post @path, json

                json_resp = JSON.parse(response.body)

                expect(response).to have_http_status(422)
            end
            it 'get status 422 without a password' do
                @login.password = ''
                json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], login: @login.as_json.except("id","created_at","updated_at")}

                post @path, json

                json_resp = JSON.parse(response.body)

                expect(response).to have_http_status(422)
            end

            before do
                FactoryGirl.create(:login, user_login: 'login', password: 'password')
            end

            it "get status 422 with not uniqueness user_login" do
                @login.user_login = 'login'
                json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], login: @login.as_json.except("id","created_at","updated_at")}

                post @path, json
                
                expect(response).to have_http_status(422)
            end

        end   

    end

    context 'Update login' do

        before(:all) do
            @login = FactoryGirl.create(:login)
            login_id = @login.id
            @path = "/logins/#{login_id}.json"
        end

        it 'without authenticity_token - status 403' do
            put @path
            expect(response).to have_http_status(403)
        end

        it 'with authenticity_token - send login and status 200 ' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], login: @login.as_json.except("id","created_at","updated_at")}

            put @path, json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(200)
            expect(json_resp["user_login"]).to eq(@login.user_login)
            expect(json_resp["id"]).not_to be_nil
        end

        it 'not existing login - empty body and status 403' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], login: @login.as_json.except("id","created_at","updated_at")}

            Login.delete_all

            put @path, json

            expect(response).to have_http_status(404)
            expect(response.body).to be_empty
        end

        it 'without login json - empty body and status 422' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            put @path, json

            # json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(422)
            expect(response.body).to be_empty
        end

    end


    context 'Delete login' do

        before(:all) do
            @login = FactoryGirl.create(:login)
            login_id = @login.id
            @path = "/logins/#{login_id}.json"
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

        it 'not existing login - empty body and status 403' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}
            Login.delete_all

            delete @path, json

            expect(response).to have_http_status(404)
            expect(response.body).to be_empty
        end

    end

    context 'Check login and passwword' do
        before(:each) do
            @login = FactoryGirl.create(:login)
            @path = "/logins/check.json"
        end

        # after(:each) do
        #     Login.delete @login
        # end

        it 'without authenticity_token - status 403' do
            post @path

            expect(response).to have_http_status(403)
        end


        it 'without login json - empty body and status 422' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN']}

            post @path, json

            expect(response).to have_http_status(422)
            expect(response.body).to be_empty
        end

        it 'not existing login - empty body and status 403' do
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], login: @login.as_json.except("id","created_at","updated_at")}

            Login.delete_all

            post @path, json

            expect(response).to have_http_status(404)
            expect(response.body).to be_empty
        end

        it 'password not corespond login - empty body and status 401' do 
            @login.password = @login.password.hash.to_s
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], login: @login.as_json.except("id","created_at","updated_at")}

            post @path, json

            expect(response).to have_http_status(401)
            expect(response.body).to be_empty
        end

        it 'password corespond login - send login and status 200' do 
            json = { :format => 'json', :authenticity_token =>  ENV['AUTH_TOKEN'], login: @login.as_json.except("id","created_at","updated_at")}

            post @path, json

            json_resp = JSON.parse(response.body)

            expect(response).to have_http_status(200)
            expect(json_resp['user_login']).to eq(@login.user_login)
            expect(json_resp['password']).to eq(@login.password)
        end
    end
end

describe Login, :type => :model do
    let(:login) {FactoryGirl.build(:login)}

    it "is valid with valid attributes" do
        expect(login).to be_valid
    end
    it "is not valid without a user_login" do
        login.user_login = ''
        expect(login).not_to be_valid
    end
    it "is not valid without a password" do
        login.password = ''
        expect(login).not_to be_valid
    end
    it "is not valid when length of user_login more then 30" do
        login.user_login = 'l'*31
        expect(login).not_to be_valid
    end

    it "is not valid when length of password more then 20" do
        login.password = 'p'*21
        expect(login).not_to be_valid
    end

    it "is not valid when length of password less then 5" do
        login.password = 4.times.to_a.join
        expect(login).not_to be_valid
    end

    it "is not valid when length of user_login less then 3" do
        login.password = 2.times.to_a.join
        expect(login).not_to be_valid
    end

    before do
        FactoryGirl.create(:login, user_login: 'login', password: 'password')
    end

    it "is not valid with not uniqueness user_login" do
        login.user_login = 'login'
        expect(login).not_to be_valid
    end


end