require "administrate/field/enum"
require "active_record"

describe Administrate::Field::Enum do
  class Post < ActiveRecord::Base
    enum status: { submitted: 1, approved: 2, rejected: 3 }
    def self.collection
      statuses
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

  describe "with_options" do
    it ":collection_method override attribute lookup" do
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
  end
end
