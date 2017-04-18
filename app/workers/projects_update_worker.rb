class ProjectsUpdateWorker 
  include Sidekiq::Worker

  def perform()
    puts "updating all projects is done"
  end
end
