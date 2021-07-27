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

  def initialize(**options)
    super(**options)
    @request_format = options[format]
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

  def validate_formats
    @not_support_formats = @request_format.split(',') - SUPPORT_FORMATS.keys
  end

  def format
    format = @request_format.split(',')
    format.map! { |t| t = SUPPORT_FORMATS[t] }
    format.join('-')
  end

end
