select2directory = (elem, params={})->  
  params['multiple'] = true if params['multiple']==undefined 
  elem.select2
    minimumInputLength: 1,
    multiple: params['multiple']
    query: (query) ->
      data = {results: []}
      $.ajax '/directories/search',
        dataType: 'json'
        data: { q: query.term , exist_only:params['exist_only']}
        error: (jqXHR, textStatus, errorThrown) ->
          
        success: (s_data, textStatus, jqXHR) ->             
          s_data.forEach (elem)->
            data.results.push({id:elem,text:elem});
          query.callback(data);
    initSelection : (element, callback)->
      data = []
      $(element.val().split(",")).each ->        
        data.push({id: this, text: this})
      data = data[0] unless params['multiple']
      callback(data)  
document.select2directory = select2directory