# encoding: utf-8
class AdminPermission < ActiveRecord::Base
	has_and_belongs_to_many :admin_users
	attr_accessible :action, :description, :subject#,:admin_user_attributes,:admin_user_ids
	# accepts_nested_attributes_for :admin_users, :allow_destroy => true

	def action_enum
        [ [ '管理 (增删改)', 'manage' ], [ '列表', 'list' ] , [ '添加', 'new' ] , [ '删除', 'delete' ] ,
        	[ '编辑', 'edit' ]  , [ '导出', 'export' ] ]
  end
	def subject_enum
        [ [ '内容管理', 'NewsContent' ], [ '优惠管理', 'CouponContent' ], [ '团购管理', 'GrouponContent' ], [ '限时抢管理', 'LimitcouponContent' ],
         [ '产品管理', 'ProductContent' ], [ '店铺管理', 'ShopContent' ], [ '图说管理', 'ImgContent' ] ,[ '活动管理', 'ActivityContent' ] , [ '评论管理', 'CmsContentComment' ] , 
         [ '内容图片管理', 'CmsContentImg' ],[ '意见反馈管理', 'CmsContentFeedback' ],['报名管理','CmsInfoApply'],['用户管理','UserInfo'] ]
  end

    rails_admin do
  		navigation_label '项目'
  		weight 2
      configure :action ,:enum
      configure :subject ,:enum
      object_label_method do
        :permission_label_method
      end
    end

end
