# This migration comes from gko_categories (originally 20110326888888)
class GkoCategoryGlobalize < ActiveRecord::Migration
  include Globalize::ActiveRecord::Migration
  
  class Category < ActiveRecord::Base
    @translated_fields = {
      :title => :string,
      :body => :text,
      :meta_title => :string,
      :meta_description => :text,
      :slug => :string,
      :path => :string
    }

    def self.translated_fields
      @translated_fields
    end

    translates *@translated_fields.keys
  end

  def up
    Category.reset_column_information
    Category.create_translation_table!(Category.translated_fields, :migrate_data => true)
  end

  def down
    Category.drop_translation_table!
  end
end

