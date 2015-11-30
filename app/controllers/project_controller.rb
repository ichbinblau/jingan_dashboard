require 'digest/md5'
require 'json'
require 'rexml/document'
class ProjectController < ApplicationController
def index

	# 当进入admin管理域名时，直接转向到 /admin 目录下，不显示首页
	if request.host == "admin.nowapp.cn"
		redirect_to "/admin/"
		return
	end
	if request.host == "cloudapi.nowapp.cn"
		redirect_to "/webapis/wiki/index"
		return
	end

	redirect_to "/webapps/262428996/"
	return 

	@cmsSorts = CmsSort.where("project_info_id = ? and father_id = ?",27,0)
	cmsSortInfos = @cmsSorts
	@cmsSortInfos = []
	@sort1 = []
	@sort2 = []
	@sortNum = []
	@images = []
	# @sorts = {:xxx =>{},:xxx1 =>{},:xxx2 =>{}}
	if !cmsSortInfos.blank?
		cmsSortInfos.each do |cmsSortInfo|
			mcmsSortInfos = {:id =>cmsSortInfo[:id],:name =>cmsSortInfo[:name],:cnname =>cmsSortInfo[:cnname]}
			Rails.logger.info("eclogger: cmsSortInfo-----------------"+cmsSortInfo[:cnname]+",id:"+cmsSortInfo[:id].to_s)	
		# @sorts[:xxx1] = CmsSort.where("project_info_id = ? and father_id = ?",27,cmsSortInfo[:id])
		@cmsSortInfos.push(mcmsSortInfos)
		end

	end

	sort1= CmsSort.where("project_info_id = ? and father_id = ?",27,14)
	sort1.each do |sortsTitle|
		sort1Infos = {:id =>sortsTitle[:id],:name =>sortsTitle[:name],:cnname =>sortsTitle[:cnname]}
		Rails.logger.info("eclogger: sortsTitle"+sortsTitle[:cnname]+",name"+sortsTitle[:name]+",id:"+sortsTitle[:id].to_s)
		sortNum = {:id =>sortsTitle[:id]}
		sort2 = CmsContent.find( :all, :include => :cms_sorts, :order => "order_level DESC",:conditions => "cms_sorts.id = #{sortsTitle[:id]}" )
		Rails.logger.info("eclogger: sort2-----------------"+sort2.length.to_s)
		if !sort2.blank? 
			i = 1
			sort2.each do |sort2Title|
				#首页轮询大图
				if sort2Title[:is_bigimage].to_s == "true"
					Rails.logger.info("eclogger: sort2Title[:is_bigimage]-----------------"+sort2Title[:is_bigimage].to_s+"sort2Title[:image_cover]"+sort2Title[:image_cover].to_s)
					image = {:image_cover => sort2Title[:image_cover]}
					@images.push(image)
				end	
				if i<4
					Rails.logger.info("eclogger: i-----------------"+i.to_s)
					if sort2Title[:abstract].length > 20
						result = sort2Title[:abstract][0, 20]
						result += "..."
						Rails.logger.info("eclogger: result-----------------"+result.to_s)
					else
						result = sort2Title[:abstract]
					end

					# @sort2.push(sort2Infos)

					if sort2Title[:title].length > 13
					   title = sort2Title[:title][0, 13]
					   Rails.logger.info("eclogger: result-----------------"+result.to_s)
					else
						title = sort2Title[:title]
					end
					sort2Infos = {:sort1Id => sortsTitle[:id],:id => sort2Title[:id],:title => title,:content =>sort2Title[:content],:abstract => result,:image_cover => sort2Title[:image_cover]}
					Rails.logger.info("eclogger: sort1Id-----------------"+sortsTitle[:id].to_s)
					Rails.logger.info("eclogger: title-----------------"+sort2Title[:title].to_s)
					Rails.logger.info("eclogger: content-----------------"+sort2Title[:content].to_s)
					Rails.logger.info("eclogger: image_cover-----------------"+sort2Title[:image_cover].to_s)
					@sort2.push(sort2Infos)
				end
				i = i+1
			end
			@sort1.push(sort1Infos)
		end
	end
	respond_to do |format|
		format.html
		format.json{ render :json => @cmsSortInfos}
	end
