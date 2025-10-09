class Report < ApplicationRecord
  belongs_to :project

  validates :title, presence: true

  # helper for generating summaries from processed results
  def self.generate_for_project(project)
    processed = project.uploads.includes(:processed_results).flat_map(&:processed_result)
    avg_ndvi = begin
      processed.map { |r| r.metadata["average_ndvi"].to_f }.compact.sum / processed.size
    rescue StandardError
      0
    end

    create!(
      project: project,
      title: "NDVI Summary Report . #{Time.current.strftime('%Y-%m-%d')}",
      summary: "This report summarizes NDVI performance across uploaded drone imagery",
      insights: {
        average_ndvi: avg_ndvi.round(2),
        total_uploads: project.uploads.count,
        total_results: processed.size,
        generated_at: Time.current
      }
    )
  end
end
