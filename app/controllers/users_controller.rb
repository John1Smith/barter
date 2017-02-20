class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  protect_from_forgery with: :null_session
skip_before_filter :verify_authenticity_token 
  # GET /users
  # GET /users.json
  def index
     if !verify_token
      render plain: '403'
      return
    end

    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if !verify_token
      render plain: '403'
      return
    end

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    if !verify_token
      render plain: '403'
      return
    end

    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if !verify_token
      render plain: '403'
      return
    end

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy

     if !verify_token
      render plain: '403'
      return
    end

    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { render plain: 'OK' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if not User.exists? params[:id]
         render plain: "404"
         return
      end           

      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:first_name, :second_name, :date_bith, :photo_url, :description, :location, :phone)
    end

    def verify_token
      if params[:format]=='json'
         params["authenticity_token"] == "OKbwY5J/iAW2V5g2k/TP84FJvWl5QsFHlagfwooX5sl4NhBGvpMV6VNIkPWpYcuqpWj5AC4SDdyrdrIx7vsR7A=="
      else
         true   
      end      
    end
    
end
