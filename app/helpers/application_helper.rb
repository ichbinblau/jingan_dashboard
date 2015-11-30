# encoding: utf-8
module ApplicationHelper
  # get_ecimg_url( :imagename =>@item_info["ImageCover"], :width=>480)
  def get_ecimg_url( para )
    # Rails.logger.info para.inspect
    fix = ""
    fix +=  para[:width].blank?  ? "_0" : "_#{para[:width]}"
    fix +=  para[:height].blank?  ? "x0" : "x#{para[:height]}"

    imgname_arr = para[:imagename].split('.')
    "http://is.hudongka.com/#{imgname_arr[0]}#{fix}.#{imgname_arr[1]}"
  end
  def get_ecimg_tag( imagename , width = 80 , height = 0 )
    "<a href='http://is.hudongka.com/#{imagename}' targe='_blank'><img src='#{get_ecimg_url( :imagename => imagename, :width=> width, :height=> height )}'/></a>"
  end

  def getNowIds( param , nowid , group )
    return nowid if params[param].blank?
    nowids = params[param].split(",")
    # Rails.logger.info group.inspect
    # Rails.logger.info "start " + nowids.inspect
    nowids.delete_if{|x| !group.collect{|y| y.id.to_s }.index(x).nil? && nowid != x  }
    # Rails.logger.info "end " + nowids.inspect
    if nowids.index(nowid).nil?
      nowids.push(nowid)
    else
      nowids.delete(nowid) 
    end
    return nowids.join(",")
  end
  def isActive( param , nowid )
    params[param] = @sort_id.to_s if params[param].blank? && !@sort_id.blank?
    return !params[param].split(",").index(nowid.to_s).nil? unless params[param].blank?
  end
  def getZHNumber(number)
    number = number.to_i
    result = ""
    numberBArr = ["","一","二","三","四","五","六","七","八","九","十"]
    if number <= 10 and number > 0
      result = numberBArr[number]
    elsif number >10 and number < 20
      result = numberBArr[10]+numberBArr[number.to_s[1].to_i]
    elsif number >=20 and number < 100
      result = numberBArr[number.to_s[0].to_i]+numberBArr[10]+numberBArr[number.to_s[1].to_i]
    end
    return result
  end

end
