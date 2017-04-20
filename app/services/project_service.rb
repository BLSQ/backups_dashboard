
class ProjectService
  def initialize(cli = HerokuCli.new)
    @pg_backups = PGBackupsConnector.new(cli)
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
    unless @pg_backups.scheduled?(project)
      @pg_backups.schedule(project, '07:00 Europe/Brussels')
    end
    project.update_attributes(frequency: @pg_backups.scheduled_at(project))
  end

  def update_backups(project)
      heroku_backups = @pg_backups.backups(project)
      heroku_backups.each do |heroku_backup|
        backup = project.backups.find_or_create_by(internal_id: heroku_backup['id']) 
        backup.update_attributes({size: heroku_backup['size'],
                                  status: heroku_backup['status']})
      end 
  end 

end