end

def product
	Rails.logger.info("eclogger: params[:contentId]-----------------"+params[:contentId].to_s)	
	@cmsSorts = CmsSort.where("project_info_id = ? and father_id = ?",27,0)
	cmsSortInfos = @cmsSorts
	@cmsSortInfos = []
	@sort1 = []
	@sort2 = []
	@sort3 = []
	@sortNum = []
	@contentInfoSort = []
	@selectContent = []
	# @sorts = {:xxx =>{},:xxx1 =>{},:xxx2 =>{}}
	if !cmsSortInfos.blank?
		cmsSortInfos.each do |cmsSortInfo|
			mcmsSortInfos = {:id =>cmsSortInfo[:id],:name =>cmsSortInfo[:name],:cnname =>cmsSortInfo[:cnname]}
			Rails.logger.info("eclogger: mcmsSortInfos-----------------"+cmsSortInfo[:cnname]+",id:"+cmsSortInfo[:id].to_s)	
		# @sorts[:xxx1] = CmsSort.where("project_info_id = ? and father_id = ?",27,cmsSortInfo[:id])
		@cmsSortInfos.push(mcmsSortInfos)
		end

	end

	sort1= CmsSort.where("project_info_id = ? and father_id = ?",27,19)
	sort1.each do |sortsTitle|

		if sortsTitle[:cnname].length > 10
			cnname = sortsTitle[:cnname][0, 10]
			Rails.logger.info("eclogger: cnname-----------------"+cnname.to_s)
		else
			cnname = sortsTitle[:cnname]
		end

		sort1Infos = {:id =>sortsTitle[:id],:name =>sortsTitle[:name],:cnname =>cnname}
		Rails.logger.info("eclogger: sortsTitle--------------"+sortsTitle[:cnname]+",id:"+sortsTitle[:id].to_s)
		# sortNum = {:id =>sortsTitle[:id]}
		# # sort2 = Client.join('LEFT OUTER JOIN cms_contents_cms_sorts ON cms_contents_cms_sorts.cms_content_id = cms_contents.id where cms_contents_cms_sorts.cms_sort_id = ?',sortsTitle[:id])
		# 	sort3= CmsSort.where("project_info_id = ? and father_id = ?",27,sortsTitle[:id])
		# 		sort3.each do |sort3Title|
		# 					# contents = CmsContent.cms_sort.where(:id => sortsTitle[:id])
		# 				sort3Infos = {:id =>sort3Title[:id],:name =>sort3Title[:name],:cnname =>sort3Title[:cnname]}
		# 				Rails.logger.info("eclogger: sort3Title----------------"+sort3Title[:cnname]+",id:"+sort3Title[:id].to_s)
						
		# 				# puts contents.to_s
		# 				# return 
				
		# 			@sort3.push(sort3Infos)

		# 		end
	
		@sort1.push(sort1Infos)
	end


	if !@sort1.blank? 
		@sort1.each do |sort1Title|
			contentInfoSort = CmsContent.find( :all, :include => :cms_sorts, :conditions => "cms_sorts.id = #{sort1Title[:id]}" )
			contentInfoSort.each do |content|
			contentInfo = {:sort1id => sort1Title[:id],:id => content[:id],:title =>content[:title],:abstract => content[:abstract],:content => content[:content],:image_cover => content[:image_cover]}
			Rails.logger.info("eclogger: title-----------------"+content[:title].to_s)
			Rails.logger.info("eclogger: content-----------------"+content[:content].to_s)
			Rails.logger.info("eclogger: image_cover-----------------"+content[:image_cover].to_s)
			@contentInfoSort.push(contentInfo)
			end
		end
	end



	if params[:cmsSortId].blank?

		params[:cmsSortId] = @sort1[0][:id].to_s
	end

	if !params[:cmsSortId].blank?
		Rails.logger.info("eclogger:  params[:cmsSortId]-----------------"+ params[:cmsSortId].to_s)
		selectContent= CmsSort.where("id = ?",params[:cmsSortId])
		selectContent.each do |scontent|
				selectContent = {:id =>scontent[:id],:abstract =>scontent[:description]}
					Rails.logger.info("eclogger: selectContent-----------------"+scontent[:description].to_s)
				@selectContent.push(selectContent)
 		end
	end

	if !params[:contentId].blank?
		Rails.logger.info("eclogger:  params[:contentId]-----------------"+ params[:contentId].to_s)
		selectContent= CmsContent.where("id = ?",params[:contentId])

		selectContent.each do |scontent|
				selectContent = {:id =>scontent[:id],:abstract =>scontent[:content]}
				Rails.logger.info("eclogger: selectContent-----------------"+scontent[:abstract].to_s)
				@selectContent = []
				@selectContent.push(selectContent)
		end
	end

		# 			selectContent = {:id =>scontent[:id],:abstract =>scontent[:abstract]}
		# 				Rails.logger.info("eclogger: selectContent-----------------"+scontent[:abstract].to_s)
		# 			@selectContent.push(selectContent)
		# 	end
		# end

	# if params[:contentId].blank?
	# 	Rails.logger.info("eclogger: sort3[0][:id]-----------------"+@sort1[0][:id].to_s)
	# 	params[:contentId] =@sort1[0][:id].to_s
	# end

	# if !params[:contentId].blank?
	# 	contentInfoSort = CmsContent.find( :all, :include => :cms_sorts, :conditions => "cms_sorts.id = #{params[:contentId]}" )
	# 	Rails.logger.info("eclogger: selectContentInfoSort-----------------"+contentInfoSort.length.to_s)
	# 	if !contentInfoSort.blank? 
	# 		contentInfoSort.each do |content|
	# 			contentInfo = {:sort1id => sort1Title[:id],:id => content[:id],:title =>content[:title],:abstract => content[:abstract],:content => content[:content],:image_cover => content[:image_cover]}
	# 			Rails.logger.info("eclogger: selectTitle-----------------"+content[:title].to_s)
	# 			Rails.logger.info("eclogger: selectContent-----------------"+content[:content].to_s)
	# 			Rails.logger.info("eclogger: selectImage_cover-----------------"+content[:image_cover].to_s)
	# 			@contentInfoSort.push(contentInfo)
	# 		end
	# 	end
	# end
		# if params[:contentId].blank?
		# 	Rails.logger.info("eclogger: sort3[0][:id]-----------------"+@sort1[0][:id].to_s)
		# 	params[:contentId] =@sort1[0][:id].to_s
		# end

		# if !params[:contentId].blank?
		# 	contentInfoSort = CmsContent.find( :all, :include => :cms_sorts, :conditions => "cms_sorts.id = #{params[:contentId]}" )
		# 	Rails.logger.info("eclogger: selectContentInfoSort-----------------"+contentInfoSort.length.to_s)
		# 	if !contentInfoSort.blank? 
		# 		contentInfoSort.each do |content|
		# 			contentInfo = {:sort1id => sort1Title[:id],:id => content[:id],:title =>content[:title],:abstract => content[:abstract],:content => content[:content],:image_cover => content[:image_cover]}
		# 			Rails.logger.info("eclogger: selectTitle-----------------"+content[:title].to_s)
		# 			Rails.logger.info("eclogger: selectContent-----------------"+content[:content].to_s)
		# 			Rails.logger.info("eclogger: selectImage_cover-----------------"+content[:image_cover].to_s)
		# 			@contentInfoSort.push(contentInfo)
		# 		end
		# 	end
		# end
