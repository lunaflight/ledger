type t

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t

val empty : t
val of_cents : int -> t

val string_of_t : t -> string
