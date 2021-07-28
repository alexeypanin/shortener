class VisitsTracker
  attr_accessor :link, :ip

  def initialize(link_id:, ip:)
    @link = ShortenedLink.find(link_id)
    @ip = ip
  end

  def call
    return if link.link_visits.where(ip: ip).exists?
    return if cached_ips.include?(ip)

    # добавляем новый ip в кэш посещений
    redis.hset('links', link.id, cached_ips.push(ip).to_json)
  end

  private

  def redis
    @redis ||= Redis.new
  end

  def cached_ips
    ids = redis.hmget('links', link.id)[0]
    ids.present? ? JSON.parse(ids) : []
  end
end