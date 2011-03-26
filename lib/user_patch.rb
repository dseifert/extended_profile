require_dependency 'user'

module UserPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            has_one :extended_profile, :dependent => :destroy, :class_name => 'ExtendedProfile'
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def profile
            self.extended_profile ||= ExtendedProfile.new(:user => self)
        end

    end

end
