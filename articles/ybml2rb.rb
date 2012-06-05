require "yaml"
ymls = Dir["./**/*.yml"]
ymls.each do |yml|
  tree = YAML.parse(File.read(yml)).transform
  #p yml
  #puts yml['title']
  rb_str = "{\n"
  tree.each do |k, v|
    raise "quote in #{yml}!!!" if k.include?('"')
    if k == "published_at"
      rb_str += %{  #{k}: Time.parse("#{v}"),\n}
    elsif k == "permalink"
      rb_str += %{  slug: "#{v}",\n}
    elsif k == "tinylink"
      rb_str += %{  tiny_slug: "#{v}",\n}
    else
      rb_str += %{  #{k}: "#{v}",\n}
    end
  end
  rb_str += "}"
  File.open(yml.gsub(/\.yml$/, ".rb"), "w") { |f| f.puts(rb_str) }
end
