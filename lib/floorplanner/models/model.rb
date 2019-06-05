module Floorplanner
  module Models
    module ComplexElement
    end

    module ComplexArrayElement
    end

    class Model < Hashie::Trash
      include Hashie::Extensions::Coercion
      include Hashie::Extensions::IgnoreUndeclared

      ELEMENT_TRANSFORMATIONS = {
        Time => lambda { |v|
          return v if v.class == Time
          if v.class == DateTime
            # When values like "2019-06-03T09:34:59+0000" are provided they automatically are set as
            # DateTime objects by the XML parser, therefore we convert them to Time objects using
            # the technique documented at: https://stackoverflow.com/a/3513247
            return Time.new(v.year, v.month, v.day, v.hour, v.min, v.sec, v.zone)
          end
          Time.parse(v)
        },
        Float => lambda { |v| v.to_f }
      }

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

      def self.from_json(json_str, key)
        hash = JSON.parse(json_str)
        from_hash({key => hash})
      end

      def self.from_hash(hash)
        _enable_symbolize_keys!(hash)
        hash.symbolize_keys!
        new(hash)
      end

      def to_json
        {element_name => to_unrooted_hash}.to_json
      end

      def to_unrooted_hash
        xml_hash = {}

        each do |key, value|
          complex = self.class.complex_elements[key]

          if complex == Floorplanner::Models::ComplexArrayElement
            xml_hash[key.to_s.concat("_attributes").to_sym] = value.map { |e| e.to_unrooted_hash }
          elsif complex
            xml_hash[key.to_s.concat("_attributes").to_sym] = value.to_unrooted_hash
          else
            xml_hash[key] = value
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
