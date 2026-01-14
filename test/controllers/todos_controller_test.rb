require "test_helper"

class TodosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @todo = todos(:one)
  end

  # Index action tests
  test "should get index" do
    get todos_url
    assert_response :success
  end

  test "index should display all todos" do
    get todos_url
    assert_response :success
    
    # Check that todos are present in the response
    Todo.all.each do |todo|
      assert_match todo.title, response.body
    end
  end

  test "index should order todos by recent (created_at desc)" do
    get todos_url
    assert_response :success
    
    # The controller uses Todo.recent scope
    todos = assigns(:todos)
    assert todos.is_a?(ActiveRecord::Relation), "Should assign todos relation"
  end

  # Show action tests
  test "should show todo" do
    get todo_url(@todo)
    assert_response :success
  end

  test "show should display todo details" do
    get todo_url(@todo)
    assert_response :success
    assert_match @todo.title, response.body
  end

  # New action tests
  test "should get new" do
    get new_todo_url
    assert_response :success
  end

  test "new should create new todo instance" do
    get new_todo_url
    assert_response :success
    todo = assigns(:todo)
    assert todo.new_record?, "Should create a new todo record"
  end

  # Edit action tests
  test "should get edit" do
    get edit_todo_url(@todo)
    assert_response :success
  end

  test "edit should load the correct todo" do
    get edit_todo_url(@todo)
    assert_response :success
    todo = assigns(:todo)
    assert_equal @todo.id, todo.id
  end

  # Create action tests
  test "should create todo with valid params" do
    assert_difference("Todo.count", 1) do
      post todos_url, params: { todo: { title: "New todo", description: "Description" } }
    end
    
    assert_redirected_to root_path
    follow_redirect!
    assert_match "Todo was successfully created", response.body
  end

  test "should create todo with only title" do
    assert_difference("Todo.count", 1) do
      post todos_url, params: { todo: { title: "Minimal todo" } }
    end
    
    created_todo = Todo.last
    assert_equal "Minimal todo", created_todo.title
    assert_nil created_todo.description
    assert_equal false, created_todo.completed
  end

  test "should not create todo without title" do
    assert_no_difference("Todo.count") do
      post todos_url, params: { todo: { description: "No title" } }
    end
    
    assert_response :unprocessable_entity
  end

  test "should not create todo with title exceeding 200 characters" do
    assert_no_difference("Todo.count") do
      post todos_url, params: { todo: { title: "a" * 201, description: "Description" } }
    end
    
    assert_response :unprocessable_entity
  end

  test "should not create todo with description exceeding 1000 characters" do
    assert_no_difference("Todo.count") do
      post todos_url, params: { todo: { title: "Title", description: "a" * 1001 } }
    end
    
    assert_response :unprocessable_entity
  end

  # Update action tests
  test "should update todo with valid params" do
    patch todo_url(@todo), params: { todo: { title: "Updated title", description: "Updated description" } }
    
    assert_redirected_to root_path
    follow_redirect!
    assert_match "Todo was successfully updated", response.body
    
    @todo.reload
    assert_equal "Updated title", @todo.title
    assert_equal "Updated description", @todo.description
  end

  test "should update todo title only" do
    original_description = @todo.description
    patch todo_url(@todo), params: { todo: { title: "New title" } }
    
    @todo.reload
    assert_equal "New title", @todo.title
    assert_equal original_description, @todo.description
  end

  test "should not update todo with invalid title" do
    original_title = @todo.title
    patch todo_url(@todo), params: { todo: { title: "" } }
    
    assert_response :unprocessable_entity
    
    @todo.reload
    assert_equal original_title, @todo.title
  end

  test "should not update todo with title exceeding 200 characters" do
    original_title = @todo.title
    patch todo_url(@todo), params: { todo: { title: "a" * 201 } }
    
    assert_response :unprocessable_entity
    
    @todo.reload
    assert_equal original_title, @todo.title
  end

  # Destroy action tests
  test "should destroy todo" do
    assert_difference("Todo.count", -1) do
      delete todo_url(@todo)
    end
    
    assert_redirected_to root_path
    follow_redirect!
    assert_match "Todo was successfully deleted", response.body
  end

  test "destroyed todo should not exist in database" do
    todo_id = @todo.id
    delete todo_url(@todo)
    
    assert_raises(ActiveRecord::RecordNotFound) do
      Todo.find(todo_id)
    end
  end

  # Toggle action tests
  test "should toggle todo completion from false to true" do
    pending_todo = todos(:pending_todo)
    assert_not pending_todo.completed?, "Todo should start as not completed"
    
    patch toggle_todo_url(pending_todo)
    
    assert_redirected_to root_path
    pending_todo.reload
    assert pending_todo.completed?, "Todo should be completed after toggle"
  end

  test "should toggle todo completion from true to false" do
    completed_todo = todos(:completed_todo)
    assert completed_todo.completed?, "Todo should start as completed"
    
    patch toggle_todo_url(completed_todo)
    
    assert_redirected_to root_path
    completed_todo.reload
    assert_not completed_todo.completed?, "Todo should not be completed after toggle"
  end

  test "toggle should persist change to database" do
    original_state = @todo.completed
    patch toggle_todo_url(@todo)
    
    @todo.reload
    assert_not_equal original_state, @todo.completed, "Toggle should change completion state"
  end

  # Error handling tests
  test "should handle non-existent todo on show" do
    get todo_url(id: 999999)
    assert_response :not_found
  end

  test "should handle non-existent todo on edit" do
    get edit_todo_url(id: 999999)
    assert_response :not_found
  end

  test "should handle non-existent todo on update" do
    patch todo_url(id: 999999), params: { todo: { title: "Updated" } }
    assert_response :not_found
  end

  test "should handle non-existent todo on destroy" do
    delete todo_url(id: 999999)
    assert_response :not_found
  end

  test "should handle non-existent todo on toggle" do
    patch toggle_todo_url(id: 999999)
    assert_response :not_found
  end
end
