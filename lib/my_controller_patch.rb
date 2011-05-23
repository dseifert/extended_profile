require_dependency 'my_controller'

module MyControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            alias_method_chain :account, :profile
            #after_filter :save_profile, :only => :account
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def account_with_profile
            if request.post?
                @user = User.current
                @user.profile.attributes = params[:profile]
                unless @user.profile.save
                    flash[:error] = @user.profile.errors.full_messages.join(', ')
                end
            end
            account_without_profile
        end

        #def save_profile
        #    if request.post? && response.redirected_to.present?
        #        @user.profile.attributes = params[:profile]
        #        unless @user.profile.save
        #            flash[:error] = @user.profile.errors.full_messages.join(', ')
        #            flash.delete(:notice)
        #        end
        #    end
        #end

    end

end
