type t [@@deriving sexp]

val to_string : t -> string
val of_string : string -> t
val empty : t
val transfer : t -> Person.t -> Person.t -> Money.t -> t
val get_owees_of : t -> Person.t -> (Person.t * Money.t) list
val add : t -> Person.t -> t
val delete : t -> Person.t -> t
