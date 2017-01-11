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
    save_to_db
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

  # === INTERFACE METHODS ===
  def async_operation
    fail "async_operation method is required for #{self.class.name}"
  end
  # === END INTERFACE METHODS ===

  def process_in_background
    begin
      async_operation
      async_complete!
    rescue Exception => e
      failed!(e)
    end
  end
  handle_asynchronously :process_in_background

  def async_complete!
    success!
    after_async_complete
  end

  def success!
    self.status = Statuses::SUCCEEDED
    save_to_db
  end

  def failed!(error)
    self.status = Statuses::FAILED
    save_to_db
    handle_async_error(error)
  end

  # === HOOKS ===
  def save_to_db
  end

  def after_async_complete
  end

  def handle_async_error(_error)
  end
  # === END HOOKS ===
end

require_relative './asyncable/active_record_scopes'
