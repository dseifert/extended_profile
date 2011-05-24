require 'redmine'
require 'dispatcher'
require 'user'

require_dependency 'profile_hook'

RAILS_DEFAULT_LOGGER.info 'Starting Extended Profile plugin for Redmine'

Dispatcher.to_prepare :extended_profile_plugin do
    unless User.included_modules.include?(UserPatch)
        User.send(:include, UserPatch)
    end
    unless MyController.included_modules.include?(MyControllerPatch)
        MyController.send(:include, MyControllerPatch)
    end
    #unless UsersController.included_modules.include?(UsersControllerPatch)
    #    UsersController.send(:include, UsersControllerPatch)
    #end
    #unless AccountController.included_modules.include?(AccountControllerPatch)
    #    AccountController.send(:include, AccountControllerPatch)
    #end
end

Redmine::Plugin.register :extended_profile_plugin do
    name 'Extended profile'
    author 'Andriy Lesyuk'
    author_url 'http://www.andriylesyuk.com'
    description 'Adds many new fields to user profile.'
    url 'http://projects.andriylesyuk.com/projects/redmine-profile'
    version '0.0.2'

    settings :default => { :require_project => true }, :partial => 'settings/profile'
end
