module Floorplanner
  module Models
    class Model < Hashie::Dash
      include Hashie::Extensions::Coercion
      include Hashie::Extensions::IgnoreUndeclared

      def self.element(name_sym)
        property name_sym
      end

      def self.complex(name_sym, type)
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

      def self.to_xml
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
