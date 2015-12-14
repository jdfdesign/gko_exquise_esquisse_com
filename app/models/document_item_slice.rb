DocumentItem.class_eval do
  belongs_to :project
  attr_accessible :project_id
  validates :project_id, :presence => true
end