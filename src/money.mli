type t

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t

val of_cents : int -> t

val string_of_t : t -> string
