module ApplicationHelper
  def message_alert_type type
    type == "danger" ? "alert alert-danger" : "alert alert-success"
  end
end
