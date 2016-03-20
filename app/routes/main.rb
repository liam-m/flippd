require 'json'
require 'open-uri'

class Flippd < Sinatra::Application

  # Store the JSON and Individual Phases
  attr_accessor :module
  attr_accessor :phases

  before do
    JsonParser.parse( self )
    Badge.populate
  end

  # On requesting the home page, display the title page in the data repo.
  get '/' do
    erb open( ENV[ 'CONFIG_URL' ] + "index.erb" ).read
  end

end
