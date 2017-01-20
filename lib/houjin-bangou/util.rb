module HoujinBangou
  module Util
    module Date
      DATE_FORMAT = '%Y-%m-%d'

      def self.encode(date)
        date.strftime(DATE_FORMAT) rescue date
      end

      def self.decode(string)
        ::Date.strptime(string, DATE_FORMAT) rescue string
      end
    end

    module Number
      def self.decode(string)
        Integer(string) rescue string
      end
    end
  end
end
