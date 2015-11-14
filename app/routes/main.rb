require 'open-uri'
require 'json'

class Flippd < Sinatra::Application
  before do
    # Load in the configuration (at the URL in the project's .env file)
    @module = JSON.load(open(ENV['CONFIG_URL'] + "module.json"))
    @phases = @module['phases']
    @items = {}
    @urls = {}

    # The configuration doesn't have to include identifiers, so we
    # add an identifier to each phase, video and quiz
    phase_id = 1
    topic_id = 1
    item_id = 1

    # generateIds will generate a URL-safe slug, while also ensuring
    # system uniqueness.
    #
    # Warning!
    # Because url conflict resolution is dependant on order of JSON data,
    # it is not guaranteed that URLs will always point to the correct item.
    # To avoid this, always use unique item names!
    generateIds = Proc.new do |item|
      # Generate Numeric ID
      item["id"] = item_id
      @items[ item_id ] = item
      item_id += 1

      # Generate Unique Slug
      baseUrl = item["title"]
        .downcase
        .gsub( /[^a-z0-9 ]/, "" )
        .gsub( " ", "-" )
      numericSuffix = nil

      loop do
        url = baseUrl + ( numericSuffix or "" ).to_s
        if not @urls[ url ]
          @urls[ url ] = item
          item[ "slug" ] = url
          break
        end

        numericSuffix = ( numericSuffix or 1 ) + 1
      end
    end

    @phases.each do |phase|
      phase["id"] = phase_id
      phase_id += 1

      phase['topics'].each do |topic|
        topic["id"] = topic_id
        topic_id += 1

        topic['videos'].each do |video|
          video["type"] = :video
          video["phase"] = phase
          video["topic"] = topic
          generateIds.call( video )
        end

        # Quizzes are optional
        if not topic["quizzes"].nil?
          topic['quizzes'].each do |quiz|

            # Validation
            if quiz['questions'].length == 0
              raise 'Quiz must have at least 1 question'
            end

            quiz['questions'].each do |question|
              if question['answers'].length <= 1
                raise 'Question must have at least 2 answers'
              end

              if question['correct_answer'].nil?
                raise 'Question must have a correct answer'
              end
            end

            quiz["type"] = :quiz
            quiz["phase"] = phase
            quiz["topic"] = topic
            generateIds.call( quiz )
          end
        end
      end
    end
  end

  get '/' do
    erb open(ENV['CONFIG_URL'] + "index.erb").read
  end

  get '/phases/:title' do
    @phase = nil
    @phases.each do |phase|
      @phase = phase if phase['title'].downcase.gsub(" ", "_") == params['title']
    end

    pass unless @phase
    erb :phase
  end

  get "/id/:id" do
    @item = @items[ params["id"].to_i ]
    pass unless @item

    @item_next = @items[ params["id"].to_i + 1 ]
    @item_prev = @items[ params["id"].to_i - 1 ]

    erb @item["type"]
  end
  get "/item/:slug" do

    @item = @urls[ params["slug"] ]
    pass unless @item

    @item_next = @items[ @item["id"].to_i + 1 ]
    @item_prev = @items[ @item["id"].to_i - 1 ]

    erb @item["type"]
  end
end
