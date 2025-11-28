class ProjectsController < ActiveModel::Serializer
    attributes :id, :name, :description, :latitude, :longitude, :created_at, :updated_at
end