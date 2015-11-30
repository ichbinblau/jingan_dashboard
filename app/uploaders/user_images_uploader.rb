# encoding: utf-8
class UserImagesUploader < CarrierWave::Uploader::Base
  require 'net/http/post/multipart' # multipart-post gem
  require 'mime/types' #mime-types gem
  require 'net/http'
  require "open-uri"

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  # process :resize_to_fill => [200, 200]
  attr_accessor :upload_url
  
  storage :file
  before :store, :remember_cache_id
  after :cache, :upload_to_server
  def upload_to_server(new_file)
    # serverurl = "http:\/\/admin.nowapp.cn\/"+cache_dir+"\/"+cache_name
    # Rails.logger.info("eclogger: imageurl -  #{serverurl}")
    # @server_file_name = Net::HTTP.get_response(URI.parse("http://is.hudongka.com/saveimg.php?url=#{serverurl}")).body

    # Rails.logger.info("eclogger: uploaded #{@server_file_name}")


    photo = File.open(new_file.path)
    url = URI.parse("http://is.hudongka.com/saveimg.php")

    req = Net::HTTP::Post::Multipart.new "#{url.path}",
      "image" => UploadIO.new(photo, mime_for_file(photo), photo.path)
    n = Net::HTTP.new(url.host, url.port)
    n.start do |http|
      response = http.request(req)
      Rails.logger.info response.body
      @server_file_name = response.body
    end

    @opts = {
      :aliyun_access_id => SITE_CONFIG['ecloud_acc']['aliyun']['access_key'],
      :aliyun_access_key => SITE_CONFIG['ecloud_acc']['aliyun']['access_key_secret'],
      :aliyun_bucket => "qymhimage"
    }
    @connection = CarrierWave::Storage::Aliyun::Connection.new(@opts)

    url = @connection.put(store_dir+"/"+@server_file_name,File.open(new_file.path).read)
    code =Net::HTTP.get_response(URI.parse(url)).code
    Rails.logger.info code.inspect
    code.to_s == "200"


  end

  def remember_cache_id(new_file)
    @cache_id_was = cache_id
    # FileUtils.cp(File.join(cache_dir, @cache_id_was) ,"fdsafasd")
  end

  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  def cache_dir
    "uploads/tmp/cache"
  end

  # version :thumb do
  #   process :rails_admin_crop
  #   process :resize_to_fill: [500,320]
  # end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end
  # def file_name
  #   "11111111" if original_filename
  # end

  def filename
    if original_filename.nil?
      if !self.upload_url.nil?
        self.upload_url
      end
    else
      "#{@server_file_name}"
    end
  end
  def mime_for_file(f)
    m = MIME::Types.type_for(f.path.split('').last)
    m.empty? ? "application/octet-stream" : m.to_s
  end
end
