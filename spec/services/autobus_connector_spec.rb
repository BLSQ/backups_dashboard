require 'rails_helper'

describe AutobusConnector do
  let(:project) { Project.new(autobus_token: 'test_token') }

  it 'should return an array of backups' do
    expected_backups = [{"created_at"=>"2017-04-24T06:34:07.015Z",
         "database"=>"JAWSDB_URL",
         "description"=>"",
         "duration"=>40,
         "id"=>"58fd9",
         "kind"=>"Daily",
         "size"=>33219652,
         "test_status"=>"Pass",
         "url"=>"fake url"},
        {"created_at"=>"2017-04-23T06:34:04.005Z",
         "database"=>"JAWSDB_URL",
         "description"=>"",
         "duration"=>44,
         "id"=>"58fc4",
         "kind"=>"Daily",
         "size"=>33206586,
         "test_status"=>"Pass",
         "url"=>"fake url"}]

    stub_request(:get, "https://www.autobus.io/api/snapshots?token=#{project.autobus_token}")
      .to_return(body: fixture_content(:autobus, 'autobus_backup_list.json'),
                 status: 200)
    ab_connector = AutobusConnector.new
    backups = ab_connector.backups(project)
    expect(backups).to eq expected_backups
  end

  def fixture_content(type, name)
    File.read(File.join('spec', 'fixtures', type.to_s, name))
  end
end
