let transfer =
    let transfer money src dst () =
        Printf.printf "From %s to %s: %d transferred.\n" src dst money
    in
    Command.basic
        ~summary:"Transfer [money] from [src] to [dst]."
        Command.Let_syntax.(
            let%map_open money = anon ("money" %: int)
            and src = anon ("src" %: string)
            and dst = anon ("dst" %: string) in
            transfer money src dst
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
