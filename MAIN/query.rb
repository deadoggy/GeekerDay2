#! /usr/bin/ruby -w
#! -*- coding: utf-8 -*-
require File.dirname(__FILE__) + '/test.rb'

def getIdsUsingHash(key, val)
	case key
	when "姓名"
		return [1,2,3]
	when "电话"
		return [1,5,6]
	when "邮箱"
		return [1,2,3]
	when "公司"
		return [1,5,6]
	when "部门"
		return [1,2,3]
	when "职位"
		return [1,5,6]
	end
end

def parsePhone(phone)
	if /[0-9]{11}/.match(phone) == nil
		return false
	else
		return true
	end
end

def parseEmail(email)
	pattern = /^(?=[a-zA-Z0-9][a-zA-Z0-9@._%+-]{5,253}$)[a-zA-Z0-9][a-zA-Z0-9._%+-]{0,63}@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,62}[a-zA-Z0-9])?\.){1,125}[a-zA-Z]{2,63}$/
	if pattern.match(email) == nil
		return false
	else
		return true
	end
end
def getKV(single_cond)
	single_cond = single_cond.strip
	if single_cond.index("=") == nil
	 	return false, "输入无效"
	end
	key = single_cond[0, single_cond.index("='")].strip
	value = single_cond[single_cond.index("=") + 1, single_cond.length - (single_cond.index("=") - 2)].strip
	value = value[/(?<=\').*?(?=\')/]
	if value == nil
		print "输入值没引号"
		return false, "输入值没引号"
	else
		return true, key, value
	end
end

def getHashIdsByConds(s_conds, obj_HashOpt)
	if s_conds[0] != '('
		return false, "条件符号错误：缺少("
	elsif s_conds[-1] != ')'
		return false, "条件符号错误：缺少)"
	else
		s_conds = s_conds[1,s_conds.length - 2]
		s_conds = s_conds.strip
	 	ar_id = []
	 	ar_key = ['姓名','电话','邮箱','公司','部门','职位']
	 	ar_kv = []
	 	count = 0
	 	ar_conds = s_conds.split(/and|or/)
	 	ar_conds.each do |cond|
	 		ar_ret = getKV(cond)
	 		if ar_ret[0] == false
	 			return ar_ret
	 		end
			if ar_key.include? ar_ret[1]
				if ar_ret[1] == "电话" && !parsePhone(ar_ret[2])
					return false, "电话格式错误"
				end
				if ar_ret[1] == "邮箱" && !parseEmail(ar_ret[2])
					return false, "邮箱格式错误"
				end 
				ar_kv[count] = [ar_ret[1], ar_ret[2]]
			else
				return false, "无效的字段:" + ar_ret[1] 
			end
			count += 1
		end
		#puts ar_kv
		pivot = 0
		ar_logic = []
		while pivot < s_conds.length
			if (pivot < s_conds.length - 3) && (s_conds[pivot,3] == 'and')
				ar_logic << 1
				pivot += 2
			elsif (pivot < s_conds.length - 3) && (s_conds[pivot,2] == 'or')
				ar_logic << 2
				pivot += 1
			end
			pivot += 1
		end
		#ar_id = obj_HashOpt.getIdsUsingHash(ar_kv[0][0], ar_kv[0][1])
		ar_id = getIdsUsingHash(ar_kv[0][0], ar_kv[0][1])
		count = 1
		ar_logic.each do |logic|
			if logic == 1
				ar_id = ar_id & getIdsUsingHash(ar_kv[count][0], ar_kv[count][1])
			else
				ar_id = ar_id | getIdsUsingHash(ar_kv[count][0], ar_kv[count][1])
			end
			count += 1
		end 
		return true, ar_id, ar_kv
	end
end

#puts getHashIdsByConds("(姓名 = '123' or 电话='12345')")
#puts getHashIdsByConds("(姓名 = '123' and 电话='12345')")
#puts getHashIdsByConds("(姓名 = '123' and 电话='12345' and 电话='12345' and 电话='12345')")		