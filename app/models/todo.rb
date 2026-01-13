class Todo < ApplicationRecord
  # Validations - ensure data integrity
  validates :title, presence: true, length: { minimum: 1, maximum: 200 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  
  # Scopes - for easy querying
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :recent, -> { order(created_at: :desc) }
  
  # Custom methods
  def toggle_completion!
    update(completed: !completed)
  end
  
  def status
    completed? ? "Completed" : "Pending"
  end
end
