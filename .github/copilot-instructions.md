## Drone-Data-SaaS API — Copilot instructions

Be concise and follow the project's existing conventions. This repo is a Rails 8 JSON API (Ruby 3.3.1) with PostGIS, Active Storage, Sidekiq, and Devise (devise-jwt). Key integrations and patterns are listed below so an AI coding agent can be productive immediately.

- Architecture: API-only controllers are namespaced under `app/controllers` and routed under `scope :api -> scope :v1` (see `config/routes.rb`). JSON is the default response format.
- Key services: PostgreSQL with PostGIS (`activerecord-postgis-adapter` + `rgeo`), Active Storage (local by default), Sidekiq for background jobs, Devise + devise-jwt for authentication.

- Setup / dev commands (assume Linux dev environment):
  - Install gems: `bundle install`
  - Create & migrate DB (Postgres + PostGIS must be installed): `bin/rails db:setup`
  - Start Rails server: `bin/rails server` (API accessible at /api/v1/...)
  - Start Sidekiq (background jobs): `bundle exec sidekiq` (Redis required)
  - Run tests (Minitest): `bin/rails test`

- Important repo files to reference:
  - Routes & API structure: `config/routes.rb` (mounts Sidekiq web UI at `/api/v1/sidekiq` in development)
  - Models: `app/models/` (notable: `project.rb` uses a PostGIS `location` geography column; `user.rb` includes `jti` for JWT revocation)
  - Controllers: `app/controllers/` and Devise custom controllers in `app/controllers/users/` (sessions/registrations)
  - Serializers: `app/serializers/` (use these to structure JSON responses)
  - Background jobs: `app/jobs/` (enqueue work via Sidekiq)
  - Storage config: `config/storage.yml` (dev uses local disk)
  - DB schema/migrations: `db/schema.rb` and files under `db/migrate/` (shows PostGIS extension usage)

- Project-specific patterns / conventions to follow:
  - API namespace: Add endpoints under the `api/v1` scope and prefer nested resources where present (e.g. `projects/:project_id/uploads/:upload_id/processed_results`).
  - JSON defaults: Controllers are set to `defaults: { format: :json }` — return JSON payloads and use serializers.
  - Auth: Devise + `devise-jwt` is used; new endpoints that require auth should expect Authorization: Bearer <token> and rely on `jti` for token revocation (see `db/schema.rb` and `users` model).
  - Geospatial data: `projects` use a `geography` point column (`location`) plus `latitude`/`longitude` decimals — use `rgeo`/PostGIS helpers for queries.
  - File uploads: Use Active Storage attachments. Storage is local in dev (`config/storage.yml`), but bucket configs are present for S3/GCS if credentials are added.
  - Background processing: Offload long-running work (processing uploaded drone data, report generation) to Sidekiq. The dashboard is available at `/api/v1/sidekiq` in development.

- Examples of where to change things:
  - To add a new upload sub-endpoint, update `config/routes.rb` and create a controller under `app/controllers/` following the nested resource pattern used by `uploads`, `processed_results`, and `reports`.
  - For custom user flows, look at `app/controllers/users/*` (Devise controllers are overridden there).

- Non-obvious gotchas:
  - PostGIS: The DB adapter is `postgis` (see `config/database.yml`). Ensure the database has PostGIS enabled locally before running migrations.
  - Sidekiq Redis URL: `config/initializers/sidekiq.rb` reads `ENV['REDIS_URL']`; set this in your environment to run workers.
  - Tests: This project uses Minitest (tests and fixtures live under `test/`).

If anything above is unclear or you want me to include example code snippets (e.g., a sample controller or serializer following repo conventions), tell me which area to expand and I'll iterate.  
