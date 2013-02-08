class ProrogationRegulationAction < Sequel::Model
  plugin :oplog, primary_key: [:prorogation_regulation_id,
                               :prorogation_regulation_role,
                               :prorogated_regulation_id,
                               :prorogated_regulation_role]
  set_primary_key  :prorogation_regulation_id, :prorogation_regulation_role,
                   :prorogated_regulation_id, :prorogated_regulation_role
end


