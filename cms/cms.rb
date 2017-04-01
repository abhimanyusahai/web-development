require 'sinatra'
require 'sinatra/reloader'
require 'tilt/erubis'
require 'redcarpet'
require 'yaml'

configure do
  enable :sessions
  set :sessions_secret, 'secret'
end

before do
  @files = Dir.glob("data/*").map do |file_path|
    File.basename(file_path)
  end
  @users = YAML.load_file("users.yml")
end

def signedin?(session)
  !!session[:username]
end

def redirect_unsignedin(session)
  if !signedin?(session)
    session[:message] = "You must sign in to perform this action."
    redirect "/"
  end
end

helpers do
  def render_markdown(text)
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    markdown.render(text)
  end
end

get "/" do
  @username = session[:username]
  if !@username
    redirect "/users/signin"
  else
    erb :index
  end
end

get "/users/signin" do
  erb :signin
end

post "/users/signin" do
  if @users.keys.include?(params[:username]) && @users[params[:username]] == params[:password]
    session[:username] = params[:username]
    session[:message] = "Welcome!"
    redirect "/"
  else
    session[:message] = "Invalid Credentials"
    redirect "/users/signin"
  end
end

post "/users/signout" do
  session.delete(:username)
  session[:message] = "You have been signed out."
  redirect "/"
end

get "/new" do
  redirect_unsignedin(session)
  erb :new
end

post "/new" do
  redirect_unsignedin(session)
  if params[:filename].empty?
    session[:message] = "A name is required"
    redirect "/new"
  else
    File.write("data/#{params[:filename]}","")
    session[:message] = "#{params[:filename]} has been created."
    redirect "/"
  end
end

get "/:filename" do
  if !File.exist?("data/#{params[:filename]}")
    session[:message] = "#{params[:filename]} does not exist"
    redirect "/"
  elsif params[:filename].split(".")[1] == "md"
    erb render_markdown(File.read("data/#{params[:filename]}"))
  else
    headers["Content-Type"] = "text/plain"
    File.read("data/#{params[:filename]}")
  end
end

get "/:filename/edit" do
  redirect_unsignedin(session)
  @filename = params[:filename]
  @content = File.read("data/#{@filename}")

  erb :edit
end

post "/:filename" do
  redirect_unsignedin(session)
  @filename = params[:filename]
  File.write("data/#{@filename}", params[:content])

  session[:message] = "#{@filename} has been updated."
  redirect "/"
end

get "/:filename/delete" do
  redirect_unsignedin(session)
  @filename = params[:filename]
  File.delete("data/#{@filename}")
  session[:message] = "#{@filename} has been deleted"
  redirect "/"
end