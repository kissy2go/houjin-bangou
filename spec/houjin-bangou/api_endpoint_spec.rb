require 'spec_helper'

describe HoujinBangou::Num do
  describe '::endpoint_url' do
    subject { HoujinBangou::Num.endpoint_url }
    it { expect(subject).to eq URI.parse(HoujinBangou.base_url + '/num') }
  end

  describe '::search' do
    subject { HoujinBangou::Num.search(number, history: history) }

    let(:history) { nil }

    context 'when number of String is given' do
      let(:number) { '123' }
      it 'returns value of HoujinBangou::request return value' do
        expect(HoujinBangou).to receive(:request).with(
          HoujinBangou::Num.endpoint_url,
          number: number, type: '01'
        ).and_return(:ok)

        expect(subject).to eq :ok
      end
    end

    context 'when number of Array is given' do
      let(:number) { %w{ 123 456 } }
      it 'returns value of HoujinBangou::request return value' do
        expect(HoujinBangou).to receive(:request).with(
          HoujinBangou::Num.endpoint_url,
          number: number.join(','), type: '01'
        ).and_return(:ok)

        expect(subject).to eq :ok
      end
    end
  end
end

describe HoujinBangou::Diff do
  describe '::endpoint_url' do
    subject { HoujinBangou::Diff.endpoint_url }
    it { expect(subject).to eq URI.parse(HoujinBangou.base_url + '/diff') }
  end

  describe '::search' do
    subject { HoujinBangou::Diff.search(from, to, address: address, kind: kind, divide: divide) }

    let(:address) { nil }
    let(:kind)    { nil }
    let(:divide)  { nil }

    context 'when from/to of Date is given' do
      let(:from) { Date.new(2017, 1, 2) }
      let(:to)   { Date.new(2017, 2, 3) }
      it 'returns value of HoujinBangou::request return value' do
        expect(HoujinBangou).to receive(:request).with(
          HoujinBangou::Diff.endpoint_url,
          from: from.strftime('%Y-%m-%d'), to: to.strftime('%Y-%m-%d'), type: '01'
        ).and_return(:ok)

        expect(subject).to eq :ok
      end
    end

    context 'when from/to of Time is given' do
      let(:from) { Time.new(2017, 1, 2) }
      let(:to)   { Time.new(2017, 2, 3) }
      it 'returns value of HoujinBangou::request return value' do
        expect(HoujinBangou).to receive(:request).with(
          HoujinBangou::Diff.endpoint_url,
          from: from.strftime('%Y-%m-%d'), to: to.strftime('%Y-%m-%d'), type: '01'
        ).and_return(:ok)

        expect(subject).to eq :ok
      end
    end

    context 'when from/to of String is given' do
      let(:from) { '2017-01-02' }
      let(:to)   { '2017-02-03' }
      it 'returns value of HoujinBangou::request return value' do
        expect(HoujinBangou).to receive(:request).with(
          HoujinBangou::Diff.endpoint_url,
          from: from, to: to, type: '01'
        ).and_return(:ok)

        expect(subject).to eq :ok
      end
    end
  end
end
