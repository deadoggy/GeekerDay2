#coding=utf-8

class DataOperator

  $RealDataFileName = "../real.data"
  $IndexDataFileName = "../index.data"
  $INDEX_WIDTH = 30

  def initialize
    #空行的定义
    @mEmptyIndexRecord = ""
    (1...50).each do
      @mEmptyIndexRecord += 0.to_s
    end
      @mEmptyIndexRecord += "\n"
    #FreeTable
    @mFreeTable = []
  end

  #获取一个记录
  def get(id)
    indexRecord = searchIndexRecordById(id)
    #没找到
    if indexRecord.nil? then return nil end
    #找到了
    dataFile = File.new($RealDataFileName, "r")
    a = indexRecord[1].to_i
    dataFile.seek(a)
    realRecord = dataFile.gets
    ret = [id]
    ret += realRecord.split("|-")
  end

  #获取list里面所有的记录
  def getList(ids)
    ret = []
    ids.each do |id| ret += get(id) end
    return ret
  end

  #更新一个记录，返回新的记录
  def update(oldId, newContent)

  end

  #删除一个记录
  def delete(id)
    delInfo = searchIndexRecordById(id)
    #更新freeTable
    @mFreeTable << [delInfo[1].to_i, delInfo[2].to_i]
    #删除IndexFile中对应的记录
    indexFile = File.new($IndexDataFileName, "w")
    indexFile.seek(delInfo[3] * $INDEX_WIDTH)
    indexFile.syswrite(@mEmptyIndexRecord)

  end

  #插入一个新的记录
  def insert(newContent)

  end

  #根据id从index文件中定位一个index记录
  def searchIndexRecordById(id)
    indexFile = File.new($IndexDataFileName, "r")
    currentPos = id

    #方向 0->begin -1->up 1->down
    direct = 0
    #根据id上下移动精确定位
    while true
      #读取文件
      indexFile.seek(currentPos * $INDEX_WIDTH)
      indexRecord = indexFile.gets
      if indexRecord.nil? then
        return nil
      end
      #空行跳过
      if (indexRecord<=>@mEmptyIndexRecord)==0 then
        currentPos += direct >=0 ? 1 : -1;
        next
      end
      #找目标行
      targetId = indexRecord.split("|")[0].to_i

      if targetId == id then
        indexFile.close
        return indexRecord.split("|") << currentPos
      elsif targetId > id then
        #方向相反， 返回nil
        if direct > 0 then indexFile.close; return nil end
        #更新位置和方向
        direct = direct < 0 ? direct : -1
        currentPos -= 1
      elsif targetId < id then
        #方向相反，返回nil
        if direct < 0 then indexFile.close; return nil end
        #更新位置和方向
        direct = direct > 0 ? direct : 1
        currentPos += 1
      end
    end

  end

end


op = DataOperator.new

test =op.get(100000000)

puts test