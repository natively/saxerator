require 'rexml/document'

module Saxerator
  module Builder
    class XmlDocument < REXML::Document
      alias to_xml to_s
    end

    class XmlBuilder
      attr_reader :name

      def initialize(config, name, attributes)
        @config = config
        @name = name
        @attributes = attributes
        @children = []
        @text = false
      end

      def add_node(node)
        @text = true if node.is_a? String
        @children << node
      end

      def to_xml(builder)
        element = REXML::Element.new(name, nil, attribute_quote: :quote)
        element.add_attributes(@attributes)
        if @text
          element.add_text(@children.join)
        else
          @children.each { |child| child.to_xml(element) }
        end
        builder.elements << element
      end

      def block_variable
        builder = XmlDocument.new
        builder << REXML::XMLDecl.new('1.0')
        to_xml(builder)
        builder
      end
    end
  end
end
