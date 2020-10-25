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
      format = inline_template_format || :erb

      @inline_template = InlineViewComponent::Compiler.compile_template(format, template_string)

      define_method :call do
        raw self.class.inline_template.render(self)
      end
    end
  end

  module Compiler
    def compile_template(format, template_string)
      raise "unsupported format #{format}" unless InlineViewComponent::FORMATS.include?(format)

      case format.to_sym
      when :erb then Tilt::ErubiTemplate.new(nil, escape_html: true, escapefunc: "::ERB::Util::h") { template_string }
      when :haml then Tilt["haml"].new(nil, 1, escape_html: true) { template_string }
      end
    end

    module_function :compile_template
  end
end
