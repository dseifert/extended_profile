require_dependency 'my_controller'

module MyExtendedControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable
            alias_method :account, :extended_account
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

        def extended_account
            @user = User.current
            @pref = @user.pref
            @profile = @user.profile
            if request.post?
                if @user.respond_to?('safe_attributes=')
                    @user.safe_attributes = params[:user]
                else # Redmine 1.0.x
                    @user.attributes = params[:user]
                    @user.mail_notification = (params[:notification_option] == 'all')
                end
                @user.pref.attributes = params[:pref]
                @user.profile.attributes = params[:profile]
                @user.pref[:no_self_notified] = (params[:no_self_notified] == '1')
                if (@user.valid? & @user.valid_profile?) && @user.save
                    @user.pref.save
                    @user.profile.save
                    if params[:notification_option] # Redmine 1.0.x
                        @user.notified_project_ids = (params[:notification_option] == 'selected' ? params[:notified_project_ids] : [])
                    else
                        @user.notified_project_ids = (@user.mail_notification == 'selected' ? params[:notified_project_ids] : [])
                    end
                    set_language_if_valid(@user.language)
                    flash[:notice] = l(:notice_account_updated)
                end
            end
            if User.columns_hash['mail_notification'].type == :boolean # Redmine 1.0.x
                @notification_options = [ [ l(:label_user_mail_option_all), 'all' ], [ l(:label_user_mail_option_none), 'none' ] ]
                @notification_options.insert(1, [ l(:label_user_mail_option_selected), 'selected' ]) if @user.memberships.length > 1
                @notification_option = @user.mail_notification? ? 'all' : (@user.notified_projects_ids.empty? ? 'none' : 'selected')
            end
        end

    end

end
