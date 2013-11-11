module Floorplanner
  module Api
    class Resource
      include ActiveModel::Serializers::Xml
      include UrlBuilder
      include Client
      include FinderMethods

      def self.resource_name
        name.demodulize.underscore
      end

      attr_accessor :attributes

      def initialize(attributes = {})
        self.attributes = attributes
      end

      def inspect
        inspection = attributes.keys.map { |key| "#{key}: #{attributes[key].inspect}" }
        "#<#{self.class} #{inspection.join(', ')}>"
      end


      private

      def read_attribute_for_serialization(name)
        # TODO .. to be removed when we have read and write methods set up on resource, and a simple schema defined with validations
        attributes[name]
      end
    end
  end
end
