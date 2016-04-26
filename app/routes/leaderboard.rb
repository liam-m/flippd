require 'omniauth'

class Flippd < Sinatra::Application

  get '/leaderboard' do
    if @user
      erb :leaderboard
    else
      flash[:error] = "Please log in to view the leaderboard."
      origin = env["HTTP_REFERER"] || '/'
      redirect to(origin)
    end
  end
end