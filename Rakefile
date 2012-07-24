require 'colorize'
task default: "build"

def parse_slim src, dest
  require 'slim'
  Slim::Engine.set_default_options :pretty => true
  
  slimfile = File.open(src, "r")
  content = IO.read(src)
  slimfile.close
  m = Regexp.new(/^(---.*?---\s*|\s*)(.*)/m).match(content)
  htmlfile = File.new(dest, "w")
  htmlfile.write(m[1] + Tilt['slim'].new{m[2]}.render) 
  htmlfile.close
end

def build_layout src
  dest = src.sub(/layouts/, ".cache/_layouts").sub(/\.slim$/, ".html")
  if src =~ /\.slim$/
    puts "slim: ".green + src.split("/").last + " -> " + dest.split("/").last
    parse_slim src, dest
  else
    puts "cp: ".green + src.split("/").last + " -> " + dest.split("/").last
    system("cp #{src} #{dest}")
  end
end

def remove_layout src
  dest = src.sub(/layouts/, ".cache/_layouts").sub(/\.slim$/, ".html")
  puts "rm: ".red + src.split("/").last + " -> " + dest.split("/").last
  system("rm #{src} #{dest}")
end

def build_page src
  dest = src.sub(/pages/, ".cache/").sub(/\.slim$/, ".html")
  if src =~ /\.slim$/
    puts "slim: ".green + src.split("/").last + " -> " + dest.split("/").last
    parse_slim src, dest
  else
    puts "cp: ".green + src.split("/").last + " -> " + dest.split("/").last
    system("cp #{src} #{dest}")
  end
end

def remove_page src
  dest = src.sub(/pages/, ".cache/").sub(/\.slim$/, ".html")
  puts "rm: ".red + src.split("/").last + " -> " + dest.split("/").last
  system("rm #{src} #{dest}")
end

task :build do
  # Clean .cache
  puts "Cleaning .cache".blue
  system("rm -r .cache")
  # Set-up
  puts "Preparing".blue
  system("mkdir -p .cache/_layouts; mkdir site")
  system("cp jekyll.yml .cache/_config.yml")
  # cp/thin: layouts -> .cache/_layouts
  puts "Building layouts".blue
  Dir.glob("layouts/**/*") { |f| build_layout f }
  # cp/thin: pages -> .cache
  puts "Building pages".blue
  Dir.glob("pages/**/*") { |f| build_page f }
  # cp: images -> .cache/img
  puts "Copying images".blue
  system("mkdir .cache/img; cp -R images/* .cache/img/")
  # cp: javascripts -> .cache/js
  puts "Copying javascripts".blue
  system("mkdir .cache/js; cp -R javascripts/* .cache/js/")
  # compass: stylesheets -> .cache/css
  puts "Running Compass".blue
  system("mkdir .cache/css; compass compile -c compass.rb")
  # jekyll: .cache -> site
  puts "Running Jekyll".blue
  system("jekyll .cache site")
end

task :watch_pages do
  require 'listen'
  
  Listen.to("pages/") do |m, c, r|
    m.each { |f| build_page f }
    c.each { |f| build_page f }
    r.each { |f| remove_page f }
  end
end

task :watch_layouts do
  require 'listen'
  
  Listen.to("layouts/") do |m, c, r|
    m.each { |f| build_layout f }
    c.each { |f| build_layout f }
    r.each { |f| remove_layout f }
  end
end

task :watch_assets do
  require 'listen'
  
  Listen.to("images", "javascripts") do |m, c, r|
    m.each { |f| system("cp #{f} " + f.sub(/javascripts/, ".cache/js").sub(/images/, ".cache/img")) }
    c.each { |f| system("cp #{f} " + f.sub(/javascripts/, ".cache/js").sub(/images/, ".cache/img")) }
    r.each { |f| system("rm " + f.sub(/javascripts/, ".cache/js").sub(/images/, ".cache/img")) }
  end
end

task :watch do
  Rake::Task["build"].invoke
  system("foreman start")
end