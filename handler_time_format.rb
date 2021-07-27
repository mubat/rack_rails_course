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
    validate_formats
  end

  def prepare_result
    ["#{Time.now.strftime(format)}\n"]
  end

  def errors?
    !@not_support_formats.empty?
  end

  def errors
    ["Unknown time format [#{@not_support_formats.join(', ')}]\n"] unless @not_support_formats.empty?
  end

  private

  ##
  # check incoming formats and save wrong set
  def validate_formats
    @not_support_formats = @request_format - SUPPORT_FORMATS.keys
  end

  def format
    @request_format.map { |t| t = SUPPORT_FORMATS[t] }.join('-')
  end

end
