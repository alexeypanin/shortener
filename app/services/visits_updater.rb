class VisitsUpdater
  class << self
    # переносим статистику посещений из рэдиса в БД
    def call
      redis.hgetall('links').each do |link_id, ips|
        link = ShortenedLink.find_by(id: link_id)
        next if link.blank? || ips.blank?

        ips = JSON.parse(ips)
        ips.each do |ip|
          link.link_visits.create(ip: ip)
        end

        remove_ips_from_cache(link_id, ips)
      end
    end

    private

    # убираем вычитанием перенесенных, т.к. во время переноса ip в бд
    # могли появиться новые переходы в кэше
    def remove_ips_from_cache link_id, ips
      current = JSON.parse(redis.hget('links', link_id))
      current -= ips
      redis.hset('links', link_id, current.to_json)
    end

    def redis
      @redis ||= Redis.new
    end
  end
end
