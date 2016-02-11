require 'csv'
require 'optparse'
require 'ostruct'

TRAIN = '../data/train.csv'
TEST = '../data/test.csv'

class OptparseExample
  def self.parse(args)
    options = OpenStruct.new

    opt_parser = OptionParser.new do |opts|
      opts.banner = "Usage: categorical.rb [options]"

      opts.separator ""
      opts.separator "Specific options:"

      opts.on("-s", "--source SOURCE", "Source file") do |source|
        #options.source = source
        puts source
      end

      opts.separator ""
      opts.separator "Common options:"

      opts.on_tail("-h", "--help", "Show this message") do
        puts opts
        exit
      end
    end

    opt_parser.parse!(args)
    options
  end  # parse()

end  # class OptparseExample

options = OptparseExample.parse(ARGV)
