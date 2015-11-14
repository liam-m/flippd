require 'open-uri'
require 'json'

class Flippd < Sinatra::Application
  before do
    # Load in the configuration (at the URL in the project's .env file)
    @module = JSON.load(open(ENV['CONFIG_URL'] + "module.json"))
    @phases = @module['phases']
    @items = {}

    # The configuration doesn't have to include identifiers, so we
    # add an identifier to each phase, video and quiz
    phase_id = 1
    topic_id = 1
    item_id = 1
    @phases.each do |phase|
      phase["id"] = phase_id
      phase_id += 1

      phase['topics'].each do |topic|
        topic["id"] = topic_id
        topic_id += 1

        topic['videos'].each do |video|
          video["type"] = :video
          video["id"] = item_id
          video["phase"] = phase
          video["topic"] = topic
          @items[ item_id ] = video

          item_id += 1
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
            quiz["id"] = item_id
            quiz["phase"] = phase
            quiz["topic"] = topic
            @items[ item_id ] = quiz

            item_id += 1
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

  get "/item/:id" do
    @item = @items[ params["id"].to_i ]
    @item_next = @items[ params["id"].to_i + 1 ]
    @item_prev = @items[ params["id"].to_i - 1 ]

    pass unless @item
    erb @item["type"]
  end
end
