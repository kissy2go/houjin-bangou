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
end
