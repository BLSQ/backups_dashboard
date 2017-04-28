namespace :projects do
  desc "Update projects and rehydrate the db asynchronously"
  task update: :environment do
    ProjectsUpdateWorker.perform_async
  end

  desc "Update projects and rehydrate the db synchronously"
  task update_synch: :environment do
    ProjectsUpdateWorker.new.perform
  end
end
