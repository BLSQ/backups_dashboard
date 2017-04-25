class Project < ApplicationRecord
  enum db_connector: %i[jaws_db clear_db postgresql]
  has_many :backups

  scope :missing_config, -> { where.not(db_connector: [Project.db_connectors[:postgresql]]).where(autobus_token: ["", nil]) }
  scope :with_autobus_config, -> { where.not(autobus_token: "") }

  def self.configured
    (postgresql + with_autobus_config).uniq
  end

  def configured?
    postgresql? ? frequency? : autobus_token? && frequency?
  end

  def last_five_backups
    backups.sort_by(&:backuped_at).last(5).reverse
  end

  def last_backup
    last_five_backups.first
  end

  def priority
    return 1 if last_backup &&
                last_backup.backuped_at.today? &&
                last_backup.status == "completed"
    0
  end
end