end
def example	

	Rails.logger.info("eclogger: params[:content]-----------------"+params[:content].to_s)	

	@examples = []
	@cmsSorts = CmsSort.where("project_info_id = ? and father_id = ?",27,0)
	cmsSortInfos = @cmsSorts
	@cmsSortInfos = []
	@sort1 = []
	@sort2 = []
	@projectApp = []
	@sortNum = []
	@contentInfoSort = []
	@selectContentId = 0
	# @sorts = {:xxx =>{},:xxx1 =>{},:xxx2 =>{}}
	if !cmsSortInfos.blank?
		cmsSortInfos.each do |cmsSortInfo|
			mcmsSortInfos = {:id =>cmsSortInfo[:id],:name =>cmsSortInfo[:name],:cnname =>cmsSortInfo[:cnname]}
			Rails.logger.info("eclogger: cmsSortInfo-----------------"+cmsSortInfo[:cnname]+",id:"+cmsSortInfo[:id].to_s)	
		# @sorts[:xxx1] = CmsSort.where("project_info_id = ? and father_id = ?",27,cmsSortInfo[:id])
		@cmsSortInfos.push(mcmsSortInfos)
		end
	end

	sort1= CmsSort.where("project_info_id = ? and father_id = ?",27,23)
	if !sort1.blank?
		sort1.each do |sortsTitle|
			sort1Infos = {:id =>sortsTitle[:id],:name =>sortsTitle[:name],:cnname =>sortsTitle[:cnname]}
			Rails.logger.info("eclogger: sortsTitle"+sortsTitle[:cnname]+",id:"+sortsTitle[:id].to_s)
			@sort1.push(sort1Infos)
		end
	end


	if !@sort1.blank? 
		@sort1.each do |sort1Title|
			contentInfoSort = CmsContent.find( :all, :include => :cms_sorts, :conditions => "cms_sorts.id = #{sort1Title[:id]}" )
			contentInfoSort.each do |content|
				contentInfo = {:sort1id => sort1Title[:id],:id => content[:id],:title =>content[:title],:content => content[:content]}
				Rails.logger.info("eclogger: title-----------------"+content[:title].to_s)
				Rails.logger.info("eclogger: content-----------------"+content[:content].to_s)
				@contentInfoSort.push(contentInfo)
			end
		end
	end
	
	#每页显示10个
	@local=10
	#初始偏移量，总便宜量为@offset*@local
	@offset=0
	#总数量 
	@count = 0
	if params[:off]!=nil
		@offset=@local*params[:off].to_i
		#根据参数修改偏移量
	end
	contentinfo = CmsContent.where( :id => params[:contentid])
	@selectContentId = contentinfo[0][:id]
	@count = contentinfo[0][:content].to_s.split(",").length
	if @count != 0
		@examples = ProjectApp.select("project_infos.* ,project_apps.* ").joins("left join project_infos on (project_apps.project_info_id = project_infos.id)").
					find( :all , :limit => @local ,:offset=> @offset, 
					:conditions => " project_apps.id in (#{contentinfo[0][:content]} )" )
	end

