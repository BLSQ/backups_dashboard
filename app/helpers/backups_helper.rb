module BackupsHelper
  def backup_line_item(backup)
    line = [('#' + backup.id.to_s)]
    line << content_tag(:span, CGI::escapeHTML(backup.status), class: 'muted') unless backup.status.blank?
    line << content_tag(:span, CGI::escapeHTML(backup.size), class: 'muted') unless backup.size.blank?
    line.join(' — ')
  end
end
