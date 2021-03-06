class LoginsController < ApplicationController
  before_filter :verify_token
  before_filter :check_login_params, only: [:create, :update, :check ]

  before_action :set_login, only: [:show, :edit, :update, :destroy ]

  protect_from_forgery with: :null_session

  # skip_before_filter :verify_authenticity_token  
  # GET /logins
  # GET /logins.json
  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins.json -X GET -d '{"authenticity_token": ""}'  
  # curl -H "Accept: application/json" -H "Content-type: application/json" https://bartermd.herokuapp.com/logins.json -X GET -d '{"authenticity_token": ""}'  

  def index
    @logins = Login.all
  end

  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins/14.json -X GET -d '{"authenticity_token": ""}'
  # GET /logins/1
  # GET /logins/1.json
  def show
  end

  # GET /logins/new
  def new
    @login = Login.new
  end

  # GET /logins/1/edit
  def edit
  end

  # POST /logins
  # POST /logins.json
  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins.json -X POST  -d '{"authenticity_token": "", "login":{"user_login":"4442","password":"very12"}}'
  def create
    
    @login = Login.new(login_params)
    respond_to do |format|
      if @login.save
        format.html { redirect_to @login, notice: 'Login was successfully created.' }
        format.json { render :show, status: :created, location: @login }
      else
        format.html { render :new }
        format.json { render json: @login.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /logins/1
  # PATCH/PUT /logins/1.json
  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins/1.json -X PUT  -d '{"authenticity_token": "", "login":{"user_login":"4442","password":"very12"}}'
  def update
    respond_to do |format|
      if @login.update(login_params)
        format.html { redirect_to @login, notice: 'Login was successfully updated.' }
        format.json { render :show, status: :ok, location: @login }
      else
        format.html { render :edit }
        format.json { render json: @login.errors, status: :unprocessable_entity }
      end
    end
  end

  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins/14.json -X GET -d '{"authenticity_token": ""}'
  # GET /logins/1
  # GET /logins/1.json
  def check
    # binding.pry
    @login = Login.find_by_user_login params[:login][:user_login]
    
    unless @login
      render nothing: true, status:  404 # Not found login
      return    
    end 

    if @login.password == params[:login][:password]
      render json: @login
    else
      render nothing: true, status:  401 # Not password corespond login
    end

  end

  # DELETE /logins/1
  # DELETE /logins/1.json
  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins/12.json -X DELETE -d '{"authenticity_token": ""}'

  def destroy
    
    @login.destroy
    respond_to do |format|
      format.html { redirect_to logins_url, notice: 'Login was successfully destroyed.' }
      format.json { render nothing: true, status:  200 }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_login
      if not Login.exists? params[:id]
         render nothing: true, status:  404
         return
      end           
      @login = Login.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def login_params
      params.require(:login).permit(:user_login, :password)
    end

    def check_login_params
      render nothing: true, status:  422 unless params[:login]
    end

    def verify_token
        respond_to do |format|  
          format.html {}    
          format.json do
             auth = params["authenticity_token"] == ENV['AUTH_TOKEN']
             render nothing: true, status:  403 unless auth
          end
        end
      
    end
 
end
