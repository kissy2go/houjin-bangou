module HoujinBangou
  class ResultSet
    include Enumerable

    attr_reader :header

    def initialize(response, src_encoding)
      dst_encoding = Encoding.default_internal || Encoding::UTF_8
      @csv_operator = CSV.new(response.encode(dst_encoding, src_encoding))
      @header = Header.new(*@csv_operator.readline)
    end

    def each(&block)
      return self.to_enum      unless block_given?
      return @csv.each(&block) unless @csv.nil?

      @csv = []
      @csv_operator.each do |row|
        @csv << record = Record.new(*row)
        yield record
      end
      @csv
    end

    class Header < ImmutableStruct.new(
        :last_update_date, # 最終更新年月日
        :count,            # 総件数
        :divide_number,    # 分割番号
        :divide_size       # 分割数
      )

      def initialize(*)
        super
        self[:last_update_date] = HoujinBangou::Util::Date.decode(last_update_date)
        self[:count]            = HoujinBangou::Util::Number.decode(count)
        self[:divide_number]    = HoujinBangou::Util::Number.decode(divide_number)
        self[:divide_size]      = HoujinBangou::Util::Number.decode(divide_size)
      end
    end

    class Record < ImmutableStruct.new(
        :sequence_number,            # 一連番号
        :corporate_number,           # 法人番号
        :process,                    # 処理区分
        :correct,                    # 訂正区分
        :update_date,                # 更新年月日
        :change_date,                # 変更年月日
        :name,                       # 商号又は名称
        :name_image_id,              # 商号又は名称イメージ ID
        :kind,                       # 法人種別
        :prefecture_name,            # 国内所在地 (都道府県)
        :city_name,                  # 国内所在地 (市区町村)
        :street_number,              # 国内所在地 (丁目番地等)
        :address_image_id,           # 国内所在地イメージ ID
        :prefecture_code,            # 都道府県コード
        :city_code,                  # 市区町村コード
        :post_code,                  # 郵便番号
        :address_outside,            # 国外所在地
        :address_outside_image_id,   # 国外所在地イメージ ID
        :close_date,                 # 登記記録の閉鎖等年月日
        :close_cause,                # 登記記録の閉鎖等の事由
        :successor_corporate_number, # 承継先法人番号
        :change_cause,               # 変更事由の詳細
        :assignment_date,            # 法人番号指定年月日
        :latest,                     # 最新履歴
        :en_name,                    # 商号又は名称 (英語表記)
        :en_prefecture_name,         # 国内所在地 (都道府県) (英語表記)
        :en_city_name,               # 国内所在地 (市区町村丁目番地等) (英語表記)
        :en_address_outside          # 国外所在地 (英語表記)
      )

      def initialize(*)
        super
        self[:sequence_number] = HoujinBangou::Util::Number.decode(sequence_number)
        self[:update_date]     = HoujinBangou::Util::Date.decode(update_date)
        self[:change_date]     = HoujinBangou::Util::Date.decode(change_date)
        self[:close_date]      = HoujinBangou::Util::Date.decode(close_date)
        self[:assignment_date] = HoujinBangou::Util::Date.decode(assignment_date)
        self[:latest]          = HoujinBangou::Util::Number.decode(latest)
      end
    end
  end
end
