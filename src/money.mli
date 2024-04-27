type t [@@deriving sexp, sexp_of]

val ( + ) : t -> t -> t
val ( - ) : t -> t -> t
val is_empty : t -> bool
val is_pos : t -> bool
val is_neg : t -> bool
val empty : t
val of_cents : int -> t
val to_string : t -> string
val of_string : string -> t
val to_abs_string : t -> string
