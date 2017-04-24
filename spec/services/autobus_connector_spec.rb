require 'rails_helper'
require_relative '../../app/services/project_service.rb'
require_relative '../mock_heroku_cli.rb'

describe AutobusConnector do
  
  let(:project) {Project.new(autobus_token: 'f6534f7b045e54e4f557732db77edbfd782d6bbe5eb0bb8d')}

  it "should return an array of backups" do 
    # how do I mock a rest api (autobusconnector uses restclient)
    expected_backups =  []
    ab_connector.backups(project) 
  end 

  end 
