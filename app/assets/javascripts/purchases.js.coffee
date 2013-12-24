main = ->
  bind_all = ()->
    $('a.change_date').unbind()  
    $('a.change_date').on 'click', ->
      date =  window.prompt('Введите дату',$('.date input').val());
      if(date!=$('.date input').val())
        form = $(this).parents("form")
        form.find(".pur_date input").val(date)
        form.submit()
        form.slideUp()
    $(".change a").click (e)->
      $(this).parents('form').submit()
      e.preventDefault();

    $(".main_input").unbind()  
    $(".main_input").on "change", ->
      form = $(this).parents(".pur_form")
      form.find(".status div").hide()
      form.find(".change").show()

    $('.pur_cost input').on "change", ->
      text_field = $(this)
      pur_cost = text_field.val()
      if(pur_cost.length>2)
        arr = pur_cost.split("")
        index = arr.length - 2
        arr.splice(index, 0, '.')
        pur_cost = arr.join("")
        text_field.val(pur_cost)
    # Date deal
    $('.date input').on "input", ->    
      text_field = $(this)
      pur_date = text_field.val()
      if(pur_date.length==2)
        today = new Date()
        mm = today.getMonth()+1
        yyyy = today.getFullYear()
        text_field.val(pur_date+'-'+mm+'-'+yyyy)
        text_field[0].setSelectionRange(3, 10)
      if(pur_date.length==5)
        today = new Date()
        yyyy = today.getFullYear()
        text_field.val(pur_date+'-'+yyyy)
        text_field[0].setSelectionRange(6, 10);
    $('.date input').on 'click', ->
      $(this).select()
    $('.date input').keydown (e) ->
      keyCode = e.keyCode or e.which
      if keyCode==13
        $('.date .go')[0].href+=$('.date input').val()
        $('.date a.go').trigger('click')
        $('.ajax-wait-msg').show()

    #input hotkeys
    #$(document).bind 'keydown', 'Alt+q', ->
    #  $('.date input').trigger('click')      
    #$(document).bind 'keydown', 'Alt+a', ->      
    #  $('.date .prev').trigger('click')
    #  $('.ajax-wait-msg').show()
    #$(document).bind 'keydown', 'Alt+s', ->
    #  $('.date .next').trigger('click')
    #  $('.ajax-wait-msg').show()
    #$('.date .prev').on 'click', ->
    #  $('.ajax-wait-msg').show()
    #$('.date .next').on 'click', ->
    #  $('.ajax-wait-msg').show()

    $(".pur_name input").keydown (e) ->
      keyCode = e.keyCode or e.which
      shifted = e.shiftKey
      if keyCode==9 && !shifted
        orig = $(this).parents(".pur_form")
        if(orig.find(".change").css('display')!='none')
          orig.find('form').submit()
          status = orig.find('.status')      
          status.find('div').hide()
          status.find('.wait').show()
          if orig.is $(".pur_form").last()
            clone = orig.clone()
            clone.find('.pur_name input').val("")
            clone.find('.pur_dir input').val("")
            clone.find('.pur_cost input').val("")      
            input = clone.find('.pur_dir input').last()
            input.removeAttr('tabindex')
            clone.find('.pur_dir').html(input)
            clone.find('.status div').hide()        
            orig.after(clone)
            bind_all()
            select2directory(clone.find('.pur_dir input'))
        else
          if orig.is $(".pur_form").last()
            e.preventDefault()
    $('.pur_form form').unbind()
    $('.pur_form form').bind 'ajax:success', (event, data, status, xhr)->  
      $(this).find('.status div').hide()      
      if(data.status=='fail')
        $(this).find('.error').show()
      else        
        if data.edit_destroy_link
          this.action=data.edit_destroy_link
          this.method='put'
          destroy_link = $(this).find('.pur_destroy a')
          destroy_link.attr('href',data.edit_destroy_link)
          destroy_link.show()
          sep = $(this).parents('.forms').find('.separator').detach()
          $(this).parent().after(sep)          

        $(this).find('.ok').show()
    $('.pur_destroy a').bind 'ajax:complete',(event, data, status, xhr)->
      $(this).parents('.pur_form').slideUp()
  bind_all()  
  select2directory = document.select2directory
  select2directory($(".pur_dir input"))    
$(document).ready(main)
document.pur_script = main