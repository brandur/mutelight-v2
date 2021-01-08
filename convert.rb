require 'time'
require 'toml'

class Time
  def to_toml(x)
    # self.to_datetime.rfc3339
    self.to_datetime.iso8601
  end
end

Dir["./articles/*.rb"].each do |meta_file|
  puts "reading: #{meta_file}"
  meta_data = File.read(meta_file)
  meta = eval(meta_data)

  extless_file = File.basename(meta_file).delete_suffix(File.extname(meta_file))

  md_file = "./articles/#{extless_file}.md"
  puts "reading: #{md_file}"
  md_data = File.read(md_file).strip


  toml_data = TOML::Generator.new(meta).body.strip

  converted_data = <<~EOS
+++
#{toml_data}
+++

#{md_data}
  EOS

  combined_file = "./converted/#{extless_file}.md"
  puts "writing: #{md_file}"
  File.write(combined_file, converted_data)
end
