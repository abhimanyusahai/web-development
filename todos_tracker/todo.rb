require "sinatra"
require "tilt/erubis"
require "sinatra/content_for"
require_relative "sequel_persistence"

configure do
  enable :sessions
  set :sessions_secret, 'secret'
  set :erb, :escape_html => true
end

configure(:development) do
  require "sinatra/reloader"
  also_reload "sequel_persistence.rb"
end

helpers do
  def list_complete?(list)
    list[:total_todos_count] > 0 && list[:remaining_todos_count] == 0
  end

  def list_class(list)
    "complete" if list_complete?(list)
  end

  def sort_lists(lists, &block)
    complete_lists, incomplete_lists = lists.partition { |list| list_complete?(list) }

    incomplete_lists.each { |list| yield list, lists.index(list) }
    complete_lists.each { |list| yield list, lists.index(list) }
  end

  def sort_todos(todos, &block)
    complete_todos, incomplete_todos = todos.partition { |todo| todo[:completed] }

    incomplete_todos.each { |todo| yield todo, todos.index(todo) }
    complete_todos.each { |todo| yield todo, todos.index(todo) }
  end
end

def error_for_list_name(name)
  if !(1..100).cover? name.size
    "List name must be between 1 and 100 characters long"
  elsif @storage.all_lists.any? { |list| list[:name] == name }
    "List name must be unique"
  end
end

def error_for_todo(name)
  if !(1..100).cover? name.size
    "Todo name must be between 1 and 100 characters long"
  end
end

def load_list(index)
  list = @storage.find_list(index)
  return list if list

  session[:error] = "The specified list was not found."
  redirect "/lists"
  #halt
end

before do
  @storage = SequelPersistence.new(logger)
end

get "/" do
  redirect "/lists"
end

get "/lists" do
  @lists = @storage.all_lists.all
  erb :lists
end

get "/lists/new" do
  erb :new_list
end

post "/lists" do
  list_name = params[:list_name].strip
  error = error_for_list_name(list_name)
  if error
    session[:error] = error
    erb :new_list
  else
    @storage.create_new_list(list_name)
    session[:success] = "New list added successfully"
    redirect "/lists"
  end
end

get "/lists/:id" do
  @list_id = params[:id].to_i
  @list = load_list(@list_id)
  @todos = @storage.fetch_todos_for_list(@list_id).all
  erb :list
end

get "/lists/:id/edit" do
  id = params[:id].to_i
  @list = load_list(id)
  erb :edit_list
end

post "/lists/:id" do
  list_name = params[:list_name].strip
  error = error_for_list_name(list_name)
  id = params[:id].to_i
  if error
    session[:error] = error
    erb :edit_list
  else
    @storage.update_list_name(id, list_name)
    session[:success] = "The list has been updated"
    redirect "/lists/#{id}"
  end
end

post "/lists/:id/delete" do
  id = params[:id].to_i
  @storage.delete_list(id)
  if env["HTTP_X_REQUESTED_WITH"] == "XMLHttpRequest"
    "/lists"
  else
    session[:success] = "The list has been deleted."
    redirect "/lists"
  end
end

post "/lists/:list_id/todos" do
  @list_id = params[:list_id].to_i
  @list = load_list(@list_id)
  text = params[:todo].strip

  error = error_for_todo(text)
  if error
    session[:error] = error
    erb :list
  else
    @storage.create_new_todo(@list_id, text)
    session[:success] = "The todo was added successfully"
    redirect "/lists/#{@list_id}"
  end
end

post "/lists/:list_id/todos/:todo_id/delete" do
  list_id = params[:list_id].to_i
  todo_id = params[:todo_id].to_i
  @storage.delete_todo(todo_id)
  if env["HTTP_x_REQUESTED_WITH"] == "XMLHttpRequest"
    status 204
  else
    session[:success] = "The todo has been deleted"
    redirect "/lists/#{list_id}"
  end
end

post "/lists/:list_id/todos/:todo_id" do
  list_id = params[:list_id].to_i
  todo_id = params[:todo_id].to_i
  is_completed = params[:completed] == "true"
  @storage.update_todo_status(todo_id, is_completed)
  session[:success] = "The todo has been updated"
  redirect "/lists/#{list_id}"
end

post "/lists/:list_id/completed" do
  list_id = params[:list_id].to_i
  @storage.mark_all_todos_completed(list_id)
  session[:success] = "All todos have been completed"
  redirect "/lists/#{list_id}"
end
