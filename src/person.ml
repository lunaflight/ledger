open! Core
open! Sexplib.Std

module T = struct
    type t = string
    [@@deriving compare, sexp_of]

    let of_name name = name
    let string_of_t person = person
end
include T
include Comparator.Make(T)
