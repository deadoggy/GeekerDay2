
index=0
=begin
IO.foreach("../real.data"){
  |line|
  puts line
  index+=1
  if index%10000==0 then
    puts index
  end
}
=end

file = File.new("../index.data")
file.seek(230 * 30)
a = file.gets.split("|")
data_f = File.new("../real.data")
data_f.seek(0)
e = data_f.gets
puts a
puts b
puts c