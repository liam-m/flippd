require 'omniauth'

class Flippd < Sinatra::Application

  before do
    @user = nil
    @user = User.get(session[:user_id]) if session.key?(:user_id)
  end

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