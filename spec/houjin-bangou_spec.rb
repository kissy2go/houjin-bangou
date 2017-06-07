require 'spec_helper'

describe HoujinBangou do
  let(:application_id) { HoujinBangou.application_id = 'this_is_test_app_id' }

  describe '::request' do
    subject { HoujinBangou.request(url, query, src_encoding: src_encoding) }

    let(:url)          { URI.parse('https://exempla.com/path/to/api') }
    let(:query)        { { arg1: 'arg1', arg2: 'args' } }
    let(:src_encoding) { Encoding::Shift_JIS }

    context 'when response is 2xx' do
      it 'returns HoujinBangou::ResultSet instance' do
        stub_houjin_bangou_request(url, application_id, query)
          .to_return(status: 200, body: 'OK')
        expect(HoujinBangou::ResultSet).to receive(:new)
          .with('OK', src_encoding)
          .and_return(:ok)
        expect(subject).to eq :ok
      end
    end

    context 'when response is 3xx' do
      it 'raises Net::HTTPRetriableError' do
        stub_houjin_bangou_request(url, application_id, query)
          .to_return(status: 302)
        expect { subject }.to raise_error Net::HTTPRetriableError
      end
    end

    context 'when response is 4xx' do
      it 'raises Net::HTTPServerException' do
        stub_houjin_bangou_request(url, application_id, query)
          .to_return(status: 404)
        expect { subject }.to raise_error Net::HTTPServerException
      end
    end

    context 'when response is 5xx' do
      it 'raises Net::HTTPFatalError' do
        stub_houjin_bangou_request(url, application_id, query)
          .to_return(status: 500)
        expect { subject }.to raise_error Net::HTTPFatalError
      end
    end

    private

    def stub_houjin_bangou_request(url, application_id, query)
      url = url.dup
      url.query = URI.encode_www_form({ id: application_id }.merge(query))
      stub_request(:get, url.to_s)
    end
  end

  describe 'health checking' do
    let(:re_record_interval) { 60 * 60 * 24 * 7 } # 7 days

    let(:vcr_options) do
      {
        re_record_interval: re_record_interval,
        match_requests_on: %i{ method uri },
        allow_unused_http_interactions: false,
      }
    end

    before { HoujinBangou.application_id = ENV['HOUJIN_BANGOU_APPLICATION_ID'] }

    describe "GET /2/num" do
      subject { HoujinBangou::Num.search(number) }

      let(:number) { '1180301018771' }

      it 'is OK' do
        VCR.use_cassette 'num', vcr_options do
          expect { subject }.not_to raise_error
        end
      end
    end

    describe "GET /2/diff" do
      subject { HoujinBangou::Diff.search(from, to) }

      let(:from) { '2017-01-01' }
      let(:to)   { '2017-01-10' }

      it 'is OK' do
        VCR.use_cassette 'diff', vcr_options do
          expect { subject }.not_to raise_error
        end
      end
    end
  end
end
