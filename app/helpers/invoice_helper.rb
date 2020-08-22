module InvoiceHelper
  def generate_status status
    case status
    when :paid
      "btn btn-success btn-sm"
    when :unpaid
      "btn btn-secondary btn-sm"
    when :refuned
      "btn btn-warning btn-sm"
    when :cancel
      "btn btn-danger btn-sm"
    when :refuning
      "btn btn-info btn-sm"
    else
      "btn btn-dark btn-sm"
    end
  end
end
