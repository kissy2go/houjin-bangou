module HoujinBangou
  module Command
    class Num
      def initialize(argv)
        @argv = argv
      end

      def execute!
        parse_opt!

        HoujinBangou.application_id = @option.delete(:application_id)
        formatter = @option.delete(:format)

        result = HoujinBangou::Num.search(@numbers, @option)
        output_header formatter
        result.each do |record|
          output(formatter, record)
        end
      end

      private

      def parse_opt!
        @option = {
          application_id: ENV['HOUJIN_BANGOU_APPLICATION_ID'],
          format: 'json',
        }

        opt = OptionParser.new do |opt|
          opt.on '--application-id=VALUE', 'Application ID' do |v|
            @option[:application_id] = v
          end

          opt.on '--[no-]history', 'includes update histories' do |v|
            @option[:history] = '1' if v
          end

          opt.on '--format=VALUE', 'output format' do |v|
            @option[:format] = v
          end
        end

        @numbers = opt.parse!(@argv)
      end

      def output_header(formatter)
        case formatter
        when /\Acsv\Z/
          puts HoujinBangou::ResultSet::Record.members.to_csv
        end
      end

      def output(formatter, record)
        value =
          case formatter
          when /\Acsv\Z/
            record.to_a.to_csv
          else
            JSON.pretty_generate(record.to_h)
          end
        puts value
      end
    end
  end
end
