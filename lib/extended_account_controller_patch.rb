require_dependency 'account_controller'

module ExtendedAccountControllerPatch

    def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
            unloadable

            alias_method :open_id_authenticate, :extended_open_id_authenticate
        end
    end

    module ClassMethods
    end

    module InstanceMethods

        OPENID_AX_EMAIL     = 'http://axschema.org/contact/email'
        OPENID_AX_FIRSTNAME = 'http://axschema.org/namePerson/first'
        OPENID_AX_LASTNAME  = 'http://axschema.org/namePerson/last'
        OPENID_AX_LANGUAGE  = 'http://axschema.org/pref/language'

        # Original function
        #def open_id_authenticate(openid_url)
        #    authenticate_with_open_id(openid_url, :required => [ :nickname, :fullname, :email ], :return_to => signin_url) do |result, identity_url, registration|
        #        if result.successful?
        #            user = User.find_or_initialize_by_identity_url(identity_url)
        #            if user.new_record?
        #                redirect_to(home_url) && return unless Setting.self_registration?
        #
        #                user.login = registration['nickname'] unless registration['nickname'].nil?
        #                user.mail = registration['email'] unless registration['email'].nil?
        #                user.firstname, user.lastname = registration['fullname'].split(' ') unless registration['fullname'].nil?
        #                user.random_password
        #                user.register
        #
        #                case Setting.self_registration
        #                when '1'
        #                    register_by_email_activation(user) do
        #                        onthefly_creation_failed(user)
        #                    end
        #                when '3'
        #                    register_automatically(user) do
        #                        onthefly_creation_failed(user)
        #                    end
        #                else
        #                    register_manually_by_administrator(user) do
        #                        onthefly_creation_failed(user)
        #                    end
        #                end
        #            else
        #                if user.active?
        #                    successful_authentication(user)
        #                else
        #                    account_pending
        #                end
        #            end
        #        end
        #    end
        #end

        def extended_open_id_authenticate(openid_url)
            options = [ :nickname, :fullname, :email ]

            # Google OpenID
            options << OPENID_AX_EMAIL     # mail
            options << OPENID_AX_FIRSTNAME # firstname
            options << OPENID_AX_LASTNAME  # lastname
            options << OPENID_AX_LANGUAGE  # language

            authenticate_with_open_id(openid_url, :required => options, :return_to => signin_url) do |result, identity_url, registration|
                if result.successful?
                    user = User.find_or_initialize_by_identity_url(identity_url)
                    if user.new_record?
                        redirect_to(home_url) && return unless Setting.self_registration?

                        if registration[OPENID_AX_EMAIL]
                            user.login = registration[OPENID_AX_EMAIL].first
                            user.mail = registration[OPENID_AX_EMAIL].first
                        else
                            user.login = registration['nickname'] unless registration['nickname'].nil?
                            user.mail = registration['email'] unless registration['email'].nil?
                        end
                        user.firstname, user.lastname = registration['fullname'].split(' ') unless registration['fullname'].nil?
                        if registration[OPENID_AX_FIRSTNAME]
                            user.firstname = registration[OPENID_AX_FIRSTNAME].first
                        end
                        if registration[OPENID_AX_LASTNAME]
                            user.lastname = registration[OPENID_AX_LASTNAME].first
                        end
                        if registration[OPENID_AX_LANGUAGE]
                            lang = registration[OPENID_AX_LANGUAGE].first
                            language = find_language(lang) || find_language(lang.split('-').first)
                            if language
                                user.language = language.to_s
                                set_language_if_valid(language)
                            end
                        end
                        user.random_password
                        user.register
                        user.profile

                        register_automatically(user) do
                            onthefly_creation_failed(user)
                        end
                    else
                        if user.active?
                            successful_authentication(user)
                        else
                            account_pending
                        end
                    end
                end
            end
        end

    end

end
