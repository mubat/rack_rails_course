require_relative 'handler_base'

class HandlerTimeFormat < HandlerBase

  SUPPORT_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def initialize(format)
    super(format)
    @request_format = format.split(',')
  end

  def handle
    validate
    return if invalid?

    @result = "#{Time.now.strftime(convert_to_time_format)}\n"
  end

  def validate
    @errors = []

    not_support_formats = @request_format - SUPPORT_FORMATS.keys
    @errors << "Unknown time format [#{not_support_formats.join(', ')}]\n" unless not_support_formats.empty?
  end

  private

  def convert_to_time_format
    @request_format.map { |t| t = SUPPORT_FORMATS[t] }.join('-')
  end

end
