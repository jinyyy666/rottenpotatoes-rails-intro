module ApplicationHelper
    #watch the video: http://railscasts.com/episodes/228-sortable-table-columns?autoplay=true
    def sortable(column, title = nil)
        title ||= column.titleize
        css_class = column == sort_column ? "hilite" : nil  #adding css
        direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
        link_to title, {:sort => column, :direction => direction}, {:class => css_class} 
    end
end
