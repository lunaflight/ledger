open! Core
open! App
module M = Money

let%expect_test "string of empty" =
  Stdio.print_endline @@ M.to_string M.empty;
  [%expect {| $0.00 |}]
;;

let money_gen =
  Quickcheck.Generator.map (Int.gen_incl Int.min_value Int.max_value) ~f:M.of_cents
;;

let money_pair_gen = Quickcheck.Generator.both money_gen money_gen

let%expect_test "addition is commutative" =
  Quickcheck.test ~sexp_of:[%sexp_of: M.t * M.t] money_pair_gen ~f:(fun (m, m') ->
    [%test_eq: M.t] (M.( + ) m m') (M.( + ) m' m))
;;
