class Project < ApplicationRecord
  belongs_to :user

  scope :nearby, ->(lon, lat, radius_km = 5) {
    where(%{
      ST_DWithin(
        projects.location::geography,
        ST_SetSRID(ST_MakePoint(?, ?), 4326)::geometry, 
        ?
      )
    }, lon, lat, radius_km * 1000)
  }
end
