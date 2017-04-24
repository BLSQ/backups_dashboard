require 'rails_helper'

describe AutobusConnector do
  let(:project) {Project.new(name: "app_name", autobus_token: 'test_token', db_connector: :jaws_db )}

  it 'should return an array of backups' do
    expected_backups = [
      {internal_id: "58fd9",
       created_at: "2017-04-24T06:34:07.015Z",
       status: :completed,
       frequency: "Daily", 
       size: "31.68 MiB"},
      {internal_id: "58fc4",
       created_at: "2017-04-23T06:34:04.005Z",
       status: :completed,
       frequency: "Daily",
       size: "31.67 MiB"}
    ]

    stub_request(:get, "https://www.autobus.io/api/snapshots?token=#{project.autobus_token}")
      .to_return(body: fixture_content(:autobus, 'autobus_backup_list.json'),
                 status: 200)
    ab_connector = AutobusConnector.new
    backups = ab_connector.backups(project)
    expect(backups).to eq expected_backups
  end

  it 'should return an empty array if no backup is found' do 
    stub_request(:get, "https://www.autobus.io/api/snapshots?token=#{project.autobus_token}")
      .to_return(body: fixture_content(:autobus, 'autobus_empty_backup_list.json'),
                 status: 200)
    ab_connector = AutobusConnector.new
    backups = ab_connector.backups(project)
    expect(backups).to eq [] 
  end 
end
