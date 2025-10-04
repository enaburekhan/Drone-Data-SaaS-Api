class UploadSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :status, :metadata, :created_at, :file_url

  belongs_to :project

  def file_url
    return unless object.file.attached?

    rails_blob_url(object.file, only_path: true)
  end
end
