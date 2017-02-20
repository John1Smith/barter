class LoginsController < ApplicationController
  before_action :set_login, only: [:show, :edit, :update, :destroy ]
  protect_from_forgery with: :null_session

  # skip_before_filter :verify_authenticity_token  
  # GET /logins
  # GET /logins.json
  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins.json -X GET -d '{"authenticity_token": "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A=="}'  
  # curl -H "Accept: application/json" -H "Content-type: application/json" https://bartermd.herokuapp.com/logins.json -X GET -d '{"authenticity_token": "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A=="}'  

  def index
    
     if !verify_token
      render plain: '403'
      return
    end

    @logins = Login.all
  end

  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins/14.json -X GET -d '{"authenticity_token": "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A=="}'
  # GET /logins/1
  # GET /logins/1.json
  def show
    if !verify_token
      render plain: '403'
      return
    end
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
  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins.json -X POST  -d '{"authenticity_token": "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A==", "login":{"user_login":"4442","password":"very12"}}'
  def create
    

    if !verify_token
      render plain: '403'
      return
    end


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
  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins/1.json -X PUT  -d '{"authenticity_token": "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A==", "login":{"user_login":"4442","password":"very12"}}'
  def update

 
    if !verify_token
      render plain: '403'
      return
    end


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

  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins/14.json -X GET -d '{"authenticity_token": "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A=="}'
  # GET /logins/1
  # GET /logins/1.json
  def check
    # binding.pry
    @login = Login.find_by_user_login params[:login][:user_login]
    
    if !verify_token
      render plain: '403'
      return
    end

    if @login == nil
      render plain: "404"
      return    
    end 

    if @login.password == params[:login][:password]
      render json: @login
    else
      render plain: '401'
    end

  end

  # DELETE /logins/1
  # DELETE /logins/1.json
  # curl -H "Accept: application/json" -H "Content-type: application/json" http://localhost:3000/logins/12.json -X DELETE -d '{"authenticity_token": "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A=="}'

  def destroy

     # binding.pry
     if !verify_token
      render plain: '403'
      return
    end

    @login.destroy
    respond_to do |format|
      format.html { redirect_to logins_url, notice: 'Login was successfully destroyed.' }
      format.json { render plain: 'OK' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_login
      if not Login.exists? params[:id]
         render plain: "404"
         return
      end           
      @login = Login.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def login_params
      params.require(:login).permit(:user_login, :password)
    end

    def verify_token
      if params[:format]=='json'
         params["authenticity_token"] == "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A=="
      else
         true   
      end      
    end
end
