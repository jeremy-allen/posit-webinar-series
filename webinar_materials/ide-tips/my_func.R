# define the function first
grow_city <- function(x) {
	cell <- 1
	organism <- 10
	animal <- (cell + organism) * 2
	family <- animal * 3
	community <- family * 5
	community * x
}

# then add a breakpoint

# then run the function
my_city <- grow_city(x = "Atlanta")

# then add browser()
