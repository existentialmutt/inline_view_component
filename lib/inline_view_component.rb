require "inline_view_component/railtie"
require "active_support/concern"
require "tilt"
require "active_support/core_ext/string/output_safety"

module InlineViewComponent
  extend ActiveSupport::Concern

  FORMATS = [:erb, :haml].freeze

  included do
    class << self
      attr_reader :inline_template, :inline_template_format
    end

    # set the template format for this component

    def self.inline_template_format=(format)
      unless InlineViewComponent::FORMATS.include? format
        raise "unsupported format #{format}.  Valid choices are: #{InlineViewComponent::FORMATS}"
      end

      @inline_template_format = format.to_sym
    end

    # set the template for this component
    def self.template(template_string)
      format = inline_template_format || :erb # Rails.configuration.x.inline_view_component.default_template_format

      raise "unsupported format #{format}" unless FORMATS.include?(format)

      @inline_template = case format.to_sym
        when :erb then Tilt["erubi"].new(nil, 1, escape: true) { template_string }
          # when :erb then Tilt::ErubiTemplate.new(nil, bufval: "ActiveSupport::SafeBuffer.new", escapefunc: "ERB::Util::h", escape: true) { template_string }
        when :haml then Tilt["haml"].new(nil, 1, escape_html: true, format: :html5) { template_string }
      end
    end

    def call
      raise "No template defined" unless self.class.inline_template

      raw self.class.inline_template.render(self)
    end
  end
end