end



def about
	Rails.logger.info("eclogger: ------------------come-----------------")
	@cmsSorts = CmsSort.where("project_info_id = ? and father_id = ?",27,0)
	cmsSortInfos = @cmsSorts
	@cmsSortInfos = []
	@sort2 = []
	@selectContent = []

	if !cmsSortInfos.blank?
		cmsSortInfos.each do |cmsSortInfo|
			mcmsSortInfos = {:id =>cmsSortInfo[:id],:name =>cmsSortInfo[:name],:cnname =>cmsSortInfo[:cnname]}
			Rails.logger.info("eclogger: cmsSortInfo-----------------"+cmsSortInfo[:cnname]+",id:"+cmsSortInfo[:id].to_s)	
		# @sorts[:xxx1] = CmsSort.where("project_info_id = ? and father_id = ?",27,cmsSortInfo[:id])
		@cmsSortInfos.push(mcmsSortInfos)
		end
	end


	sort2 = CmsContent.find( :all, :include => :cms_sorts, :conditions => "cms_sorts.id = 27" )
	Rails.logger.info("eclogger: sort2-----------------"+sort2.length.to_s)
	if !sort2.blank? 
		sort2.each do |sort2Title|
			sort2Infos = {:id =>sort2Title[:id],:title =>sort2Title[:title],:abstract => sort2Title[:abstract],:content => sort2Title[:content],:image_cover => sort2Title[:image_cover]}
			Rails.logger.info("eclogger: title-----------------"+sort2Title[:title].to_s)
			Rails.logger.info("eclogger: content-----------------"+sort2Title[:content].to_s)
			Rails.logger.info("eclogger: content-----------------"+sort2Title[:image_cover].to_s)
			@sort2.push(sort2Infos)
		end
	end

	if params[:contentId].blank?
		params[:contentId] = @sort2[0][:id].to_s
	end

	if !params[:contentId].blank?
			Rails.logger.info("eclogger:  params[:contentId]-----------------"+ params[:contentId].to_s)
			selectContent= CmsContent.where("id = ?",params[:contentId])

			selectContent.each do |scontent|

					selectContent = {:id =>scontent[:id],:title =>scontent[:title],:content =>scontent[:content],:abstract =>scontent[:abstract]}
					Rails.logger.info("eclogger: selectContent-----------------"+scontent[:title].to_s)
					Rails.logger.info("eclogger: selectContent-----------------"+scontent[:content].to_s)
					@selectContent.push(selectContent)
			end
		end


