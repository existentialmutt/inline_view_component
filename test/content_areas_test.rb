require "haml-rails"
require "test_helper"
require "inline_view_component"
require "view_component/test_case"

# This test confirms that we can call use `<%= ... do>` within inline template declarations
# the tilt version had issues with this

class ContentWrapperComponent < ViewComponent::Base
  include InlineViewComponent
  with_content_areas :named_content

  template <<~ERB
    <%= content %>
    <div id="named_content">
      <%= named_content %>
    </div>
  ERB
end

class ContentWrapperCallerComponent < ViewComponent::Base
  include InlineViewComponent

  template <<~ERB
    <%= render ContentWrapperComponent.new do |c| %>
      <h1>Unnamed Content</h1>
      <%- c.with :named_content do %>
        <h2>Named Content</h2>
      <% end -%>
    <% end -%>
  ERB
end

class ContentAreasTest < ViewComponent::TestCase
  RESULT = "\n  <h1>Unnamed Content</h1>\n\n<div id=\"named_content\">\n      <h2>Named Content</h2>\n\n</div>\n"

  def test_it_renders_with_content_areas
    assert_equal RESULT, render_inline(ContentWrapperCallerComponent.new).to_s
  end
end
