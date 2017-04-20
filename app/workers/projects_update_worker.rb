class ProjectsUpdateWorker 
  include Sidekiq::Worker

  def perform
    service = ProjectService.new 
    service.configure_apps
  end
end
