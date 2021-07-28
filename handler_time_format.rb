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
    return unless valid?

    @result = "#{Time.now.strftime(format)}\n"
  end

  def errors
    @errors = []

    not_support_formats = @request_format - SUPPORT_FORMATS.keys
    @errors << "Unknown time format [#{not_support_formats.join(', ')}]\n" unless not_support_formats.empty?
  end

  private

  def format
    @request_format.map { |t| t = SUPPORT_FORMATS[t] }.join('-')
  end

end
