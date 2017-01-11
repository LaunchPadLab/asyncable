module Asyncable
  module ActiveRecordScopes
    extend ActiveSupport::Concern

    included do
      scope :processing, -> { where(status: Statuses::PROCESSING) }
      scope :failed, -> { where(status: Statuses::FAILED) }
      scope :succeeded, -> { where(status: Statuses::SUCCEEDED) }
    end
  end
end
