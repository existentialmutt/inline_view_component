# InlineViewComponent
Provide templates as heredoc strings from within ViewComponent class definitions.  Really good HAML support and ERB's not bad either.  Syntax highlighting for Sublime Text included.

## Usage
How to use my plugin.

BASIC EXAMPLE ERB

HAML IS ALSO SUPPORTED

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

## Default Template Format

## Syntax Highlighting

Syntax highlighting for Sublime Text is available.  Download (this file)[/editor/Ruby.sublime-syntax] and add it to your Sublime User package.  Then open your compoent files in the `Ruby (Custom)` syntax (or choose `View -> Syntax -> Open All with current extention as...` to use it automatically).

To get syntax highlighting to work use `ERB` or `HAML` as the delimiter for your heredoc string e.g.

```
template <<~HAML
  %h1 A really great template
HAML
```

Note that ERB highlighting currently has an issue that screws up text highlighting after the closing `ERB` delimiter.  If you put your template at the end of your class definition you'll only have to deal with bad highlighting on a couple `end`'s



## TODO

This is a very early release of the plugin.  Contributions are welcome!

- [ ] get `raw` and `html_safe` working in ERB templates
- [ ] fix syntax highlighting for ERB in Sublime Text
- [ ] add syntax highlighting for VSCode
- [ ] add support for other templating languages (slim, etc)

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
