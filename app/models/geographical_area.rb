class GeographicalArea < Sequel::Model
  plugin :time_machine

  set_primary_key :geographical_area_sid

  one_to_one :geographical_area_description, dataset: -> {
    GeographicalAreaDescription.with_actual(GeographicalAreaDescriptionPeriod)
                               .join(:geographical_area_description_periods, geographical_area_description_periods__geographical_area_description_period_sid: :geographical_area_descriptions__geographical_area_description_period_sid,
                                                                             geographical_area_description_periods__geographical_area_sid: :geographical_area_descriptions__geographical_area_sid)
                               .where(geographical_area_descriptions__geographical_area_sid: geographical_area_sid)
                               .order(:geographical_area_description_periods__validity_start_date.desc)
  }, eager_loader: (proc do |eo|
    eo[:rows].each{|geo_area| geo_area.associations[:geographical_area_description] = nil}

    id_map = eo[:id_map]

    GeographicalAreaDescription.with_actual(GeographicalAreaDescriptionPeriod)
                               .join(:geographical_area_description_periods, geographical_area_description_periods__geographical_area_description_period_sid: :geographical_area_descriptions__geographical_area_description_period_sid,
                                                                             geographical_area_description_periods__geographical_area_sid: :geographical_area_descriptions__geographical_area_sid)
                               .where(geographical_area_descriptions__geographical_area_sid: id_map.keys)
                               .order(:geographical_area_description_periods__validity_start_date.asc).all do |geographical_area_description|
      if geographical_areas = id_map[geographical_area_description.geographical_area_sid]
        geographical_areas.each do |geographical_area|
          geographical_area.associations[:geographical_area_description] = geographical_area_description
        end
      end
    end
  end)

  one_to_many :children_geographical_areas, key: :parent_geographical_area_group_sid,
                                            primary_key: :geographical_area_sid,
                                            class_name: 'GeographicalArea',
                                            eager: :geographical_area_description

  one_to_one :parent_geographical_area, key: :geographical_area_sid,
                                        primary_key: :parent_geographical_area_group_sid,
                                        class_name: 'GeographicalArea'

  one_to_many :contained_geographical_areas, class_name: 'GeographicalArea', dataset: -> {
    GeographicalArea.with_actual(GeographicalAreaMembership)
                    .join(:geographical_area_memberships, geographical_areas__geographical_area_sid: :geographical_area_memberships__geographical_area_sid)
                    .where(geographical_area_memberships__geographical_area_group_sid: geographical_area_sid)

  }, eager_loader: (proc do |eo|
    eo[:rows].each{|geographical_area| geographical_area.associations[:contained_geographical_areas] = []}

    id_map = eo[:id_map]

    GeographicalArea.with_actual(GeographicalAreaMembership)
                    .eager(:geographical_area_description)
                    .join(:geographical_area_memberships, geographical_areas__geographical_area_sid: :geographical_area_memberships__geographical_area_sid)
                    .where(geographical_area_memberships__geographical_area_group_sid: id_map.keys).all do |contained_geographical_area|
      if geographical_areas = id_map[contained_geographical_area[:geographical_area_group_sid]]
        geographical_areas.each do |geographical_area|
          geographical_area.associations[:contained_geographical_areas] << contained_geographical_area
        end
      end
    end
  end)

  one_to_many :measures, dataset: -> {
    actual(Measure).where(geographical_area_sid: geographical_area_sid)
  }

  delegate :description, to: :geographical_area_description

  # TODO
  def validate
    super
    # GA1
    validates_unique([:geographical_area_id, :validates_start_date])
    # GA2
    validates_start_date
  end

  def iso_code
    (geographical_area_id.size == 2) ? geographical_area_id : nil
  end
end


