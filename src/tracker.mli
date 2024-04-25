type t [@@deriving sexp]

val to_string : t -> string
val of_string : string -> t

val empty : t
val update_owes : t -> Person.t -> Person.t -> Money.t -> t
val get_owees_of : t -> Person.t -> (Person.t * Money.t) list
