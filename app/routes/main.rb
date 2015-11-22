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

    @phases.each do |phase|
      phase["id"] = phase_id
      # TODO: Refactor slug generation
      # TODO: Abstract generting URLs instead of /phase/#{phase}/#{item}
      phase["slug"] = phase["title"]
        .downcase
        .gsub( /[^a-z0-9 ]/, "" )
        .gsub( " ", "-" )
      @urls[ phase_id ] = {}
      phase_id += 1

      # generateIds will generate a URL-safe slug, while also ensuring
      # phase uniqueness.
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
          if not @urls[ phase["id"] ][ url ]
            @urls[ phase["id"] ][ url ] = item
            item[ "slug" ] = url
            break
          end

          numericSuffix = ( numericSuffix or 1 ) + 1
        end
      end

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
      if phase[ "slug" ] == params[ "title" ]
        @phase = phase
      end
    end

    pass unless @phase
    erb :phase
  end

  get '/phases/:title/:slug' do
    # TODO: Abstract away getting @phase, @item, possibly @item_next @item_prev
    @phase = nil
    @phases.each do |phase|
      if phase[ "slug" ] == params[ "title" ]
        @phase = phase
      end
    end
    pass unless @phase

    @item = @urls[ @phase[ "id" ] ][ params[ 'slug' ] ]
    pass unless @item

    @item_next = @items[ @item["id"].to_i + 1 ]
    @item_prev = @items[ @item["id"].to_i - 1 ]

    erb @item[ "type" ]
  end

  post '/phases/:title/:slug' do
    @phase = nil
    @phases.each do |phase|
      if phase[ "slug" ] == params[ "title" ]
        @phase = phase
      end
    end
    pass unless @phase

    @item = @urls[ @phase[ "id" ] ][ params[ 'slug' ] ]
    pass unless @item

    @item_next = @items[ @item["id"].to_i + 1 ]
    @item_prev = @items[ @item["id"].to_i - 1 ]

    # Quiz Submission
  # TODO: Refactor!!!
    if @item[ "type" ] == :quiz
      @results = []
      @correct_num = 0
      @submission_error = nil

      @item["questions"].each_with_index do | question, index |
        if params[ ( "q" + index.to_s ).to_sym ].nil?
          answer = params[ ( "q" + index.to_s ).to_sym ].to_i
          @results[ index ] = [
            false, # Correct?
            false, # Selected Answer
            question[ "correct_answer" ], # Actual correct answer
            false
          ]
          @submission_error = "Please answer all questions"
        else
          answer = params[ ( "q" + index.to_s ).to_sym ].to_i
          @results[ index ] = [
            answer == question[ "correct_answer" ], # Correct?
            answer, # Selected Answer
            question[ "correct_answer" ], # Actual correct answer
            true
          ]
        end
        if answer == question[ "correct_answer" ]
          @correct_num += 1
        end
      end
      if @submission_error.nil?
        erb :quiz_complete
      else
        erb :quiz
      end
    end
  end
end
