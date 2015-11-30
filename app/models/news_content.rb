# encoding: utf-8
class NewsContent < CmsContent
  has_one :cms_info_news,:foreign_key => "cms_content_id",:dependent => :destroy 

  has_and_belongs_to_many :shop_contents
  attr_accessible :shop_contents_attributes,:shop_content_ids
  accepts_nested_attributes_for :shop_contents

  has_and_belongs_to_many :activity_contents
  attr_accessible :activity_contents_attributes,:activity_content_ids
  accepts_nested_attributes_for :activity_contents

  has_and_belongs_to_many :product_contents
  attr_accessible :product_contents_attributes,:product_content_ids
  accepts_nested_attributes_for :product_contents

  has_and_belongs_to_many :user_groups

  before_save :setup_beforeinfo
  after_save :setup_afterinfo
  after_create :create_contentid
  protected
    def setup_beforeinfo
      self.baidu_gps_point = "POINT(0 0)"
      
      # Rails.logger.info "1111111"
      self.cms_sort_type_id=4
      # if self.is_push==true && self.is_pushed == false
      #   self.is_pushed = 1
      #   # android推送
      #   android_push
      #   # 添加苹果推送
      #   apn_push、
      # end
    end
    def setup_afterinfo
    end
    def create_contentid
      if self.is_push==true
        self.is_pushed = 1
        # android推送
        android_push
        # 添加苹果推送
        apn_push
      end
    end
    rails_admin do
      list do
        field :project_info
        field :cms_sorts
        field :id
        field :title
        field :cms_sort_type_id
        field :type
        field :user_info_id
      end
      #限制cms_sorts显示，只显示当前项目当前类型的分类
      field :cms_sorts do
        nested_form false
      end
      field :sys_location_infos do
        nested_form false
      end
      field :shop_contents do
        nested_form false
      end
      field :product_contents do
        nested_form false
      end
      include_all_fields
      exclude_fields :baidu_gps_point , :baidu_longitude, :baidu_latitude

      navigation_label '内容'
      weight 1
    end
  end
    # class NewsSort < CmsSort
    #     has_and_belongs_to_many :NewsContent ,:association_foreign_key =>"cms_content_id" ,:class_name =>"CmsContent"
    #     rails_admin do
    #       visible false
    #     end
    # end
