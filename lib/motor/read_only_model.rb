module Motor
  module ReadOnlyModel
    extend ActiveSupport::Concern

    included do
      before_create :raise_read_only!
      before_update :raise_read_only!
      before_destroy :raise_read_only!
    end

    def readonly?
      true
    end

    private

    def raise_read_only!
      raise ActiveRecord::ReadOnlyRecord, "#{self.class.name} is read-only"
    end
  end
end
