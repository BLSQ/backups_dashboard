
class PGBackupsConnector

  HEROKU_CMD = 'pg:backups'

  def initialize(cli = HerokuCli.new)
    @cli = cli
  end 

  def schedule(project,date)
    response = @cli.execute "#{HEROKU_CMD} schedule DATABASE_URL --at #{date} --app #{project.name}"
    raise "error while scheduling app #{project.name} with schedule #{date}" if !response.include?('done') 
  end 
  
  def scheduled_at(project)
    scheduled_at = @cli.execute "#{HEROKU_CMD} schedules --app #{project.name}"
    scheduled_at.partition('DATABASE_URL:').last.strip
  end 

  def scheduled?(project)
    !scheduled_at(project).blank?
  end 

  def backups(project)
    @cli.execute "#{HEROKU_CMD} --app #{project.name}"
  end 
end 
