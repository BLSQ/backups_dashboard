class Project < ApplicationRecord
  enum db_connector: %i[jaws_db clear_db postgresql]
  has_many :backups

  scope :missing_config, -> { where.not(db_connector: [Project.db_connectors[:postgresql]]).where(autobus_token: '') }
  scope :configured, -> { where.not(autobus_token: '') }

  def configured?
    postgresql? ? true : autobus_token?
  end
end
