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
    result = RestClient.get("https://www.autobus.io/api/snapshots?token=#{project.autobus_token}",
                              headers = {})
    raw_api_backups = JSON.parse(result.body)
    raw_api_backups.map do |raw_api_backup| 
      create_backup(raw_api_backup)
    end 
  end

  def create_backup(raw_api_backup)
    status_mapping = {"Pass" => :completed, "Failed" => :failed}
    {internal_id: raw_api_backup["id"],
     created_at: raw_api_backup["created_at"],
     status: status_mapping[raw_api_backup["test_status"]] || 'unknown',
     frequency: raw_api_backup["kind"],
     size: Filesize.from("#{raw_api_backup["size"]} B").pretty}
  end 
end
