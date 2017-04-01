require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  @title = "Chapter #{params[:number]}"
  @chapter = File.read("data/chp#{params[:number]}.txt")
  erb :chapter
end

get "/search" do
  @title = "The Adventures of Sherlock Holmes"

  if params[:query]
    @results = @contents.each_with_index.each_with_object([]) do |(chapter, index), results|
                 text = File.read("data/chp#{index + 1}.txt")
                 paragraphs = text.split("\n\n")
                 paragraphs.each_with_index do |paragraph, paragraph_index|
                   if paragraph.include?(params[:query])
                     results << [chapter, index, paragraph, paragraph_index]
                   end
                 end
               end
  end
  erb :search
end

helpers do
  def in_paragraphs(text)
    text.split("\n\n").each_with_index.map do |line, index|
      "<p id=paragraph#{index}>#{line}</p>"
    end.join
  end

  def highlight_phrase(text,phrase)
    text.gsub(phrase, "<strong>#{phrase}</strong>")
  end
end

not_found do
  redirect "/"
end
