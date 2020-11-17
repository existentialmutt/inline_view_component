# InlineViewComponent

This gem allows your ViewComponents to define template strings within the class definition. You should be able to use any templating language your rails app supports (ERB, HAML, Slim...). There's also custom syntax highlighting for heredoc templates for Sublime Text.

## Usage

Include the `InlineViewComponent` mixin and then specify your template string with `template(string)`. Be sure to delete your component's external template file or ViewComponent will raise an error.

#### Examples

```ruby
class ErbComponent < ViewComponent::Base
  include InlineViewComponent

  def message
    "Such inline. Much convenient."
  end

  template <<~ERB
    <p> <%= message %> </p>
  ERB
end
```

```ruby
class HamlComponent < ViewComponent::Base
  include InlineViewComponent

  def message
    "Very HAML. Many terse."
  end

  self.inline_template_format = :haml
  template <<~HAML
    %p= message
  HAML
end
```

You can also provide the template format as an optional second argument to the template method

```ruby
  template <<~SLIM, :slim
    h1 Hello World!
  SLIM
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'inline_view_component'
```

And then execute:

```bash
$ bundle
```

Or install it yourself as:

```bash
$ gem install inline_view_component
```

## Syntax Highlighting

Syntax highlighting for Sublime Text is available. Download [this file](/editor/Ruby.sublime-syntax) and add it to your Sublime User package. Then open your ruby files in the `Ruby (Custom)` syntax (or choose `View -> Syntax -> Open All with current extention as...` to use it automatically).

To get syntax highlighting to work use `ERB`, `HAML`, or `SLIM` as the delimiter for your heredoc string e.g.

```
template <<~HAML, :haml
  %h1 A really great template
HAML
```

## TODO

This is an early release. Contributions are welcome!

- [ ] add syntax highlighting for more editors (VS Code, vim, ...)

## Contributing

Send a pull request.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
