module FormtasticHacks
	def sane_datetime_input(method, options)
		
		position = { :date => 1, :time => 2 }
    inputs   = options.delete(:order) || [ :date, :time ]

		inputs_capture = ''
    hidden_fields_capture = ''

    # Gets the datetime object. It can be a Fixnum, Date or Time, or nil.
    datetime     = @object ? @object.send(method) : nil
    html_options = (options.delete(:input_html) || {}).with_indifferent_access

    inputs.each do |input|
      html_id    = generate_html_id(method, "#{position[input]}s")
      field_name = "#{method}(#{position[input]}s)"
      if options["discard_#{input}".intern]
        break if time_inputs.include?(input)
        
        hidden_value = datetime.respond_to?(input) ? datetime.send(input) : datetime
        hidden_fields_capture << template.hidden_field_tag("#{@object_name}[#{field_name}]", (hidden_value || 1), :id => html_id)
      else
				this_html_options = html_options[input] ? html_options.merge(html_options.delete(input)) : html_options
        # item_label_text = I18n.t(input.to_s, :default => input.to_s.humanize, :scope => [:datetime, :prompts])

        inputs_capture << template.text_field_tag("#{@object_name}[#{field_name}]", datetime, this_html_options.merge(:id => html_id))
      end
    end

		self.label(method, options_for_label(options)) + hidden_fields_capture + inputs_capture
	end
end
