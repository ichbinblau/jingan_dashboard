# encoding: utf-8
class WebApiTools::UriPushEntity

  attr_accessor :uri,:params,:items,:api_uri_call_config,:api_uri_call_job_id

  def initialize(uri=nil,api_uri_call_config)
     @items,@params = {},{}
     @uri = uri
     @api_uri_call_config =api_uri_call_config

  end

end


class  WebApiTools::UriPushTask

  #@logger= Rails.logger
  @tag ='UriPushQueue'

  # To change this template use File | Settings | File Templates.

  attr_accessor :items

  def initialize
    @items={}
  end


public

  def send_task
    unless @wait_items.nil?
      @wait_items.each do |item |
        #item.api_uri_call_config = nil

        Rails.logger.info("#{@tag}=>send_task:start ")

        Resque.enqueue(PushUriJob, {:data => item  })
        #Resque.enqueue_in(10.seconds, PushAndroid,args)
        Rails.logger.info("#{@tag}=>send_task: api_uri_call_job_id: "+item.api_uri_call_job_id.to_s )
      end
    end

    self
  end



  def save_job
    logger =Rails.logger
    #formArgs,uri_call_configM,user_entity,api_web_info_id, api_web_info_version_id
    #configM = recordArgs[:api_uri_call_config ]

    unless @wait_items.nil?
      @wait_items.each do | item |

        logger.info("#{@tag}=>save_job.item:"+item.to_json)

        configM= item.api_uri_call_config
        logger.info("#{@tag}=>save_job.each:"+configM.to_json)


        #api_call_uri_sort_id
        #api_call_uri_sort_id

        jobM =  ApiUriCallJob.new
        jobM[:api_uri_call_sort_id ] =configM[:api_call_uri_sort_id]
        jobM[:api_uri_call_config_id ] =configM[:id]    #configM[:id]
        jobM[:call_to_uri ]=  item.uri.to_s
        jobM[:call_params] =  item.params.to_json
        jobM[:call_count] = 0
        jobM[:created_at] = Time.now


        yield jobM,item

        logger.info("#{@tag}=>job:"+jobM.to_json)

        jobM.save
        item.api_uri_call_job_id = jobM[:id]



        #jobM[:api_web_info_id]=  api_web_info_id
        #jobM[:api_web_info_version_id]=  api_web_info_version_id
        #jobM[:project_info_id] = user_entity.project_info_id
        #jobM[:user_info_id ] =  user_entity.user_info_id

      end
    end

    self
  end

  def each
     unless @wait_items.nil?
       @wait_items.each{| item | yield item }
     end
     self
  end

  def filter
    logger =Rails.logger
    logger.info("#{@tag}=>filter")

    unless  @wait_items.nil?
     buf = []
     @wait_items.each do |item |

       buf << item   if(yield item)!=false
     end
     @wait_items = buf
     logger.info("#{@tag}=>filter_count:"+buf.length.to_s)
    end
    self
  end



  def load_uri_config(dic={} )

    logger = Rails.logger

    uriConfigRecord =ApiUriCallConfig.find(dic[:api_uri_call_config_id] ) if dic.has_key?(:api_uri_call_config_id)

    uriConfigRecord =dic[:api_uri_call_config]  if uriConfigRecord.nil? &&  dic.has_key?(:api_uri_call_config)


    buf=[]
    if uriConfigRecord.nil?
      if dic.has_key?(:project_info_id) && dic.has_key?(:api_call_uri_sort_id)
        #
        condition,condition_params =["project_info_id=? and api_call_uri_sort_id=?"], [dic[:project_info_id],dic[:api_call_uri_sort_id]]
        if dic.has_key? :api_uri_call_sort_id
          condition << 'AND api_uri_call_sort_id=?'
          condition_params << dic[:condition_params]
        end

        ApiUriCallConfig.find(:all,:conditions => [ condition.join(' ') ]+condition_params).each do |config_item|
          buf <<  WebApiTools:: UriPushEntity.new(config_item.uri,config_item )
        end
      end
    else

      buf << WebApiTools::UriPushEntity.new(uriConfigRecord[:uri],uriConfigRecord )
    end

    @wait_items = buf
    logger.info("#{@tag}=>load_uri_config buf:"+buf.to_json)
    #raise "为找到要发送的配置 api_uri_call_configs "  if(uriConfigRecord.nil?)
    self
  end

end