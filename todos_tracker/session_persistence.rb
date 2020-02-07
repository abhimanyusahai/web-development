class SessionPersistence
  def initialize(session)
    @session = session
    @session[:lists] ||= []
  end

  def find_list(index)
    @session[:lists][index] if index
  end

  def all_lists
    @session[:lists]
  end

  def create_new_list(list_name)
    @session[:lists] << {name: list_name, todos: []}
  end

  def delete_list(id)
    @session[:lists].delete_at(id)
  end

  def update_list_name(id, new_name)
    list = find_list(id)
    list[:name] = new_name
  end

  def create_new_todo(list_id, todo_name)
    find_list(list_id)[:todos] << {name: todo_name, completed: false}
  end

  def delete_todo(list_id, todo_id)
    find_list(list_id)[:todos].delete_at(todo_id)
  end

  def update_todo_status(list_id, todo_id, todo_status)
    find_list(list_id)[:todos][todo_id][:completed] = todo_status
  end

  def mark_all_todos_completed(list_id)
    find_list(list_id)[:todos].each { |todo| todo[:completed] = true }
  end
end
