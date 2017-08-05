#coding=utf-8

class DataInitializer

  INDEX_WIDTH = 30


  def initialize
    @mSourceDataFileName = "../card_person_new.data"

    @mTargetDataFileName = "../real.data"

    @mTargetIndexFileName = "../index.data"

  end

  def processData

    puts "threes files: "
    puts @mSourceDataFileName
    puts @mTargetDataFileName
    puts @mTargetIndexFileName

    targetFile = File.new(@mTargetDataFileName, "w")
    targetIndexFile = File.new(@mTargetIndexFileName, "w")
    #数据index 也是id
    index = 0
    #数据开始的字节数
    start = 0
    #处理文件
    IO.foreach(@mSourceDataFileName){
      |line|
      if index%10000==0 then
        puts "now: " + index.to_s
      end

      splRec = line.split("\t")
      #记录数据文件
      itemIndex = 0
      dataRecord = ""
      splRec.each do |recItem|
        dataRecord += recItem
        ##写数据文件的每一项
        if itemIndex <= 4 then
          dataRecord += "|-"
        end
        itemIndex += 1
      end



      targetFile.syswrite(dataRecord)

      #记录index
      indexRecord = index.to_s + "|" + start.to_s + "|" + dataRecord.bytes.length.to_s + "\n"
      if indexRecord.bytes.length < INDEX_WIDTH then
        ocSUm = INDEX_WIDTH-indexRecord.bytes.length
        (0...ocSUm).each do  indexRecord = 0.to_s + indexRecord end
      end
      targetIndexFile.syswrite(indexRecord)

      index += 1
      start += dataRecord.bytes.length
    }

    targetFile.close()
    targetIndexFile.close()
  end

end

dataInitializer = DataInitializer.new

dataInitializer.processData