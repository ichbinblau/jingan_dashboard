# 自定义的适配器
$["adapter"] = (input , config) ->
	return new Adapter input , config
Adapter = (input , config) -> 
	self = this
	self.input = input
	self.config = config
	return self.init()

# 实现功能：复制中更换变量名称；复制并合并组成新数组;{$value}替换
Adapter.prototype = 
	input : null
	config : null
	init : ()->
		self = this
		input = Object.clone self.input
		output = {}
		config = self.config
		return input if config.length == 0
		# 执行adapter
		for item in config
			continue if item.key == "model"
			output = $.extend output , self.getNewOutput(input , item.key , item.value)
		return output

	getNewOutput : (input ,from ,to) ->
		newoutput = {}
		# {$value}替换
		matchStr = false
		from.gsub( /\{\$(.*)\}/, (match)->
			eval "newoutput.#{to} = match[1]"
			matchStr = true
		)
		return newoutput if matchStr
		# 复制中更换变量名称
		matchArray = false
		fromarray = []
		fromitems = ""
		toarray = []
		toitems = ""
		from.gsub( /(.*)\[\]\{(.*)\}/, (match)-> 
			matchArray = true
			fromarray = match[1]
			fromitems = match[2].split ","
		)
		if matchArray
			eval "inpuitArray = input.#{fromarray}"
			to.gsub( /(.*)\[\]\{(.*)\}/, (match)->
				toarray = match[1]
				toitems = match[2].split ","
			)
			eval "newoutput.#{toarray} = []"
			for item in inpuitArray
				newobj = {}
				for v,k in fromitems
					newobj[toitems[k]] = item[fromitems[k]]
				eval "newoutput.#{toarray}.push( newobj )"
			return newoutput
		# 一般替换
		from = from.replace "[]" , ""
		to = to.replace "[]" , ""
		eval "newoutput.#{to} = input.#{from}"
		return newoutput
