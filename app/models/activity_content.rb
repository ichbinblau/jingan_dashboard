# encoding: utf-8
class ActivityContent < CmsContent

  has_one :cms_info_activity,:foreign_key => "cms_content_id",:dependent => :destroy #,:as => :cms_content
  
  # belongs_to :cms_content_info, :polymorphic => true, :inverse_of => :activity_content
  attr_accessible :cms_info_activity_id, :cms_info_activity_attributes
  accepts_nested_attributes_for :cms_info_activity, :allow_destroy => true

  has_and_belongs_to_many :news_contents
  attr_accessible :news_contents_attributes,:news_content_ids
  accepts_nested_attributes_for :news_contents

  has_and_belongs_to_many :shop_contents
  attr_accessible :shop_contents_attributes,:shop_content_ids
  accepts_nested_attributes_for :shop_contents


  before_save :setup_beforeinfo
  after_save :setup_afterinfo
  after_create :create_contentid
  protected
    def setup_beforeinfo
      self.baidu_gps_point = "POINT(0 0)"

      self.cms_sort_type_id=7
      activityid=self.cms_info_activity.id
      Rails.logger.info("eclogger: "+activityid.to_s)
      self.cms_content_info_id = activityid
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
        end
        field :shop_contents do
          nested_form false
        end
        include_all_fields
        navigation_label '内容'
        weight 1
      end

    end
