module ApplicationHelper
	def sortable(column, title = nil)
		title ||= column.titleize
		css_class = column == sort_column ? "text-success current #{sort_direction}" : "text-white"
		direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
		link_to title, params.to_unsafe_h.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}

	end
end
