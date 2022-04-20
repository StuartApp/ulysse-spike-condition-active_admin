class Store < ApplicationRecord
  def self.lookup_zone(name)
    [0..50_00000, -1_00000..10_00000]
  end
  scope :by_zone, ->(zone_name) {
    lat_range, lng_range = lookup_zone(zone_name)
    where(lat: lat_range, lng: lng_range)
  }

  def self.ransackable_scopes(*)
    %i(by_zone)
  end
end
