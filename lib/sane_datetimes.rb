module SaneDatetimes
  def self.included(base)
    define_method :instantiate_time_object_with_two_field_date_times do |name, values|
      begin
        values = Time.parse(values.join ' ').to_a[0..5].reverse if values.first.is_a? String
        instantiate_time_object_without_two_field_date_times(name, values)
      rescue ArgumentError
        self.errors.add(name, 'bad date')
      end
    end

    base.alias_method_chain :instantiate_time_object, :two_field_date_times
  end
end

