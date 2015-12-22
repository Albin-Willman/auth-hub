require 'rails_helper'

RSpec.describe User, regressor: true do
  # === Relations ===
  it { is_expected.to have_many :tokens }

  # === Database (Columns) ===
  it { is_expected.to have_db_column :id }
  it { is_expected.to have_db_column :email }
  it { is_expected.to have_db_column :name }
  it { is_expected.to have_db_column :password_digest }
  it { is_expected.to have_db_column :token }
  it { is_expected.to have_db_column :active }
  it { is_expected.to have_db_column :created_at }
  it { is_expected.to have_db_column :updated_at }

  # === Validations (Length) ===
  it { is_expected.to allow_value(Faker::Lorem.characters(72)).for :password }
  it { is_expected.not_to allow_value(Faker::Lorem.characters(73)).for :password }

  # === Validations (Presence) ===
  it { is_expected.to validate_presence_of :email }
end
