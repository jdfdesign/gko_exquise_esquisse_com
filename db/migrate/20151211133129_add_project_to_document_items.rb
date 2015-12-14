class AddProjectToDocumentItems < ActiveRecord::Migration
  def change
    add_column :document_items, :project_id, :integer
    add_index :document_items, :project_id
  end
end
