require 'rails_helper'

RSpec.describe Token, regressor: true do
  # === Relations ===
  it { is_expected.to belong_to :user }

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :token }
  it { is_expected.to have_db_column :service }
  it { is_expected.to have_db_column :user_id }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Database (Indexes) ===
  it { is_expected.to have_db_index ["user_id"] }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :user }
end
