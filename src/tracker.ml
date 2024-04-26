open! Core
open! Sexplib
open! Sexplib.Std

type adj_map = Money.t Map.M(Person).t [@@deriving sexp]
type graph = adj_map Map.M(Person).t [@@deriving sexp]
type person_set = Set.M(Person).t [@@deriving sexp]
type t = person_set * graph [@@deriving sexp]

let to_string t = Sexp.to_string @@ sexp_of_t t
let of_string string = t_of_sexp @@ Sexp.of_string string
let empty_set = Set.empty (module Person)
let empty_graph = Map.empty (module Person)
let empty_adj = Map.empty (module Person)
let empty = empty_set, empty_graph

(*
   Transfer [money] from person [src] to Person [dst]
   This means that:
   Person [src] owes [dst] [money] less dollars
   Person [dst] owes [src] [money] more dollars
*)
let transfer ((set, graph) : t) (src : Person.t) (dst : Person.t) (delta : Money.t) =
  if not (Set.mem set src && Set.mem set dst)
  then failwith "Unknown people"
  else (
    let change update_f graph src dst =
      let adj_list_with_only key data = Some (Map.add_exn empty_adj ~key ~data) in
      let update_adj_list_with adj key update_f =
        let new_adj =
          Map.change adj key ~f:(fun x ->
            match x with
            | None -> Some (update_f Money.empty)
            | Some money' ->
              let new_money = update_f money' in
              if Money.is_empty new_money then None else Some new_money)
        in
        if Map.is_empty new_adj then None else Some new_adj
      in
      Map.change graph src ~f:(fun x ->
        match x with
        | None -> adj_list_with_only dst (update_f Money.empty)
        | Some adj -> update_adj_list_with adj dst update_f)
    in
    let add = change @@ fun v -> Money.( + ) v delta in
    let sub = change @@ fun v -> Money.( - ) v delta in
    let graph = sub graph src dst in
    let graph = add graph dst src in
    set, graph)
;;

let get_owees_of (set, graph) person =
  if not @@ Set.mem set person
  then failwith "Person does not exist"
  else (
    match Map.find graph person with
    | None -> []
    | Some x -> Map.to_alist x)
;;

let add (set, graph) person =
  if Set.mem set person
  then failwith "Person already exists"
  else Set.add set person, graph
;;

let delete (set, graph) person =
  if not @@ Set.mem set person
  then failwith "Person does not exist"
  else (
    match get_owees_of (set, graph) person with
    | [] -> Set.remove set person, graph
    | _ -> failwith "Person has outstanding transactions")
;;
