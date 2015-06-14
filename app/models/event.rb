class Event < ActiveRecord::Base
	belongs_to :category

	filterrific(
  default_filter_params: { sorted_by: 'date_begin_desc' },
  available_filters: [
    :sorted_by,
    :search_query,
    :with_category_id,

  ]

)
	  self.per_page = 10

  scope :search_query, lambda { |query|
	  # Searches the students table on the 'first_name' and 'last_name' columns.
	  # Matches using LIKE, automatically appends '%' to each term.
	  # LIKE is case INsensitive with MySQL, however it is case
	  # sensitive with PostGreSQL. To make it work in both worlds,
	  # we downcase everything.
	  return nil  if query.blank?

	  # condition query, parse into individual keywords
	  terms = query.downcase.split(/\s+/)

	  # replace "*" with "%" for wildcard searches,
	  # append '%', remove duplicate '%'s
	  terms = terms.map { |e|
	    ('%' + e.gsub('%', '%') + '%').gsub(/%+/, '%')
	  }
	  # configure number of OR conditions for provision
	  # of interpolation arguments. Adjust this if you
	  # change the number of OR conditions.
	  num_or_conds = 2
	  where(
	    terms.map { |term|
	      "(LOWER(events.title) LIKE ? OR LOWER(events.description) LIKE ?)"
	    }.join(' AND '),
	    *terms.map { |e| [e] * num_or_conds }.flatten
	  )
  }

  scope :sorted_by, lambda { |sort_option|
	  # extract the sort direction from the param value.
	  direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
	  case sort_option.to_s
	  when /^date_begin_/
	    # Simple sort on the created_at column.
	    # Make sure to include the table name to avoid ambiguous column names.
	    # Joining on other tables is quite common in Filterrific, and almost
	    # every ActiveRecord table has a 'created_at' column.
	    order("events.date_begin #{ direction }")
	  when /^title_/
	    # Simple sort on the name colums
	    order("LOWER(events.title) #{ direction }")
	  else
	    raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
	  end
  }


	scope :with_category_id, lambda { |category_ids|
	  where(category_id: [*category_ids])
	}



	def self.options_for_sorted_by
		[
			['Name (a-z)', 'title_asc'],
			['Registration date (newest first)', 'date_begin_desc'],
			['Registration date (oldest first)', 'date_begin_asc'],
		]
  end
end
