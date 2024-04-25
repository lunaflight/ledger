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
    let check user () =
        Printf.printf "User %s has $%d.\n" user 10
    in
    Command.basic
        ~summary:"Check how much money [user] has."
        Command.Let_syntax.(
            let%map_open user = anon ("user" %: string) in
            check user
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
