type t
[@@deriving sexp, sexp_of]

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t
val ( = ) : t -> t -> bool

val empty : t
val of_cents : int -> t

val string_of_t : t -> string
