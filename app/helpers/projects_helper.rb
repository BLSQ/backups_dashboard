module ProjectsHelper
  def db_icon(db_connector)
    path = case db_connector
           when "postgresql"
             "postgresql.svg"
           else
             "mysql.svg"
           end

    image_tag path, width: 16, class: "db-icon"
  end

  def project_line_item(project)
    line = [project.name]
    line << content_tag(:span, CGI.escapeHTML(project.region), class: "muted") if project.region.present?
    line << content_tag(:span, CGI.escapeHTML(project.domain), class: "muted") if project.domain.present?
    line << content_tag(:span, CGI.escapeHTML(project.frequency), class: "muted") if project.frequency.present?
    line.join(" — ")
  end
end
