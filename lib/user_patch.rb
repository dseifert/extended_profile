require_dependency 'user'

module UserPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            has_one :extended_profile, :dependent => :destroy, :class_name => 'ExtendedProfile'

            safe_attributes 'extended_profile'

            validates_associated :extended_profile
            validates_presence_of :extended_profile

            #after_save :save_profile

        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def profile
            self.extended_profile ||= ExtendedProfile.new(:user => self)
        end

        #def save_profile
        #    self.extended_profile
        #end

    end

end
