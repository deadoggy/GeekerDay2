#! /usr/bin/ruby -w
#! -*- coding: utf-8 -*-

## 获取hash表
require File.dirname(__FILE__) + "/query.rb"
## getlist 文件

def getList(id)
	return [[1, "张晓明"]]
	#return [[1,"张晓明","13331234123","dasd@gcaifu.com","深圳政府",'补胎','NULL']]
end
puts "请输入你要查询的命令> "
#cmd = "select(姓名='张晓明' and 电话='13331234123' and 邮箱='dasd@gcaifu.com' and 公司='深圳政府' and 部门='补胎' and 职位='NULL')" 
#cmd = gets()
cmd = "select(姓名='张晓明')"
arr_hash_table = ''
if cmd[0,6] == 'select'
	ret = getHashIdsByConds(cmd[6, cmd.length - 6], arr_hash_table)
	if(ret[0] == false)
		puts ret[1]
	else
		ar_id = ret[1]
		ar_cond_kv = ret[2]
		ar_item = getList(ar_id)
		count = 0
		s_output = ""
		arr_output = []
		ar_item.each do |item|
			 item.each do |column|
			 	if count != 0
			 		 if column == ar_cond_kv[item.index(column) - 1][1]
			 		 	s_output += column + " "
			 		 else
			 		 	s_output = ""
			 		 	break
			 		 end
			 		#print column, " "
			 	end
			 	count += 1
			 end
			 if s_output != ""
			 	arr_output << s_output
			 end
		end
		arr_output.each do |str_output|
			puts str_output
		end
	end
elsif cmd[0,6] = 'update'
	ar_id = getHashIdsByConds(cmd[6, cmd.length - 6], arr_hash_table)
elsif cmd[0,6] = 'delete'
	ar_id = getHashIdsByConds(cmd[6, cmd.length - 6], arr_hash_table)
elsif cmd[0,5] = 'count'
	ar_id = getHashIdsByConds(cmd[5, cmd.length - 5], arr_hash_table)
end

