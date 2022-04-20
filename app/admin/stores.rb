ActiveAdmin.register Store do
  menu
  # Create sections on the index screen
  scope :all, default: true
  # scope :available
  # scope :drafts

  controller do
    before_action only: :index do
      p params
      if params.dig("q", "by_zone").present? && params.dig("q", "category_eq").nil?
        raise "nop"
      end
    end
  end

  # Filterable attributes on the index screen
  filter :name
  filter :by_zone, as: :string
  filter :category, as: :select, collection: %w(food tech)
  filter :created_at
end
