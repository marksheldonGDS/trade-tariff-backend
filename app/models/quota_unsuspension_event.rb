class QuotaUnsuspensionEvent < Sequel::Model
  set_primary_key  :quota_definition_sid

  # belongs_to :quota_definition, foreign_key: :quota_definition_sid
end

# == Schema Information
#
# Table name: quota_unsuspension_events
#
#  record_code            :string(255)
#  subrecord_code         :string(255)
#  record_sequence_number :string(255)
#  quota_definition_sid   :integer(4)
#  occurrence_timestamp   :datetime
#  unsuspension_date      :date
#  created_at             :datetime
#  updated_at             :datetime
#

