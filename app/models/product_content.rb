# encoding: utf-8
class ProductContent < CmsContent

  has_one :cms_info_product, :foreign_key => "cms_content_id", :dependent => :destroy
  has_many :cms_info_product_prices,:foreign_key => "cms_content_id", :dependent => :destroy

  # attr_accessible :cms_info_product_prices_attributes,:cms_info_product_prices_ids
  # accepts_nested_attributes_for :cms_info_product_prices, :allow_destroy => true

  attr_accessible :cms_info_product_id, :cms_info_product_attributes
  accepts_nested_attributes_for :cms_info_product, :allow_destroy => true

  has_and_belongs_to_many :shop_contents
  attr_accessible :shop_contents_attributes, :shop_content_ids
  accepts_nested_attributes_for :shop_contents, :allow_destroy => true

  before_save :setup_beforeinfo
  after_save :setup_afterinfo
  after_create :create_contentid

  # self join
  # has_and_belongs_to_many :followers, class_name: "User", foreign_key: "followee_id", join_table: "followees_followers", association_foreign_key: "follower_id"
  # has_and_belongs_to_many :followees, class_name: "User", foreign_key: "follower_id", join_table: "followees_followers", association_foreign_key: "followee_id"

  has_and_belongs_to_many :relproduct_contents, class_name: "ProductContent", foreign_key: "product_content_id", join_table: "product_contents_relproduct_contents", association_foreign_key: "relproduct_content_id"
  attr_accessible :product_contents_attributes, :product_content_ids
  has_and_belongs_to_many :product_contents, class_name: "ProductContent", foreign_key: "relproduct_content_id", join_table: "product_contents_relproduct_contents", association_foreign_key: "product_content_id"
  attr_accessible :relproduct_contents_attributes, :relproduct_content_ids



  public

  def load_record_relations(*not_includes)
    item = self
    item[:u_cms_sorts]= item.cms_sorts
    item[:u_cms_info_product]=item.cms_info_product
    item[:u_shop_contents]=item.shop_contents

    item[:u_cms_sorts]= item.cms_sorts.order("sort_order")    unless  not_includes.include? (:u_cms_sorts)

    item[:u_cms_info_product_prices] = item.cms_info_product_prices  unless  not_includes.include? (:u_cms_info_product_prices)

    #unless  dic.include?(:cms_info_product_prices)
    ##  price_item = dic[:cms_info_product_prices]
    ##  item[:cms_info_product_prices] =price_item    unless  price_item.nil?
    ##  logger.info(item[:cms_info_product_prices].to_json)
    ##else
    ##  logger.info("111111111111111111111111")
    #  #item[:cms_info_product_prices] = item.cms_info_product_prices
    #end

    item
  end

  protected
  def setup_beforeinfo

    self.baidu_gps_point = "POINT(0 0)"

    productid=self.cms_info_product.id
    self.cms_sort_type_id=5
    Rails.logger.info("eclogger: "+productid.to_s)
    self.cms_content_info_id = productid
    if self.is_push==true && self.is_pushed == false
      self.is_pushed = 1
      # android推送
      android_push
      # 添加苹果推送
      contentid=self.id
      # 查询推送记录表中是否有该推送记录
      pushinfo=SysPushOrder.where("cms_content_id = ? ", contentid.to_s)
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
      field :sys_location_infos
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
