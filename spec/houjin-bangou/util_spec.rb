require 'spec_helper'

describe HoujinBangou::Util::Date do
  describe '::encode' do
    subject { HoujinBangou::Util::Date.encode(date) }

    context 'when Date instance is given' do
      let(:date) { Date.today }
      it 'returns date string formatted YYYY-mm-dd' do
        expect(subject).to eq date.strftime('%Y-%m-%d')
      end
    end

    context 'when Time instance is given' do
      let(:date) { Time.now }
      it 'returns date string formatted YYYY-mm-dd' do
        expect(subject).to eq date.strftime('%Y-%m-%d')
      end
    end

    context 'when unformattable object is given' do
      let(:date) { 'This is unformattable object' }
      it 'returns given argument' do
        expect(subject).to be date
      end
    end
  end

  describe '::decode' do
    subject { HoujinBangou::Util::Date.decode(string) }

    context 'when date string formatted YYYY-mm-dd is given' do
      let(:string) { '2017-01-02' }
      it 'returns Date instance' do
        expect(subject).to eq Date.strptime(string, '%Y-%m-%d')
      end
    end

    context 'when date string formatted YYYY/mm/dd is given' do
      let(:string) { '2017/01/02' }
      it 'returns given argument' do
        expect(subject).to be string
      end
    end

    context 'when unparsable object is given' do
      let(:string) { 'This is unparsable object' }
      it 'returns given argument' do
        expect(subject).to be string
      end
    end
  end
end

describe HoujinBangou::Util::Number do
  describe '::decode' do
    subject { HoujinBangou::Util::Number.decode(string) }

    context 'when number string is given' do
      let(:string) { '123' }
      it 'returns Fixnum instance' do
        expect(subject).to eq Integer(string)
      end
    end

    context 'when NaN string is given' do
      let(:string) { 'This is NaN string' }
      it 'returns given argument' do
        expect(subject).to be string
      end
    end
  end
end
