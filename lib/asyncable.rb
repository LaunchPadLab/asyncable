require 'asyncable/version'
require 'active_support/all'

module Asyncable
  module Statuses
    PROCESSING = 'processing'
    FAILED = 'failed'
    SUCCEEDED = 'succeeded'
  end

  # === CLASS HOOKS ===
  def self.handle_asynchronously(method)
  end
  # === END CLASS HOOKS ===

  def start_async
    self.status = Statuses::PROCESSING
    save
    process_in_background
  end

  def succeeded?
    status == Statuses::SUCCEEDED
  end

  def failed?
    status == Statuses::FAILED
  end

  def processing?
    status == Statuses::PROCESSING
  end

  private

  def process_in_background
    begin
      async_operation
      complete!
    rescue Exception => e
      failed!(e)
    end
  end
  handle_asynchronously :process_in_background


  def complete!
    self.status = Statuses::SUCCEEDED
    save
    after_async_complete
  end

  def failed!(error)
    self.status = Statuses::FAILED
    save
    handle_async_error(error)
  end

  # === INTERFACE ===
  def async_operation
    fail "async_operation method is required for #{self.class.name}"
  end

  def save
    fail "save method is required for #{self.class.name}"
  end
  # === END INTERFACE ===

  # === HOOKS ===
  def after_async_complete
  end

  def handle_async_error(_error)
  end
  # === END HOOKS ===
end

require_relative './asyncable/active_support_scopes'
