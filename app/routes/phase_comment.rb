class Flippd < Sinatra::Application

  attr_accessor :comments

  post '/phases/:title/:slug/comment' do

    pass unless @item
    pass unless @item["type"] == :video
    pass unless @user

    Comment.create(
      timestamp: DateTime.now,
      text: params[:new_comment],
      item_slug: @item["slug"],
      user: @user
    )

    redirect to(env["HTTP_REFERER"] + "#comments")

  end

end
