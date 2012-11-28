#!/usr/bin/env ruby
##############################################################################
require 'coderay'
##############################################################################


##############################################################################

def lesspipe(*args)
  if args.any? and args.last.is_a?(Hash)
    options = args.pop
  else
    options = {}
  end
  
  output = args.first if args.any?
  
  params = []
  params << "-R" unless options[:color] == false
  params << "-S" unless options[:wrap] == true
  params << "-F" unless options[:always] == true
  if options[:tail] == true
    params << "+\\>"
    $stderr.puts "Seeking to end of stream..."
  end
  params << "-X"
  
  IO.popen("less #{params * ' '}", "w") do |less|
    if output
      less.puts output
    else
      yield less
    end
  end
  
rescue Errno::EPIPE, Interrupt
  # less just quit -- eat the exception.
end

##############################################################################

def render(arg)
  if arg == $stdin
    CodeRay.scan($stdin).term
  elsif File.exists? arg
    if %w[.md .markdown].include? File.extname(arg)
      render_markdown(File.read arg)
    else
      CodeRay.scan_file(arg).term
    end
  else
    "\e[31m\e[1mFile not found.\e[0m"
  end
end

##############################################################################

def render_markdown(data)
  # Lazily load markdown renderer
  eval DATA.read

  carpet = Redcarpet::Markdown.new(BlackCarpet, :fenced_code_blocks=>true)
  carpet.render(data)
end


##############################################################################

args = ARGV

lesspipe(:wrap=>true) do |less|
  case args.size
  when 0
    less.puts render($stdin)
  when 1
    less.puts render(args.first)
  else # 2 or more args
    args.each do |arg|
      less.puts "\e[30m\e[1m=== \e[0m\e[36m\e[1m#{arg} \e[0m\e[30m\e[1m==============\e[0m"
      less.puts
      less.puts render(arg)
      less.puts
    end
  end
end


### Markdown ANSI Renderer ("BlackCarpet") #######################################
__END__

require 'epitools/colored'
require 'redcarpet'

def indented?(text)
  indent_sizes = text.lines.map{ |line| if line =~ /^(\s+)/ then $1 else '' end }.map(&:size)
  indent_sizes.all? {|dent| dent > 0 }  
end

def unwrap(text)
  return text unless indented? text
  text.lines.to_a.map(&:strip).join ' '
end

def indent(text,amount=2)
  text.lines.map{|line| " "*amount + line }.join("\n")
end

class BlackCarpet < Redcarpet::Render::Base

  def normal_text(text)
    text
  end

  def raw_html(html)
    ''
  end
  
  def link(link, title, content)
    unless content[/^Back /]
      content
    end
  end
  
  def block_code(code, language)
    language ||= :ruby
    "#{indent CodeRay.scan(code, language).term}\n"
  end
  
  def block_quote(text)
    indent paragraph(text)
  end

  def codespan(code)
    code.cyan
  end

  def header(title, level)
    color = case level
      when 1 then :light_yellow
      when 2 then :light_cyan
      when 3 then :light_blue
    end
    
    bar = ("-"*(title.size+4)).grey
    
    "#{bar}\n  #{title.send(color)}\n#{bar}\n\n"    
  end

  def double_emphasis(text)
    text.light_green
  end

  def emphasis(text)
    text.green
  end

  def linebreak
    "\n"
  end

  def paragraph(text)
    "#{indented?(text) ? text : unwrap(text)}\n\n"
  end

  def list(content, list_type)
    case list_type
    when :ordered
      @counter = 0
      "#{content}\n"
    when :unordered
      "#{content}\n"
    end
  end

  def list_item(content, list_type)
    case list_type
    when :ordered
      @counter ||= 0
      @counter += 1
      "  <8>#{@counter}.</8> #{content.strip}\n".colorize
    when :unordered
      "  <8>*</8> #{content.strip}\n".colorize
    end
  end
end
