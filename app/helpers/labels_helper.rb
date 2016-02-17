module LabelsHelper
	def track_label(label_id)
    if label_id
		label = Label.find(label_id)

	    color = case label.color
	    when "green"
	      "success"
	    when "blue"
	      "primary"
	    when "orange"
	      "warning"
	    when "red"
	      "danger"
	    end


	    html = <<-HTML
	      <span class="label label-#{color}">
	        #{label.name}  
	      </span>
	    HTML

      html.html_safe
    end

  end

end
