require 'rails_helper'
require_relative '../../app/services/project_service.rb'
require_relative '../mock_heroku_cli.rb'

describe PGBackupsConnector do
  
  let(:project) {Project.new(name: "app_name", db_connector: :postgresql)}
  
  it "scheduled_at return the date of the schedule for a specific app" do 
    mock_heroku_cli = MockHerokuCli.new({
      "pg:backups schedules --app #{project.name}" => "pgbackups_scheduled_at.txt"
    })

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
    mock_heroku_cli = MockHerokuCli.new({"pg:backups schedule DATABASE_URL --at '#{date}' --app #{project.name}" => "pgbackups_schedule.txt"})
    pg_backups = PGBackupsConnector.new mock_heroku_cli
    expect{pg_backups.schedule(project,date)}.to_not raise_error(RuntimeError) 
  end 

  it "schedule raise error if schedule doesn't work" do
    date = '07:00 Europe/Brussels'
    mock_heroku_cli = MockHerokuCli.new({"pg:backups schedule DATABASE_URL --at '#{date}' --app #{project.name}" => "pgbackups_schedule_error.txt"})
    pg_backups = PGBackupsConnector.new mock_heroku_cli
    expect{pg_backups.schedule(project,date)}.to raise_error(RuntimeError) 
  end 

  it "should return list of backups" do 

    expected_backups =  [
          {"id"=>"a165",
           "created_at"=>"2017-04-19 05:29:37 +0000",
           "status"=>"Completed 2017-04-19 05:36:12 +0000",
           "size"=>"4.87MB",
           "database"=>"DATABASE"},
          {"id"=>"b116",
           "created_at"=>"2017-03-01 13:58:19 +0000",
           "status"=>"Completed 2017-03-01 14:04:54 +0000",
           "size"=>"4.47MB",
           "database"=>"DATABASE"},
          {"id"=>"b074",
           "created_at"=>"2017-01-19 07:20:28 +0000",
           "status"=>"Failed 2017-01-19 07:20:30 +0000",
           "size"=>"",
           "database"=>" 0.00B"},
          {"id"=>"b070",
           "created_at"=>"2017-01-18 07:38:30 +0000",
           "status"=>"Failed 2017-01-18 07:38:32 +0000",
           "size"=>"",
           "database"=>" 0.00B"}]

    mock_heroku_cli = MockHerokuCli.new({"pg:backups --app #{project.name}" => "pgbackups_backup_list.txt"})
    pg_backups = PGBackupsConnector.new mock_heroku_cli
    expect(pg_backups.backups(project)).to eq(expected_backups) 
  end 


end 
