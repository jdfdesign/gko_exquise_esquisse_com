# This migration comes from gko_core (originally 20110326000000)
class GkoCoreGlobalize < ActiveRecord::Migration 
  include Globalize::ActiveRecord::Migration

  class Site < ActiveRecord::Base
    @translated_fields = {
      :meta_title => :string,
      :title => :string,
      :subtitle => :string
    }

    def self.translated_fields
      @translated_fields
    end

    translates *@translated_fields.keys
  end

  class Section < ActiveRecord::Base
    @translated_fields = {
      :title => :string,
      :body => :text,
      :meta_title => :string,
      :meta_description => :text,
      :slug => :string,
      :path => :string,
      :redirect_url => :string,
      :menu_title => :string
    }

    def self.translated_fields
      @translated_fields
    end

    translates *@translated_fields.keys
  end 


  class Content < ActiveRecord::Base
    @translated_fields = {
      :title => :string,
      :body => :text,
      :meta_title => :string,
      :meta_description => :text,
      :slug => :string
    }

    def self.translated_fields
      @translated_fields
    end

    translates *@translated_fields.keys
  end
  
  def up
    unless table_exists?(:site_translations)
      Site.reset_column_information
      Site.create_translation_table!(Site.translated_fields, :migrate_data => true)
    end
    unless column_exists?(:sections, :menu_title)
      add_column :sections, :menu_title, :string
    end
    unless table_exists?(:section_translations)
      Section.reset_column_information
      Section.create_translation_table!(Section.translated_fields, :migrate_data => true)
    end
    unless table_exists?(:content_translations)
      Content.reset_column_information
      Content.create_translation_table!(Content.translated_fields, :migrate_data => true)
    end
  end

  def down
    Site.drop_translation_table! :migrate_data => true if table_exists?(:site_translations)
    Section.drop_translation_table! :migrate_data => true if table_exists?(:section_translations)
    Content.drop_translation_table! :migrate_data => true if table_exists?(:content_translations)
  end
end
