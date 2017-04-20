namespace :projects do
  desc 'Update projects and rehydrate the db'
  task update: :environment do
    ProjectsUpdateWorker.perform_async
  end
end
