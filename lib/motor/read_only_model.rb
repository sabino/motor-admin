# frozen_string_literal: true
require "active_support/concern"

module Motor
  # Provides read-only behavior for models
  module ReadOnlyModel
    extend ActiveSupport::Concern

    included do
      # mark the model as read only
      def readonly?
        true
      end

      before_create  :raise_readonly
      before_update  :raise_readonly
      before_destroy :raise_readonly
    end

    private

    def raise_readonly(*_args)
      raise ActiveRecord::ReadOnlyRecord, "#{self.class} is read only"
    end
  end
end
