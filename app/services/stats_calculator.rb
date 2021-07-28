# данный сервис считает статистику посещений для конкретной ссылки
class StatsCalculator
  attr_reader :link

  def initialize link
    @link = link
  end

  def call
    link.link_visits.count + cache_visits
  end

  private

  def cache_visits
    ips =  Redis.new.hget('links', link.id)
    ips.present? ? JSON.parse(ips).size : 0
  end
end
