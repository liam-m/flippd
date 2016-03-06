require 'omniauth'

class Flippd < Sinatra::Application

  before do
    @user = nil
    @user = User.get(session[:user_id]) if session.key?(:user_id)
  end

  get '/user' do
    if @user
      erb :user
    else
      flash[:error] = "Please log in to view your user page."
      origin = env["HTTP_REFERER"] || '/'
      redirect to(origin)
    end
  end
end