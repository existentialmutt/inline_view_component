require "active_support/concern"

module InlineViewComponent
  extend ActiveSupport::Concern

  included do
    class << self
      attr_reader :inline_template, :inline_template_format
    end

    # set the template format for this component
    def self.inline_template_format=(format)
      @inline_template_format = format.to_sym
    end

    # set the template for this component
    def self.template(template_string)
      format = inline_template_format || :erb

      handler = ActionView::Template.handler_for_extension(format.to_s)
      @inline_template = if handler.method(:call).parameters.length > 1
        handler.call(self, template_string)
      else
        handler.call(OpenStruct.new(source: template_string, identifier: identifier, type: type))
      end

      define_method :call do
        @output_buffer = ActionView::OutputBuffer.new
        raw instance_eval(self.class.inline_template)
      end
    end
  end
end
