module BackupsHelper
  def backup_line_item(backup)
    line = [('#' + backup.id.to_s)]
    line << content_tag(:span, CGI::escapeHTML(backup.status), class: 'muted') unless backup.status.blank?
    line << content_tag(:span, CGI::escapeHTML(backup.size), class: 'muted') unless backup.size.blank?
    line.join(' — ')
  end

  def backup_status(status)
    if status.match('Completed')
      'completed'
    elsif status.match('Failed')
      'failed'
    else
      'pending'
    end
  end

  def backup_status_icon_name(backup)
    case backup_status(backup.status)
    when 'completed'
      'done'
    when 'failed'
      'report_problem'
    else
      'cached'
    end
  end
end
