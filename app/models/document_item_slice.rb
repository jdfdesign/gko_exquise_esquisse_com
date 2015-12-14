DocumentItem.class_eval do
  belongs_to :project
  attr_accessible :project_id
end