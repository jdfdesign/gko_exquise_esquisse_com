# This migration comes from gko_stickers (originally 20110419175909)
class GkoStickersTranslate < ActiveRecord::Migration
  include Globalize::ActiveRecord::Migration
  
  class Sticker < ActiveRecord::Base
    @translated_fields = {
      :name => :string
    }

    def self.translated_fields
      @translated_fields
    end

    translates *@translated_fields.keys
  end

  def up
    Sticker.reset_column_information
    Sticker.create_translation_table!(Sticker.translated_fields, :migrate_data => true)
  end

  def down
    Sticker.drop_translation_table!
  end
end