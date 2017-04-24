
class ProjectService
  def initialize(cli = HerokuCli.new)
    @pg_connector = PGBackupsConnector.new(cli)
    @ab_connector = AutobusConnector.new(cli)
  end

  def configure_apps
    heroku = PlatformAPI.connect_oauth(ENV['HEROKU_TOOLBELT_API_PASSWORD'])
    heroku.app.list.each do |app|
      begin
        project = Project.find_or_create_by(name: app['name'])
        update_project(project, app)
        configure(project)
        update_backups(project)
      rescue => e 
        puts "error while configuring #{app['name']} : #{e.message} #{e.backtrace.join('\n')}"
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

  def configure(project)
    return unless project.postgresql?
    unless @pg_connector.scheduled?(project)
      @pg_connector.schedule(project, '07:00 Europe/Brussels')
    end
    project.update_attributes(frequency: @pg_connector.scheduled_at(project))
  end

  def postgres_backups(project)
      postgres_backups = @pg_connector.backups(project)
      postgres_backups.each do |postgres_backup|
        backup = project.backups.find_or_create_by(internal_id: postgres_backup['id']) 
        backup.update_attributes({size: postgres_backup['size'],
                                  status: postgres_backup['status']})
      end 
  end 
  
  def autobus_backups(project)
      autobus_backups = @ab_connector.backups(project)
      autobus_backups.each do |autobus_backup|
        backup = project.backups.find_or_create_by(internal_id: autobus_backup['id']) 
        backup.update_attributes({size: autobus_backup['size'].to_i.to_filesize,
                                  status: autobus_backup['test_status'],
                                  frequency: autobus_backup['kind']})
      end
  end 

end
