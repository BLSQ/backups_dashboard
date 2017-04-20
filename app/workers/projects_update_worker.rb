class ProjectsUpdateWorker 
  include Sidekiq::Worker

  def perform
    #project_service = ProjectService.new 
    #applications = project_service.retrieve_heroku_applications

     heroku = PlatformAPI.connect_oauth(ENV['HEROKU_TOOLBELT_API_PASSWORD'])
     heroku_cmd = '/app/vendor/heroku-toolbelt/bin/heroku'
     heroku.app.list.each do |app|
       puts app['name']
       puts `#{heroku_cmd} pg:backups --app #{app['name']}`
     end

  end
end
