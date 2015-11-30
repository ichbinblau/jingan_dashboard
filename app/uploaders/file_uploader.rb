# encoding: utf-8
require 'net/http'
class FileUploader < CarrierWave::Uploader::Base

  # include CarrierWave::MiniMagick

  storage :file
  # before :store, :remember_cache_id
  # after :cache, :upload_to_server
 #  def upload_to_server(new_file)
 #    # Rails.logger.info("eclogger: uploaded #{@server_file_name}")
 #  end

 # def remember_cache_id(new_file)
 #    @cache_id_was = cache_id
 #    # FileUtils.cp(File.join(cache_dir, @cache_id_was) ,"fdsafasd")
 #  end

  after :cache, :upload_to_server
  def upload_to_server(new_file)
    @basepath = 
    @opts = {
      :aliyun_access_id => SITE_CONFIG['ecloud_acc']['aliyun']['access_key'],
      :aliyun_access_key => SITE_CONFIG['ecloud_acc']['aliyun']['access_key_secret'],
      :aliyun_bucket => "qymhvideo"
    }
    @connection = CarrierWave::Storage::Aliyun::Connection.new(@opts)

    url = @connection.put(store_dir+"/"+filename,File.open(new_file.path).read)
    code =Net::HTTP.get_response(URI.parse(url)).code
    Rails.logger.info code.inspect
    code.to_s == "200"
  end



  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  # def cache_dir
  #   "uploads/tmp/cache"
  # end
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  def extension_white_list
    %w(ipa apk doc docx ppt pptx xls xlsx pem mp4 png jpg)
  end


  # def filename
  #   "#{@server_file_name}" if original_filename
  # end

end
