document.select2directory($("input#directories"),{exist_only:true})
document.select2directory($("input#directory"),{multiple:false, exist_only:true})
plot1 = {}
overview1 = {}
reload_plot1 = (s_data)->  
  s_data_plot1 = s_data
  values = [ { label: "Сумма в день", data: s_data_plot1 }]    
  options =
    xaxis:
      mode: "time"
      tickLength: 5
      minTickSize: [1, "day"]
    selection:
      mode: "x"
    grid: 
      hoverable: true 
    series: 
      lines: { show: true },
      points: { show: true }
    tooltip: true
    tooltipOpts:
      content: "%y"

  plot1 = $.plot("#plot1", values, options)  
  overview1 = $.plot("#overview1", values,
    series:
      lines:
        show: true
        lineWidth: 1

      shadowSize: 0

    xaxis:
      ticks: []
      mode: "time"

    yaxis:
      ticks: []
      min: 0
      autoscaleMargin: 0.1

    selection:
      mode: "x"
  )
  
  # now connect the two
  $("#plot1").bind "plotselected", (event, ranges) ->    
    # do the zooming
    plot1 = $.plot("#plot1", values, $.extend(true, {}, options,
      xaxis:
        min: ranges.xaxis.from
        max: ranges.xaxis.to
    ))
    
    # don't fire event on the overview to prevent eternal loop
    overview1.setSelection ranges, true

  $("#overview1").bind "plotselected", (event, ranges) ->
    plot1.setSelection ranges  

reload_plot2 = (s_data)->
  
  plot2 = $.plot('#plot2', s_data, {
    series: {
      pie: { 
        show: true
        }
      },
    legend: {
      show: false
    }
    grid: {
      hoverable: true,
      clickable: true
    }
  })
   

$("input#directories").on "change", ()->    
  selected = JSON.stringify( $("input#directories").select2('data') );
  $.ajax '/reports/dirsum',
    dataType: 'json'
    data: { directories: selected}     
    success: (s_data, textStatus, jqXHR) ->      
      reload_plot1(s_data)

$("input#directory").on "change", ()->    
  selected = $("input#directory").val()
  $.ajax '/reports/dirchildsum',
    dataType: 'json'
    data: { directory: selected}     
    success: (s_data, textStatus, jqXHR) ->      
      reload_plot2(s_data)
      


setDates = (from, to)->  
  $(".date-field #to").val(to.format("DD.MM.YYYY"))  
  $(".date-field #from").val(from.format("DD.MM.YYYY"))
  $(".date-field #from").trigger('change')

$(".date-buttons .last_month").on "click", ()->
  setDates(moment().subtract("month",1), moment())

$(".date-buttons .last_week").on "click", ()->
  setDates(moment().subtract("week",1), moment())

$(".date-field #to,#from").on "change", ()->  
  from_str = $(".date-field #from").val();
  from = moment(from_str, "DD.MM.YYYY").valueOf();
  to_str = $(".date-field #to").val();
  to = moment(to_str, "DD.MM.YYYY").valueOf();  
  plot1.setSelection({ xaxis: { from: from, to: to } });
  overview1.setSelection({ xaxis: { from: from, to: to } });

$("#plot2").bind "plotclick", (event, pos, obj) ->
  return unless obj
  name = obj.series.label
  return if name == "Без категории"
  $("input#directory").select2("data", {id: name, text: name});
  $("input#directory").trigger("change")
  
$("input#directories,input#directory").trigger("change"); #first init

