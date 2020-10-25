require "haml-rails"
require "test_helper"
require "inline_view_component"
require "view_component/test_case"

class WrapperComponent < ViewComponent::Base
  include InlineViewComponent

  def initialize(render_inner:)
    @render_inner = render_inner
  end

  template <<~ERB
             <h1>ERB Component</h1>
             
             <p><%= '<span style="color: green;">Manually escape safe html with &#37;== </span>' %></p>
             <p><%= '<span style="color: green;">html_safe strings work</span>'.html_safe %></p>
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

              <p><%== '<span style="color: blue;">Manually escape safe html with &#37;==</span>' %></p>
              <p><%= '<span style="color: red">unsafe HTML is escaped</span>' %></p>
           ERB
end

class HamlWrapperComponent < ViewComponent::Base
  include InlineViewComponent

  def initialize(render_inner)
    @render_inner = render_inner
  end

  self.inline_template_format = :haml
  template <<~HAML
             %h1 HAML Component

             %p!= '<span style="color: green;">Use != for HTML-safe HAML</span>'
             %p= '<span style="color: green;">html_safe strings work</span>'.html_safe
             %p= '<span style="color: red">unsafe HTML is escaped</span>'

             = render(InnerComponent.new) if @render_inner
           HAML
end

class BrComponent < ViewComponent::Base
  include InlineViewComponent

  template <<~ERB
             <p>html_safe: <%= "<br>".html_safe %></p>
             <p>html_unsafe: <%= "<br>" %></p>
           ERB
end

class InlineViewComponentTest < ViewComponent::TestCase
  ERB_RESULT = "<h1>ERB Component</h1>\n\n<p>&lt;span style=\"color: green;\"&gt;Manually escape safe html with &amp;#37;== &lt;/span&gt;</p>\n<p><span style=\"color: green;\">html_safe strings work</span></p>\n<p>&lt;span style=\"color: red\"&gt;unsafe HTML is escaped&lt;/span&gt;</p>\n\n<pre>\n  @render_inner: true  \n</pre>\n\n<h3>Hi I'm the insides.  Here's how I render HTML strings</h3>\n\n <p><span style=\"color: blue;\">Manually escape safe html with %==</span></p>\n <p>&lt;span style=\"color: red\"&gt;unsafe HTML is escaped&lt;/span&gt;</p>\n        \n\n"

  HAML_RESULT = "<h1>HAML Component</h1>\n<p><span style=\"color: green;\">Use != for HTML-safe HAML</span></p>\n<p><span style=\"color: green;\">html_safe strings work</span></p>\n<p>&lt;span style=\"color: red\"&gt;unsafe HTML is escaped&lt;/span&gt;</p>\n<h3>Hi I'm the insides.  Here's how I render HTML strings</h3>\n\n <p><span style=\"color: blue;\">Manually escape safe html with %==</span></p>\n <p>&lt;span style=\"color: red\"&gt;unsafe HTML is escaped&lt;/span&gt;</p>\n\n"

  def test_that_it_has_a_version_number
    refute_nil ::InlineViewComponent::VERSION
  end

  def test_it_renders_erb
    # puts render_inline(WrapperComponent.new(render_inner: true)).to_s.inspect
    # puts render_inline(BrComponent.new(render_inner: true))

    assert_equal ERB_RESULT, render_inline(WrapperComponent.new(render_inner: true)).to_s
  end

  def test_it_renders_haml
    # puts render_inline(HamlWrapperComponent.new(render_inner: true)).to_s.inspect
    assert_equal HAML_RESULT, render_inline(HamlWrapperComponent.new(render_inner: false)).to_s
  end

  def test_it_compiles_erb_templates
    expected = "<p>html_safe: <br></p>\n<p>html_unsafe: &lt;br&gt;</p>\n"

    template_string = <<~ERB
      <p>html_safe: <%= "<br>".html_safe %></p>
      <p>html_unsafe: <%= "<br>" %></p>
    ERB

    assert_equal expected, InlineViewComponent::Compiler.compile_template(:erb, template_string).render
  end

  def test_it_compiles_haml_templates
    expected = "<p>\nhtml_safe\n<br>\n</p>\n<p>\nhtml_unsafe:\n&lt;br&gt;\n</p>\n"

    template_string = <<~HAML
      %p
        html_safe
        = "<br>".html_safe
      %p
        html_unsafe:
        = "<br>"
    HAML

    assert_equal expected, InlineViewComponent::Compiler.compile_template(:haml, template_string).render
  end
end
