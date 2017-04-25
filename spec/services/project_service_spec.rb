require "rails_helper"
require_relative "../../app/services/project_service.rb"
require_relative "../mock_heroku_cli.rb"

describe ProjectService do
  let(:project) { Project.new(name: "app_name", db_connector: :postgresql) }

  let(:pg_addons) do
    [
      {
        "name"                => "heroku-postgresql:hobby-dev",
        "description"         => "Heroku Postgres Hobby Dev",
        "beta"                => false,
        "state"               => "public",
        "attachable"          => true,
        "price"               => {
          "cents" => 0,
          "unit"  => "month"
        },
        "slug"                => "hobby-dev",
        "consumes_dyno_hours" => false,
        "plan_description"    => "Hobby Dev",
        "group_description"   => "Heroku Postgresql",
        "selective"           => false,
        "terms_of_service"    => false,
        "sso_url"             => "https://addons-sso.heroku.com/apps/...",
        "attachment_name"     => "DATABASE",
        "configured"          => true
      }
    ]
  end

  it "should work" do
    stub_api_heroku_list_app
    stub_api_heroku_addons(pg_addons)

    mock_heroku_cli = MockHerokuCli.new(
      "pg:backups schedules --app myapp" => "pgbackups_scheduled_at.txt",
      "pg:backups --app myapp"           => "pgbackups_backup_list.txt"
    )

    service = ProjectService.new(mock_heroku_cli)
    service.update_all
    service.update_all_backups

    expect(Project.count).to eq 1
    expect(Backup.count).to eq 4
  end

  def stub_api_heroku_list_app
    stub_request(:get, "https://api.heroku.com/apps")
      .to_return(status: 200, body: [
                   { "id"     => 123,
                     "name"   => "myapp",
                     "domain" => "myapp.herokuapp.com",
                     "region" => { "name" => "eu" } }
                 ], headers: {})
  end

  def stub_api_heroku_addons(addons)
    stub_request(:get, "https://api.heroku.com/apps/myapp/addons")
      .to_return(status: 200, body: addons.to_json, headers: {})
  end
end
