class UsersController < ApplicationController
    #skip_before_action :verify_authenticity_token, only: [:create, :login]

    def create
        #create user account 
        @user = User.new({
            username: params[:username],
            email: params[:email],
            password: params[:password]
        })
        if @user.save 
            # upon success... render json response 
            render json: @user.to_json 
        else 
            # upon failure... render json response
            if @user.errors
                render json: @user.errors.full_messages.to_json
            else
                render json: "Something happened.".to_json
            end
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
        @user = User.find_by(email: params[:user][:email])
        if @user && @user.authenticate(params[:password])
            # upon success... render json response  
            render json: @user.to_json # (include: [:characters, :relationships, :gifts])
        else
            # upon failure... render json response
            if @user.errors
                render json: "Invalid credentials. For your security we cannot disclose which is incorrect. We apologize for the inconvenience.".to_json
            else
                render json: "Something happened.".to_json
            end
        end  
    end

    def logout

    end

    private 

    def user_params
        params.require(:user).permit(:username, :password, :email, :avatar)
    end 
end
