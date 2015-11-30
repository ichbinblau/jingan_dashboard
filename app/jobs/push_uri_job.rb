# encoding: utf-8

class PushUriJob
  @queue = "PushUriJob"
  @tag = "PushUriJob"
  @@default_send_interval_config=  {'1'=> 10,'2'=>20,'3'=>30 }

  # To change this template use File | Settings | File Templates.







  def self.perform(args)
    #
    logger = Rails.logger
    pushInfo,ex,success = args['data'],nil,false

    logger.info("#{Time.now} #{@tag}=>pushInfo:#{pushInfo.nil?}")

    #pushInfo = UriPushEntity.new
    #Resque.enqueue(PushUriJob, args)
    #Resque.enqueue_in(10.seconds, PushAndroid,args)
    #

    logger.info("#{Time.now} #{@tag}=>begin" )


    begin
      logger.info("#{Time.now} #{@tag}=>api_uri_call_job_id:#{pushInfo['api_uri_call_job_id']}" )
      jobM =  ApiUriCallJob.find(pushInfo['api_uri_call_job_id'])
      logger.info("#{Time.now} PushUriJob=>jobM:"+jobM.to_json)

      raise "#{Time.now} #{@tag}=>job_id=#{pushInfo['api_uri_call_job_id']} 不存在"   if jobM.nil?

      uri = URI(pushInfo['uri'])

      res = Net::HTTP.post_form(uri, pushInfo['params'])


      logger.info("#{Time.now} #{@tag}=>post_form.res: "+ res.to_json )
      logger.info("#{Time.now} #{@tag}=>post_form.res.body: "+res.body )

      is_find =res['content-type'].to_s.include?('json')

      logger.info("#{Time.now} #{@tag}=>is_find:#{is_find} ")

      if is_find
        logger.info("#{Time.now} #{@tag}=>JSON.parse:begin" )
        backData =  JSON.parse (res.body)
        logger.info("#{Time.now} #{@tag}=>JSON.parse:end #{backData.class.name}" )
        #logger.info("#{@tag}=>has_key #{backData.has_key?(:status)}" )

        success =backData.has_key?('status') &&  backData['status'].to_s == "0"
        logger.info("#{Time.now} #{@tag}=>result:"+success.to_s )
        #success =  backData.include?('status') && backData['status'].to_s=="0"
      end
      logger.info("#{Time.now} #{@tag}=>success->:#{success}" )
    rescue Exception => e
      ex = e
      #logger.info("PushUriJob=error"+e.to_s )

      logger.error "#{Time.now} #{@tag}=>=error:#{e.message}"+'\r\n'+ e.backtrace.join('\r\n')
    ensure
      run_count = jobM[:call_count]+=1

      if success
        jobM[:call_result] = res.body
        jobM.save
      else
        errorM = ApiUriCallJobErrorLog.new
        errorM[:api_call_job_id],errorM[:created_at ],errorM[:error_code ]= jobM[:id],Time.now,'3'

        if  !ex.nil?
          errorM[:error ] = ex.message+'r\n'+ e.backtrace.join('\r\n')
        elsif !res.body.nil?
          errorM[:error ] = res.body
        else
          errorM[:error ]=''
        end
        errorM.save
        jobM.save
        logger.info("#{Time.now} #{@tag}=> current: #{jobM[:call_count]} ")
         # 查找 配置项目 设置自己的 间隔 | 退出

         uri_configM =  ApiUriCallConfig.find(jobM[:api_uri_call_config_id])
         logger.info("#{Time.now} #{@tag}=>find ApiUriCallConfig:#{uri_configM.nil?}  id: #{jobM[:api_uri_call_config_id]}")

         send_config = JSON.parse( uri_configM[:send_config])  unless uri_configM[:send_config].blank?
         logger.info("#{Time.now} #{@tag}=> send_config is null :#{send_config.nil?} ")

         send_interval_config =send_config['interval']  if !send_config.nil? && send_config.has_key?('interval')
         send_interval_config=@@default_send_interval_config  if send_interval_config.nil?

         logger.info("#{Time.now} #{@tag}=> send_interval_config is null :#{send_interval_config.nil?} ")
         #send_interval_config=  {'1'=> 10,'2'=>20,'3'=>30,'-1'=>30 }

         time_span_key =run_count.to_s

         time_span_key ='-1' unless send_interval_config.has_key? time_span_key
         time_span_key =''  unless send_interval_config.has_key? time_span_key
         logger.info("#{Time.now} #{@tag}=> time_span_key is null :#{time_span_key.nil?} ")


         logger.info("#{Time.now} #{@tag}=> send_interval_config has_key?  :#{send_interval_config.has_key?(time_span_key)} ")


         if  send_interval_config.has_key?(time_span_key)

             logger.info("#{Time.now} #{@tag}=> continue  begin time_span_key: #{time_span_key}  val:#{send_interval_config[time_span_key]} ")
             Resque.enqueue_in(send_interval_config[time_span_key].seconds, PushUriJob,args)
             logger.info("#{Time.now} #{@tag}=> continue end")
         else
             logger.info("#{Time.now} #{@tag}=>  break")
         end

         #if jobM[:call_count]=> @@max_count
         #  logger.info("#{Time.now} #{@tag}=>  break")
         #else
         #  logger.info("#{Time.now} #{@tag}=> continue begin")
         #  Resque.enqueue_in(10.seconds, PushUriJob,args)
         #  logger.info("#{Time.now} #{@tag}=> continue end")
         #end

      end
    end

  end

end
