let cmd =
  let transfer money src dst () =
    let tracker = Saver.load_tracker () in
    let tracker = Tracker.transfer tracker src dst money in
    Saver.save_tracker tracker
  in
  Command.basic
    ~summary:"Transfer [money] from [src] to [dst]."
    (let%map_open.Command src = anon ("src" %: string)
     and dst = anon ("dst" %: string)
     and money = anon ("money" %: string) in
     transfer (Money.of_string money) (Person.of_name src) (Person.of_name dst))
;;
