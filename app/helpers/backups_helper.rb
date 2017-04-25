module BackupsHelper
  def backup_line_item(backup)
    line = [("#" + backup.id.to_s)]
    line << content_tag(:span, CGI.escapeHTML(backup.status), class: "muted") if backup.status.present?
    line << content_tag(:span, CGI.escapeHTML(backup.size), class: "muted") if backup.size.present?
    line << content_tag(:span, CGI.escapeHTML(backup.backuped_at.to_s), class: "muted") if backup.backuped_at.present?
    line.join(" — ")
  end

  def backup_status(status)
    if status.match("completed")
      "completed"
    elsif status.match("failed")
      "failed"
    else
      "pending"
    end
  end

  def backup_status_icon_name(backup)
    case backup_status(backup.status)
    when "completed"
      "done"
    when "failed"
      "report_problem"
    else
      "cached"
    end
  end

  def project_status_icon_name(backup)
    return "highlight_off" unless backup
    return backup_status_icon_name(backup) if backup.backuped_at.today?
    "highlight_off"
  end

  def project_status_icon_color_class(backup)
    return "material-icons--error" unless backup
    return status_icon_color_class(backup.status) if backup.backuped_at.today?
    "material-icons--error"
  end
end
