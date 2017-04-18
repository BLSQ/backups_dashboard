class Project < ApplicationRecord
  enum db_connector: [:jaws_db, :clear_db, :postgresql]
end
