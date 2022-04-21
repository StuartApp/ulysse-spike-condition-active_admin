module ConditionalFilter
  def filter(attribute, options = {})
    dep = options.delete(:if)
    if dep
      controller do
        before_action only: :index do
          q = params["q"]
          if q && q["by_zone"].present? && q.keys.none? { |key| key.start_with?(dep.to_s) }
            raise "nop"
          end
        end
      end
    end
    super
  end
end

ActiveAdmin.register Store do
  extend ConditionalFilter
  menu
  # Create sections on the index screen
  scope :all, default: true
  # scope :available
  # scope :drafts

  p method(:filter).source_location * ?:

  # controller do
  #   before_action only: :index do
  #     p params
  #     if params.dig("q", "by_zone").present? && params.dig("q", "category_eq").nil?
  #       raise "nop"
  #     end
  #   end
  # end

  # Filterable attributes on the index screen
  filter :name
  filter :category, as: :select, collection: %w(food tech)
  filter :by_zone, as: :string, if: :category
  filter :created_at
end
