require 'rails_helper'
require_relative '../../app/services/project_service.rb'
require_relative '../mock_heroku_cli.rb'

describe PGBackupsConnector do
  
  let(:project) {Project.new(name: "app_name", db_connector: :postgresql)}
  
  it "scheduled_at return the date of the schedule for a specific app" do 
    mock_heroku_cli = MockHerokuCli.new({"pg:backups schedules --app #{project.name}" => "pgbackups_scheduled_at.txt"})
    pg_backups = PGBackupsConnector.new mock_heroku_cli
    expect(pg_backups.scheduled_at(project)).to eq("daily at 7:00 Europe/Brussels")
  end 
  
  it "scheduled_at return empty string if there is no scheduled date for a specific app" do 
    mock_heroku_cli = MockHerokuCli.new({"pg:backups schedules --app #{project.name}" => "pgbackups_no_scheduled_at.txt"})
    pg_backups = PGBackupsConnector.new mock_heroku_cli
    expect(pg_backups.scheduled_at(project)).to eq("")
  end 

  it "scheduled? return true if there is a scheduled date for a specific app" do 
    mock_heroku_cli = MockHerokuCli.new({"pg:backups schedules --app #{project.name}" => "pgbackups_scheduled_at.txt"})
    pg_backups = PGBackupsConnector.new mock_heroku_cli
    expect(pg_backups.scheduled?(project)).to eq(true)
  end 

  it "scheduled? return false if there is a no scheduled date for a specific app" do 
    mock_heroku_cli = MockHerokuCli.new({"pg:backups schedules --app #{project.name}" => "pgbackups_no_scheduled_at.txt"})
    pg_backups = PGBackupsConnector.new mock_heroku_cli
    expect(pg_backups.scheduled?(project)).to eq(false)
  end 

  it "schedule date for a specific app" do
    date = '07:00 Europe/Brussels'
    mock_heroku_cli = MockHerokuCli.new({"pg:backups schedule DATABASE_URL --at #{date} --app #{project.name}" => "pgbackups_schedule.txt"})
    pg_backups = PGBackupsConnector.new mock_heroku_cli
    expect{pg_backups.schedule(project,date)}.to_not raise_error(RuntimeError) 
  end 

  it "schedule raise error if schedule doesn't work" do
    date = '07:00 Europe/Brussels'
    mock_heroku_cli = MockHerokuCli.new({"pg:backups schedule DATABASE_URL --at #{date} --app #{project.name}" => "pgbackups_schedule_error.txt"})
    pg_backups = PGBackupsConnector.new mock_heroku_cli
    expect{pg_backups.schedule(project,date)}.to raise_error(RuntimeError) 
  end 

end 
