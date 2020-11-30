require 'uri'
require 'open-uri'

class GuidesController < ApplicationController

    def index
        @guides = Guide.order('views DESC')
        if @guides.size == 0
            render json: "404 Not Found".to_json
        else
            # don't include slides here for faster load
            render json: @guides.to_json(include: [:user, :likes], methods: :thumbnail_url)
        end
    end

    def show
        @guide = Guide.find(params[:id])
        @guide.update(views: @guide.views + 1)
        render json: @guide.to_json(include: [:user, :likes, :slides], methods: :thumbnail_url)
    end

    def create
        if params[:slides].size == 0
            render json: ["Guide must have slides"].to_json
        elsif params[:thumbnail].size == 0
            render json: ["Guide must have a thumbnail"].to_json
        else
            @guide = Guide.new({
                title: params[:title],
                user_id: params[:user_id],
            })
            begin
                file = open(params[:thumbnail])
                uri = URI.parse(params[:thumbnail])
                filename = File.basename(uri.path)
            rescue StandardError => e
                render json: ["Thumbnail failed to parse"].to_json and return
            end
            if file
                @guide.thumbnail.attach(io: file, filename: filename)
            end
            if @guide.save 
                params[:slides].each { |slide|
                    Slide.create({
                        guide_id: @guide.id,
                        header: slide[:header],
                        content: slide[:content],
                        media: slide[:media]
                    })
                }
                # upon success... render json response 
                render json: @guide.to_json(include: [:user, :likes, :slides], methods: :thumbnail_url)
            else 
                # upon failure... render json response 
                if @guide.errors
                    render json: @guide.errors.full_messages.to_json
                else
                    render json: ["Something happened."].to_json
                end
            end
        end
    end

    def update
        # find by id so title can change
        @guide = Guide.find(params[:id])
        # validate again
        if params[:slides].size == 0
            render json: ["Guide must have slides"].to_json
        elsif params[:thumbnail].size == 0
            render json: ["Guide must have a thumbnail"].to_json
        else
            # check if thumbnail is new
            if !params[:thumbnail].include?('/rails/active_storage/')
                begin
                    file = open(params[:thumbnail])
                    uri = URI.parse(params[:thumbnail])
                    filename = File.basename(uri.path)
                rescue StandardError => e
                    render json: ["Thumbnail failed to parse"].to_json and return
                end
                if file
                    @guide.thumbnail.attach(io: file, filename: filename)
                end
            end
            # update guide
            @guide.update({
                title: params[:title],
                user_id: params[:user_id],
            })
            if @guide.save
                # clear all old slides
                @guide.slides.destroy_all
                # rebuild slides
                params[:slides].each { |slide|
                    Slide.create({
                        guide_id: @guide.id,
                        header: slide[:header],
                        content: slide[:content],
                        media: slide[:media]
                    })
                }
                # upon success... render json response 
                render json: @guide.to_json(include: [:user, :likes, :slides], methods: :thumbnail_url)
            else 
                # upon failure... render json response 
                if @guide.errors
                    render json: @guide.errors.full_messages.to_json
                else
                    render json: ["Something happened."].to_json
                end
            end
        end
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
