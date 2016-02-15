module InvoicesHelper
  def invoiced_price(invoice)
    price = 0
    invoice.project.tracks.where('end >?', invoice.from).where('end < ?', invoice.to).each do |t|
      price += ((t.end - t.start) / 60 / 60) * t.label.wage unless t.label.nil?
    end
    price.round(2).to_s + " " + invoice.project.currency
  end

  def render_invoice(invoice)
    pdf = Prawn::Document.new

    pdf.font_families.update(
      'OpenSans' => {
        :normal => Rails.root.join('fonts/OpenSans-Regular.ttf').to_s,
        :bold => Rails.root.join('fonts/OpenSans-Bold.ttf').to_s,
        :italic => Rails.root.join('fonts/OpenSans-Italic.ttf').to_s,
        :bold_italic => Rails.root.join('fonts/OpenSans-BoldItalic.ttf').to_s })
    pdf.font "OpenSans"

    # Defining the grid
    # See http://prawn.majesticseacreature.com/manual.pdf
    pdf.define_grid(:columns => 5, :rows => 8, :gutter => 10)

    pdf.grid([0, 0], [1, 1]).bounding_box do
      pdf.text "INVOICE", :size => 18
      pdf.text "Invoice No.: #{invoice.id}", :align => :left
      pdf.text "Date: #{Date.today}", :align => :left
      pdf.move_down 10

      pdf.text "Supplier:", :style => :bold
      pdf.text invoice.project.author.name, :align => :left
      pdf.text invoice.project.author.additional, :align => :left
      pdf.text invoice.project.author.email, :align => :left
    end

    pdf.grid([0, 3.2], [1, 4]).bounding_box do
      # Company address
      pdf.move_down 10
      pdf.text "Customer:", :style => :bold
      pdf.text invoice.project.client
    end

    pdf.text "Details of Invoice", :style => :bold
    pdf.stroke_horizontal_rule

    pdf.move_down 10
    items = [["Description", "Unit Price", "Qt.", "Amount"]]
    items += invoice_items(invoice)
    items += [["Total", "", "", invoiced_price(invoice)]]

    pdf.table items, :header => true,
      :column_widths => { 0 => 350 }, :row_colors => %w(d2e3ed FFFFFF) do
      style(columns(3)) { |x| x.align = :right }
    end

    pdf.move_down 200
    pdf.text ".........................................."
    pdf.text "Signature/Company Stamp"

    pdf.move_down 10
    pdf.stroke_horizontal_rule

    pdf.render
  end

  def invoice_items(invoice)
    items = []
    invoice.project.labels.each do |l|
      time = 0
      next if l.nil?
      l.tracks.where('end >?', invoice.from).where('end < ?', invoice.to).each do |t|
        time += ((t.end - t.start) / 60 / 60)
      end
      items << [l.name, l.wage.to_s + ' ' + invoice.project.currency, time.round(2).to_s, (time * l.wage).round(2).to_s + ' ' + invoice.project.currency] if time > 0
    end
    items
  end
end
