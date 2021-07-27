class VisitsTracker
  attr_accessor :link, :ip

  def initialize link_id:, ip:
    @link = ShortenedLink.find(link_id)
    @ip = ip
  end

  def call
    return if link.link_visits.where(ip: ip).exists?

    ActiveRecord::Base.transaction do
      link.link_visits.create(ip: ip)
      link.increment!(:transitions)
    end
  end
end