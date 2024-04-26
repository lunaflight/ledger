open! Core

type t [@@deriving compare, sexp, sexp_of]
type comparator_witness

val comparator : (t, comparator_witness) Comparator.t
val of_name : string -> t
val to_string : t -> string
