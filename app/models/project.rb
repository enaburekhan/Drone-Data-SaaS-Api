class Project < ApplicationRecord
  belongs_to :user
  has_many :uploads, dependent: :destroy
  has_many :reports, dependent: :destroy

  # validate presence
  validates :name, presence: true
  validates :latitude, presence: true, numericality: {
    greater_than_or_equal_to: -90,
    less_than_or_equal_to: 90
  }
  validates :longitude, presence: true, numericality: {
    greater_than_or_equal_to: -180,
    less_than_or_equal_to: 180
  }

  # callbacks
  before_save :set_location_from_lat_lon

  # geospatial scope (find nearby projects in km)
  scope :nearby, lambda { |lon, lat, radius_km = 5|
    where(%{
      ST_DWithin(
        location::geography,
        ST_SetSRID(ST_MakePoint(?, ?), 4326)::geography,
        ?
      )
    }, lon, lat, radius_km * 1000)
  }

  # return GeoJSON feature

  def to_geojson_feature
    lon = longitude
    lat = latitude

    {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [lon, lat]
      },
      properties: {
        id: id,
        name: name,
        description: description,
        user_id: user_id,
        created_at: created_at,
        updated_at: updated_at
      }
    }
  end

  private

  def set_location_from_lat_lon
    return if latitude.blank? || longitude.blank?

    self.location = "POINT(#{longitude} #{latitude})"
  end
end
