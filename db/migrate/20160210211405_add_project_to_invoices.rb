class AddProjectToInvoices < ActiveRecord::Migration
  def change
    add_reference :invoices, :project, index: true, foreign_key: true
  end
end
