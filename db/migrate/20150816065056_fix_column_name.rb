class FixColumnName < ActiveRecord::Migration
  def up
      rename_column :cms_content_comments, :image_cover, :admin_reply
  end

  def down
  end
end
