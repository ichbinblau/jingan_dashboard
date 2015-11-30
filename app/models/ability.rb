# encoding: utf-8
class Ability
  include CanCan::Ability

  def initialize(user)
  user ||= AdminUser.new
  # if user.id == 1
      
  # can :access, :rails_admin
  # can :dashboard            # dashboard access


  # can :manage, :all
  # can :index, ProjectInfo, :id=>user.project_info_id
  # cannot :new , ProjectInfo
  # cannot :edit , ProjectInfo
  # can :new, ActivityContent
  # cannot :manage , User

  project_model = ['ActivityContent','NewsContent','ProductContent','ActCouponOrder','ActLimitCouponOrder','ShopContent','CouponContent','LimitCouponContent','CmsContentFeedback','CmsInfoApply']
  onlylist_model = ['ActCouponOrder','UserInfo']

  if user.id == 1
    can :manage, :all
    # can :manage, :manage
  else
    #通用权限
    can :access, :rails_admin
    can :dashboard            # dashboard access
    cannot :manage , ProjectInfo
    can :index, ProjectInfo, :id=>user.project_info_id
    cannot :manage , CmsSortType
    can :index, CmsSortType
    cannot :manage , CmsSort
    can :index, CmsSort , :project_info_id=>user.project_info_id

    #详细权限
    user.admin_permissions.each do |p|
      begin
        #限制指定内容的权限只能查看
        if onlylist_model.include? p.subject
          p.action = "list"
        end

        action = p.action.to_sym
        subject = begin
                    # RESTful Controllers
                    p.subject.camelize.constantize
                  rescue
                    # Non RESTful Controllers
                    p.subject.underscore.to_sym
                  end
        #限制内容显示在当前项目
        if project_model.include? p.subject
          can action ,subject ,:project_info_id => user.project_info_id
        else
          can action, subject
        end
      rescue => e
        Rails.logger.info "eclogger: #{e}"
        Rails.logger.info "eclogger: #{subject}"
      end
    end
  end


      # can do |action, subject_class, subject|
      #   user.admin_permissions.find_all_by_action(aliases_for_action(action)).any? do |permission|
      #     permission.subject_class == subject_class.to_s &&
      #       (subject.nil? || permission.subject_id.nil? || permission.subject_id == subject.id)
      #   end
      # end
      # can :manage, ProjectInfo,ProjectInfo.id do |project|
      #     project.id = 2
      # end
  # else
    # can :manage, :all

    # can do |action, subject_class, subject|
    #   user.admin_permissions.find_all_by_action(aliases_for_action(action)).any? do |permission|
    #     permission.subject_class == subject_class.to_s &&
    #       (subject.nil? || permission.subject_id.nil? || permission.subject_id == subject.id)
    #   end
    # end
  end


end

# Copyright © 2009-2011 蒂丽雪斯, All Rights Reserved
# 蛋糕 蒂丽雪斯 烘焙坊 面包 早餐 饮料 奶茶 甜点 冷饮 热饮

# http://www.nowapp.cn
# http://www.delisuesi.com/
