require 'spec_helper'

describe Chapter do
  describe 'associations' do
    describe 'headings' do
      let!(:chapter)  { create :chapter }
      let!(:heading1) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}10000000",
                                         validity_start_date: 10.years.ago,
                                         validity_end_date: nil }
      let!(:heading2) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}20000000",
                                         validity_start_date: 2.years.ago,
                                         validity_end_date: nil }
      let!(:heading3) { create :heading, goods_nomenclature_item_id: "#{chapter.goods_nomenclature_item_id.first(2)}30000000",
                                         validity_start_date: 10.years.ago,
                                         validity_end_date: 8.years.ago }

      around(:each) do |example|
        TimeMachine.at(1.year.ago) do
          example.run
        end
      end

      it 'returns headings matched by part of own goods nomenclature item id' do
        chapter.headings.should include heading1
      end

      it 'returns relevant by actual time headings' do
        chapter.headings.should include heading2
      end

      it 'does not return heading that is irrelevant to given time' do
        chapter.headings.should_not include heading3
      end
    end
  end

  describe '#to_indexed_json' do
    let!(:chapter) { create :chapter, :with_section, :with_description }
    let(:pattern)  {
                     {
                       id: chapter.goods_nomenclature_sid,
                       goods_nomenclature_item_id: chapter.goods_nomenclature_item_id,
                       section: Hash,
                     }.ignore_extra_keys!
                   }

    it 'returns json representation for ElasticSearch' do
      chapter.to_indexed_json.should match_json_expression pattern
    end
  end

  describe "#number_indents" do
    let(:chapter) { build :chapter }

    it 'defaults to zero' do
      chapter.number_indents.should == 0
    end
  end

  describe '#to_param' do
    let(:chapter) { create :chapter }

    it 'uses first two digits of goods_nomenclature_item_id as param' do
      chapter.to_param.should == chapter.goods_nomenclature_item_id.first(2)
    end
  end
end
