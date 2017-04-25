
class ProjectService
  def initialize(cli = HerokuCli.new)
    @pg_connector = PGBackupsConnector.new(cli)
    @ab_connector = AutobusConnector.new(cli)
  end

  def update_all 
    heroku = PlatformAPI.connect_oauth(ENV['HEROKU_TOOLBELT_API_PASSWORD'])
    heroku.app.list.each do |app|
      begin
        project = Project.find_or_create_by(name: app['name'])
        update_project(project, app)
        schedule(project)
      rescue => e 
        puts "error while configuring #{app['name']} : #{e.message} #{e.backtrace.join('\n')}"
      end 
    end
  end

  def update_all_backups
    Project.all.each do |project|
      begin
        update_backups(project)
      rescue => e 
        puts "error while retrieving backups for #{project['name']} : #{e.message} #{e.backtrace.join('\n')}"
      end 
    end
  end 

  def type(app)
    response = RestClient.get("https://api.heroku.com/apps/#{app['name']}/addons", headers = {})
    addons = JSON.parse(response.body)
    if addons.any? { |addon| addon['name'].include?('postgres') }
      :postgresql
    elsif addons.any? { |addon| addon['name'].include?('cleardb') }
      :clear_db
    elsif addons.any? { |addon| addon['name'].include?('jawsdb') }
      :jaws_db
    else
      nil
    end
  end

  def update_project(project, app)
    return unless project.region.nil?
    project.update_attributes({
      region: app['region']['name'],
      domain: app['domain'],
      db_connector: type(app)})
  end

  def schedule(project)
    return unless project.postgresql?
    unless @pg_connector.scheduled?(project)
      @pg_connector.schedule(project, '07:00 Europe/Brussels')
    end
    project.update_attributes(frequency: @pg_connector.scheduled_at(project))
  end


  def update_backups(project)
    connector_backups = project.postgresql? ? @pg_connector.backups(project)
                                            : @ab_connector.backups(project) 

    connector_backups.each do |connector_backup|
      backup = project.backups.find_or_create_by(internal_id: connector_backup[:internal_id]) 
      backup.update_attributes({size: connector_backup[:size],
                                status: connector_backup[:status],
                                backuped_at: connector_backup[:created_at],
                                frequency: connector_backup[:frequency]})
    end
  end 
end
