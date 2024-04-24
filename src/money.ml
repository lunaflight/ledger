(* This is the number of cents, as an integer *)
type t = int

let ( + ) cents delta = cents + delta
let ( - ) cents delta = cents - delta

let of_cents cents = cents

let string_of_t money = 
    let dollars = money mod 100 in
    let cents = money - dollars in
    Printf.sprintf "$%d.%02d" dollars cents
