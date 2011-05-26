class AddUpdatedOn < ActiveRecord::Migration

    def self.up
        add_column :extended_profiles, :updated_on, :datetime, :null => false
    end

    def self.down
        remove_column :extended_profiles, :updated_on
    end

end
