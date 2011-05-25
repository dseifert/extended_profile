require_dependency 'user'

module ExtendedUserPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            has_one :extended_profile, :dependent => :destroy, :class_name => 'ExtendedProfile'

            safe_attributes 'extended_profile'

            validates_presence_of :extended_profile

            def project_id=(id)
                self.extended_profile = ExtendedProfile.new(:user => self, :project_id => id)
            end

            def profile=(params) # FIXME: redirect to some form if project is required
                attrs = params.dup
                self.extended_profile = ExtendedProfile.new(attrs.merge!(:user => self))
            end
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def profile
            self.extended_profile ||= ExtendedProfile.new(:user => self)
        end

        def valid_profile?
            if self.extended_profile.invalid?
                self.extended_profile.errors.each do |field, message|
                    errors.add(field, message)
                end
                return false
            end
            return true
        end

    end

end
