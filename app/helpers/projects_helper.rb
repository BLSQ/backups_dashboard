module ProjectsHelper
  def db_icon(db_connector)
    path = case db_connector
           when 'postgresql'
             'postgresql.svg'
           else
             'mysql.svg'
           end

    image_tag path, width: 16, class: 'db-icon'
  end
end
