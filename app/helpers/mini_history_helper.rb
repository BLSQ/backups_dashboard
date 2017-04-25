module MiniHistoryHelper
  def mini_history_bar_classes(backup)
    ["mini-history__bar", mini_history_bar_bg_class(backup.status)].join(" ")
  end

  def mini_history_bar_bg_class(status)
    status = backup_status(status)
    case status
    when "completed"
      "mini-history__bar--completed"
    when "failed"
      "mini-history__bar--failed"
    else
      "mini-history__bar--pending"
    end
  end

  def status_icon_color_class(status)
    status = backup_status(status)
    case status
    when "completed"
      "material-icons--success"
    when "failed"
      "material-icons--error"
    end
  end
end
