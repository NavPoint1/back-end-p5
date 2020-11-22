class GuidesController < ApplicationController

    def index
        @guides = Guide.all
        render json: @guides.to_json
    end

    def show
        @guide = Guide.find(params[:id])
        render json: @guide.to_json(include: [:user])
    end

    def create
        #create user account 
        @guide = Guide.new(guide_params)
        if @guide.save 
            # upon success... render json response 
            render json: @guide.to_json(include: [:user])
        else 
            # upon failure... render json response 
            if @guide.errors
                render json: @guide.errors.full_messages.to_json
            else
                render json: "Something happened.".to_json
            end
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
