this.aniTasks = ->
    @tasks = []
    @task_index = -1

    @

this.aniTasks.prototype.addTaskPair = (ani, delay=0) ->
    @tasks.push [ani, delay]

this.aniTasks.prototype.animateCurrent = (recover=false) ->
    if not @tasks[@task_index]
        if @task_index > @tasks.length
            @task_index = @tasks.length
        else if @task_index < -1
            @task_index = -1

        return false

    delay = @tasks[@task_index][1]
    ani = @tasks[@task_index][0]
    setTimeout((-> if recover then ani.init() else ani.animate()), delay)

this.aniTasks.prototype.next = (recover=false) ->
    @task_index += 1
    @animateCurrent(recover)

this.aniTasks.prototype.prev = (recover=false) ->
    @task_index -= 1
    @animateCurrent(recover)

this.aniTasks.prototype.animate = (reverse=false) ->
    if reverse
        while @prev(true)
            null
    else
        while @next()
            null

this.aniMove = (obj, target_pos) ->
    $obj = $(obj)
    $obj.css 'transition', 'top 0.5s ease, left 0.5s ease, bottom 0.5s ease, right 0.5s ease'
    $obj.css '-webkit-transition', 'top .2s ease, left .2s ease, bottom .2s ease, right .2s ease'
    $obj.css 'transform', 'translateZ(0) !important'
    $obj.css '-webkit-transform', 'translateZ(0) !important'

    @init_pos =
        'top': $obj.css('top')
        'right': $obj.css('right')
        'bottom': $obj.css('bottom')
        'left': $obj.css('left')

    @target_pos = target_pos
    @$obj = $obj
    @

this.aniMove.prototype.animate = ->
    @$obj.css @target_pos

this.aniMove.prototype.init = ->
    @$obj.css @init_pos


this.lightbox = (->
    autohide = true
    $lb = $('<div id="lightbox"></div>');
    $lb.css {
        position: 'fixed'
        width: '100%'
        height: '100%'
        display: 'none'
        top: 0
        left: 0
        opacity: 0
        'transition': 'opacity 0.5s ease'
        '-webkit-transition': 'opacity 0.5s ease'
        background: 'rgba(0,0,0,0.3)'
        'z-index': 100
    }

    $lb.tap ->
        if not autohide
            return null

        lightbox.hide()

    $(->
        $('body').append($lb);
    )

    retfn = (html, ah=true) ->
        autohide = ah

        $lb.html(html)
        $lb.show()
        $lb.css('opacity', 1)

    retfn.hide = ->
        $lb.css 'opacity', 0
        setTimeout(->
            $lb.hide()
        , 500)

    retfn
)()


this.introCard = (->
    $card = $('<div id="intro-card"></div>');
    $card.css {
        width: '70%'
        height: '75%'
        overflow: 'auto'
        position: 'absolute'
        top: '50%'
        left: '50%'
        'border-radius': '10px'
        'background': 'rgba(0,0,0,0.5)'
    }

    ($content, css={}) ->
        $card.html($content).clone().css({
            'margin-top': $(window).height() * -0.75 / 2
            'margin-left': $(window).width() * -0.70 / 2
        }).css(css)
)()
@form_card1 = {}
this.formCard1 = (->
    $card = $('<div id="intro-card"></div>');

    $card.css {
        width: '300px'
        height: '330px'
        overflow: 'auto'
        position: 'absolute'
        top: ($(window).height() - 330) / 2
        left: ($(window).width() - 300) / 2
        'border-radius': '10px'
        'background': 'rgba(0,0,0,0.5)'
    }

    ($content, css={}) ->
        @form_card1 = $card.html($content).clone()
        @form_card1.css(css)
)()
@form_card2 = {}
this.formCard2 = (->
    $card = $('<div id="intro-card"></div>');

    $card.css {
        width: '300px'
        height: '330px'
        overflow: 'auto'
        position: 'absolute'
        top: ($(window).height() - 330) / 2
        left: ($(window).width() - 300) / 2
        'border-radius': '10px'
        'background': 'rgba(0,0,0,0.5)'
    }

    ($content, css={}) ->
        @form_card2 = $card.html($content).clone()
        @form_card2.css(css)
)()
$(window).resize ()->
    @form_card1.css {
        top: ($(window).height() - 330) / 2
        left: ($(window).width() - 300) / 2
    }
    @form_card2.css {
        top: ($(window).height() - 330) / 2
        left: ($(window).width() - 300) / 2
    }
#        alert $(window).height()
#    alert(form_card)