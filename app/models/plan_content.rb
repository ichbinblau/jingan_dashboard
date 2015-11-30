# encoding: utf-8
class PlanContent < CmsContent

 	# has_and_belongs_to_many :news_sorts ,:association_foreign_key =>"cms_sort_id" ,:class_name =>"CmsSort"#, :conditions => { :cms_sort_type_id => 8 } , :class_name => 'CmsSort'
	# attr_accessible :news_sorts_attributes,:news_sort_ids
	# accepts_nested_attributes_for :news_sorts#, :allow_destroy => true

	# belongs_to :cms_sorts , :polymorphic => true, :inverse_of => :comments

	# attr_accessible :cms_sorts_attributes,:cms_sort_ids

	# belongs_to :shop_content 
	

  has_one :cms_info_plan,:foreign_key => "cms_content_id",:dependent => :destroy 
  attr_accessible :cms_info_plan_id, :cms_info_plan_attributes
  accepts_nested_attributes_for :cms_info_plan, :allow_destroy => true
  
  # belongs_to :user_info, :inverse_of => :cms_info_customers
  # attr_accessible :user_info_id
  before_save :setup_beforeinfo
  after_create :create_contentid
  protected
    def setup_beforeinfo
      # 添加表关联
        planid=self.cms_info_plan.id 
        # user_info_id = self.cms_info_plan.user_info_id
        self.cms_content_info_id = planid
        # self.user_info_id = user_info_id
        # self.cms_sort_type_id=17
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
		include_all_fields
        navigation_label '内容'
        weight 1

    end
end
