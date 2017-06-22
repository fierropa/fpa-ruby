json.partial! "comparisons/comparison", comparison: @comparison
json.extract! @comparison, :id, :name, :description, :documents, :created_at, :updated_at