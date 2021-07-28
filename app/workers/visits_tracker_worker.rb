class VisitsTrackerWorker
  include Sidekiq::Worker

  def perform(link_id, ip)
    VisitsTracker.new(link_id: link_id, ip: ip).call
  end
end