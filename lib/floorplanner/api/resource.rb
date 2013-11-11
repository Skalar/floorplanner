module Floorplanner
  module Api
    class Resource
      include UrlBuilder
      include Client
      include FinderMethods

      def self.resource_name
        name.demodulize.underscore
      end



      def initialize(attributes = {})
        @attributes = attributes
      end

      def attributes
        attributes.dup
      end

      def inspect
        inspection = attributes.keys.map { |key| "#{key}: #{attributes[key].inspect}" }
        "#<#{self.class} #{inspection.join(', ')}>"
      end


      private

      attr_reader :attributes
    end
  end
end
