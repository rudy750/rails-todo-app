class Todo < ApplicationRecord
  # Validations - ensure data integrity
  validates :title, presence: true, length: { minimum: 1, maximum: 200 }
  validates :description, length: { maximum: 1000 }, allow_blank: true
  validate :due_date_must_be_in_future, if: -> { due_date.present? }
  
  # Scopes - for easy querying
  scope :completed, -> { where(completed: true) }
  scope :pending, -> { where(completed: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :due_today, -> { where(due_date: Date.current) }
  scope :due_soon, -> { where(due_date: Date.current..7.days.from_now.to_date) }
  scope :overdue, -> { where("due_date < ? AND completed = ?", Date.current, false) }
  scope :upcoming, -> { where("due_date > ?", Date.current) }
  
  # Custom methods
  def toggle_completion!
    update(completed: !completed)
  end
  
  def status
    completed? ? "Completed" : "Pending"
  end
  
  # Due date helper methods
  def overdue?
    due_date.present? && due_date < Date.current && !completed?
  end
  
  def due_soon?
    due_date.present? && due_date >= Date.current && due_date <= 7.days.from_now.to_date
  end
  
  def due_today?
    due_date.present? && due_date == Date.current
  end
  
  def days_until_due
    return nil unless due_date.present?
    (due_date - Date.current).to_i
  end
  
  private
  
  def due_date_must_be_in_future
    if due_date.present? && due_date < Date.current
      errors.add(:due_date, "cannot be in the past")
    end
  end
end
