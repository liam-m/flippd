require 'open-uri'
require 'json'

class Flippd < Sinatra::Application
  before do
    # Load in the configuration (at the URL in the project's .env file)
    @module = JSON.load(open(ENV['CONFIG_URL'] + "module.json"))
    @phases = @module['phases']

    # The configuration doesn't have to include identifiers, so we
    # add an identifier to each phase, video and quiz
    phase_id = 1
    video_id = 1
    quiz_id = 1
    @phases.each do |phase|
      phase["id"] = phase_id
      phase_id += 1

      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          video["id"] = video_id
          video_id += 1
        end
        # Quizzes are optional
        if not topic["quizzes"].nil?
          topic['quizzes'].each do |quiz|

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

            quiz["id"] = quiz_id
            quiz_id += 1
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

  get '/videos/:id' do
    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          if video["id"] == params['id'].to_i
            @phase = phase
            @video = video
          end
        end
      end
    end

    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          if video["id"] == params['id'].to_i + 1
            @next_video = video
          end
        end
      end
    end

    @phases.each do |phase|
      phase['topics'].each do |topic|
        topic['videos'].each do |video|
          if video["id"] == params['id'].to_i - 1
            @previous_video = video
          end
        end
      end
    end

    pass unless @video
    erb :video
  end

  get '/quizzes/:id' do
    @phases.each do |phase|
      phase['topics'].each do |topic|
        if not topic['quizzes'].nil?
          topic['quizzes'].each do |quiz|
            if quiz["id"] == params['id'].to_i
              @phase = phase
              @quiz = quiz
            end
          end
        end
      end
    end

    pass unless @quiz
    erb :quiz
  end

  post "/quizzes/:id" do
    # Get the quiz
    @phases.each do |phase|
      phase['topics'].each do |topic|
        if not topic['quizzes'].nil?
          topic['quizzes'].each do |quiz|
            if quiz["id"] == params['id'].to_i
              @phase = phase
              @quiz = quiz
            end
          end
        end
      end
    end

    pass unless @quiz

    @results = []
    @correct_num = 0

    @quiz["questions"].each_with_index do | question, index |
      answer = params[ ( "q" + index.to_s ).to_sym ].to_i
      @results[ index ] = [
        answer == question[ "correct_answer" ], # Correct?
        answer, # Selected Answer
        question[ "correct_answer" ] # Actual correct answer
      ]
      if answer == question[ "correct_answer" ]
        @correct_num += 1
      end
    end

    erb :quiz
  end
end
