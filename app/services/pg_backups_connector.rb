
class PGBackupsConnector

  HEROKU_CMD = 'pg:backups'

  def initialize(cli = HerokuCli.new)
    @cli = cli
  end 

  def schedule(project,date)
    response = @cli.execute "#{HEROKU_CMD} schedule DATABASE_URL --at '#{date}' --app #{project.name}"
    raise "error while scheduling app #{project.name} with schedule #{date}" if !response.include?('done') 
  end 
  
  def scheduled_at(project)
    scheduled_at = @cli.execute "#{HEROKU_CMD} schedules --app #{project.name}"
    scheduled_at.partition('_URL:').last.strip
  end 

  def scheduled?(project)
    !scheduled_at(project).blank?
  end 

  def backups(project)
    result = @cli.execute "#{HEROKU_CMD} --app #{project.name}"
    backups = result.split('=== ').second.split("\n")[3..-1]
    return [] if  backups.nil?
    backups.map do |raw_api_backup| 
      create_backup(raw_api_backup)
    end 
  end 

  def create_backup(raw_api_backup)
    backup = Hash[['id','created_at','status','size'].zip(raw_api_backup.split(/\s{2,}/))]
    status_mapping = {"Completed" => :completed, "Failed" => :failed}
    {internal_id: backup["id"],
     created_at: backup["created_at"],
     status: status_mapping[backup["status"].split(" ")[0]],
     frequency: "",
     size: backup["size"]}
  end 
end 
