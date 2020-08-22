class InvoicesController < ApplicationController
  def index
    @invoices = Invoice.newest
  end
end
