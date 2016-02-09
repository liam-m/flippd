require 'json'

module JsonParser

  def JsonParser.safeURL( text )
    return text
      .downcase
      .gsub( /[^a-z0-9 ]/, "" )
      .gsub( " ", "-" )
  end

  def JsonParser.generateSlug( flippd, item, phase, numeric_id )

    item["id"] = numeric_id
    flippd.items[ numeric_id ] = item

    slug = JsonParser.safeURL( item["title"] )
    slugSuffix = nil

    # Test if the slug is already taken
    # If so, append a numeric suffix
    loop do
      url = slug + ( slugSuffix or "" ).to_s

      # Slug not taken, assign and return
      if not flippd.urls[ phase ][ url ]
        flippd.urls[ phase ][ url ] = item
        item["slug"] = url
        return
      end

      # Slug taken, increase numeric suffix and try again
      slugSuffix = ( slugSuffix or 1 ) + 1
    end

  end

  # Request the JSON structure from the config URL
  def JsonParser.request()
    return JSON.load( open( ENV[ 'CONFIG_URL' ] + "module.json" ) )
  end

  # Grab the JSON from its source, parse, and
  # convert into an internal representation, and generate tags for items
  def JsonParser.parse( flippd )

    # If already parsed, exit
    if flippd.module then return end

    # Get the JSON and store it
    json = JsonParser.request()
    flippd.module = json
    flippd.phases = json[ 'phases' ]

    # All items indexed numerically in sequence
    flippd.items = {}
    # All items indexed by their slug
    flippd.urls = {}

    item_id = 1

    flippd.phases.each do |phase|

      phase["slug"] = JsonParser.safeURL( phase["title"] )
      flippd.urls[ phase["slug"] ] = {}

      phase["topics"].each do |topic|
        topic["items"].each do |item|
          item["type"] = item["type"].to_sym
          item["phase"] = phase
          item["topic"] = topic
          JsonParser.generateSlug( flippd, item, phase["slug"], item_id )
          item_id += 1
        end
      end

    end

  end

end
