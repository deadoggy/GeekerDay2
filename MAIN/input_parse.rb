#! /usr/bin/ruby -w
#! -*- coding: utf-8 -*-

require File.dirname(__FILE__) + "/query.rb"
## 获取hash表
require File.dirname(__FILE__) + "/../HASH/HashOpt.rb"
## getlist 文件
require File.dirname(__FILE__) + "/../IO/DataOperator.rb"
hash_opt = HashOpt.new
data_operator = DataOperator.new
#def getList(id)
	#return [[1, "张晓明"]]
	#return [[1,"张晓明","13331234123","dasd@gcaifu.com","深圳政府",'补胎','NULL']]
#end
puts "请输入你要查询的命令> "
#cmd = "select(姓名='张晓明' and 电话='13331234123' and 邮箱='dasd@gcaifu.com' and 公司='深圳政府' and 部门='补胎' and 职位='NULL')" 
cmd = gets
hash_opt = ''
if cmd[0,6] == 'select'
	ret = getHashIdsByConds(cmd[6, cmd.length - 6], hash_opt)
	if(ret[0] == false)
		puts ret[1]
		return
	else
		ar_id = ret[1]
		ar_cond_kv = ret[2]
		ar_item = data_operator.getList(ar_id)
		#ar_item = getList(ar_id)
		count = 0
		s_output = ""
		arr_output = []
		ar_item.each do |item|
			 if true == resultCheck(item, ar_cond_kv)
			 	item.each do |column|
			 		if count != 0
			 			s_output += column + " "
			 		end
			 		count += 1
			 	end
			 else
			 	next
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
	if cmd.index("set") == nil
		puts "没有set字段!"
		return
	else
		str_cond = cmd[0, cmd.index("set")]
		str_set = cmd[cmd.index("set"), cmd.length - cmd.index("set") - 3]
		set_ret = parseSetData(str_set)
		if set_ret[1] == false
			puts set_ret[2]
		else
			set_param = set_ret[2]
			cond_ret = getHashIdsByConds(cond_ret, hash_opt)
			ar_id = cond_ret[1]
			ar_cond_kv = cond_ret[2]
			ar_item = data_operator.getList(ar_id)
			#ar_item = getList(ar_id)
			ar_item.each do |item|
				if true == resultCheck(item, ar_cond_kv)
				count = 0
				item_new = []
			 	item.each do |column|
			 		if set_param[count] != nil
			 			item_new[count] = set_param[count]
			 		else
			 			item_new[count] = item[count]
			 		end
			 		count += 1
			 	end
			 	else
			 		next
				end 
				update_ret = data_operator.update(item[0], item_new[1,6])
				if -1 == update_ret
					puts "更新失败"
				else
					puts "更新成功"
					hash_opt.updateInHT(item[0], item[1,6], item_new[1,6])
				end
			end
		end
	end
elsif cmd[0,6] = 'delete'
	ret = getHashIdsByConds(cmd[6, cmd.length - 6], hash_opt)
	if(ret[0] == false)
		puts ret[1]
	else
		ar_id = ret[1]
		ar_cond_kv = ret[2]
		ar_item = data_operator.getList(ar_id)
		ar_item.each do |item|
			del_ret = data_operator.delete(item[0])
			if false == del_ret
				puts "删除失败"
			else
				puts "删除成功"
				hash_opt.deleteInHT(item[0], item[1, 6])
			end
		end
	end
elsif cmd[0,6] = 'insert'
	ar_id = ret[1]
	ar_cond_kv = ret[2]
	insert_ret = parseSetData(cmd[6, cmd.length - 6])
	if insert_ret[1] == false
		puts insert_ret[2]
	else
		ar_insert_item = insert_ret[2]
		count = 0
		ar_insert_item.each do |item|
			if nil == item
				ar_insert_item[count] = "NULL"
			end
			count += 1
		end
		insert_ret = data_operator.insert(ar_insert_item)
		if -1 == insert_ret
			puts "插入失败"
		else
			puts "插入成功"
			hash_opt.insertInHT(insert_ret,ar_insert_item)
		end
	end
elsif cmd[0,5] = 'count'
	ret = getHashIdsByConds(cmd[6, cmd.length - 6], hash_opt)
	if(ret[0] == false)
		puts ret[1]
		return
	else
		ar_id = ret[1]
		ar_cond_kv = ret[2]
		ar_item = data_operator.getList(ar_id)
		sum = 0
		count = 0
		s_output = ""
		arr_output = []
		ar_item.each do |item|
			 if true == resultCheck(item, ar_cond_kv)
			 	sum += 1
			 else
			 	next
			 end 
		end
		print sum, "个\n"
	end
end
