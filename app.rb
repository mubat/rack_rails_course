# frozen_string_literal: true

require 'cgi'
require 'pry'
require_relative 'handler_time_format'

class App
  def initialize
    @handlers = { '/time': HandlerTimeFormat }
  end

  ##
  # main method of incoming call handling
  # It Prepare 3 states:
  #   1 - if incoming path not support (404)
  #   2 - if handler has errors (400 and errors message in body)
  #   3 - normal state when request handled successfully
  #  All addition logic will be described inside each handler according it business logic
  def call(env)
    request = Rack::Request.new(env)
    return response(404) unless @handlers.key?(request.path.to_sym)

    handler = @handlers[request.path.to_sym].new(request.params['format'])
    return response(400, handler.errors) if handler.errors?

    response(body: handler.prepare_result)

  end

  private

  def response(status = 200, body = nil, headers = { 'Content-Type' => 'text/plain' })
    Rack::Response.new(body, status, headers).finish
  end
end
