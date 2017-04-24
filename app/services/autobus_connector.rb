class AutobusConnector
  def initialize(cli = HerokuCli.new)
    @cli = cli
  end

  def schedule(project, date)
  end

  def scheduled_at(project)
  end

  def scheduled?(project)
  end

  def backups(project)
    response = RestClient.get("https://www.autobus.io/api/snapshots?token=#{project.autobus_token}",
                              headers = {})
    snapshots = JSON.parse(response.body)
  end
end
