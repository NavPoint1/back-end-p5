class GuidesController < ApplicationController

    def index
        @guides = Guide.all
        render json: @guides.to_json
    end

    def show
        @guide = Guide.find_by(title: params[:guide][:title])
        render json: @guide.to_json 
    end

    def create
        #create user account 
        @guide = Guide.new(guide_params)
        if @guide.save 
            # upon success... render json response 
            render json: @guide.to_json 
        else 
            # upon failure... render json response 
        end
    end

    def update
        # maybe need to find by id if title is being edited?
        @guide = Guide.find_by(title: params[:guide][:title])
        # edit details
        # render json response
    end

    def destroy
        @guide = Guide.find_by(title: params[:guide][:title])
        # delete
        # render json response
    end

    private 

    def guide_params
        params.require(:guide).permit(:title, :user_id, :thumbnail)
    end 
end
