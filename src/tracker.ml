open! Core
open! Sexplib
open! Sexplib.Std

type adj_map = Money.t Map.M(Person).t [@@deriving sexp]
type graph = adj_map Map.M(Person).t [@@deriving sexp]
type t = graph [@@deriving sexp]

let to_string t = Sexp.to_string @@ sexp_of_t t
let of_string string = t_of_sexp @@ Sexp.of_string string
let empty = Map.empty (module Person)
let empty_adj = Map.empty (module Person)

(*
   Transfer [money] from person [src] to Person [dst]
   This means that:
   Person [src] owes [dst] [money] less dollars
   Person [dst] owes [src] [money] more dollars
*)
let transfer (graph : t) (src : Person.t) (dst : Person.t) (delta : Money.t) =
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
  graph
;;

let get_owees_of tracker person =
  match Map.find tracker person with
  | None -> []
  | Some x -> Map.to_alist x
;;
