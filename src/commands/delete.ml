let cmd =
  let delete user () =
    let tracker = Saver.load_tracker () in
    let tracker = Tracker.delete tracker user in
    Saver.save_tracker tracker
  in
  Command.basic
    ~summary:"Delete [user] from the tracker."
    (let%map_open.Command user = anon ("user" %: string) in
     delete (Person.of_name user))
;;
