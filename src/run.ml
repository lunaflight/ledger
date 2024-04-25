let transfer =
    let transfer money src dst () =
        let tracker = Saver.load_tracker () in
        let tracker = Tracker.transfer tracker src dst money in
        Saver.save_tracker tracker;
    in
    Command.basic
        ~summary:"Transfer [money] from [src] to [dst]."
        Command.Let_syntax.(
            let%map_open money = anon ("money" %: int)
            and src = anon ("src" %: string)
            and dst = anon ("dst" %: string) in
            transfer (Money.of_cents money) (Person.of_name src) (Person.of_name dst)
        )
    
let check =
    let check src () =
        let owes_list = Tracker.get_owees_of (Saver.load_tracker ()) src in
        let print (person, money) = match money with
            | x when Money.is_pos x -> Printf.printf "%s owes %s %s\n" (Person.string_of_t src) (Person.string_of_t person) (Money.to_abs_string money)
            | x when Money.is_neg x -> Printf.printf "%s paid %s %s\n" (Person.string_of_t src) (Person.string_of_t person) (Money.to_abs_string money)
            | _ -> failwith "$0 should not be recorded in the tracker\n."
        in
        List.iter print owes_list
    in
    Command.basic
        ~summary:"Check how much money [person] has."
        Command.Let_syntax.(
            let%map_open person = anon ("person" %: string) in
            check (Person.of_name person)
        )

let add =
    let add user () =
        Printf.printf "Added %s for tracking.\n" user
    in
    Command.basic
        ~summary:"Add [user] to the database for tracking."
        Command.Let_syntax.(
            let%map_open user = anon ("user" %: string) in
            add user
        )

let command =
    Command.group
        ~summary:"A simple command line interface to track money."
        [ "add", add;
        "check", check;
        "transfer", transfer ]

let main () =
    Command_unix.run ~version:"1.0" ~build_info:"MoneyApp" command
