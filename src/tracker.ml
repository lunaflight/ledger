open! Core
open! Sexplib
open! Sexplib.Std

type person_to_owee_map = Money.t Map.M(Person).t [@@deriving sexp]
type t = person_to_owee_map Map.M(Person).t [@@deriving sexp]

let to_string tracker = Sexp.to_string @@ sexp_of_t tracker
let of_string string = t_of_sexp @@ Sexp.of_string string

let empty = Map.empty (module Person)
let owees_empty = Map.empty (module Person)

let update_owes (tracker : t) (src : Person.t) (dst : Person.t) (money : Money.t) = 
    Map.update tracker src
        ~f:(fun owees -> match owees with
            | None -> Map.add_exn owees_empty ~key:dst ~data:money
            | Some owees -> Map.update owees dst
            ~f:(fun money' -> match money' with
                | None -> money
                | Some money' -> Money.(+) money money'
            )
        )

let get_owees_of tracker person =
    match Map.find tracker person with
        | None -> []
        | Some x -> Map.to_alist x
