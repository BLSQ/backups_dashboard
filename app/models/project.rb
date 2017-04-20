class Project < ApplicationRecord
  enum db_connector: %i[jaws_db clear_db postgresql]
  has_many :backups

  scope :missing_config, -> { where.not(db_connector: :postgresql).where(autobus_token: nil) }
  scope :configured, -> { where.not(autobus_token: nil) }

  def configured?
    postgresql? ? frequency? : autobus_token? && frequency? 
  end
end
