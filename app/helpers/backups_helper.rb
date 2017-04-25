module BackupsHelper
  def backup_line_item(backup)
    line = [('#' + backup.id.to_s)]
    line << content_tag(:span, CGI::escapeHTML(backup.status), class: 'muted') unless backup.status.blank?
    line << content_tag(:span, CGI::escapeHTML(backup.size), class: 'muted') unless backup.size.blank?
    line << content_tag(:span, CGI::escapeHTML(backup.backuped_at.to_s), class: 'muted') unless backup.backuped_at.blank?
    line.join(' — ')
  end

  def backup_status(status)
    if status.match('completed')
      'completed'
    elsif status.match('failed')
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
