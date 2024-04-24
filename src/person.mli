type t

val ( + ) : t -> Money.t -> t
val ( - ) : t -> Money.t -> t

val of_data : string -> Money.t -> t

val string_of_t : t -> string
