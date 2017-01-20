module HoujinBangou
  def self.APIEndpoint(path)
    Module.new do |m|
      define_method :endpoint_url do
        URI.parse(HoujinBangou.base_url + path)
      end
    end
  end

  module Num
    extend HoujinBangou::APIEndpoint('/num')

    RESPONSE_TYPE = '01' # CSV 形式 / Shift-JIS (JIS 第一及び第二水準)

    def self.search(number, history: nil)
      query = {}
      query[:number]  = Array[*number].join(',')
      query[:history] = history unless history.nil?
      query[:type]    = RESPONSE_TYPE

      HoujinBangou.request(endpoint_url, query)
    end
  end

  module Diff
    extend HoujinBangou::APIEndpoint('/diff')

    KIND_COUNTRY         = '01' # 国の機関
    KIND_LOCAL_GOVEMENTS = '02' # 地方公共団体
    KIND_HOUJIN          = '03' # 設立登記法人
    KIND_ETC             = '04' # 外国会社等・その他

    RESPONSE_TYPE = '01' # CSV 形式 / Shift-JIS (JIS 第一及び第二水準)

    def self.search(from, to, address: nil, kind: nil, divide: nil)
      query = {}
      query[:from]    = HoujinBangou::Util::Date.encode(from)
      query[:to]      = HoujinBangou::Util::Date.encode(to)
      query[:address] = address                unless address.nil?
      query[:kind]    = Array[*kind].join(',') unless kind.nil?
      query[:divide]  = divide                 unless divide.nil?
      query[:type]    = RESPONSE_TYPE

      HoujinBangou.request(endpoint_url, query)
    end
  end
end
