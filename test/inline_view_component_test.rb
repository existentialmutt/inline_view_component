require "test_helper"
require "haml-rails"
require "inline_view_component"
require "view_component/test_case"

class WrapperComponent < ViewComponent::Base
  include InlineViewComponent

  def initialize(render_inner:)
    @render_inner = render_inner
  end

  template <<~ERB
             <h1>ERB Component</h1>

             <p><%== '<span style="color: green;">Manually escape safe html with <%==</span>' %></p>
             <p><%= '<span style="color: red">unsafe HTML is escaped</span>' %></p>

             <pre>
               @render_inner: <%= @render_inner %>  
             </pre>
             
             <%= render InnerComponent.new if @render_inner %>        

           ERB
end

class InnerComponent < ViewComponent::Base
  include InlineViewComponent

  template <<~ERB
             <h3>Hi I'm the insides.  Here's how I render HTML strings</h3>

              <p><%== '<span style="color: blue;">Manually escape safe html with <%==</span>' %></p>
              <p><%= raw '<span style="color: blue;">Or use #raw</span>' %></p>
              <p><%= '<span style="color: blue;">.html_safe also works</span>'.html_safe %></p>
              <p><%= '<span style="color: red">unsafe HTML is escaped</span>' %></p>
           ERB
end

# class HamlWrapperComponent < ViewComponent::Base
#   include InlineViewComponent

#   def initialize(render_inner)
#     @render_inner = render_inner
#   end

#   self.inline_template_format = :haml
#   template <<~HAML
#              %h1 HAML Component

#              %p== '<span style="color: green;">Use %== for HTML-safe HAML</span>'
#              %p= '<span style="color: red">unsafe HTML is escaped</span>'

#              %div= render(InnerComponent.new) if @render_inner
#            HAML
# end

ERB_RESULT = "<h1>ERB Component</h1>\n\n<p><span style=\"color: green;\">Manually escape safe html with </span></p>\n<p>&lt;span style=\"color: red\"&gt;unsafe HTML is escaped&lt;/span&gt;</p>\n\n<pre>\n  @render_inner: false  \n</pre>\n\n        \n\n".freeze

class InlineViewComponentTest < ViewComponent::TestCase
  def test_that_it_has_a_version_number
    refute_nil ::InlineViewComponent::VERSION
  end

  def test_it_renders_erb
    assert_equal ERB_RESULT, render_inline(WrapperComponent.new(render_inner: false)).to_s
  end

  # def test_it_renders_haml
  #   puts render_inline(HamlWrapperComponent.new(render_inner: true)).to_s
  # end

  # def test_it_sets_default_template_format
  # end

  # def test_it_escapes_html
  # end
end
