open! Core
open! Sexplib.Std

(* This is the number of cents, as an integer *)
type t = int [@@deriving sexp, sexp_of]

let empty = 0
let ( + ) cents delta = cents + delta
let ( - ) cents delta = cents - delta
let is_empty t = t = 0
let is_pos t = t > 0
let is_neg t = t < 0
let of_cents cents = cents
let to_pair t = t / 100, t mod 100
let of_pair (dollars, cents) = (dollars * 100) + cents

let non_neg_to_string t =
  let dollars, cents = to_pair t in
  if dollars < 0 || cents < 0
  then failwith "Negative value"
  else Printf.sprintf "$%d.%02d" dollars cents
;;

let to_string t =
  if is_neg t then "-" ^ non_neg_to_string (abs t) else non_neg_to_string t
;;

let to_abs_string t = non_neg_to_string (abs t)

let of_string str =
  let regex =
    Re.compile
      Re.(
        seq
          [ bol
          ; opt (str "$")
          ; group (rep digit)
          ; opt @@ seq [ str "."; group (seq [ digit; digit ]) ]
          ; eol
          ])
  in
  match Re.exec_opt regex str with
  | None -> failwith "Unrecognised format for money"
  | Some groups ->
    (match Re.Group.all groups with
     | [| _; ""; "" |] -> failwith "Ill-formed regex with no data"
     | [| _; dollars; cents |] ->
       let ( = ) = String.( = ) in
       let int_of_string s = if s = "" then 0 else int_of_string s in
       let dollars = int_of_string dollars in
       let cents = int_of_string cents in
       of_pair (dollars, cents)
     | _ -> failwith "Ill-formed regex of wrong length")
;;
