# This migration comes from gko_core (originally 20110311000000)
class GkoCoreCreate < ActiveRecord::Migration
  def self.up

    unless table_exists?(:accounts)
      create_table :accounts do |t|
        t.string :reference, :limit => 40
        t.string :nickname
        t.string :status, :limit => 40
        t.string :type, :limit => 40
        t.datetime :deleted_at
        t.datetime :expires_at
        t.timestamps
      end
    end
    unless table_exists?(:sites)
      create_table :sites do |t|
        t.references :account
        t.string :host
        t.string :title
        t.string :meta_title
        t.string :subtitle
        t.string :timezone
        t.string :locales, :limit => 17
        t.boolean :public, :default => true
        t.text :options
        t.timestamps
      end
      add_index :sites, :host, :unique => :true
    end
    unless table_exists?(:settings)
      create_table :settings do |t|
        t.references :site
        t.string :name
        t.text :value
        t.boolean :destroyable, :default => true
        t.string :scoping
        t.boolean :restricted, :default => false
        t.string :callback_proc_as_string
        t.string :form_value_type, :default => 'text_area', :null => false
        t.timestamps
      end
      add_index :settings, :name
      add_index :settings, :site_id
    end
    unless table_exists?(:dynamic_files)
      create_table :dynamic_files do |t|
        t.references :site
        t.string :type
        t.string :file_type
        t.string :name
        t.string :format
        t.string :handler
        t.text :body
        t.timestamps
      end
      add_index :dynamic_files, :name
    end
    create_table "image_assignments", :force => true do |t|
      t.integer  "position",                      :default => 1, :null => false
      t.integer  "image_id",                                     :null => false
      t.integer  "attachable_id",                                :null => false
      t.string   "attachable_type", :limit => 40,                :null => false
      t.datetime "created_at",                                   :null => false
      t.datetime "updated_at",                                   :null => false
    end

    add_index "image_assignments", ["attachable_id", "attachable_type"], :name => "index_image_assignments_on_attachable_id_and_attachable_type"

    create_table "image_folders", :force => true do |t|
      t.string   "name"
      t.integer  "site_id"
      t.integer  "parent_id"
      t.integer  "lft"
      t.integer  "rgt"
      t.integer  "level"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    create_table "image_folders_images", :id => false, :force => true do |t|
      t.integer  "image_folder_id"
      t.integer  "image_id"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
    end

    add_index "image_folders_images", ["image_folder_id", "image_id"], :name => "index_image_folders_images_on_image_folder_id_and_image_id"
    add_index "image_folders_images", ["image_id", "image_folder_id"], :name => "index_image_folders_images_on_image_id_and_image_folder_id"

    create_table "images", :force => true do |t|
      t.integer  "site_id"
      t.integer  "image_assignments_count", :default => 0
      t.datetime "created_at",                             :null => false
      t.datetime "updated_at",                             :null => false
      t.string   "image_mime_type"
      t.string   "image_name"
      t.integer  "image_size"
      t.integer  "image_width"
      t.integer  "image_height"
      t.string   "image_uid"
    end
    unless table_exists?(:sections)
      create_table :sections do |t|
        t.references :site
        t.references :parent
        t.references :link, :polymorphic => true

        t.integer :lft
        t.integer :rgt
        t.string :type
        t.string :name
        t.string :slug
        t.string :path
        t.integer :level
        t.text :options

        t.string :title
        t.string :layout
        t.text :body
        t.string :meta_title
        t.text :meta_description
        t.string :redirect_url
        t.string :title_addon
        t.datetime :published_at

        t.boolean :hidden, :default => false
        t.timestamps
      end
      add_index :sections, [:link_id, :link_type]
    end
    unless table_exists?(:contents)
      create_table :contents do |t|
        t.references :site
        t.references :section
        t.references :account
        t.references :author
        t.string :type
        t.string :title
        t.string :slug
        t.text :body
        t.datetime :published_at
        t.string :layout, :limit => 40
        t.string :meta_title
        t.text :meta_description
        t.text :options
        t.string :author_name, :limit => 120
        t.timestamps
      end
      add_index :contents, :section_id
      add_index :contents, :site_id
      add_index :contents, :slug
    end
  end

  def self.down
    drop_table :accounts
    drop_table :sites
    drop_table :sections
    drop_table :contents
    drop_table :settings
    drop_table :dynamic_files
  end
end
