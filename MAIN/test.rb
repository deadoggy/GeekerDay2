#! /usr/bin/ruby -w
#! -*- coding: utf-8 -*-
require File.dirname(__FILE__) + "/query.rb"
# ar = []
# ar[2] = 3
# puts ar[2]
str = "(公司='小明')"
ar1 = parseSetData(str)
ar1 = ar1[1]
count = 0
ar1.each do |item|
	if item == nil
		puts "null"
	else
		puts item
	end
end