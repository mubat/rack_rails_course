# frozen_string_literal: true

# Base class for all Handlers.
# Describes common methods that use to execute handler
# All handlers should be extended from this class
class HandlerBase

  def initialize(**options); end

  ##
  # Handle and return response data.
  def prepare_response
    raise 'Method should implemented in inherit class'
  end

  ##
  # Check is current state has errors
  def errors?
    errors.nil?
  end

  ##
  # A set of errors that has been found
  def errors
    raise 'Method should implemented in inherit class'
  end
end
