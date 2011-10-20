class ExtendedProfile < ActiveRecord::Base
    belongs_to :user

    validates_presence_of :user
    validates_presence_of :project_id, :if => Proc.new { Setting.plugin_extended_profile_plugin[:require_project] }
    validates_uniqueness_of :user_id
    validates_format_of :company_site, :with => /^(http|https):\/\//i, :if => Proc.new { |profile| !profile.company_site.blank? }
    validates_format_of :personal_site, :with => /^(http|https):\/\//i, :if => Proc.new { |profile| !profile.personal_site.blank? }
    validates_format_of :blog, :with => /^(http|https):\/\//i, :if => Proc.new { |profile| !profile.blog.blank? }
    validates_format_of :facebook, :with => /^([0-9]+|[a-z0-9.]+)$/i, :if => Proc.new { |profile| !profile.facebook.blank? }
    validates_format_of :twitter, :with => /^[a-z0-9_]+$/i, :if => Proc.new { |profile| !profile.twitter.blank? }
    validates_format_of :linkedin, :with => /^(http|https):\/\//i, :if => Proc.new { |profile| !profile.linkedin.blank? }

    def personal_id=(arg)
        if arg.empty?
            arg = nil
        end
        write_attribute(:personal_id, arg)
    end

    def company_site=(arg)
        if arg.empty? || arg == 'http://'
            arg = nil
        end
        write_attribute(:company_site, arg)
    end

    def personal_site=(arg)
        if arg.empty? || arg == 'http://'
            arg = nil
        end
        write_attribute(:personal_site, arg)
    end

    def blog=(arg)
        if arg.empty? || arg == 'http://'
            arg = nil
        end
        write_attribute(:blog, arg)
    end

    def linkedin=(arg)
        if arg.empty? || arg == 'http://'
            arg = nil
        end
        write_attribute(:linkedin, arg)
    end

end
