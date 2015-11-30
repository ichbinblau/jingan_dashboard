# encoding: utf-8
# RailsAdmin config file. Generated on December 12, 2012 16:45
# See github.com/sferik/rails_admin for more informations
RailsAdmin.config do |config|

  require 'i18n'
  I18n.default_locale = :zh

  # config.models do
  #   edit do
  #     fields do
  #       actions do
  #         model = self.abstract_model.model_name.underscore
  #         field = self.name
  #         model_lookup = "admin.actions.#{model}.#{field}".to_sym
  #         field_lookup = "admin.actions.#{field}".to_sym
  #         I18n.t model_lookup, :actions => actions, :default => [field_lookup, actions]
  #       end
  #     end
  #   end
  # end


  config.main_app_name = ["宜云物联", "APP后台管理"]
  config.main_app_name = Proc.new { |controller| [ "宜云物联", "APP后台管理 - #{controller.params[:action].try(:titleize)}" ] }
  ################  Global configuration  ################

  # Set the admin name here (optional second array element will appear in red). For example:
  # config.main_app_name = ['Generala', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_admin_user } # auto-generated


  config.navigation_static_links = {
    'APP状态查询' => '/manage/appstate'
  }
  config.navigation_static_label = "其它"


  config.authorize_with :cancan

  def cnname_label_method
    "#{self.cnname}"
  end

  def image_label_method
    "#{self.description}"
  end
  def permission_label_method
    "#{self.subject} - #{self.action}"
  end
  def project_label_method
    "#{self.id} - #{self.cnname}"
  end
  def sort_label_method
    "#{self.project_info_id} - #{self.cnname}"
  end

  # config.model CmsContent do
  #   # include_all_fields
  #   # end
  # #   # configure :image_cover, :carrierwave
  # #   # nested do
  # #   #   field :cms_content_img
  # #   # end
  # end

  # config.model ActivityContent do
    # field :activity_sorts do
    #   nested_form false
    # end
    # include_all_fields
  # end

  # config.model NewsContent do
      # associated_collection_scope do
      #   # bindings[:object] & bindings[:controller] are available, but not in scope's block!
      #   sort = bindings[:object]
      #   Proc.new { |scope|
      #     # scoping all Players currently, let's limit them to the team's league
      #     # Be sure to limit if there are a lot of Players and order them by position
      #     # scope = scope.where(league_id: sort.league_id) if team.present?
      #     scope = scope.where(cms_sort_type_id: 8) if sort.present?
      #     # scope = scope.limit(30).reorder('players.position DESC') # REorder, not ORDER
      #   }
      # end
  # end

  #     # orderable true

  # config.model AdminUser do

  #   include_all_fields
  #   field :admin_permissions do
  #     nested_form false
  #     # orderable true
  #   end

  #   # configure :image_cover, :carrierwave
  #   # nested do
  #   #   field :cms_content_img
  #   # end
  # end

  # config.model CmsContentImg do
  #   # configure :image, :carrierwave
  #   edit do
  #     field :image, :carrierwave
  #     include_all_fields
  #   end
  # end


  # config.model AdminPermission do
  #   configure :action ,:enum
  #   configure :subject ,:enum
  # end


  # config.model CmsContent do
  #   field :cms_content_comment do
  #     # associated_collection_cache_all false  # REQUIRED if you want to SORT the list as below
  #     associated_collection_scope do
  #       # bindings[:object] & bindings[:controller] are available, but not in scope's block!
  #       comment = bindings[:object]
  #       Proc.new { |scope|
  #         # scoping all Players currently, let's limit them to the team's league
  #         # Be sure to limit if there are a lot of Players and order them by position
  #         # scope = scope.where(league_id: comment.league_id) if comment.present?
  #         scope = scope.limit(10) # REorder, not ORDER
  #       }
  #     end
  #   end
  # end

  # config.model User do
  #   object_label_method :custom_name_method
  # end


# RailsAdmin.config do |config|
#   config.model Blog do
#     edit do
#       field :title, :string
#       field :category_id, :belongs_to_association
#       field :content, :text do
#         ckeditor true
#       end
#       field :tags, :string
#       field :seo_desc, :text
#      end
#   end
#   config.included_models = [Blog, Category, Comment, User, Book] 
# end



  # SKIP_RAILS_ADMIN_INITIALIZER=false rake mytask
  # If you want to track changes on your models:


  # config.audit_with :history, 'User'
  # RailsAdmin.config do |config|
  #   config.audit_with do
  #     # nowobject = ApplicationController::get_object

   

  #     logger.debug("zzdebug: in controller ApplicationController #{_current_user.email}")
  #     # Use sorcery's before filter to auth users
  #     # require_login
  #   end
  # end

  # RailsAdmin.config |config| do
  # config.model ProjectInfo do
  #   # field :players do
  #     associated_collection_scope do
  #       team = bindings[:object]
  #       Proc.new { |default_scope|
  #         default_scope = scope.where(:id =>_current_user.email )
  #       }
  #       # default_scope where(:id =>_current_user.email )
  #     end
  #   # end
  # end
  # end

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  # config.excluded_models = []

  # Include specific models (exclude the others):
  # config.included_models = []

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:


end
