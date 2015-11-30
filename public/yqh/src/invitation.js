// Generated by CoffeeScript 1.7.1
(function() {
  Reveal.addEventListener('slidechanged', function(event) {
    var $arrows, $curr_slide, $prev_slide, curr_slide_index, page_name, prev_page_name;
    $prev_slide = $(event.previousSlide);
    $curr_slide = $(event.currentSlide);
    curr_slide_index = event.indexv;
    page_name = $curr_slide.attr('data-page');
    prev_page_name = $prev_slide.attr('data-page');
    if (page_name === 'guest-page') {
      guest_ani_tasks.animate();
    }
    if (prev_page_name === 'guest-page') {
      guest_ani_tasks.animate(true);
    }
    if (page_name === 'contact-page') {
      banner_ani_tasks.animate();
    }
    $arrows = $('.arrow').css('opacity', 0);
    if (page_name === 'cover-page') {
      $('.arrow-down').css('opacity', 1);
    } else if (page_name === 'contact-page') {
      $('.arrow-up').css('opacity', 1);
    } else {
      $arrows.css('opacity', 1);
    }
    if (page_name === 'arrangement') {
      $('.arrange-swiper').swiper({
        slidesPerView: 'auto',
        offsetPxBefore: 25,
        offsetPxAfter: 10,
        calculateHeight: true
      });
    }
    if (page_name === 'contact-page') {
      return window.$travel_swiper = $('.travel-intro-slider').swiper({
        calculateHeight: true
      });
    }
  });

  $(function() {
    $('.travel-intro .title').tap(function() {
      var $this, margin_top;
      $this = $(this).parent();
      margin_top = parseInt($this.css('margin-top'));
      if (margin_top < -30) {
        return $this.css('margin-top', -30);
      } else {
        return $this.css('margin-top', $(window).height() * -0.9);
      }
    });
    $('.join-btn1').click(function() {
      var $form;
      $form = $('#form1').clone();
      return lightbox(formCard1($form.html(), {
        'background': 'rgba(255,255,255, 1)'
      }), false);
    });
    $('.join-btn2').click(function() {
      var $form;
      $form = $('#form2').clone();
      return lightbox(formCard2($form.html(), {
        'background': 'rgba(255,255,255, 1)'
      }), false);
    });
    return document.ontouchmove = function(event) {
      return event.stopPropagation();
    };
  });

  this.submit_form1 = function() {
    var param;
    param = {
      name: this.form_card1.find("input[name=name]").val(),
      add_1: this.form_card1.find("input[name=add_1]").val(),
      mobile: this.form_card1.find("input[name=mobile]").val(),
      comp: this.form_card1.find("input[name=comp]").val(),
      code: this.form_card1.find("input[name=code]").val()
    };
    if (param.name === "" || param.add_1 === "" || param.mobile === "" || param.comp === "" || param.code === "") {
      return alert("请填入打”*“的项目（必填项）");
    } else {
      return $.post('/api/1.0/public/proj_codesignup', param, function(response) {
        if (response.data.error) {
          return alert("邀请码不存在");
        } else {
          alert("提交成功");
          return lightbox.hide();
        }
      });
    }
  };

  this.submit_form2 = function() {
    var param;
    param = {
      name: this.form_card2.find("input[name=name]").val(),
      email: this.form_card2.find("input[name=email]").val(),
      mobile: this.form_card2.find("input[name=mobile]").val(),
      comp: this.form_card2.find("input[name=comp]").val(),
      add_1: this.form_card2.find("input[name=add_1]").val(),
      add_2: this.form_card2.find("input[name=add_2]").val(),
      add_3: this.form_card2.find("input[name=add_3]").val()
    };
    if (param.name === "" || param.email === "" || param.mobile === "" || param.comp === "" || param.add_1 === "" || param.add_2 === "" || param.add_3 === "") {
      return alert("请填入打”*“的项目（必填项）");
    } else {
      return $.post('/api/1.0/public/proj_codesignup', param, function(response) {
        if (response.errors) {

        } else {
          alert("提交成功");
          return lightbox.hide();
        }
      });
    }
  };

}).call(this);

//# sourceMappingURL=invitation.map
