class Flippd < Sinatra::Application

  attr_accessor :items
  attr_accessor :urls

  attr_accessor :phase
  attr_accessor :item
  attr_accessor :item_next
  attr_accessor :item_prev

  attr_accessor :comments

  # HACK: This slug should work as /phases/*, and yet, doesn't.
  before '/phases/:title/?*' do
    # TODO: Find some way to pass data from before blocks to routes
    @phase = @phases.find { |x| x['slug'] == params['title'] }
  end

  get '/phases/:title' do
    pass unless @phase
    erb :phase
  end

  before '/phases/:title/:slug/?*' do
    return unless @phase
    @item = @urls[ @phase[ "slug" ] ][ params[ "slug" ] ]

    if @item
      @item_next = @items[ @item["id"].to_i + 1 ]
      @item_prev = @items[ @item["id"].to_i - 1 ]

      @comments = Comment.all(:item_slug => @item["slug"], :order => [ :timestamp.desc ])
    end
  end

  get '/phases/:title/:slug' do
    pass unless @item
    erb @item["type"]
  end

  # Forces a pass if the current item isn't of the correct type
  def must_be_a( type )
    pass unless @item and @item["type"] == type
  end

end
