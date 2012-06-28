class FtsRegulationAction < ActiveRecord::Base
  belongs_to :fts_regulation, foreign_key: [:fts_regulation_role, :fts_regulation_id],
                              class_name: 'FullTemporaryStopRegulation'
  belongs_to :stopped_fts_regulation, foreign_key: [:stopped_regulation_role, :stopped_regulation_id],
                                      class_name: 'FullTemporaryStopRegulation'
end