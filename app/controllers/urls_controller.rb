class UrlsController < ApplicationController
  before_action :find_link, only: %i[show stats]

  def create
    link = ShortenedLink.new(original_url: url_param[:url],
                             shortened_url: LinkGenerator.new.call)
    if link.save
      render json: { short_link: link.shortened_url }.to_json
    else
      render json: { errors: link.errors.full_messages.to_sentence }.to_json
    end
  end

  # статистику считаем асинхронно, чтобы редирект был максимально быстрым
  def show
    VisitsTrackerWorker.perform_async(@link.id, request.remote_ip)
    render json: { full_link: @link.original_url }.to_json
  end

  def stats
    render json: { transitions: StatsCalculator.new(@link).call }.to_json
  end

  private

  def find_link
    @link = ShortenedLink.find_by!(shortened_url: params[:id])
  end

  def url_param
    params.permit(:url)
  end
end
