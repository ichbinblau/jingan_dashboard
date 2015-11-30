# encoding: utf-8
class Kf::Status < ActiveRecord::Base
	attr_accessible :date,:count_type,:status_type,:relation_id, :activeuser_count,  :course_fav_count,  :indexdone_count, :newmobileaccount_count, :newuser_count \
					,:activeuser_count_android,  :course_fav_count_android,  :indexdone_count_android, :newmobileaccount_count_android, :newuser_count_android \
					,:activeuser_count_ios,  :course_fav_count_ios,  :indexdone_count_ios, :newmobileaccount_count_ios, :newuser_count_ios
	before_validation :ensure_data
	protected
	def ensure_data
		sys_app_id = JSON.parse(Kf::GlobalConfig.where(:key => "sys_app_id").first.value)
		android_app_id = sys_app_id["android"]
		ios_app_id = sys_app_id["ios"]
		date = self.date

		if self.status_type == 1		#课程统计

			# 活跃用户
			self.activeuser_count_android = SlaveSysApiCallLog.joins(" log left join kf_course_user_favs fav on (log.user_info_id = fav.user_info_id and fav.kf_course_id = #{self.relation_id}) ") \
									.where("fav.kf_course_id > 0 AND ( method = 'users/courses/indices/byday') and project_app_id = '#{android_app_id}' AND log.updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'") \
									.count("log.user_info_id" , :distinct =>true)
			self.activeuser_count_ios = SlaveSysApiCallLog.joins(" log left join kf_course_user_favs fav on (log.user_info_id = fav.user_info_id and fav.kf_course_id = #{self.relation_id}) ") \
									.where("fav.kf_course_id > 0 AND ( method = 'users/courses/indices/byday') and project_app_id = '#{ios_app_id}' AND log.updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'") \
									.count("log.user_info_id" , :distinct =>true)
			self.activeuser_count = self.activeuser_count_android.to_i + self.activeuser_count_ios.to_i

			# # 人均完成数量
			self.indexdone_count_android = SlaveSysApiCallLog.joins(" log left join kf_course_user_favs fav on (log.user_info_id = fav.user_info_id and fav.kf_course_id = #{self.relation_id}) ") \
									.where("fav.kf_course_id > 0 AND method = 'users/courses/course_indices/action' and project_app_id = '#{android_app_id}' AND log.updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'") \
									.count("log.id" , :distinct =>true)
			self.indexdone_count_ios =  SlaveSysApiCallLog.joins(" log left join kf_course_user_favs fav on (log.user_info_id = fav.user_info_id and fav.kf_course_id = #{self.relation_id}) ") \
									.where("fav.kf_course_id > 0 AND method = 'users/courses/course_indices/action' and project_app_id = '#{ios_app_id}' AND log.updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'") \
									.count("log.id" , :distinct =>true)
			self.indexdone_count = self.indexdone_count_android + self.indexdone_count_ios
			# self.indexdone_count_android =  (indexdone_count_android / self.activeuser_count_android).to_i if !self.activeuser_count_android.blank? && self.activeuser_count_android != 0
			# self.indexdone_count_ios = (indexdone_count_ios / self.activeuser_count_ios).to_i if !self.activeuser_count_ios.blank? && self.activeuser_count_ios != 0

			# # 添加课程用户数量
			self.course_fav_count_android = SlaveSysApiCallLog.joins(" log left join kf_course_user_favs fav on (log.user_info_id = fav.user_info_id and fav.kf_course_id = #{self.relation_id}) ") \
									.where("fav.kf_course_id > 0 AND  method = 'users/courses/create' and project_app_id = '#{android_app_id}' AND log.updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'") \
									.count("log.user_info_id" , :distinct =>true)
			self.course_fav_count_ios = SlaveSysApiCallLog.joins(" log left join kf_course_user_favs fav on (log.user_info_id = fav.user_info_id and fav.kf_course_id = #{self.relation_id}) ") \
									.where("fav.kf_course_id > 0 AND  method = 'users/courses/create' and project_app_id = '#{ios_app_id}' AND log.updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'") \
									.count("log.user_info_id" , :distinct =>true)
			self.course_fav_count = self.course_fav_count_android + self.course_fav_count_ios

		elsif self.status_type == 2		#护士台统计
			sort = Kf::Sort.find self.relation_id
			activeuser_count_android = 0
			activeuser_count_ios = 0
			indexdone_count_android = 0
			indexdone_count_ios = 0
			course_fav_count_android = 0
			course_fav_count_ios = 0
			sort.kf_course.each do |item|
				con = {:status_type =>1 , :relation_id => item.id , :date => self.date ,:count_type => 0}
				course = Kf::Status.where(con)
				if course.blank?
					course = Kf::Status.new(con)
					course.save
				else
					course = course.first
					course.update_attributes(con)
				end
				activeuser_count_android = activeuser_count_android + course.activeuser_count_android
				activeuser_count_ios = activeuser_count_ios + course.activeuser_count_ios
				indexdone_count_android = indexdone_count_android + course.indexdone_count_android
				indexdone_count_ios = indexdone_count_ios + course.indexdone_count_ios
				course_fav_count_android = course_fav_count_android + course.course_fav_count_android
				course_fav_count_ios = course_fav_count_ios + course.course_fav_count_ios
			end
			self.activeuser_count_android = activeuser_count_android
			self.activeuser_count_ios = activeuser_count_ios
			self.activeuser_count = self.activeuser_count_android.to_i + self.activeuser_count_ios.to_i

			self.indexdone_count_android = indexdone_count_android
			self.indexdone_count_ios = indexdone_count_ios
			self.indexdone_count = indexdone_count_android + indexdone_count_ios

			self.course_fav_count_android = course_fav_count_android
			self.course_fav_count_ios = course_fav_count_ios
			self.course_fav_count = self.course_fav_count_android + self.course_fav_count_ios

		elsif self.status_type == 3		#管道统计
			sort = Kf::Pipe.find self.relation_id
			activeuser_count_android = 0
			activeuser_count_ios = 0
			indexdone_count_android = 0
			indexdone_count_ios = 0
			course_fav_count_android = 0
			course_fav_count_ios = 0
			sort.kf_sorts.each do |item|
				con = {:status_type =>2 , :relation_id => item.id , :date => self.date ,:count_type => 0}
				course = Kf::Status.where(con)
				if course.blank?
					course = Kf::Status.new(con)
					course.save
				else
					course = course.first
					course.update_attributes(con)
				end
				activeuser_count_android = activeuser_count_android + course.activeuser_count_android
				activeuser_count_ios = activeuser_count_ios + course.activeuser_count_ios
				indexdone_count_android = indexdone_count_android + course.indexdone_count_android
				indexdone_count_ios = indexdone_count_ios + course.indexdone_count_ios
				course_fav_count_android = course_fav_count_android + course.course_fav_count_android
				course_fav_count_ios = course_fav_count_ios + course.course_fav_count_ios
			end
			self.activeuser_count_android = activeuser_count_android
			self.activeuser_count_ios = activeuser_count_ios
			self.activeuser_count = self.activeuser_count_android.to_i + self.activeuser_count_ios.to_i

			self.indexdone_count_android = indexdone_count_android
			self.indexdone_count_ios = indexdone_count_ios
			self.indexdone_count = indexdone_count_android + indexdone_count_ios

			self.course_fav_count_android = course_fav_count_android
			self.course_fav_count_ios = course_fav_count_ios
			self.course_fav_count = self.course_fav_count_android + self.course_fav_count_ios

		else
			# 新激活用户
			self.newuser_count_android = SlaveUserOauthTokenOrder.count(:user_device_id , :distinct => true , :conditions => "project_app_id = '#{android_app_id}' AND updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'")
			self.newuser_count_ios = SlaveUserOauthTokenOrder.count(:user_device_id , :distinct => true , :conditions => "project_app_id = '#{ios_app_id}' AND updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'")
			self.newuser_count = self.newuser_count_android.to_i + self.newuser_count_ios.to_i
			# 新注册用户

			# 活跃用户
			self.activeuser_count_android = SlaveSysApiCallLog.count(:user_info_id ,:distinct => true , :conditions => "(method = 'users/courses/indices/onday' or method = 'users/courses/indices/byday') and project_app_id = '#{android_app_id}' AND updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'")
			self.activeuser_count_ios = SlaveSysApiCallLog.count(:user_info_id ,:distinct => true , :conditions => "(method = 'users/courses/indices/onday' or method = 'users/courses/indices/byday') and project_app_id = '#{ios_app_id}' AND updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'")
			self.activeuser_count = self.activeuser_count_android.to_i + self.activeuser_count_ios.to_i

			# 人均完成数量
			self.indexdone_count_android = SlaveSysApiCallLog.count(:conditions => "method = 'users/courses/course_indices/action' and project_app_id = '#{android_app_id}' AND updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'")
			self.indexdone_count_ios = SlaveSysApiCallLog.count(:conditions => "method = 'users/courses/course_indices/action' and project_app_id = '#{ios_app_id}' AND updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'")
			self.indexdone_count = self.indexdone_count_android + self.indexdone_count_ios

			# 添加课程用户数量
			self.course_fav_count_android = SlaveSysApiCallLog.count(:user_info_id ,:distinct => true ,:conditions => "method = 'users/courses/create' and project_app_id = '#{android_app_id}' AND updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'")
			self.course_fav_count_ios = SlaveSysApiCallLog.count(:user_info_id ,:distinct => true ,:conditions => "method = 'users/courses/create' and project_app_id = '#{ios_app_id}' AND updated_at between '#{date.strftime('%Y-%m-%d')} 00:00:00' and '#{date.next_day.strftime('%Y-%m-%d')} 00:00:00'")
			self.course_fav_count = self.course_fav_count_android + self.course_fav_count_ios
		end
	end
end
