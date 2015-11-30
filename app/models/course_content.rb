# encoding: utf-8
class CourseContent < CmsContent

  # has_one :cms_info_course,:foreign_key => "cms_content_id",:dependent => :destroy 
  # attr_accessible :cms_info_course_id, :cms_info_course_attributes
  # accepts_nested_attributes_for :cms_info_course, :allow_destroy => true

  has_many :cms_info_schedules, :inverse_of => :course_content




 before_save :setup_beforeinfo
  # after_save :setup_afterinfo
  after_create :create_contentid
  protected
    def setup_beforeinfo
      # 添加表关联
        # courseid=self.cms_info_course.id 
        # self.cms_content_info_id = courseid
        self.cms_sort_type_id=18
    end

    def create_contentid
      # self.save
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
      #限制cms_sorts显示，只显示当前项目当前类型的分类
      field :cms_sorts do
          nested_form false
      end
      include_all_fields
      navigation_label '内容'
      weight 1
    end
end