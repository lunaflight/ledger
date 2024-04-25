open! Core
open! Sexplib
open! Sexplib.Std

type person_to_owee_map = Money.t Map.M(Person).t [@@deriving sexp]
type t = person_to_owee_map Map.M(Person).t [@@deriving sexp]

let to_string tracker = Sexp.to_string @@ sexp_of_t tracker
let of_string string = t_of_sexp @@ Sexp.of_string string

let empty = Map.empty (module Person)
let owees_empty = Map.empty (module Person)

(*
Transfer [money] from person [src] to Person [dst] 
This means that:
    Person [src] owes [dst] [money] less dollars
    Person [dst] owes [src] [money] more dollars
*)
let transfer (tracker : t) (src : Person.t) (dst : Person.t) (money : Money.t) = 
    let change money_f tracker src dst money =
        Map.change tracker src
            ~f:(fun x -> match x with
                | None -> Some (Map.add_exn owees_empty ~key:dst ~data:(money_f Money.empty money))
                | Some owees -> 
                    let new_owees =
                        Map.change owees dst
                        ~f:(fun x -> match x with
                            | None -> Some (money_f Money.empty money)
                            | Some money' ->
                                let new_money = money_f money' money in
                                if Money.(=) new_money Money.empty then None else Some new_money
                        )
                    in
                    if Map.is_empty new_owees then None else Some new_owees
            )
    in
    let add = change Money.(+) in
    let sub = change Money.(-) in
    let tracker = sub tracker src dst money in
    let tracker = add tracker dst src money in
    tracker


let get_owees_of tracker person =
    match Map.find tracker person with
        | None -> []
        | Some x -> Map.to_alist x
