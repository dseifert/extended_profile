class AddIdField < ActiveRecord::Migration

    def self.up
        add_column :extended_profiles, :personal_id, :string
    end

    def self.down
        remove_column :extended_profiles, :personal_id
    end
end
