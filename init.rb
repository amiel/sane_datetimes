$:.unshift "#{File.dirname(__FILE__)}/lib"
require 'sane_datetimes'
ActiveRecord::Base.class_eval { include SaneDatetimes }


if defined? Formtastic then
	require 'formtastic_hacks'
	class Formtastic::SemanticFormBuilder
		include FormtasticHacks
	end
end