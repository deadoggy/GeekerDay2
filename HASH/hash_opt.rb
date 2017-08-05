#coding:utf-8
class HashOpt

  # here need 6
  def initialize
    @nameHT = Hash.new
    @phoneHT = Hash.new
    @mailHT=Hash.new
  end

  # inside need 6
  def readHash
    @nameHT = readSingleHT("nameHT")
    # @phoneHT = readSingleHT('../phoneHT')

    @phoneHT = readSingleHT("phoneHT")

    @mailHT = readSingleHT("mailHT")
  end

  # inside need 6
  def writeHash
    writeSingleHT("nameHT", @nameHT)
    writeSingleHT("phoneHT", @phoneHT)
    writeSingleHT("mailHT", @mailHT)
  end


  def printHash
    puts "name:"
    puts @nameHT                               # here puts

    puts "phone:"
    puts @phoneHT

    puts "mail:"
    puts @mailHT
  end

  # here ok
  def readSingleHT(path)
    hs = {}
    arr = IO.readlines(path)
    arr.each{|item|
      res = item.split(':')
      ids = []
      res[1].split(',').each {|id| ids<<id.to_i if not id == "\n" }
      hs[res[0]] = ids
    }
    return hs
  end

  def writeSingleHT(path,hs)
    aFile = File.open(path, 'w')

    hs.each{|key,value|
      aFile.syswrite(key+':')
      value.each {|id|
        aFile.syswrite(id.to_s+',')
      }
      aFile.syswrite("\n")
    }
  end


  # here ok telHash need implementation
  def telHash(str)
    num = str.to_i
    if str.include?"*"
      num = num*(10**(12-str.length))
    end
    ran1 = num/1000000000
    if ran1<13 or ran1>18 or ran1==14 or ran1==17
      return 0.to_s
    else
      ran2 = (num%1000000000)/10000
      return ran2.to_s
    end
  end

  def strHash(str)
    ans = 0
    leng = str.length
    (0...leng).each {|i|
      ans += (str[i].ord)*(9**(leng-i-1))
    }
    ans = ans % 100003
    return ans.to_s
  end

  def mailHash(str)
    ans = 0
    leng = str.length

    str_after = str.downcase
    (0...leng).each {|i|
      ans += (str_after[i].ord)*(9**(leng-i-1))
    }
    ans = ans % 100003
    return ans.to_s
  end


  # here need 1+6
  def generateHTs(id, item)
    generateNameHT(id, item[0])
    generatePhoneHT(id, item[1])
    generateMailHT(id, item[2])
  end

  def generateNameHT(id, name)
    hs_after = strHash(name)
    if @nameHT[hs_after] == nil
      @nameHT[hs_after]=[]
    end
    @nameHT[hs_after]<<id
  end

  def generatePhoneHT(id,phone)
    hs_after = telHash(phone)
    if @phoneHT[hs_after] == nil
      @phoneHT[hs_after]=[]
    end
    @phoneHT[hs_after]<<id
  end

  def generateMailHT(id, mail)
    hs_after = mailHash(mail)
    if @mailHT[hs_after] == nil
      @mailHT[hs_after]=[]
    end
    @mailHT[hs_after]<<id
  end


  # here need 6
  def getIdsUsingHash(kind, str)
    if kind == '姓名'
      temp_hs = strHash(str)
      ans = @nameHT[temp_hs]
      if ans == nil
        return []
      else
        return ans
      end
    elsif kind == '电话'
      temp_hs = telHash(str)
      ans = @phoneHT[temp_hs]
      if ans == nil
        ans =[]
      end
      puts ans
      if str.include?"*"
        temp_temp_hs = temp_hs.to_i+1
        temp_using = 0
        if temp_hs.to_i%10 == 0
          temp_using += 1
          if temp_hs.to_i % 100 ==0
            temp_using+=1
            if temp_hs.to_i % 1000 ==0
              temp_using+=1
              if temp_hs.to_i % 10000 == 0
                temp_using +=1
              end
            end
          end
        end
        (temp_temp_hs...(temp_temp_hs+10**temp_using)).each{|i|
          if not @phoneHT[i.to_s]==nil
            ans += @phoneHT[i.to_s]
          end
        }
      end
      if ans == nil
        return []
      else
        return ans
      end
    elsif kind == '邮箱'
      temp_hs = mailHash(str)
      ans = @mailHT[temp_hs]
      if ans == nil
        return []
      else
        return ans
      end
      # other hash opts
    end
  end

  # here ok
  def insertInHT(id, item)
    generateHTs(id, item)
  end

  # here need 6
  def deleteInHT(id,item)
    @nameHT[strHash(item[0])].delete(id)
    @phoneHT[telHash(item[1])].delete(id)
    @mailHT[mailHash(item[2])].delete(id)
  end

  def updateInHT(id,item_before,item_after)
    deleteInHT(id, item_before)
    insertInHT(id, item_after)
  end

end

hsOpt = HashOpt.new
# hsOpt.readHash
# hsOpt.printHash

hsOpt.insertInHT(4,['张晓梅4', '13452463453','asduasld@mail.com2'])
hsOpt.printHash

# hsOpt.deleteInHT(4,['张晓梅4', '13452463453451','asduasld@mail.com2'])
# hsOpt.printHash
#
# hsOpt.updateInHT(3,['张晓梅4', '13452463453454','asduasld@mail.com4'],['张晓梅5', '13452463453455','asduasld@mail.com5'])
# hsOpt.printHash

# puts hsOpt.getIdsUsingHash("姓名","张晓梅2")
# hsOpt.writeHash
# puts hsOpt.strHash("QQWEQWEQWE@QWE")
# puts hsOpt.strHash("qqweqweqwe@qwe")
# puts hsOpt.strHash('张晓梅1')

# hsOpt.generateHTs(0,['张晓梅1', '13452463453451','asduasld@mail.com1'])
# hsOpt.generateHTs(1,['张晓梅2', '13452463453452','asduasld@mail.com2'])
# hsOpt.generateHTs(2,['张晓梅3', '13452463453453','asduasld@mail.com3'])
# hsOpt.generateHTs(3,['张晓梅4', '13452463453454','asduasld@mail.com4'])
#
# hsOpt.writeHash

# hs = Hash.new
# if hs["ds"] == nil
#   hs["ds"]=[]
#   puts "empty"
# end
#
# hs["ds"]<<11
# hs["ds"]<<11
# hs["ds"]<<11
#
# puts hs["ds"][0]
puts hsOpt.getIdsUsingHash("电话","134*")