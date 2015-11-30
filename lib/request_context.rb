# encoding: utf-8

class RequestContext

  attr_accessor  :items,:exec_entity, :params, :user_entity, :api_entity





  def initialize
    # you can setup stuff here, be aware that this
    # is being called in _every_ request.
    @items={}
  end


  #
  def self.instance
    i = Thread.current[:request_context]
    unless i
      raise "No instance present. In script/rakefiles: use RequestContext.with_scope {}, " +
                "in controller: ensure `around_filter :request_scope` is configured"
    end
    return i
  end

  # Allows the use of this scope from rake/scripts
  # ContextScope.with_scope do |scope|
  #   # do something
  #   ...
  # end
  def self.with_scope
    begin
      begin_request
      yield(instance)
    ensure
      end_request
    end
  end

  def self.begin_request
    raise "request_context already set" if Thread.current[:request_context]
    Thread.current[:request_context] = RequestContext.new
  end

  def self.end_request
    raise "request_context already nil" unless Thread.current[:request_context]
    Thread.current[:request_context] = nil
  end

  # user part, add constructors/getters/setters here


end
