#!/usr/bin/env ruby
#################################################################
## For author info, scroll to the end of this file.
#################################################################


#################################################################
## Load Modules
require 'pathname'
#################################################################


#################################################################
## Load the colorize gem, and define the "hilite" function
begin
  require 'rubygems' 
  require 'colorize'
  # Colourized hilite...
  class String
    def hilite(query)
      self.to_s.gsub(/(.*)(#{query})(.*)/) { $1.green + $2.black.on_yellow + $3.green }
    end
  end
rescue LoadError
  STDERR.puts "Note: You should install the 'colorize' gem for extra prettiness.\n"
  # Monochrome hilite does nothing...
  class String
    def hilite(query); self; end
  end
end
#################################################################


#################################################################
## Display Help (if requested)
if ["--help", "-h"].include?(ARGV[0])
  puts DATA.read
  exit
end
#################################################################


#################################################################
## Parse Commandline
query = Regexp.new(Regexp.escape(ARGV.any? ? ARGV.shift : ""), Regexp::IGNORECASE)
roots = (ARGV.any? ? ARGV : ['.']).select { |path| File.directory? path }
#################################################################


#################################################################
## Search/display files
def breadth_first_scan(root, &block)
  children = Pathname(root).children.sort
  children.each { |child| yield child } # breadth
  children.each { |child| breadth_first_scan(child, &block) if child.directory? }
end

roots.each do |root|
  breadth_first_scan(root) do |path|
    dirname, filename = File.split(path)
    puts "#{dirname}/#{filename.hilite(query)}" if filename =~ query
  end
end
#################################################################


#################################################################
## Help message (will be put in the DATA array)
__END__
"f" (c) 2002-2008 by Chris Gahan (chris@ill-logic.com)

Usage:
  f                         => recursively list all files in current directory
  f <search string>         => recursively list all files in current directory
                               containing <search string>
  f <search string> <paths> => recursively list all files in <paths>
                               containing <search string>

(Note: To colorize the search results, install the "colorize" gem.)

