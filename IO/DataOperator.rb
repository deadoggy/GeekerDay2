#coding=utf-8

class DataOperator

  $REAL_DATA_FILE_NAME = "../real.data"
  $INDEX_DATA_FILE_NAME = "../index.data"
  $FREE_TABLE_FILE_NAME = "../free.data"
  $INDEX_WIDTH = 30

  def initialize
    #空行的定义
    @mEmptyIndexRecord = ""
    (1...$INDEX_WIDTH).each do
      @mEmptyIndexRecord += 0.to_s
    end
      @mEmptyIndexRecord += "\n"
    #FreeTable
    @mFreeTable = []
    if File.exists?($FREE_TABLE_FILE_NAME) then
      freeTableFile = File.new($FREE_TABLE_FILE_NAME, "r")
      while nil != (line = freeTableFile.gets)
        @mFreeTable << [line.split("|")[0].to_i, line.split("|")[1].to_i]
      end
    end
  end

  #获取一个记录
  def get(id)
    fileSize = File.size($REAL_DATA_FILE_NAME)
    indexRecord = searchIndexRecordById(id)
    #没找到
    if indexRecord.nil? then return nil end
    #找到了
    dataFile = File.new($REAL_DATA_FILE_NAME, "r")
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

  #更新一个记录，返回新的记录id
  def update(oldId, newContent)
    if delete(oldId) then
      return insert(newContent)
    end
    return -1
  end

  #删除一个记录
  def delete(id)
    delInfo = searchIndexRecordById(id)
    if delInfo.nil? then
      return false
    end
    #更新freeTable
    @mFreeTable << [delInfo[1].to_i, delInfo[2].to_i]
    #删除IndexFile中对应的记录
    indexFile = File.new($INDEX_DATA_FILE_NAME, "r+")
    indexFile.seek(delInfo[3] * $INDEX_WIDTH)
    indexFile.puts(@mEmptyIndexRecord)
    indexFile.close
    return true
  end

  #插入一个新的记录
  def insert(newContent)
    newContent = ArrToString(newContent)
    len = newContent.bytesize
    #获取新的ID
    newId = File.size($INDEX_DATA_FILE_NAME) / $INDEX_WIDTH
    start = File.size($REAL_DATA_FILE_NAME)
    minFreeSize = 1000000000
    minFreeStart = start

    #检查FreeTable是否有空余的空间
    @mFreeTable.each do |freeBlock|
      if len < freeBlock[1] and minFreeSize > freeBlock[1] then #如果有空余空间
        minFreeSize = freeBlock[1]
        minFreeStart = freeBlock[0]
      end
    end
    start = minFreeStart
    #更新freeTable
    if minFreeSize != 1000000000 then
      newFreeStart = minFreeStart + len
      newFreeSize = minFreeSize - len
      @mFreeTable.delete([minFreeStart, minFreeSize])
      if newFreeSize > 0 then
        @mFreeTable << [newFreeStart, newFreeSize]
      end
    end
    #更新index文件
    indexFile = File.new($INDEX_DATA_FILE_NAME, "a")
    indexFile.syswrite(genNewIndexRec(newId, start, len))
    indexFile.close
    #更新data文件
    dataFile = File.new($REAL_DATA_FILE_NAME, "r+")
    dataFile.seek(start)
    dataFile.syswrite(newContent)
    dataFile.close
    return newId
  end

  #根据id从index文件中定位一个index记录
  def searchIndexRecordById(id)
    indexFile = File.new($INDEX_DATA_FILE_NAME, "r")
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

  def genNewIndexRec(id, start, length)
    indexRecord = id.to_s + "|" + start.to_s + "|" + length.to_s + "\n"
    (0...$INDEX_WIDTH-indexRecord.length).each do indexRecord = 0.to_s + indexRecord end
    return indexRecord
  end

  def ArrToString(arr)

    ret = ""
    count = 0
    arr.each do
      |item|
      ret += item
      ret += count == 5 ? "\n" : "|-"
      count += 1
    end
    return ret
  end

  #关闭时保存freeTable状态
  def saveStatus
    freeTable = File.new($FREE_TABLE_FILE_NAME, "w")
    @mFreeTable.each do |i|
      freeTable.syswrite(i[0].to_s + "|"+i[1].to_s)
    end
    freeTable.close
  end
  

end


op = DataOperator.new

#先删除一个记录
#op.delete(3)
#在插入一个短的记录
test_data = ["n", "1", "d", "q", "w", "e"]
new_id = op.insert(test_data)
#再取出
new_con = op.get(new_id)
op.saveStatus

puts new_id