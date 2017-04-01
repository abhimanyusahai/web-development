require "pg"

class DatabasePersistence
  def initialize(logger)
    @db = PG.connect(dbname: "todos")
    @logger = logger
  end

  def query(statement, *params)
    @logger.info "#{statement}: #{params}"
    @db.exec_params(statement, params)
  end

  def find_list(index)
    sql = <<-SQL
      SELECT lists.id, lists.name, COUNT(todos.completed) AS total_todos_count, COUNT(NULLIF(todos.completed, true)) AS remaining_todos_count
      FROM lists LEFT OUTER JOIN todos
      ON lists.id = todos.list_id
      WHERE lists.id = $1
      GROUP BY lists.id
      ORDER BY lists.name;
    SQL
    result = query(sql, index)
    tuple = result.first
    list_id = tuple["id"].to_i
    todos = fetch_todos_for_list(list_id)
    tuple_to_list_hash(tuple)
  end

  def all_lists
    sql = <<-SQL
      SELECT lists.id, lists.name, COUNT(todos.completed) AS total_todos_count, COUNT(NULLIF(todos.completed, true)) AS remaining_todos_count
      FROM lists LEFT OUTER JOIN todos
      ON lists.id = todos.list_id
      GROUP BY lists.id
      ORDER BY lists.name;
    SQL
    result = query(sql)
    result.map do |tuple|
      tuple_to_list_hash(tuple)
    end
  end

  def fetch_todos_for_list(list_id)
    sql = "SELECT * FROM todos WHERE list_id = $1"
    result = query(sql, list_id)
    result.map do |tuple|
      {id: tuple["id"].to_i,
       name: tuple["name"],
       completed: tuple["completed"] == "t"
      }
    end
  end

  def create_new_list(list_name)
    sql = "INSERT INTO lists (name) VALUES ($1)"
    query(sql, list_name)
  end

  def delete_list(id)
    sql_delete_list = "DELETE FROM lists WHERE id = $1"
    sql_delete_todos = "DELETE FROM todos WHERE list_id = $1"
    query(sql_delete_todos, id)
    query(sql_delete_list, id)
  end

  def update_list_name(id, new_name)
    sql = "UPDATE lists SET name = $1 WHERE id = $2"
    query(sql, new_name, id)
  end

  def create_new_todo(list_id, todo_name)
    sql = "INSERT INTO todos (list_id, name) VALUES ($1, $2)"
    query(sql, list_id, todo_name)
  end

  def delete_todo(todo_id)
    sql = "DELETE FROM todos WHERE id = $1"
    query(sql, todo_id)
  end

  def update_todo_status(todo_id, todo_status)
    sql = "UPDATE todos SET completed = $1 WHERE id = $2"
    query(sql, todo_status, todo_id)
  end

  def mark_all_todos_completed(list_id)
    sql = "UPDATE todos SET completed = true WHERE list_id = $1"
    query(sql, list_id)
  end

  private

  def tuple_to_list_hash(tuple)
    { id: tuple["id"].to_i,
      name: tuple["name"],
      total_todos_count: tuple["total_todos_count"].to_i,
      remaining_todos_count: tuple["remaining_todos_count"].to_i
    }
  end

end
