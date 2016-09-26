module ApplicationHelper
	# The difference between writing a helper method vs a model method is that
	# model methods are functions of an instance of a model so they define the
	# model's behaviour.
	# If you have a utility function that doesn't associate itself with a model
	# then that would make an appropriate helper method

	# Provides specified page title
	def full_title(page_title = '')
		base_title = "Ruby on Rails Tutorial Sample App"
		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end
end
