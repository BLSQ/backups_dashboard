require 'rails_helper'
require_relative '../../app/services/project_service.rb'
require_relative '../mock_heroku_cli.rb'

describe ProjectService do
  
  let(:project) {Project.new(name: "app_name", db_connector: :postgresql)}

  it "should return the date of the schedule for a specific app" do 
    mock_heroku_cli = MockHerokuCli.new({"pg:backups schedules --app #{project.name}" => "pgbackups_backup_list.txt"})
    service = ProjectService.new mock_heroku_cli
    service.configure(project)
  end 

  it "should return the list of backups for a specific app" do 
    mock_heroku_cli = MockHerokuCli.new({"pg:backups --app #{project.name}" => "pgbackups_scheduled_at.txt"})
    service = ProjectService.new mock_heroku_cli
    service.configure(project)
  end 
end 
