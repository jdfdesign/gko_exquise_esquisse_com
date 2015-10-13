# This migration comes from gko_core (originally 20130621151100)
class RenamePartnersUrlToLink < ActiveRecord::Migration
  def change
    rename_column :partners, :url, :link if column_exists?(:partners, :url)
  end
end