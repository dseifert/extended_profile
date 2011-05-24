require_dependency 'my_controller'

module MyControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            alias_method :account, :account_with_profile
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        def account_with_profile # FIXME: check for 1.0.x and maybe paste above orig. code
            @user = User.current
            @pref = @user.pref
            @profile = @user.profile
            if request.post?
                @user.safe_attributes = params[:user]
                @user.pref.attributes = params[:pref]
                @user.profile.attributes = params[:profile]
                @user.pref[:no_self_notified] = (params[:no_self_notified] == '1')
                if (@user.valid? & @user.valid_profile?) && @user.save
                    @user.pref.save
                    @user.profile.save
                    @user.notified_project_ids = (@user.mail_notification == 'selected' ? params[:notified_project_ids] : [])
                    set_language_if_valid(@user.language)
                    flash[:notice] = l(:notice_account_updated)
                end
            end
        end

    end

end
