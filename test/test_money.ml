open! Core
open! App
module M = Money

let money_gen =
  Quickcheck.Generator.map (Int.gen_incl Int.min_value Int.max_value) ~f:M.of_cents
;;

let money_pair_gen = Quickcheck.Generator.both money_gen money_gen
let pos_money_gen = Quickcheck.Generator.map (Int.gen_incl 1 Int.max_value) ~f:M.of_cents

let neg_money_gen =
  Quickcheck.Generator.map (Int.gen_incl Int.min_value (-1)) ~f:M.of_cents
;;

let%expect_test "addition is commutative" =
  Quickcheck.test ~sexp_of:[%sexp_of: M.t * M.t] money_pair_gen ~f:(fun (m, m') ->
    [%test_eq: M.t] (M.( + ) m m') (M.( + ) m' m))
;;

let%expect_test "subtract and add is identity" =
  let ( - ) = M.( - ) in
  let ( + ) = M.( + ) in
  Quickcheck.test ~sexp_of:[%sexp_of: M.t * M.t] money_pair_gen ~f:(fun (m, m') ->
    [%test_eq: M.t] (m - m' + m') m)
;;

let%expect_test "positive" =
  Quickcheck.test ~sexp_of:[%sexp_of: M.t] pos_money_gen ~f:(fun m -> assert (M.is_pos m))
;;

let%expect_test "negative" =
  Quickcheck.test ~sexp_of:[%sexp_of: M.t] neg_money_gen ~f:(fun m -> assert (M.is_neg m))
;;

let%expect_test "empty is empty" = assert (M.is_empty M.empty)

let%expect_test "string of empty" =
  Stdio.print_endline @@ M.to_string M.empty;
  [%expect {| $0.00 |}]
;;

let%expect_test "to abs string is same as to string for positive" =
  Quickcheck.test ~sexp_of:[%sexp_of: M.t] pos_money_gen ~f:(fun m ->
    [%test_eq: string] (M.to_string m) (M.to_abs_string m))
;;

let%expect_test "of_cents string representation" =
  let answers =
    [ 0, "$0.00"
    ; 1, "$0.01"
    ; 10, "$0.10"
    ; 99, "$0.99"
    ; 100, "$1.00"
    ; 101, "$1.01"
    ; 420, "$4.20"
    ]
  in
  List.iter answers ~f:(fun (c, s) ->
    assert (String.equal (M.to_string (M.of_cents c)) s))
;;

let%expect_test "valid strings" =
  let xs =
    [ "$0.00"
    ; "$0.01"
    ; "$12.42"
    ; "$.00"
    ; "$.01"
    ; "$0"
    ; "$1"
    ; "0.00"
    ; "0.01"
    ; "12.42"
    ; ".00"
    ; ".01"
    ; "0"
    ; "1"
    ]
  in
  List.iter xs ~f:(fun s -> print_endline (M.to_string (M.of_string s)));
  [%expect
    {|
    $0.00
    $0.01
    $12.42
    $0.00
    $0.01
    $0.00
    $1.00
    $0.00
    $0.01
    $12.42
    $0.00
    $0.01
    $0.00
    $1.00 |}]
;;
