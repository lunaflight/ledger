open! Core

type person_to_owee_map = (Person.t, Money.t, Person.comparator_witness) Map.t
type t = (Person.t, person_to_owee_map, Person.comparator_witness) Map.t

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
