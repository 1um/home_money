module DirectoriesHelper  
  def list_struct_of dir, &blk
    ret = content_tag :ul, class: 'folder'  do      
      dir.children.collect do |child|
        str = blk.call(child)
        li = content_tag :li, class: 'folder' do
          content_tag(:span, str) + list_struct_of(child,&blk)
        end
        concat li
      end      
    end
  end  
end
# def list_struct_of dir
#     ret = content_tag :ul, class: 'folder'  do      
#       dir.children.collect do |child|
#         li = content_tag :li, class: 'folder' do
#           content_tag(:span, (yield child)) + list_struct_of(child)
#         end
#         concat li
#       end      
#     end
#   end