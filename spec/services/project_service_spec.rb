require 'rails_helper'
require_relative '../../app/services/project_service.rb'
require_relative '../mock_heroku_cli.rb'

describe ProjectService do
  
  let(:project) {Project.new(name: "app_name", db_connector: :postgresql)}

end 
