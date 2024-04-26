open! Core
open! Sexplib.Std

module T = struct
  type t = string [@@deriving compare, sexp, sexp_of]

  let of_name name = name
  let to_string person = person
end

include T
include Comparator.Make (T)
