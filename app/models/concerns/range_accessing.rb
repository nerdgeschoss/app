# frozen_string_literal: true

module RangeAccessing
  extend ActiveSupport::Concern

  class_methods do
    def range_accessor_methods(name)
      storage_key = "#{name}_during"
      setter_key = "#{storage_key}="

      define_method("#{name}?") do
        datetime_range_includes public_send(storage_key), DateTime.current
      end

      define_method("#{name}_from") do
        date = public_send(storage_key)&.begin
        date = nil if [DateTime::Infinity.new(-1), -Float::INFINITY].include?(date)
        date&.in_time_zone
      end

      define_method("#{name}_from=") do |date|
        ending = public_send(storage_key)&.end
        value = date.presence&.to_datetime || DateTime.current
        ending = value if ending && value > ending
        ending ||= DateTime::Infinity.new
        public_send(setter_key, value..ending)
      end

      define_method("#{name}_until") do
        date = public_send(storage_key)&.end
        date = nil if [DateTime::Infinity.new, Float::INFINITY].include?(date)
        date&.in_time_zone
      end

      define_method("#{name}_until=") do |date|
        start = public_send(storage_key)&.begin
        start = nil if [DateTime::Infinity.new(-1), -Float::INFINITY].include?(start)
        start ||= DateTime.current
        date = date.presence&.to_datetime
        start = [start, date].compact.min
        date ||= DateTime::Infinity.new
        public_send(setter_key, start..date)
      end
    end
  end
end
