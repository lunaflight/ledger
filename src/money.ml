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

let non_neg_to_string dollars cents =
  if dollars < 0
  then failwith "Negative value"
  else Printf.sprintf "$%d.%02d" dollars cents
;;

let money_to_pair money = money mod 100, money - (money mod 100)

let to_string money =
  let dollars, cents = money_to_pair money in
  if dollars < 0
  then "-" ^ non_neg_to_string (abs dollars) cents
  else non_neg_to_string dollars cents
;;

let to_abs_string money =
  let dollars, cents = money_to_pair money in
  non_neg_to_string (abs dollars) cents
;;
