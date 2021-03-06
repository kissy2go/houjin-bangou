require 'spec_helper'

describe HoujinBangou::ResultSet do
  let(:result_set) { HoujinBangou::ResultSet.new(response, src_encoding) }

  let(:response)     { raw_response.join("\r\n").encode(src_encoding, Encoding.default_internal) }
  let(:src_encoding) { Encoding::Stateless_ISO_2022_JP }

  let(:raw_response) do
    [
      '2017-05-10,1,1,1',
      '1,3430001005002,01,1,2017-05-09,2015-10-05,"株式会社英語表記新規登 録",,301,"北海道","札幌市中央区","北三条西6丁目1",,01,101,060000 3,,,,,,,2015-10-05,1,"A Company Limited","Hokkaido","6-1 Kita3-jonishi, Chuo ku Sapporo shi",',
    ]
  end

  describe '#header' do
    subject { result_set.header }

    it 'returns HoujinBangou::ResultSet::Header instance' do
      expect(subject).to eq HoujinBangou::ResultSet::Header.new(*raw_response[0].parse_csv)
    end
  end

  describe '#each' do
    context 'when block is not given' do
      it 'returns Enumerator' do
        expect(result_set.each).to be_an_instance_of Enumerator
      end
    end

    context 'when block is given' do
      it 'yields record count times' do
        expect { |b| result_set.each(&b) }.to yield_control.exactly(raw_response.count - 1).times
      end

      it 'yields with HoujinBangou::ResultSet::Record instance' do
        expected = raw_response[1..-1].map { |r| HoujinBangou::ResultSet::Record.new(*r.parse_csv) }
        expect { |b| result_set.each(&b) }.to yield_successive_args(*expected)
      end
    end
  end
end

describe HoujinBangou::ResultSet::Header do
  let(:header) { HoujinBangou::ResultSet::Header.new(*values) }
  let(:values) { '2017-05-10,1,1,1'.parse_csv }
  let(:attrs)  { Hash[*([HoujinBangou::ResultSet::Header.members, values].transpose.flatten)] }

  describe 'attribute accessors' do
    it 'provides read access' do
      expect(header.last_update_date).to eq Date.strptime(attrs[:last_update_date], '%Y-%m-%d')
      expect(header.count).to eq Integer(attrs[:count])
      expect(header.divide_number).to eq Integer(attrs[:divide_number])
      expect(header.divide_size).to eq Integer(attrs[:divide_size])
    end
  end
end

describe HoujinBangou::ResultSet::Record do
  let(:record) { HoujinBangou::ResultSet::Record.new(*values) }
  let(:values) { '1,3430001005002,01,1,2017-05-09,2015-10-05,"株式会社英語表記新規登 録",,301,"北海道","札幌市中央区","北三条西6丁目1",,01,101,060000 3,,,,,,,2015-10-05,1,"A Company Limited","Hokkaido","6-1 Kita3-jonishi, Chuo ku Sapporo shi",'.parse_csv }
  let(:attrs)  { Hash[*([HoujinBangou::ResultSet::Record.members, values].transpose.flatten)] }

  describe 'attribute accessors' do
    it 'provides read access' do
      expect(record.sequence_number).to eq Integer(attrs[:sequence_number])
      expect(record.corporate_number).to eq attrs[:corporate_number]
      expect(record.process).to eq attrs[:process]
      expect(record.correct).to eq attrs[:correct]
      expect(record.update_date).to eq attrs[:update_date] ? Date.strptime(attrs[:update_date], '%Y-%m-%d') : nil
      expect(record.change_date).to eq attrs[:change_date] ? Date.strptime(attrs[:change_date], '%Y-%m-%d') : nil
      expect(record.name).to eq attrs[:name]
      expect(record.name_image_id).to eq attrs[:name_image_id]
      expect(record.kind).to eq attrs[:kind]
      expect(record.prefecture_name).to eq attrs[:prefecture_name]
      expect(record.city_name).to eq attrs[:city_name]
      expect(record.street_number).to eq attrs[:street_number]
      expect(record.address_image_id).to eq attrs[:address_image_id]
      expect(record.prefecture_code).to eq attrs[:prefecture_code]
      expect(record.city_code).to eq attrs[:city_code]
      expect(record.post_code).to eq attrs[:post_code]
      expect(record.address_outside).to eq attrs[:address_outside]
      expect(record.address_outside_image_id).to eq attrs[:address_outside_image_id]
      expect(record.close_date).to eq attrs[:close_date] ? Date.strptime(attrs[:close_date], '%Y-%m-%d') : nil
      expect(record.close_cause).to eq attrs[:close_cause]
      expect(record.successor_corporate_number).to eq attrs[:successor_corporate_number]
      expect(record.change_cause).to eq attrs[:change_cause]
      expect(record.assignment_date).to eq attrs[:assignment_date] ? Date.strptime(attrs[:assignment_date], '%Y-%m-%d') : nil
      expect(record.latest).to eq Integer(attrs[:latest])
      expect(record.en_name).to eq attrs[:en_name]
      expect(record.en_prefecture_name).to eq attrs[:en_prefecture_name]
      expect(record.en_city_name).to eq attrs[:en_city_name]
      expect(record.en_address_outside).to eq attrs[:en_address_outside]
    end
  end
end
