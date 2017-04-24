class ProjectsUpdateWorker 
  include Sidekiq::Worker

  def perform
    service = ProjectService.new 
    service.update_all
    service.update_all_backups
  end
end
