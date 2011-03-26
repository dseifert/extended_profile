require_dependency 'my_controller'

module MyControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            after_filter :save_profile, :only => :account
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def save_profile
            if request.post?
                @profile = @user.profile
                @user.profile.attributes = params[:profile]
                unless @user.profile.save
                    flash[:error] = @user.profile.errors.full_messages.join(', ')
                end
            end
        end

    end

end
