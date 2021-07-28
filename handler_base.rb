# Base class for all Handlers.
# Describes common methods that use to execute handler
# All handlers should be extended from this class
class HandlerBase

  attr_reader :result, errors

  def initialize(*)
    @result = nil
    @errors = []
  end

  ##
  # Handle and return response data.
  # Main method of all handler logic. It makes main things
  # return boolean result of handling data. Errors you can see by calling `errors` method
  def handle
    raise 'Method should implemented in inherit class'
  end

  ##
  # Check is current state has errors
  def invalid?
    !@errors.empty?
  end

  ##
  # A set of errors that has been found
  def errors
    raise 'Method should implemented in inherit class'
  end
end
