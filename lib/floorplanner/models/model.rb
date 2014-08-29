module Floorplanner
  module Models
    module ComplexElement
      def self.to_xml(value)
        value.to_unrooted_xml_hash
      end
    end

    module ComplexArrayElement
      def self.to_xml(value)
        element_name = "#{value.first.element_name}!"
        { :@type => "array", :content! => { element_name.to_sym => value.map { |v| v.to_unrooted_xml_hash[:content!] } } }
      end
    end

    class Model < Hashie::Trash
      include Hashie::Extensions::Coercion
      include Hashie::Extensions::IgnoreUndeclared

      ELEMENT_TRANSFORMATIONS = {
        Time => lambda { |v| Time.parse(v) },
        Float => lambda { |v| v.to_f }
      }

      # These properties are declared for
      # compatability with Gyoku
      property :attributes!
      property :order!

      def self.complex_elements
        @complex_elements ||= {}
      end

      def self.namespace=(ns)
        @namespace = ns
      end

      def self.namespace
        @namespace
      end

      def self.element(name_sym, type = nil)
        property name_sym, {transform_with: ELEMENT_TRANSFORMATIONS[type]}
      end

      def self.complex(name_sym, type)
        if type.is_a?(Array)
          complex_elements[name_sym] = ComplexArrayElement
        else
          complex_elements[name_sym] = ComplexElement
        end

        coerce_key name_sym, type
        property name_sym
      end 

      def self.from_xml(xml_str)
        parser = Nori.new
        hash = parser.parse(xml_str)
        from_hash(hash)
      end

      def self.from_hash(hash)
        _enable_symbolize_keys!(hash)
        hash.symbolize_keys!
        new(hash)
      end

      def to_xml
        Gyoku.xml(element_name => to_unrooted_xml_hash)
      end

      def to_unrooted_xml_hash
        xml_hash = { :content! => {} }

        if self.class.namespace
          xml_hash[:@xmlns] = self.class.namespace
        end

        each do |key, value|
          element_name_for_key = key.to_s.gsub("_", "-")

          complex = self.class.complex_elements[key]

          if complex
            xml_hash[:content!][element_name_for_key.concat("!").to_sym] = complex.to_xml(value)
          else
            xml_hash[:content!][element_name_for_key.to_sym] = value
          end
        end

        xml_hash
      end

      # element_name("Foo::Bar::MyCoolElement") #=> :my-cool-element
      def element_name
        self.class.name.split("::").last.split(/(?=[A-Z])/).join("-").downcase.to_sym
      end

      private

      def self._enable_symbolize_keys!(obj)
        case obj
        when Hash
          obj.extend Hashie::Extensions::SymbolizeKeys

          obj.each do |k, v|
            if v.is_a?(Hash) or v.is_a?(Array)
              _enable_symbolize_keys!(v)
            end
          end
        when Array
          obj.each do |v|
            if v.is_a?(Hash) or v.is_a?(Array)
              _enable_symbolize_keys!(v)
            end
          end
        end
      end
    end
  end
end
