$(document).ready ->
  $('form.add_dir').bind "ajax:success", (event, data, status, xhr)->
    if data.status=='ok'
      $(".tree").dynatree("getRoot").addChild({ title: data.dir.name, key: data.dir.id, isFolder:true})
  $(".tree").dynatree
    dnd:
      onDragStart: (node) ->
        true      
      autoExpandMS: 1000
      preventVoidMoves: true 
      onDragEnter: (node, sourceNode) ->        
        true
      onDragOver: (node, sourceNode, hitMode) ->
        return false  if node.isDescendantOf(sourceNode)        
        "after"  if not node.data.isFolder and hitMode is "over"
      onDrop: (node, sourceNode, hitMode, ui, draggable) ->        
        sourceNode.move node, hitMode        
        url = $('.change_dir').attr('href')        
        reg = /<span>(.*)<\/span>/
        url = url.replace("_child_",reg.exec(sourceNode.data.title||"<span>0_o</span>")[1])
        url = url.replace("_parent_",reg.exec(sourceNode.parent.data.title||"<span>root</span>")[1])
        $.post(url)      
    onKeydown: (node,e)->
      if e.which == 113 # [F2]        
        editNode(node)
        return false
      
            

  editNode = (node) ->
    virt_node = $('<div/>').html(node.data.title)
    prevTitle = virt_node.find('span').html()
    tree = node.tree
        
    tree.$widget.unbind()
        
    $(".dynatree-title", node.span).html "<input id='editNode' value='" + prevTitle + "'>"
        
    $("input#editNode").focus().keydown((event) ->
      switch event.which
        when 27
          $("input#editNode").val prevTitle
          $(this).blur()
        when 13
          $(this).blur()
    ).blur (event) ->    
      # Accept new value, when user leaves <input>
      title = $("input#editNode").val()
      virt_node.find('span').html(title)
      if title!=prevTitle
        $.ajax virt_node.find('a').attr('href'),
          type: "POST"
          dataType: "json"        
          data:
            directory: {name:title}
      node.setTitle virt_node.html()
      # Re-enable mouse and keyboard handlling
      tree.$widget.bind()
      node.focus()      
    


    