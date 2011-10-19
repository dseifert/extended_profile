require 'redmine'
require 'dispatcher'

require_dependency 'principal'
require_dependency 'user'

require_dependency 'profile_hook'

RAILS_DEFAULT_LOGGER.info 'Starting Extended Profile plugin for Redmine'

Dispatcher.to_prepare :extended_profile_plugin do
    unless User.included_modules.include?(ExtendedUserPatch)
        User.send(:include, ExtendedUserPatch)
    end
    unless MyController.included_modules.include?(MyExtendedControllerPatch)
        MyController.send(:include, MyExtendedControllerPatch)
    end
    unless UsersController.included_modules.include?(ExtendedUsersControllerPatch)
        UsersController.send(:include, ExtendedUsersControllerPatch)
    end
    unless AccountController.included_modules.include?(ExtendedAccountControllerPatch)
        AccountController.send(:include, ExtendedAccountControllerPatch)
    end
end

Redmine::Plugin.register :extended_profile_plugin do
    name 'Extended profile'
    author 'Andriy Lesyuk'
    author_url 'http://www.andriylesyuk.com'
    description 'Adds many new fields to user profile.'
    url 'http://projects.andriylesyuk.com/projects/redmine-profile'
    version '0.0.3'

    settings :default => { :require_project => true }, :partial => 'settings/profile'
end
