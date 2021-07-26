# frozen_string_literal: true

require 'cgi'

class App
  SUPPORT_FORMATS = {
    'year' => '%Y',
    'month' => '%m',
    'day' => '%d',
    'hour' => '%H',
    'minute' => '%M',
    'second' => '%S'
  }.freeze

  def call(env)
    @env = env
    parse
    validate_formats
    @status = status
    @headers = headers
    @body = body
    [@status, @headers, @body]
  end

  private

  def status
    return 400 if errors?

    @env['REQUEST_PATH'] == '/time' ? 200 : 404
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    return ["Unknown time format [#{@not_support_formats.join(', ')}]\n"] if errors?
    return [] unless @status == 200

    ["#{Time.now.strftime(format)}\n"]
  end

  def parse
    @params = CGI.parse(@env['QUERY_STRING'])
    @request_format = @params['format'][0]
  end

  def validate_formats
    @not_support_formats = @request_format.split(',') - SUPPORT_FORMATS.keys
  end

  def errors?
    !@not_support_formats.empty?
  end

  def format
    format = @request_format.split(',')
    format.map! { |t| t = SUPPORT_FORMATS[t] }
    format.join('-')
  end
end
