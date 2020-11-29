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
            render json: @user.to_json(include: [:likes])
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
            render json: @user.to_json(include: [:likes])
        else
            # upon failure... render json response
            render json: "Invalid credentials. For your security we cannot disclose which is incorrect. We apologize for the inconvenience.".to_json
        end  
    end

    def logout

    end

    def like
        @user = User.find(params[:id])
        guide = Guide.find(params[:guide_id])
        if @user.guides.include?(guide)
            # unlike
            Like.where(user_id: params[:id], guide_id: params[:guide_id]).first.destroy
        else
            # like
            Like.create({
                user_id: params[:id],
                guide_id: params[:guide_id]
            })
        end
        render json: guide.to_json(include: [:user, :likes, :slides], methods: :thumbnail_url)
    end

    private 

    def user_params
        params.require(:user).permit(:username, :password, :email, :avatar)
    end 
end
