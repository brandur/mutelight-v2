Rails has great built-in support for an asset pipeline, and I often find myself wanting to reuse this pattern in Sinatra. Initially, I'd boot up a Sprockets module directly in my application's rackup file (that's `config.ru`), but more recently I've found that I can get great flexibility and clarity by running it from a Sinatra module.

Add Sprockets and Yahoo's YUI compressor to your `Gemfile`:

``` ruby
gem "sprockets"
gem "yui-compressor"

# I find it well worth to include CoffeeScript and SASS as well
gem "coffee-script"
gem "sass"
```

Your assets file structure should look something like this:

```
+ assets
  + images
  + javascripts
    - app.js
    - my-scripts.coffee
  + stylesheets
    - app.css
    - my-styles.sass
```

`app.js` should load all other JavaScript assets in its directory (in the example structure above this will pick up `my-scripts.coffee`):

``` javascript
//= require_tree
```

`app.css` as well (includes `my-styles.sass`):

``` css
//= require_tree
```

The Sinatra module should look something like this:

``` ruby
class Assets < Sinatra::Base
  configure do
    set :assets, (Sprockets::Environment.new { |env|
      env.append_path(settings.root + "/assets/images")
      env.append_path(settings.root + "/assets/javascripts")
      env.append_path(settings.root + "/assets/stylesheets")

      # compress everything in production
      if ENV["RACK_ENV"] == "production"
        env.js_compressor  = YUI::JavaScriptCompressor.new
        env.css_compressor = YUI::CssCompressor.new
      end
    })
  end

  get "/assets/app.js" do
    content_type("application/javascript")
    settings.assets["app.js"]
  end

  get "/assets/app.css" do
    content_type("text/css")
    settings.assets["app.css"]
  end

  %w{jpg png}.each do |format|
    get "/assets/:image.#{format}" do |image|
      content_type("image/#{format}")
      settings.assets["#{image}.#{format}"]
    end
  end
end
```

Now use the assets module as middleware in  `config.ru`, and delegate everything else to your main app:

``` ruby
use Assets
run Sinatra::Application
```
