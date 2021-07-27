# frozen_string_literal: true

require 'cgi'
require 'pry'
require_relative 'handler_time_format'

class App
  def initialize
    @handlers = { '/time': HandlerTimeFormat }
  end

  def call(env)
    @request = Rack::Request.new(env)
    initialize_response_arguments
    process_call
    Rack::Response.new(@body, @status, @headers).finish
  end

  private

  ##
  # main method of incoming call handling
  # It Prepare 3 states:
  #   1 - if incoming path not support (404)
  #   2 - if handler has errors (400 and errors message in body)
  #   3 - normal state when request handled successfully
  #  All addition logic will be described inside each handler according it business logic
  def process_call
    unless @handlers.key?(@request.path.to_sym)
      @status = 404
      return
    end

    handler = @handlers[@request.path.to_sym].new(@request.params['format'])
    @status = 400 if handler.errors?
    @body = handler.errors? ? handler.errors : handler.prepare_result
  end

  ##
  # Initialization executes in separate action
  # It's need to clean data for each request call
  def initialize_response_arguments
    @body = nil
    @status = 200
    @headers = { 'Content-Type' => 'text/plain' }
  end

end
