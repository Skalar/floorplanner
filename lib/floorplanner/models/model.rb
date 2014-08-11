module Floorplanner
  module Models
    module ComplexElement
      def self.to_xml(value)
        value.to_xml(include_root: false)
      end
    end

    module ComplexArrayElement
      def self.to_xml(value)
        element_name = "#{value.first.element_name}!"
        {:@type => "array", :content! => { element_name.to_sym => value.map { |v| v.to_xml(include_root: false) }}}
      end
    end

    class Model < Hashie::Dash
      include Hashie::Extensions::Coercion
      include Hashie::Extensions::IgnoreUndeclared


      # These properties are declared for
      # compatability with Gyoku
      property :attributes!
      property :order!

      def self.complex_elements
        @complex_elements ||= {}
      end

      def self.element(name_sym)
        property name_sym
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

      def to_xml(include_root: true)
        xml_hash = {}

        each do |key, value|
          element_name = key.to_s.gsub("_", "-").to_sym

          complex = self.class.complex_elements[key]
          if complex
            xml_hash[element_name] = complex.to_xml(value)
          else
            xml_hash[element_name] = value
          end
        end
        
        if include_root
          xml_hash = {element_name.to_sym => xml_hash}
        end

        Gyoku.xml(xml_hash)
      end

      def element_name
        self.class.name.split("::").last.downcase
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
