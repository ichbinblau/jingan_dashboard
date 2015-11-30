Reveal.addEventListener('slidechanged', (event) ->
    $prev_slide = $(event.previousSlide)
    $curr_slide = $(event.currentSlide)
    curr_slide_index = event.indexv

    page_name = $curr_slide.attr('data-page')
    prev_page_name = $prev_slide.attr('data-page')

    if page_name == 'guest-page'
        guest_ani_tasks.animate()

    if prev_page_name == 'guest-page'
        guest_ani_tasks.animate true

    if page_name == 'contact-page'
        banner_ani_tasks.animate()

    $arrows = $('.arrow').css('opacity', 0)
    if page_name == 'cover-page'
        $('.arrow-down').css('opacity', 1)
    else if page_name == 'contact-page'
        $('.arrow-up').css('opacity', 1)
    else
        $arrows.css('opacity', 1)

    if page_name == 'arrangement'
        $('.arrange-swiper').swiper {
            slidesPerView:'auto',
            offsetPxBefore:25,
            offsetPxAfter:10,
            calculateHeight: true
        }

    if page_name == 'contact-page'
        window.$travel_swiper = $('.travel-intro-slider').swiper {
            calculateHeight: true
        }
)

$(->


    $('.travel-intro .title').tap(->
        $this = $(this).parent()
        margin_top = parseInt $this.css('margin-top')

        if margin_top < -30
            $this.css 'margin-top', -30
        else
            $this.css 'margin-top', $(window).height() * -0.9
    )

    $('.join-btn1').click ->
        $form = $('#form1').clone()
        lightbox formCard1($form.html(), {'background': 'rgba(255,255,255, 1)'}), false
    $('.join-btn2').click ->
        $form = $('#form2').clone()
        lightbox formCard2($form.html(), {'background': 'rgba(255,255,255, 1)'}), false


    document.ontouchmove = (event) ->
        event.stopPropagation()


)
@submit_form1 = () ->
    param =
        name : @form_card1.find("input[name=name]").val()
        add_1 : @form_card1.find("input[name=add_1]").val()
        mobile : @form_card1.find("input[name=mobile]").val()
        comp : @form_card1.find("input[name=comp]").val()
        code : @form_card1.find("input[name=code]").val()
    if param.name is "" ||param.add_1 is "" ||param.mobile is "" ||param.comp is "" || param.code is ""
        alert "请填入打”*“的项目（必填项）"
    else
        $.post('/api/1.0/public/proj_codesignup', param, (response) ->
            if response.data.error
#                alert JSON.stringify response
                alert "邀请码不存在"
            else
                alert "提交成功"
                lightbox.hide();
        )
#    add_1 =
@submit_form2 = () ->
    param =
        name : @form_card2.find("input[name=name]").val()
        email : @form_card2.find("input[name=email]").val()
        mobile : @form_card2.find("input[name=mobile]").val()
        comp : @form_card2.find("input[name=comp]").val()
        add_1 : @form_card2.find("input[name=add_1]").val()
        add_2 : @form_card2.find("input[name=add_2]").val()
        add_3 : @form_card2.find("input[name=add_3]").val()
#    alert JSON.stringify param

    if param.name is "" ||param.email is "" ||param.mobile is "" ||param.comp is "" ||param.add_1 is "" ||param.add_2 is "" ||param.add_3 is ""
        alert "请填入打”*“的项目（必填项）"
    else
        $.post('/api/1.0/public/proj_codesignup', param, (response) ->
            if response.errors
#                alert response.errors[0].error_msg
            else
                alert "提交成功"
                lightbox.hide();

        )
#    add_1 =