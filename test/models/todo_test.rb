require "test_helper"

class TodoTest < ActiveSupport::TestCase
  # Validation tests
  test "should not save todo without title" do
    todo = Todo.new(description: "Test description")
    assert_not todo.save, "Saved the todo without a title"
  end

  test "should save valid todo" do
    todo = Todo.new(title: "Valid title", description: "Valid description")
    assert todo.save, "Failed to save a valid todo"
  end

  test "title should not be empty" do
    todo = Todo.new(title: "", description: "Test description")
    assert_not todo.valid?, "Todo is valid with empty title"
    assert_includes todo.errors[:title], "can't be blank"
  end

  test "title should not exceed 200 characters" do
    todo = Todo.new(title: "a" * 201, description: "Test description")
    assert_not todo.valid?, "Todo is valid with title exceeding 200 characters"
  end

  test "title should accept 200 characters" do
    todo = Todo.new(title: "a" * 200, description: "Test description")
    assert todo.valid?, "Todo is not valid with title of 200 characters"
  end

  test "description should not exceed 1000 characters" do
    todo = Todo.new(title: "Test title", description: "a" * 1001)
    assert_not todo.valid?, "Todo is valid with description exceeding 1000 characters"
  end

  test "description should accept 1000 characters" do
    todo = Todo.new(title: "Test title", description: "a" * 1000)
    assert todo.valid?, "Todo is not valid with description of 1000 characters"
  end

  test "description can be blank" do
    todo = Todo.new(title: "Test title", description: "")
    assert todo.valid?, "Todo is not valid with blank description"
  end

  test "description can be nil" do
    todo = Todo.new(title: "Test title", description: nil)
    assert todo.valid?, "Todo is not valid with nil description"
  end

  test "completed should default to false" do
    todo = Todo.create(title: "Test title")
    assert_equal false, todo.completed, "New todo should default to not completed"
  end

  # Scope tests
  test "completed scope returns only completed todos" do
    completed_count = Todo.completed.count
    assert_operator completed_count, :>, 0, "Should have completed todos in fixtures"
    
    Todo.completed.each do |todo|
      assert todo.completed?, "Completed scope returned incomplete todo"
    end
  end

  test "pending scope returns only pending todos" do
    pending_count = Todo.pending.count
    assert_operator pending_count, :>, 0, "Should have pending todos in fixtures"
    
    Todo.pending.each do |todo|
      assert_not todo.completed?, "Pending scope returned completed todo"
    end
  end

  test "recent scope orders by created_at descending" do
    todos = Todo.recent.to_a
    assert_operator todos.size, :>, 1, "Should have multiple todos to test ordering"
    
    # Check that each todo's created_at is >= the next one's
    todos.each_cons(2) do |current, following|
      assert_operator current.created_at, :>=, following.created_at,
        "Recent scope did not order todos by created_at descending"
    end
  end

  # Custom method tests
  test "toggle_completion! changes completed from false to true" do
    todo = todos(:pending_todo)
    assert_not todo.completed?, "Starting todo should not be completed"
    
    todo.toggle_completion!
    assert todo.completed?, "Todo should be completed after toggle"
  end

  test "toggle_completion! changes completed from true to false" do
    todo = todos(:completed_todo)
    assert todo.completed?, "Starting todo should be completed"
    
    todo.toggle_completion!
    assert_not todo.completed?, "Todo should not be completed after toggle"
  end

  test "toggle_completion! persists the change" do
    todo = todos(:pending_todo)
    original_state = todo.completed
    
    todo.toggle_completion!
    todo.reload
    
    assert_not_equal original_state, todo.completed, "Toggle should persist to database"
  end

  test "status returns 'Completed' for completed todo" do
    todo = todos(:completed_todo)
    assert_equal "Completed", todo.status, "Status should be 'Completed' for completed todo"
  end

  test "status returns 'Pending' for pending todo" do
    todo = todos(:pending_todo)
    assert_equal "Pending", todo.status, "Status should be 'Pending' for pending todo"
  end

  test "status updates after toggle" do
    todo = todos(:pending_todo)
    assert_equal "Pending", todo.status
    
    todo.toggle_completion!
    assert_equal "Completed", todo.status
  end
end
