let cmd =
  let add user () =
    let tracker = Saver.load_tracker () in
    let tracker = Tracker.add tracker user in
    Saver.save_tracker tracker
  in
  Command.basic
    ~summary:"Add [user] to the tracker."
    (let%map_open.Command user = anon ("user" %: string) in
     add (Person.of_name user))
;;
