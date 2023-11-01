class UrlsController < ApplicationController
  # before_action :set_url, only: %i[ show update destroy ]
  SHORTEND_LENGTH = 6

  # GET /urls
  def index
    @urls = Url.all

    render json: @urls
  end

  # GET /urls/1
  def show
    tmp = Url.where(origin: params[:url])
    @url = Url.where(origin: params[:url]).first
    if @url
      if @url.clicked.nil?
        @url.update_attribute(:clicked, 0)
      end
      @url.update_attribute(:clicked, @url.clicked + 1)
      render json: "http://localhost:3000/s/#{@url.shortened}"
    else
      loop do
        @url = Url.new
        @url.origin = params[:url]
        short = SecureRandom.alphanumeric(SHORTEND_LENGTH)
        if !Url.where(shortened: short).exists?
          @url.shortened = short
          @url.save
          break
        end
      end
      render json: "http://localhost:3000/s/#{@url.shortened}"
    end
    
  end

  def direct
    @url = Url.where(shortened: params[:shortened]).first
    # @url.update_attribute(:clicked, @url.clicked + 1)
    redirect_to @url.origin, allow_other_host: true
  end

  # POST /urls
  def create
    @url = Url.new(url_params)

    if @url.save
      render json: @url, status: :created, location: @url
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /urls/1
  def update
    if @url.update(url_params)
      render json: @url
    else
      render json: @url.errors, status: :unprocessable_entity
    end
  end

  # DELETE /urls/1
  def destroy
    @url.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      # @url = Url.find(params[:url])
    end

    # Only allow a list of trusted parameters through.
    def url_params
      params.require(:url).permit(:origin, :shortened, :clicked)
    end
end
