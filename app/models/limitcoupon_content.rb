# encoding: utf-8
class LimitcouponContent < CmsContent

	has_one :cms_info_limitcoupon,:foreign_key => "cms_content_id",:dependent => :destroy 
	attr_accessible :cms_info_limitcoupon_id, :cms_info_limitcoupon_attributes
	accepts_nested_attributes_for :cms_info_limitcoupon, :allow_destroy => true
  
	# has_and_belongs_to_many :cms_info_shops
	# has_many :cms_info_shops_cms_info_products
 #  	has_many :cms_info_shop, :through => :cms_info_shops_cms_info_products
  	before_save :setup_beforeinfo
    after_save :setup_afterinfo
    after_create :create_contentid
    protected
    def setup_beforeinfo
        self.cms_sort_type_id=2
        projectid=self.project_info_id
        limitcouponid=self.cms_info_limitcoupon.id 
        self.cms_content_info_id = limitcouponid

        #查询优惠码
        allcode=self.cms_info_limitcoupon.my_all_apply_code 
        allcodelist=allcode.split(/,/)
        if allcodelist.length>0
          for code in allcodelist do 
            orderinfo=ActLimitcouponOrder.where("apply_code = ? AND project_info_id = ?", code, projectid)
            if orderinfo.blank?
              Rails.logger.info("eclogger: "+orderinfo.to_s)
              order = ActLimitcouponOrder.new()
              order.project_info_id=projectid
              order.act_status_type_id=1
              order.cms_content_limitcoupon_id=limitcouponid
              order.apply_code=code
              order.save
            end
          end
        end
    end
    def setup_afterinfo
        # 添加推送
        ispush=self.is_push
        contentid=self.id
        if ispush==true
          # 查询推送记录表中是否有该推送记录
          pushinfo=SysPushOrder.where("cms_content_id = ? ",contentid.to_s )
          # 循环分类
          if pushinfo.blank?
            for sorts in self.cms_sorts do 
              pushorder = SysPushOrder.new()
              pushorder.cms_content_id=contentid
              pushorder.project_info_id=self.project_info_id
              pushorder.cms_sort_id=sorts.id
              pushorder.cms_content_title=self.title
              t = Time.new
              date = t.strftime("%Y-%m-%d %H:%M:%S")
              pushorder.updatetime=date
              pushorder.pushtype="content"
              pushorder.save
            end
            apn_push
          end          
        end
    end
    def create_contentid
      self.save
    end
    rails_admin do
          list do
              field :cms_sorts
              field :title
              field :id
              field :cms_sort_type_id          
              field :type
              field :user_info_id
              field :project_info
              field :user_info_id
          end
    	field :cms_sorts do
		  nested_form false
          # associated_collection_scope do
          #     sort = bindings[:object]
          #     Proc.new { |scope|
          #       scope = scope.where( :cms_sort_type_id => 2  ) if sort.present?
          #     }
          #   end
		end
		include_all_fields
  		navigation_label '内容'
  		weight 1
    end
end
