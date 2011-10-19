class FixMissingProfile < ActiveRecord::Migration

    def self.up
        settings = Setting.plugin_extended_profile_plugin
        User.find(:all).select{ |user| user.profile.new_record? }.each do |user|
            if settings[:require_project]
                projects = Project.all(:conditions => Project.visible_by(user), :order => 'name')
                unless projects.empty?
                    user.profile.project_id = projects.first.id
                end
            end
            user.profile.save
        end
    end

end
