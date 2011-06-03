require_dependency 'users_controller'

module ExtendedUsersControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method :add, :extended_add # Redmine 1.0.x
            alias_method :edit, :extended_edit if Redmine::VERSION::MAJOR == 1 && Redmine::VERSION::MINOR == 0 # Redmine 1.0.x

            alias_method :create, :extended_create
            alias_method :update, :extended_update
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        # Original function
        #def create
        #    @user = User.new(:language => Setting.default_language, :mail_notification => Setting.default_notification_option)
        #    @user.safe_attributes = params[:user]
        #    @user.admin = params[:user][:admin] || false
        #    @user.login = params[:user][:login]
        #    @user.password, @user.password_confirmation = params[:user][:password], params[:user][:password_confirmation] unless @user.auth_source_id
        #
        #    @user.pref.attributes = params[:pref]
        #    @user.pref[:no_self_notified] = (params[:no_self_notified] == '1')
        #
        #    if @user.save
        #        @user.pref.save
        #        @user.notified_project_ids = (@user.mail_notification == 'selected' ? params[:notified_project_ids] : [])
        #
        #        Mailer.deliver_account_information(@user, params[:user][:password]) if params[:send_information]
        #
        #        respond_to do |format|
        #            format.html {
        #                flash[:notice] = l(:notice_successful_create)
        #                redirect_to(params[:continue] ? 
        #                    {:controller => 'users', :action => 'new'} :
        #                    {:controller => 'users', :action => 'edit', :id => @user}
        #                )
        #            }
        #            format.api  { render :action => 'show', :status => :created, :location => user_url(@user) }
        #        end
        #    else
        #        @auth_sources = AuthSource.find(:all)
        #        @user.password = @user.password_confirmation = nil
        #
        #        respond_to do |format|
        #            format.html { render :action => 'new' }
        #            format.api  { render_validation_errors(@user) }
        #        end
        #    end
        #end

        def extended_create
            @user = User.new(:language => Setting.default_language, :mail_notification => Setting.default_notification_option)
            @user.safe_attributes = params[:user]
            @user.admin = params[:user][:admin] || false
            @user.login = params[:user][:login]
            @user.password, @user.password_confirmation = params[:user][:password], params[:user][:password_confirmation] unless @user.auth_source_id
            @user.pref.attributes = params[:pref]
            @user.pref[:no_self_notified] = (params[:no_self_notified] == '1')
            @user.profile.attributes = params[:profile]
            if (@user.valid? & @user.valid_profile?) && @user.save
                @user.pref.save
                @user.profile.save
                @user.notified_project_ids = (@user.mail_notification == 'selected' ? params[:notified_project_ids] : [])
                Mailer.deliver_account_information(@user, params[:user][:password]) if params[:send_information]
                respond_to do |format|
                    format.html {
                        flash[:notice] = l(:notice_successful_create)
                        redirect_to(params[:continue] ?
                            { :controller => 'users', :action => 'new' } :
                            { :controller => 'users', :action => 'edit', :id => @user })
                    }
                    format.api { render(:action => 'show', :status => :created, :location => user_url(@user)) }
                end
            else
                @auth_sources = AuthSource.find(:all)
                @user.password = @user.password_confirmation = nil
                respond_to do |format|
                    format.html { render(:action => 'new') }
                    format.api { render_validation_errors(@user) }
                end
            end
        end

        # Original function for Redmine 1.0.x
        #def add
        #    if request.get?
        #        @user = User.new(:language => Setting.default_language)
        #    else
        #        @user = User.new(params[:user])
        #        @user.admin = params[:user][:admin] || false
        #        @user.login = params[:user][:login]
        #        @user.password, @user.password_confirmation = params[:password], params[:password_confirmation] unless @user.auth_source_id
        #        if @user.save
        #            Mailer.deliver_account_information(@user, params[:password]) if params[:send_information]
        #            flash[:notice] = l(:notice_successful_create)
        #            redirect_to(params[:continue] ? { :controller => 'users', :action => 'add' } :
        #                                            { :controller => 'users', :action => 'edit', :id => @user })
        #            return
        #        end
        #    end
        #    @auth_sources = AuthSource.find(:all)
        #end

        def extended_add # Redmine 1.0.x
            if request.get?
                @user = User.new(:language => Setting.default_language)
            else
                @user = User.new(params[:user])
                @user.admin = params[:user][:admin] || false
                @user.login = params[:user][:login]
                @user.password, @user.password_confirmation = params[:password], params[:password_confirmation] unless @user.auth_source_id
                @user.profile.attributes = params[:profile]
                if (@user.valid? & @user.valid_profile?) && @user.save
                    @user.profile.save
                    Mailer.deliver_account_information(@user, params[:password]) if params[:send_information]
                    flash[:notice] = l(:notice_successful_create)
                    redirect_to(params[:continue] ?
                        { :controller => 'users', :action => 'add' } :
                        { :controller => 'users', :action => 'edit', :id => @user })
                    return
                end
            end
            @auth_sources = AuthSource.find(:all)
        end

        # Original function
        #def update
        #    @user.admin = params[:user][:admin] if params[:user][:admin]
        #    @user.login = params[:user][:login] if params[:user][:login]
        #    if params[:user][:password].present? && (@user.auth_source_id.nil? || params[:user][:auth_source_id].blank?)
        #        @user.password, @user.password_confirmation = params[:user][:password], params[:user][:password_confirmation]
        #    end
        #    @user.safe_attributes = params[:user]
        #    was_activated = (@user.status_change == [User::STATUS_REGISTERED, User::STATUS_ACTIVE])
        #    @user.pref.attributes = params[:pref]
        #    @user.pref[:no_self_notified] = (params[:no_self_notified] == '1')
        #
        #    if @user.save
        #        @user.pref.save
        #        @user.notified_project_ids = (@user.mail_notification == 'selected' ? params[:notified_project_ids] : [])
        #
        #        if was_activated
        #            Mailer.deliver_account_activated(@user)
        #        elsif @user.active? && params[:send_information] && !params[:user][:password].blank? && @user.auth_source_id.nil?
        #            Mailer.deliver_account_information(@user, params[:user][:password])
        #        end
        #
        #        respond_to do |format|
        #            format.html {
        #                flash[:notice] = l(:notice_successful_update)
        #                redirect_to :back
        #            }
        #            format.api  { head :ok }
        #        end
        #    else
        #        @auth_sources = AuthSource.find(:all)
        #        @membership ||= Member.new
        #        @user.password = @user.password_confirmation = nil
        #
        #        respond_to do |format|
        #            format.html { render :action => :edit }
        #            format.api  { render_validation_errors(@user) }
        #        end
        #    end
        #rescue ::ActionController::RedirectBackError
        #    redirect_to :controller => 'users', :action => 'edit', :id => @user
        #end

        def extended_update
            @user.admin = params[:user][:admin] if params[:user][:admin]
            @user.login = params[:user][:login] if params[:user][:login]
            if params[:user][:password].present? && (@user.auth_source_id.nil? || params[:user][:auth_source_id].blank?)
                @user.password, @user.password_confirmation = params[:user][:password], params[:user][:password_confirmation]
            end
            @user.safe_attributes = params[:user]
            was_activated = (@user.status_change == [ User::STATUS_REGISTERED, User::STATUS_ACTIVE ])
            @user.pref.attributes = params[:pref]
            @user.profile.attributes = params[:profile]
            @user.pref[:no_self_notified] = (params[:no_self_notified] == '1')
            if (@user.valid? & @user.valid_profile?) && @user.save
                @user.pref.save
                @user.profile.save
                @user.notified_project_ids = (@user.mail_notification == 'selected' ? params[:notified_project_ids] : [])
                if was_activated
                    Mailer.deliver_account_activated(@user)
                elsif @user.active? && params[:send_information] && !params[:user][:password].blank? && @user.auth_source_id.nil?
                    Mailer.deliver_account_information(@user, params[:user][:password])
                end
                respond_to do |format|
                    format.html {
                        flash[:notice] = l(:notice_successful_update)
                        redirect_to(:back)
                    }
                    format.api { head :ok }
                end
            else
                @auth_sources = AuthSource.find(:all)
                @membership ||= Member.new
                @user.password = @user.password_confirmation = nil
                respond_to do |format|
                    format.html { render(:action => :edit) }
                    format.api { render_validation_errors(@user) }
                end
            end
        rescue ::ActionController::RedirectBackError
            redirect_to(:controller => 'users', :action => 'edit', :id => @user)
        end

        # Original function for Redmine 1.0.x
        #def edit
        #    @user = User.find(params[:id])
        #    if request.post?
        #        @user.admin = params[:user][:admin] if params[:user][:admin]
        #        @user.login = params[:user][:login] if params[:user][:login]
        #        @user.password, @user.password_confirmation = params[:password], params[:password_confirmation] unless params[:password].nil? or params[:password].empty? or @user.auth_source_id
        #        @user.group_ids = params[:user][:group_ids] if params[:user][:group_ids]
        #        @user.attributes = params[:user]
        #        was_activated = (@user.status_change == [User::STATUS_REGISTERED, User::STATUS_ACTIVE])
        #        if @user.save
        #            if was_activated
        #                Mailer.deliver_account_activated(@user)
        #            elsif @user.active? && params[:send_information] && !params[:password].blank? && @user.auth_source_id.nil?
        #                Mailer.deliver_account_information(@user, params[:password])
        #            end
        #            flash[:notice] = l(:notice_successful_update)
        #            redirect_to :back
        #        end
        #    end
        #    @auth_sources = AuthSource.find(:all)
        #    @membership ||= Member.new
        #rescue ::ActionController::RedirectBackError
        #    redirect_to :controller => 'users', :action => 'edit', :id => @user
        #end

        def extended_edit # Redmine 1.0.x
            @user = User.find(params[:id])
            if request.post?
                @user.admin = params[:user][:admin] if params[:user][:admin]
                @user.login = params[:user][:login] if params[:user][:login]
                @user.password, @user.password_confirmation = params[:password], params[:password_confirmation] unless params[:password].nil? || params[:password].empty? || @user.auth_source_id
                @user.group_ids = params[:user][:group_ids] if params[:user][:group_ids]
                @user.attributes = params[:user]
                @user.profile.attributes = params[:profile]
                was_activated = (@user.status_change == [ User::STATUS_REGISTERED, User::STATUS_ACTIVE ])
                if (@user.valid? & @user.valid_profile?) && @user.save
                    @user.profile.save
                    if was_activated
                        Mailer.deliver_account_activated(@user)
                    elsif @user.active? && params[:send_information] && !params[:password].blank? && @user.auth_source_id.nil?
                        Mailer.deliver_account_information(@user, params[:password])
                    end
                    flash[:notice] = l(:notice_successful_update)
                    redirect_to(:back)
                end
            end
            @auth_sources = AuthSource.find(:all)
            @membership ||= Member.new
        rescue ::ActionController::RedirectBackError
            redirect_to(:controller => 'users', :action => 'edit', :id => @user)
        end

    end

end
