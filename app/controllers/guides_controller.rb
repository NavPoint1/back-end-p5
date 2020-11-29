require 'uri'
require 'open-uri'

class GuidesController < ApplicationController

    def index
        @guides = Guide.order('views DESC')
        if @guides.size == 0
            render json: "404 Not Found".to_json
        else
            render json: @guides.to_json(include: [:user, :slides], methods: :thumbnail_url)
        end
    end

    def show
        @guide = Guide.find(params[:id])
        @guide.update(views: @guide.views + 1)
        # render json: @guide.to_json(include: {thumbnail: {include: {attachments: {include: {blob: {methods: :service_url}}}}}})
        render json: @guide.to_json(include: [:user, :slides], methods: :thumbnail_url)
        # render json: @guide.thumbnail_url
    end

    def create
        @guide = Guide.new({
            title: params[:title],
            user_id: params[:user_id],
        })
        if @guide.save 
            # direct uploads
            # @guide.thumbnail.attach(params[:thumbnail])
            # from url
            file = open(params[:thumbnail])
            uri = URI.parse(params[:thumbnail])
            filename = File.basename(uri.path)
            if file
                @guide.thumbnail.attach(io: file, filename: filename)
            end
            # @guide.thumbnail.attach(io: File.open(params[:thumbnail]), filename: params[:thumbnail].split("/").last)
            params[:slides].each { |slide|
                Slide.create({
                    guide_id: @guide.id,
                    header: slide[:header],
                    content: slide[:content],
                    media: slide[:media]
                })
            }
            # upon success... render json response 
            # render json: @guide.to_json(include: {thumbnail: {include: {attachments: {include: {blob: {methods: :service_url}}}}}})
            render json: @guide.to_json(include: [:user, :slides], methods: :thumbnail_url)
            # render json: @guide.to_json(include: [:user, :slides], methods: :thumbnail_url)
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
