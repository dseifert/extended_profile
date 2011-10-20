require_dependency 'my_controller'

module MyExtendedControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            alias_method_chain :account, :extended
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        # Original function
        #def account
        #    @user = User.current
        #    @pref = @user.pref
        #    if request.post?
        #        @user.safe_attributes = params[:user]
        #        @user.pref.attributes = params[:pref]
        #        @user.pref[:no_self_notified] = (params[:no_self_notified] == '1')
        #        if @user.save
        #            @user.pref.save
        #            @user.notified_project_ids = (@user.mail_notification == 'selected' ? params[:notified_project_ids] : [])
        #            set_language_if_valid @user.language
        #            flash[:notice] = l(:notice_account_updated)
        #-           redirect_to :action => 'account'
        #-           return
        #        end
        #    end
        #end

        def account_with_extended
            if request.post?
                @user = User.current
                @pref = @user.pref
                @profile = @user.profile
                @user.profile.attributes = params[:profile]

                if (@user.valid? & @user.valid_profile?) && @user.save
                    @user.profile.save
                end
            end
            account_without_extended
        end

    end

end
