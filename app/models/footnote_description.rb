class FootnoteDescription < Sequel::Model
  plugin :time_machine
  plugin :oplog, primary_key: [:footnote_description_period_sid,
                               :footnote_id,
                               :footnote_type_id]

  set_primary_key :footnote_description_period_sid, :footnote_id, :footnote_type_id
end


