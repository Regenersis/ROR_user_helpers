module Users
  module Controller

    def self.included(base)
      base.class_eval do
        include InstanceMethods

        include Session

        before_filter :init_user
        before_filter CASClient::Frameworks::Rails::Filter

        before_filter :set_user
        before_filter :can_access

        include SentientController
      end
    end

    module InstanceMethods

      def set_user
        session[:user] = User.find(session[:cas_extra_attributes][:id]).to_json if session[:user].nil?
      end

      def can_access
        render 'shared/access_denied' unless current_user.can_access(request.url)
      end

      def init_user
        if ["development","test"].include?(RAILS_ENV)
          CASClient::Frameworks::Rails::Filter.fake("homer")
        end
      end
    end
  end
end

ApplicationController.send(:include, Users::Controller)