end

def detail
	@cmsSorts = CmsSort.where("project_info_id = ? and father_id = ?",27,0)
	cmsSortInfos = @cmsSorts
	@cmsSortInfos = []
	@sort2 = []
	@selectContent = []
	@tempSortId = []
	if !cmsSortInfos.blank?
		cmsSortInfos.each do |cmsSortInfo|
			mcmsSortInfos = {:id =>cmsSortInfo[:id],:name =>cmsSortInfo[:name],:cnname =>cmsSortInfo[:cnname]}
			Rails.logger.info("eclogger: cmsSortInfo-----------------"+cmsSortInfo[:cnname]+",id:"+cmsSortInfo[:id].to_s)	
		# @sorts[:xxx1] = CmsSort.where("project_info_id = ? and father_id = ?",27,cmsSortInfo[:id])
		@cmsSortInfos.push(mcmsSortInfos)
		end
	end
	cmsSortId = {:cmsSortId => params[:cmsSortId]}
	@tempSortId.push(cmsSortId)
	Rails.logger.info("eclogger: params[:cmsSortId]-----------------"+params[:cmsSortId].to_s)	
		Rails.logger.info("eclogger: params[:contentId]-----------------"+params[:contentId].to_s)	

	sort2 = CmsContent.find( :all, :include => :cms_sorts, :conditions => "cms_sorts.id =  #{params[:cmsSortId]}" )
	Rails.logger.info("eclogger: sort2-----------------"+sort2.length.to_s)
	if !sort2.blank? 
		sort2.each do |sort2Title|
			if sort2Title[:title].length > 10
				title = sort2Title[:title][0, 10]
				Rails.logger.info("eclogger: title-----------------"+title.to_s)
			else
				title = sort2Title[:title]
			end
			sort2Infos = {:id =>sort2Title[:id],:title =>title,:abstract => sort2Title[:abstract],:content => sort2Title[:content],:image_cover => sort2Title[:image_cover]}
			Rails.logger.info("eclogger: title-----------------"+sort2Title[:title].to_s)
			Rails.logger.info("eclogger: content-----------------"+sort2Title[:content].to_s)
			Rails.logger.info("eclogger: content-----------------"+sort2Title[:image_cover].to_s)
			@sort2.push(sort2Infos)
		end
	end

	if !params[:contentId].blank?
			Rails.logger.info("eclogger:  params[:contentId]-----------------"+ params[:contentId].to_s)
			selectContent= CmsContent.where("id = ?",params[:contentId])

			selectContent.each do |scontent|
					if scontent[:title].length > 10
						title = scontent[:title][0, 10]
						Rails.logger.info("eclogger: title-----------------"+title.to_s)
					else
						title = scontent[:title]
					end
					selectContent = {:id =>scontent[:id],:title =>title,:contentTitle =>scontent[:title],:content =>scontent[:content],:abstract =>scontent[:abstract]}
					Rails.logger.info("eclogger: selectContent-----------------"+scontent[:title].to_s)
					Rails.logger.info("eclogger: selectContent-----------------"+scontent[:content].to_s)
					@selectContent.push(selectContent)
			end
	end
end


end