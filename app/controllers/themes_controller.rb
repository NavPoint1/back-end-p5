class ThemesController < ApplicationController

    def index
        @themes = Theme.all
        if @themes.size == 0
            render json: "".to_json
        else
            # omit images and associations for faster index load
            render json: @themes.to_json
        end
    end

    def show
        @theme = Theme.find(params[:id])
        render json: @theme.to_json(include: [:user], methods: [:top_border_url, :bottom_border_url, :background_url, :watermark_url])
    end

    def create
        if params[:top_border].size == 0 || params[:bottom_border].size == 0 || params[:background].size == 0 || params[:watermark].size == 0
            render json: ["All image fields are required"].to_json
        else
            @theme = Theme.new({
                name: params[:name],
                user_id: params[:user_id],
            })
            # top border
            begin
                file = open(params[:top_border])
                uri = URI.parse(params[:top_border])
                filename = File.basename(uri.path)
            rescue StandardError => e
                render json: ["Top border image failed to parse"].to_json and return
            end
            if file
                @theme.top_border.attach(io: file, filename: filename)
            end
            # bot border
            begin
                file = open(params[:bottom_border])
                uri = URI.parse(params[:bottom_border])
                filename = File.basename(uri.path)
            rescue StandardError => e
                render json: ["Bottom border image failed to parse"].to_json and return
            end
            if file
                @theme.bottom_border.attach(io: file, filename: filename)
            end
            # background
            begin
                file = open(params[:background])
                uri = URI.parse(params[:background])
                filename = File.basename(uri.path)
            rescue StandardError => e
                render json: ["Background image failed to parse"].to_json and return
            end
            if file
                @theme.background.attach(io: file, filename: filename)
            end
            # watermark
            begin
                file = open(params[:watermark])
                uri = URI.parse(params[:watermark])
                filename = File.basename(uri.path)
            rescue StandardError => e
                render json: ["Watermark image failed to parse"].to_json and return
            end
            if file
                @theme.watermark.attach(io: file, filename: filename)
            end
            if @theme.save 
                render json: @theme.to_json(include: [:user], methods: [:top_border_url, :bottom_border_url, :background_url, :watermark_url])
            else 
                if @theme.errors
                    render json: @theme.errors.full_messages.to_json
                else
                    render json: ["Something happened"].to_json
                end
            end
        end
    end

end
