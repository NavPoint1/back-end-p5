class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :login]

    def create
        #create user account 
        @user = User.new(user_params)
        if @user.save 
            # upon success... render json response 
            render json: @user.to_json 
        else 
            # upon failure... render json response 
        end
    end

    def update
        @user = User.find_by(username: params[:user][:username])
        # edit details
            # update avatar
            @user.avatar.attach(params[:user][:avatar])
        # render json response
    end

    def destroy
        @user = User.find_by(username: params[:user][:username])
        # delete
        # render json response
    end

    def login
        @user = User.find_by(username: params[:user][:username])
        if @user && @user.authenticate(params[:user][:password])
            # upon success... render json response  
            render json: @user.to_json # (include: [:characters, :relationships, :gifts])
        else
            # upon failure... render json response 
            # "Invalid username or password. For your security we are not disclosing which is incorrect. You're welcome :)"
        end  
    end

    def logout

    end

    private 

    def user_params
        params.require(:user).permit(:username, :password, :email, :avatar)
    end 
end
