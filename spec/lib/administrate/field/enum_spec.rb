require "administrate/field/enum"
require "active_record"

describe Administrate::Field::Enum do
  class Post < ActiveRecord::Base
    enum status: { submitted: 1, approved: 2, rejected: 3 }

    def self.collection
      statuses
    end

    def self.hash_collection
      [
        { label: "Submitted", value: 1 },
        { label: "Approved", value: 2 },
        { label: "Rejected", value: 3 },
      ]
    end

    def self.invalid_hash_collection
      [
        { label: "Submitted" },
        { label: "Approved" },
        { label: "Rejected" },
      ]
    end

    def self.array_collection
      [
        %w(Submitted 1),
        %w(Approved 2),
        %w(Rejected 3),
      ]
    end

    def self.invalid_array_collection
      [
        %w(Submitted),
        %w(Approved),
        %w(Rejected),
      ]
    end
  end

  describe "#to_partial_path" do
    it "returns a partial based on the page being rendered" do
      page = :show
      field = Administrate::Field::Enum.new(:enum, "hello", page)

      path = field.to_partial_path

      expect(path).to eq("/fields/enum/#{page}")
    end
  end

  describe "#resource_name" do
    it "return a titleize class name" do
      page = :show
      field = Administrate::Field::Enum.new(:enum, "hello", page)
      field.resource_name = :post
      expect(field.resource_name).to eq("Post")
    end
  end

  describe "#selectable_options" do
    it "return all enum values" do
      page = :show
      field = Administrate::Field::Enum.new(:status, "approved", page)
      field.resource_name = :post
      expect(field.selectable_options).to eq([
                                               %w(Submitted submitted),
                                               %w(Approved approved),
                                               %w(Rejected rejected),
                                             ])
    end
  end

  describe "Given the option :collection_method" do
    it "overrides default behaviour" do
      page = :show
      field = Administrate::Field::Enum.new(
        :status, "approved", page, collection_method: :collection
      )

      field.resource_name = :post

      expect(field.selectable_options).to eq([
                                               %w(Submitted submitted),
                                               %w(Approved approved),
                                               %w(Rejected rejected),
                                             ])
    end

    describe "Given a valid" do
      describe "Array" do
        it "return a valid collection" do
          page = :show
          field = Administrate::Field::Enum.new(
            :status,
            "approved",
            page,
            collection_method: :array_collection,
          )

          field.resource_name = :post

          expect(field.selectable_options).to eq([
                                                   %w(Submitted 1),
                                                   %w(Approved 2),
                                                   %w(Rejected 3),
                                                 ])
        end
      end

      describe "Hash" do
        it "return a valid collection" do
          page = :show
          field = Administrate::Field::Enum.new(
            :status,
            "approved",
            page,
            collection_method: :hash_collection,
            label_key: :label,
            value_key: :value,
          )

          field.resource_name = :post

          expect(field.selectable_options).to eq([
                                                   %w(Submitted 1),
                                                   %w(Approved 2),
                                                   %w(Rejected 3),
                                                 ])
        end
      end
    end

    describe "Given an invalid" do
      describe "Array" do
        it "raises an ArgumentError when the array have not the required length" do
          page = :show
          field = Administrate::Field::Enum.new(
            :status,
            "approved",
            page,
            collection_method: :invalid_array_collection,
          )

          field.resource_name = :post

          expect { field.selectable_options }.to raise_error(ArgumentError)
        end
      end

      describe "Hash" do
        it "raises a KeyError when the Hash has not the required keys" do
          page = :show
          field = Administrate::Field::Enum.new(
            :status,
            "approved",
            page,
            collection_method: :invalid_hash_collection,
            label_key: :label,
            value_key: :value,
          )

          field.resource_name = :post

          expect { field.selectable_options }.to raise_error(KeyError)
        end
      end
    end
  end
end
