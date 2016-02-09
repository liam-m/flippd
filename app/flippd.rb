require 'dotenv'
Dotenv.load

# Load all helpers
helpers_directory = File.dirname(__FILE__) + "/helpers/"
helper_files = Dir[helpers_directory + "*.rb"]
helper_files.each { |f| require f }

require_relative 'db/init'

require 'sinatra'
require 'sinatra/multi_route'
require 'rack-flash'

class Flippd < Sinatra::Application
  register Sinatra::MultiRoute
  use Rack::Session::Cookie, secret: ENV['COOKIE_SECRET']
  use Rack::Flash

  before do
    @version = "0.0.4"
  end
end

require_relative 'routes/init'
