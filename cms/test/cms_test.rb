ENV["RACK_ENV"] = "test"

require "minitest/autorun"
require "rack/test"

require_relative "../cms"

class CMSTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_index
    get "/"

    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "history.txt"
    assert_includes last_response.body, "about.txt"
    assert_includes last_response.body, "changes.txt"
  end

  # def test_history
  #   get "/history.txt"
  #   assert_equal 200, last_response.status
  #   assert_equal "text/html; charset=utf-8", last_response["Content-Type"]
  #   assert_equal "", last_response.body
  # end
  #
  # def test_about
  #   get "/about.txt"
  #   assert_equal 200, last_response.status
  #   assert_equal "text/html; charset=utf-8", last_response["Content-Type"]
  #   assert_equal "", last_response.body
  # end
  #
  # def test_changes
  #   get "/changes.txt"
  #   assert_equal 200, last_response.status
  #   assert_equal "text/html; charset=utf-8", last_response["Content-Type"]
  #   assert_equal "", last_response.body
  # end
end