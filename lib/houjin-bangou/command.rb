require 'optparse'
require 'json'

require 'houjin-bangou'
require 'houjin-bangou/command/num'
require 'houjin-bangou/command/diff'

module HoujinBangou
  module Command
    def self.execute!(argv)
      command =
        case argv.shift
        when 'num'  then Num.new(argv)
        when 'diff' then Diff.new(argv)
        else
        end
      command.execute!
    end
  end
end
