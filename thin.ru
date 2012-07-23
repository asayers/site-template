map "/" do
  run Rack::Directory.new('./site')
end
