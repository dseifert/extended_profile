class CreateExtendedProfiles < ActiveRecord::Migration

    def self.up
        create_table :extended_profiles do |t|
            t.column :user_id,       :integer, :null => false
            t.column :company,       :string, :limit => 60
            t.column :company_site,  :string, :limit => 120
            t.column :position,      :string, :limit => 60
            t.column :project_id,    :integer
            t.column :personal_site, :string, :limit => 120
            t.column :blog,          :string, :limit => 120
            t.column :facebook,      :string, :limit => 60
            t.column :twitter,       :string, :limit => 60
            t.column :linkedin,      :string, :limit => 120
        end
        add_index :extended_profiles, [:user_id], :name => :extended_profiles_user_id
    end

    def self.down
        drop_table :extended_profiles
    end

end
