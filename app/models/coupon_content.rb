# encoding: utf-8
class CouponContent < CmsContent

  has_one :cms_info_coupon,:foreign_key => "cms_content_id",:dependent => :destroy

  attr_accessible :cms_info_coupon_id,:cms_info_coupon_attributes
  accepts_nested_attributes_for :cms_info_coupon, :allow_destroy => true


  has_and_belongs_to_many :shop_contents
  attr_accessible :shop_contents_attributes,:shop_content_ids
  accepts_nested_attributes_for :shop_contents

  before_save :setup_beforeinfo
  after_save :setup_afterinfo
  after_create :create_contentid
  protected
    def setup_beforeinfo
      self.baidu_gps_point = "POINT(0 0)"

      # 添加表关联
      couponid=self.cms_info_coupon.id
      projectid=self.project_info_id
      self.cms_content_info_id = couponid
      self.cms_sort_type_id=3
      #添加优惠码
      allcode=self.cms_info_coupon.my_all_apply_code
      allcodelist=allcode.split(/,/)

      for i in allcodelist do
          Rails.logger.info("eclogger: "+i.to_s)
          orderinfo=ActCouponOrder.where("apply_code = ? AND project_info_id = ?", i, projectid)
          if  orderinfo.length<=0
            # Rails.logger.info("eclogger: body-------------------orderinfo.apply_code ")
            order = ActCouponOrder.new()
            order.project_info_id=projectid
            order.act_status_type_id=1
            order.cms_content_coupon_id=couponid
            order.apply_code=i
            order.save
          end
        end
        if self.is_push==true && self.is_pushed == false
          self.is_pushed = 1
          # android推送
          android_push
          # 添加苹果推送
          contentid=self.id
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
        def setup_afterinfo
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
          end
          field :sys_location_infos do
            nested_form false
          end
          field :shop_contents do
            nested_form false
          end
          include_all_fields
          exclude_fields :baidu_gps_point , :baidu_longitude, :baidu_latitude
          navigation_label '内容'
          weight 1
        end
      end
