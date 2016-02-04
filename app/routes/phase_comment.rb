class Flippd < Sinatra::Application

  attr_accessor :comments

  post '/phases/:title/:slug/comment' do

    pass unless @item
    pass unless @item["type"] == :video
    pass unless @user

    @comment_text = params[:new_comment]
    @new_comment = Comment.create(:timestamp => DateTime.now, :text => @comment_text, :item_slug => @item["slug"], :user => @user)

    redirect to(env["HTTP_REFERER"])

  end

end
