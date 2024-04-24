type t = {
    name: string;
    money: Money.t;
}

let ( + ) person money = { person with money = Money.( + ) person.money money }
let ( - ) person money = { person with money = Money.( - ) person.money money }

let of_data name money = { name; money }

let string_of_t person = 
    Printf.sprintf "%s: %s" person.name (Money.string_of_t person.money)
