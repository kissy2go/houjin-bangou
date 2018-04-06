module HoujinBangou
  module Command
    class Diff
      def initialize(options)
        @options = options
      end

      def execute!
        p @options
      end
    end
  end
end
