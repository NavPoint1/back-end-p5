class ThemesController < ApplicationController

    def index
        @themes = Theme.all
        if @themes.size == 0
            render json: "404 Not Found".to_json
        else
            render json: @themes.to_json(include: [:user], methods: [:top_border_url, :bottom_border_url, :background_url, :watermark_url])
        end
    end

    def show
        @theme = Theme.find(params[:id])
        render json: @theme.to_json(include: [:user], methods: [:top_border_url, :bottom_border_url, :background_url, :watermark_url])
    end

    def create
        if params[:images].size == 0
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
                    @guide.slides.create({
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

end
