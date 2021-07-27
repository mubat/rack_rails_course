# frozen_string_literal: true

require 'cgi'
require_relative 'time_format'

class App
  def initialize
    @handlers = { '/time': TimeFormat }
  end

  def call(env)
    @request = Rack::Request.new(env)
    process
    response = Rack::Response.new(body, status, headers)
    response.finish
  end

  private

  def process
    return unless @handlers.key?(@request.path.to_sym)

    @handler = @handlers[@request.path.to_sym].new(@request.params['format'])
  end

  def status
    return 404 unless @handlers.key?(@request.path.to_sym)

    @handler.errors? ? 400 : 200
  end

  def headers
    { 'Content-Type' => 'text/plain' }
  end

  def body
    return unless @handlers.key?(@request.path.to_sym)
    return @handler.errors if @handler.errors?

    @handler.handle
  end
end
