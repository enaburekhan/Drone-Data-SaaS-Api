class Denylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = "denylist"
end
