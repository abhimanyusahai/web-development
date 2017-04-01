require "sequel"

DB = Sequel.connect("postgres://localhost/todos")

class SequelPersistence
  def initialize(logger)
    DB.logger = logger
  end

  def find_list(index)
    all_lists.first(lists__id: index)
  end

  def all_lists
    DB[:lists].left_outer_join(:todos, list_id: :id).
    select do
      [ lists__id,
        lists__name,
        count(todos__id).as(total_todos_count),
        count(nullif(todos__completed, true)).as(remaining_todos_count)
      ]
    end.
    group(:lists__id).
    order(:lists__name)
  end

  def fetch_todos_for_list(list_id)
    DB[:todos].where(list_id: list_id)
  end

  def create_new_list(list_name)
    DB[:lists].insert(name: list_name)
  end

  def delete_list(id)
    DB[:lists].where(id: id).delete
    DB[:todos].where(list_id: id).delete
  end

  def update_list_name(id, new_name)
    DB[:lists].where(id: id).update(name: new_name)
  end

  def create_new_todo(list_id, todo_name)
    DB[:todos].insert(name: todo_name, list_id: list_id)
  end

  def delete_todo(todo_id)
    DB[:todos].where(id: todo_id).delete
  end

  def update_todo_status(todo_id, todo_status)
    DB[:todos].where(id: todo_id).update(completed: todo_status)
  end

  def mark_all_todos_completed(list_id)
    DB[:todos].where(list_id: list_id).update(completed: true)
  end
end
