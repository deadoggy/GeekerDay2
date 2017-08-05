
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

a = gets

puts a