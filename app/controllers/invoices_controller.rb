class InvoicesController < ApplicationController
  include InvoicesHelper
  before_action :set_invoice, only: [:destroy, :download]
  before_action :authenticate_user!
  authorize_actions_for Invoice, :actions => {:download => :update, :invoice_project => :create }

  # GET /invoices
  # GET /invoices.json
  def index
  end

  # GET /invoices/new
  def invoice_project
    @invoice = Invoice.new
  end

  def download
    authorize_action_for @invoice
    send_data render_invoice(@invoice), filename: 'invoice.pdf', type: 'application/pdf'
  end

  # POST /invoices
  # POST /invoices.json
  def create
    @invoice = Invoice.new(invoice_params)
    respond_to do |format|
      if @invoice.save
        format.html { redirect_to projects_path, notice: 'Invoice was successfully created.' }
      else
        format.html { render :invoice_project }
      end
    end
  end

  # DELETE /invoices/1
  # DELETE /invoices/1.json
  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_invoice
      @invoice = Invoice.find Invoice.decode_id(params[:id])
    end

    def set_project
      @project = Project.find Project.decode_id(params[:id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def invoice_params
      params.require(:invoice).permit(:from, :to, :project_id)
    end
end
