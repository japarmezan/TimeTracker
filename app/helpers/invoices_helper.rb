module InvoicesHelper
  def invoiced_price(invoice)
    price = 0
    invoice.project.tracks.where('end >?', invoice.from).where('end < ?', invoice.to).each do |t|
      price += ((t.end - t.start) / 60 / 60) * t.label.wage
    end
    price.round(2).to_s + " " + invoice.project.currency
  end
end
