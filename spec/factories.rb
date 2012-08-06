FactoryGirl.define do
  sequence(:sid) { |n| n}

  factory :goods_nomenclature do
    ignore do
      indents { 1 }
      description { Forgery(:basic).text }
    end

    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_item_id { 10.times.map{ Random.rand(9) }.join }
    producline_suffix   { [10,20,80].sample }
    validity_start_date { Date.today.ago(2.years) }
    validity_end_date   { nil }

    trait :actual do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { nil }
    end

    trait :expired do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { Date.today.ago(1.year)  }
    end

    trait :with_indent do
      after(:create) { |gono, evaluator|
        FactoryGirl.create(:goods_nomenclature_indent, goods_nomenclature_sid: gono.goods_nomenclature_sid,
                                                       number_indents: evaluator.indents)
      }
    end

    trait :with_description do
      after(:create) { |gono, evaluator|
        FactoryGirl.create(:goods_nomenclature_description, goods_nomenclature_sid: gono.goods_nomenclature_sid,
                                                            validity_start_date: gono.validity_start_date,
                                                            validity_end_date: gono.validity_end_date,
                                                            description: evaluator.description)
      }
    end
  end

  factory :commodity, parent: :goods_nomenclature, class: Commodity do
    trait :declarable do
      producline_suffix { 80 }
    end

    trait :non_declarable do
      producline_suffix { 10 }
    end
  end

  factory :chapter, parent: :goods_nomenclature, class: Chapter do
    goods_nomenclature_item_id { "#{2.times.map{ Random.rand(9) }.join}00000000" }
  end

  factory :heading, parent: :goods_nomenclature, class: Heading do
    goods_nomenclature_item_id { "#{4.times.map{ Random.rand(9) }.join}000000" }

    trait :declarable do
      producline_suffix { 80 }
    end

    trait :non_grouping do
      producline_suffix { 80 }
    end

    trait :non_declarable do
      after(:create) { |heading, evaluator|
        FactoryGirl.create(:goods_nomenclature, :with_description,
                                                :with_indent,
                                                goods_nomenclature_item_id: "#{heading.short_code}#{6.times.map{ Random.rand(9) }.join}")
      }
    end

    trait :with_chapter do
      after(:create) { |heading, evaluator|
        FactoryGirl.create(:goods_nomenclature, :with_description,
                                                :with_indent,
                                                goods_nomenclature_item_id: heading.chapter_id)
      }
    end
  end

  factory :goods_nomenclature_indent do
    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_indent_sid { generate(:sid) }
    number_indents { Forgery(:basic).number }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :goods_nomenclature_description_period do
    goods_nomenclature_sid { generate(:sid) }
    goods_nomenclature_description_period_sid { generate(:sid) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :goods_nomenclature_description do
    ignore do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date { nil }
    end

    goods_nomenclature_sid { generate(:sid) }
    description { Forgery(:basic).text }
    goods_nomenclature_description_period_sid { generate(:sid) }

    after(:create) { |gono_desc, evaluator|
      FactoryGirl.create(:goods_nomenclature_description_period, goods_nomenclature_sid: gono_desc.goods_nomenclature_sid,
                                                                 goods_nomenclature_description_period_sid: gono_desc.goods_nomenclature_description_period_sid,
                                                                 validity_start_date: evaluator.validity_start_date,
                                                                 validity_end_date: evaluator.validity_end_date
                                                                 )
    }
  end

  factory :quota_definition do
    quota_definition_sid   { generate(:sid) }
    quota_order_number_sid { generate(:sid) }
    quota_order_number_id  { 6.times.map{ Random.rand(9) }.join }

    trait :actual do
      validity_start_date { Date.today.ago(3.years) }
      validity_end_date   { nil }
    end
  end

  factory :quota_balance_event do
    quota_definition
    last_import_date_in_allocation { Time.now }
    old_balance { Forgery(:basic).number }
    new_balance { Forgery(:basic).number }
    imported_amount { Forgery(:basic).number }
    occurrence_timestamp { Time.now }
  end

  factory :quota_exhaustion_event do
    quota_definition
    exhaustion_date { Date.today }
    occurrence_timestamp { Time.now }
  end

  factory :quota_critical_event do
    quota_definition
    critical_state_change_date { Date.today }
    occurrence_timestamp { Time.now }
  end

  factory :section do
    position { Forgery(:basic).number }
    numeral { ["I", "II", "III"].sample }
    title { Forgery(:lorem_ipsum).sentence }
  end

  factory :measure do
    measure_sid  { generate(:sid) }
    measure_type { generate(:sid) }
    measure_generating_regulation_id { generate(:sid) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }

    trait :with_measure_type do
      after(:create) { |measure, evaluator|
        FactoryGirl.create(:measure_type, measure_type_id: measure.measure_type_id)
      }
    end

    trait :with_base_regulation do
      after(:create) { |measure, evaluator|
        FactoryGirl.create(:base_regulation, base_regulation_id: measure.measure_generating_regulation_id)
      }
    end
  end

  factory :measure_type do
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end

  factory :base_regulation do
    base_regulation_id { generate(:sid) }
    validity_start_date { Date.today.ago(3.years) }
    validity_end_date   { nil }
  end
end
