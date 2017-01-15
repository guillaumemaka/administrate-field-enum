require "administrate/field/base"
require "rails"

module Administrate
  module Field
    class Enum < Field::Base
      class Engine < ::Rails::Engine
      end

      attr_writer :resource_name

      def self.searchable?
        false
      end

      def to_s
        data
      end

      def resource_name
        @resource_name.to_s.titleize
      end

      def selectable_options
        collection.map do |v|
          [v.titleize, v]
        end
      end

      private

      def collection
        resource = Object.const_get(resource_name)
        @collection = resource.respond_to?(collection_method) ? resource.send(collection_method).keys : []
      end

      def collection_method
        if options.key?(:collection_method)
          options.fetch(:collection_method)
        else
          @attribute.to_s.downcase.pluralize
        end
      end
    end
  end
end
