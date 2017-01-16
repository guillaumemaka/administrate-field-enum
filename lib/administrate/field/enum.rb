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
        collection_from_hash || collection_from_array
      end

      private

      def check_option(key)
        unless options.key?(key)
          raise ArgumentError.new("Expected options #{key}")
        end
      end

      def collection
        resource = Object.const_get(resource_name)
        @collection ||= resource.respond_to?(collection_method) ? resource.send(collection_method) : []
      end

      def collection_method
        if options.key?(:collection_method)
          options.fetch(:collection_method)
        else
          @attribute.to_s.downcase.pluralize
        end
      end

      def collection_from_hash
        if collection.is_a?(HashWithIndifferentAccess)
          collection.keys.map do |k|
            [k.to_s.titleize, k.to_s]
          end
        elsif collection.is_a?(Array) && collection.first.is_a?(Hash)
          check_option(:label_key)
          check_option(:value_key)

          collection.map do |item, value|
            label = item.fetch(options.fetch(:label_key).to_sym).to_s
            value = item.fetch(options.fetch(:value_key).to_sym)
            [label.titleize, value.to_s]
          end
        end
      end

      def collection_from_array
        if collection.is_a?(Array) && !collection.empty?
          if collection.first.is_a?(Array)
            unless collection.first.length == 2
              raise ArgumentError.new("Expected array of length: 2, given: #{collection.first.length}")
            end

            collection.map do |label, value|
              [label.to_s.titleize, value.to_s]
            end
          else
            collection.map do |value|
              [value.to_s.titleize, value.to_s]
            end
          end
        else
          raise ArgumentError.new("Expected an Array, given: #{collection.class}")
        end
      end
    end
  end
end
