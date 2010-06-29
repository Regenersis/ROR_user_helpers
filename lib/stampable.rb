module Users
  module Stampable
    def self.included(base)
      base.class_eval do
        include InstanceMethods
        before_save :set_updated_by
        before_create :set_created_by
      end
    end
  end

  module InstanceMethods
    def set_updated_by
      self.updated_by = User.current.username
    end

    def set_created_by
      self.created_by = User.current.username
    end
  end
end
ActiveRecord::Base.send(:include, Users::Stampable) if defined?(ActiveRecord)