require 'omniauth'

class Flippd < Sinatra::Application

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