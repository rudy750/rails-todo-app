class AddDueDateToTodos < ActiveRecord::Migration[6.1]
  def change
    add_column :todos, :due_date, :date, null: true
    add_index :todos, :due_date
  end
end
