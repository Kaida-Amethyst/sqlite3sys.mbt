///|
test "select1" {
  let _use_record : Record = Record::HashThreshold(0)
  let _use_record2 : Record = Record::Halt
  let _use_sort : SortMode = SortMode::NoSort
  let _use_sort2 : SortMode = SortMode::RowSort
  let _use_sort3 : SortMode = SortMode::ValueSort
  let _use_expected : ExpectedResult = ExpectedResult::Hash(0, "")
  let _use_expected2 : ExpectedResult = ExpectedResult::Values([])
  let db : Ref[Sqlite3] = Ref::new(Sqlite3::init())
  let open_rc : Int = @sqlite3sys.sqlite3_open(CStr::from_string(":memory:"), db)
  assert_true(open_rc == @sqlite3sys.SQLITE_OK)
  let mut hash_threshold : Int = 8
  let label_map : Ref[Array[(String, String)]] = Ref::new([])
  let records = [
    Record::Statement(true, "CREATE TABLE t1(a INTEGER, b INTEGER, c INTEGER, d INTEGER, e INTEGER)", false),
    Record::Statement(true, "INSERT INTO t1(e,c,b,d,a) VALUES(103,102,100,101,104)", false),
    Record::Statement(true, "INSERT INTO t1(a,c,d,e,b) VALUES(107,106,108,109,105)", false),
    Record::Statement(true, "INSERT INTO t1(e,d,b,a,c) VALUES(110,114,112,111,113)", false),
    Record::Statement(true, "INSERT INTO t1(d,c,e,a,b) VALUES(116,119,117,115,118)", false),
    Record::Statement(true, "INSERT INTO t1(c,d,b,e,a) VALUES(123,122,124,120,121)", false),
    Record::Statement(true, "INSERT INTO t1(a,d,b,e,c) VALUES(127,128,129,126,125)", false),
    Record::Statement(true, "INSERT INTO t1(e,c,a,d,b) VALUES(132,134,131,133,130)", false),
    Record::Statement(true, "INSERT INTO t1(a,d,b,e,c) VALUES(138,136,139,135,137)", false),
    Record::Statement(true, "INSERT INTO t1(e,c,d,a,b) VALUES(144,141,140,142,143)", false),
    Record::Statement(true, "INSERT INTO t1(b,a,e,d,c) VALUES(145,149,146,148,147)", false),
    Record::Statement(true, "INSERT INTO t1(b,c,a,d,e) VALUES(151,150,153,154,152)", false),
    Record::Statement(true, "INSERT INTO t1(c,e,a,d,b) VALUES(155,157,159,156,158)", false),
    Record::Statement(true, "INSERT INTO t1(c,b,a,d,e) VALUES(161,160,163,164,162)", false),
    Record::Statement(true, "INSERT INTO t1(b,d,a,e,c) VALUES(167,169,168,165,166)", false),
    Record::Statement(true, "INSERT INTO t1(d,b,c,e,a) VALUES(171,170,172,173,174)", false),
    Record::Statement(true, "INSERT INTO t1(e,c,a,d,b) VALUES(177,176,179,178,175)", false),
    Record::Statement(true, "INSERT INTO t1(b,e,a,d,c) VALUES(181,180,182,183,184)", false),
    Record::Statement(true, "INSERT INTO t1(c,a,b,e,d) VALUES(187,188,186,189,185)", false),
    Record::Statement(true, "INSERT INTO t1(d,b,c,e,a) VALUES(190,194,193,192,191)", false),
    Record::Statement(true, "INSERT INTO t1(a,e,b,d,c) VALUES(199,197,198,196,195)", false),
    Record::Statement(true, "INSERT INTO t1(b,c,d,a,e) VALUES(200,202,203,201,204)", false),
    Record::Statement(true, "INSERT INTO t1(c,e,a,b,d) VALUES(208,209,205,206,207)", false),
    Record::Statement(true, "INSERT INTO t1(c,e,a,d,b) VALUES(214,210,213,212,211)", false),
    Record::Statement(true, "INSERT INTO t1(b,c,a,d,e) VALUES(218,215,216,217,219)", false),
    Record::Statement(true, "INSERT INTO t1(b,e,d,a,c) VALUES(223,221,222,220,224)", false),
    Record::Statement(true, "INSERT INTO t1(d,e,b,a,c) VALUES(226,227,228,229,225)", false),
    Record::Statement(true, "INSERT INTO t1(a,c,b,e,d) VALUES(234,231,232,230,233)", false),
    Record::Statement(true, "INSERT INTO t1(e,b,a,c,d) VALUES(237,236,239,235,238)", false),
    Record::Statement(true, "INSERT INTO t1(e,c,b,a,d) VALUES(242,244,240,243,241)", false),
    Record::Statement(true, "INSERT INTO t1(e,d,c,b,a) VALUES(246,248,247,249,245)", false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "3c13dee48d9356ae19af2515e05e6b54"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "808146289313018fce25f1a280bd8c30"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(b-c),
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND d>e
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 4,2,1,3,5
    ), ExpectedResult::Hash(80, "f588aa173060543daffc54d07638516f"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       d-e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4,
      #|       e
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR (e>c OR e<d)
      #| ORDER BY 1,5,3,2,4
    ), ExpectedResult::Hash(145, "1e4da6adbf79506920a0b1e379d830d8"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5,
      #|       abs(a),
      #|       e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d
      #|  FROM t1
      #| WHERE b>c
      #|   AND c>d
      #| ORDER BY 3,4,5,1,2,6
    ), ExpectedResult::Hash(24, "425542fc8d1ec04f89534ae98d59a74d"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 4,2,1,3
    ), ExpectedResult::Hash(60, "a2af299d7b2197866b7c8f6854b77ab5"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "f2bf77f8cfb62666ab72c866ed4d4f1a"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR c>d
      #| ORDER BY 1
    ), ExpectedResult::Hash(20, "1d6b8ed1db696a5f1c8d126facddd077"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b-c,
      #|       a-b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR a>b
      #|    OR b>c
      #| ORDER BY 1,4,3,2,5
    ), ExpectedResult::Hash(145, "65042db64d506f67a37c85f825cdd11f"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3,
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR b>c
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 4,1,5,2,6,3,7
    ), ExpectedResult::Hash(210, "a259991ed1248a55a07838ce36a7c257"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c,
      #|       b-c
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR a>b
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 5,3,6,1,2,4
    ), ExpectedResult::Hash(180, "631b9506abcdd5dcea64c7ed2a3799ed"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d,
      #|       a+b*2+c*3+d*4,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR c>d
      #| ORDER BY 3,5,4,1,2
    ), ExpectedResult::Hash(125, "58b4ab36ed442f3837188b38cd02486a"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a-b,
      #|       abs(b-c),
      #|       c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 4,3,6,2,5,1
    ), ExpectedResult::Hash(180, "705c6f14a9e50f5542ad5d2fd225e6f1"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (a+b+c+d+e)/5,
      #|       e,
      #|       c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 5,4,6,2,1,7,3
    ), ExpectedResult::Hash(133, "af6179f0918bfe7e3a9cd1940fbb3f75"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a,
      #|       b
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "f88a6f6656b30fc5b3c4ede940008ff2"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(66, "49b01d3ad62fdaa733104a9c70dfb87c"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(b-c),
      #|       b-c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a-b
      #|  FROM t1
      #| WHERE b>c
      #|   AND a>b
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 2,1,6,4,3,5
    ), ExpectedResult::Hash(42, "6921d8dad7855bee57bd82dfd5fcbabc"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       abs(a),
      #|       b-c,
      #|       c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1,5,4,2,6,3
    ), ExpectedResult::Hash(144, "1d2ad7123e951f275353001a6879b3c8"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b-c,
      #|       b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 4,3,5,1,6,2,7
    ), ExpectedResult::Hash(210, "b046dd2378da12da24149ec8171de183"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       a+b*2+c*3+d*4+e*5,
      #|       c-d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 6,2,4,5,3,1
    ), ExpectedResult::Hash(180, "9fc96182924e07a6ffa415425e69adcf"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       abs(a),
      #|       b,
      #|       c-d,
      #|       a+b*2+c*3,
      #|       abs(b-c),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND d>e
      #|   AND c>d
      #| ORDER BY 1,3,7,5,2,6,4
    ), ExpectedResult::Hash(42, "1b3471ef4d294cdab97aa6e5eb44bdc6"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4,
      #|       b-c,
      #|       c
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 2,5,1,7,3,6,4
    ), ExpectedResult::Hash(154, "437f5acfb0bed27efe918cd27dc829cd"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c-d,
      #|       c
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,4,5,6,2,3
    ), ExpectedResult::Hash(132, "b1b55f05abc1bf86626a186d4b60ea65"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND c>d
      #| ORDER BY 1
    ), ExpectedResult::Values(["1000", "1180", "1240"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       abs(b-c),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 6,1,7,3,4,5,2
    ), ExpectedResult::Hash(56, "41c19a8a94cbb13f6a1672a654f9ef40"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a+b*2+c*3,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE d>e
      #|   AND (c<=d-2 OR c>=d+2)
      #|   AND b>c
      #| ORDER BY 2,3,1,5,4
    ), ExpectedResult::Hash(25, "d26c6a15ff9231615a949e9c2412fc2b"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a,
      #|       abs(b-c),
      #|       a+b*2,
      #|       d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR a>b
      #| ORDER BY 4,5,3,7,1,6,2
    ), ExpectedResult::Hash(196, "601e621103e91110c69c4545c08a48c1"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c-d,
      #|       a-b
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 3,5,4,1,2
    ), ExpectedResult::Hash(135, "635b37bb69d24a1353243f6975112cea"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND a>b
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Values([]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE a>b
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR c>d
      #| ORDER BY 3,2,1,4,5
    ), ExpectedResult::Hash(140, "dd6eae29e54f220617fca7f22df83acb"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3,
      #|       c-d,
      #|       (a+b+c+d+e)/5,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 3,4,2,6,5,1
    ), ExpectedResult::Hash(180, "4cf6744bf5d3826cd98ad853eeb5beba"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (a+b+c+d+e)/5,
      #|       abs(b-c),
      #|       abs(a),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 7,2,5,1,3,6,4
    ), ExpectedResult::Hash(154, "b82f838cd6b2f0034ba34f8069a36b09"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b,
      #|       c,
      #|       e
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1,2,4,3,5
    ), ExpectedResult::Hash(70, "f0e2146374bd151d6ede973c9ed1f2a5"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a,
      #|       a+b*2+c*3,
      #|       b,
      #|       d,
      #|       d-e
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 2,6,4,1,5,3
    ), ExpectedResult::Hash(24, "afd55bf27f337fa6f2554d2ae3726e96"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2,
      #|       c-d,
      #|       a,
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 2,6,5,4,3,1
    ), ExpectedResult::Hash(84, "5e2c89b85bc66b196ff3083128f5a494"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       (a+b+c+d+e)/5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c),
      #|       b-c
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 2,5,3,4,1
    ), ExpectedResult::Hash(95, "eae71ba4e872a3ba44a0ecd1bf870a3e"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a,
      #|       a+b*2,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| ORDER BY 1,4,3,2
    ), ExpectedResult::Hash(120, "e86542e069867cfb60f1ec3aef772ebd"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c,
      #|       d-e
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND c>d
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(15, "08fa8e3fd6a4743609ebd0354e659bba"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 2,4,3,1
    ), ExpectedResult::Hash(120, "c328c1a96813bf1072935593f41667ab"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "66be8c935b54646fa54e09d50724c3fc"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d-e
      #|  FROM t1
      #| WHERE d>e
      #|    OR (e>a AND e<b)
      #| ORDER BY 4,1,3,2
    ), ExpectedResult::Hash(72, "25a13d479847a5eb07e7e6088d47b373"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR a>b
      #| ORDER BY 1
    ), ExpectedResult::Hash(23, "58bbff23f68fc8cebb2a4c6436d0b04a"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d-e,
      #|       b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 2,6,3,5,4,1
    ), ExpectedResult::Hash(174, "bf3a367003c73007e24f49edd2245ff8"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       c-d,
      #|       d
      #|  FROM t1
      #| WHERE c>d
      #|   AND a>b
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 1,2,3
    ), ExpectedResult::Values(["131", "1", "133", "182", "1", "183"]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5,
      #|       c,
      #|       (a+b+c+d+e)/5,
      #|       b
      #|  FROM t1
      #| ORDER BY 5,4,1,3,2
    ), ExpectedResult::Hash(150, "b5d3c38c9410c06baec2ae85a2834ffd"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c-d,
      #|       abs(a),
      #|       abs(b-c),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,5,3,2,4
    ), ExpectedResult::Hash(145, "8024d1eebf4b583f802c8e24ef08700f"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(a),
      #|       (a+b+c+d+e)/5,
      #|       a+b*2,
      #|       d-e
      #|  FROM t1
      #| WHERE b>c
      #|   AND (a>b-2 AND a<b+2)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 4,5,3,1,2,6
    ), ExpectedResult::Hash(24, "141c5a5c81089f8c2a8422883e66bae6"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       d
      #|  FROM t1
      #| WHERE d>e
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 3,2,4,1
    ), ExpectedResult::Hash(88, "d5ef959057259760f6e4ff24af1eb5c9"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(a),
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR c>d
      #| ORDER BY 2,3,4,1
    ), ExpectedResult::Hash(120, "d15570017ab0bf7eb3db1e803003e5f0"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "20bb63abd067ae8ef5a05f08be3b6762"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4,
      #|       a+b*2
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 3,4,1,2,5
    ), ExpectedResult::Hash(80, "dda48f2f14d6eef074c866167931274f"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a-b
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(28, "2d23fde26e5c80f6eabca42e592bde71"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4,
      #|       b-c
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 4,1,5,3,2
    ), ExpectedResult::Hash(80, "36b0bd3c4a5efd58912d89eec64b42fe"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(81, "21c30dc6df3b8c769f84c72451f968b5"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       a+b*2,
      #|       a,
      #|       b,
      #|       b-c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 5,2,7,1,4,6,3
    ), ExpectedResult::Hash(210, "0b5da24cf40d35551d12b1cf0eebd15e"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT e
      #|  FROM t1
      #| WHERE b>c
      #|   AND d>e
      #| ORDER BY 1
    ), ExpectedResult::Values(["120", "126", "135", "152", "165", "230", "237", "246"]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b,
      #|       e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(30, "e2107ed9f44c1f14fa1a14b1818a2073"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       d-e,
      #|       c-d,
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 1,2,4,3
    ), ExpectedResult::Hash(120, "d9fe6e44ef568e5ddcdd440b1c1058b2"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR b>c
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(56, "6d15efe8755229aeadcfc31141690e0c"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,3,4,2
    ), ExpectedResult::Hash(88, "4a6aed05d6c85e07758823b33c86f793"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a+b*2+c*3+d*4+e*5,
      #|       c-d
      #|  FROM t1
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(90, "55385fb185c3f7837e3d245e236b0355"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2,
      #|       d-e
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND d>e
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 5,3,1,4,2
    ), ExpectedResult::Hash(50, "0d42d0a09548edf4a343fe9e95c98b2c"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c-d,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND c>d
      #| ORDER BY 2,5,6,4,1,3
    ), ExpectedResult::Hash(18, "51c5d8e007a143cf3bf858945f677039"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d,
      #|       b-c,
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a-b
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (e>c OR e<d)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 7,2,4,1,5,6,3
    ), ExpectedResult::Hash(210, "4abfb880f67a314446d0402a24ae5282"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       d,
      #|       a,
      #|       b-c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND d NOT BETWEEN 110 AND 150
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1,2,4,5,3
    ), ExpectedResult::Values(["317", "108", "107", "-1", "333"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 3,2,4,1
    ), ExpectedResult::Hash(16, "85402be2fec11d33679b4d7e94802e86"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Values(["165"]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c-d
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 3,4,5,1,2
    ), ExpectedResult::Hash(145, "b8a4950564e773b97d38a41c172ef1f7"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND d>e
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(30, "841db017799a825a9fce9bcc940f7f96"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT b-c
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "970be304ddec1d2bede8d8e2f14368c6"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(b-c),
      #|       a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5,
      #|       d-e,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,6,2,4,5,3
    ), ExpectedResult::Hash(174, "05379a2f92dfafe9d9f27b43b2da99a1"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       c,
      #|       b,
      #|       a+b*2+c*3+d*4,
      #|       b-c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR c>d
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 3,5,6,2,4,1
    ), ExpectedResult::Hash(180, "2be73e9f2d4c951c36a76c1e3dba5c9d"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       (a+b+c+d+e)/5,
      #|       c-d,
      #|       b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE d>e
      #|   AND d NOT BETWEEN 110 AND 150
      #|   AND (e>a AND e<b)
      #| ORDER BY 1,3,2,5,4,6
    ), ExpectedResult::Hash(12, "4aec8d073aa39894da494a2e5c69e108"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(120, "a4fdc5ad18d6f820af499abd4b4730ad"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       c,
      #|       a-b,
      #|       d-e,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE d>e
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 2,1,4,3,5
    ), ExpectedResult::Hash(115, "05325b83edf1f52fb3d249495c4114e2"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND b>c
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 1,2
    ), ExpectedResult::Values(["-1", "222", "-1", "222", "1", "333"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       abs(a),
      #|       a,
      #|       c
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (e>c OR e<d)
      #|    OR b>c
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(112, "5ae5415105496a1711310d3c42176846"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c-d,
      #|       a+b*2
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND b>c
      #| ORDER BY 2,4,3,1
    ), ExpectedResult::Hash(56, "5f4a5fcffe6f102f57b56bf2e339dd89"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE c>d
      #|   AND a>b
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(12, "d33f553dec1000186e0827b36e03a5a0"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d-e,
      #|       b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a-b,
      #|       a,
      #|       e
      #|  FROM t1
      #| ORDER BY 4,5,1,3,7,6,2
    ), ExpectedResult::Hash(210, "8d6b363f389996a9821b4e3809779f76"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(b-c),
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 1,6,2,3,5,4
    ), ExpectedResult::Hash(180, "51a0a8497754b6679d3130c947c96360"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(81, "f73fa4ec254d735c86e5741004f72034"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       abs(b-c),
      #|       c-d
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(81, "9be3a71635f36f06be72937acb24a74d"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       abs(a),
      #|       d
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR d>e
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(90, "27ca10878c9391decf14b1da14b81a1a"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(38, "6b17e3a64ebbafbdf4ec543abf34d414"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       abs(a),
      #|       d
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND (e>c OR e<d)
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(12, "2a20cfe00170362fbce52cfe093cf6ad"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a-b,
      #|       abs(b-c),
      #|       c,
      #|       b,
      #|       e
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 4,5,3,6,2,1,7
    ), ExpectedResult::Hash(112, "056a2f68932723bbdeb9dc7c26e21ff8"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (a>b-2 AND a<b+2)
      #|    OR b>c
      #| ORDER BY 1,3,5,4,2
    ), ExpectedResult::Hash(140, "3dfb60ce29bfaa3deb2c90771787ae28"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3,
      #|       d-e,
      #|       b,
      #|       a,
      #|       c,
      #|       a+b*2
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR (e>a AND e<b)
      #|    OR d>e
      #| ORDER BY 5,6,3,7,2,1,4
    ), ExpectedResult::Hash(154, "7be42f68cbfeb20d2a574569eabc62b8"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c-d
      #|  FROM t1
      #| WHERE c>d
      #|    OR (a>b-2 AND a<b+2)
      #|    OR b>c
      #| ORDER BY 1,3,5,2,4
    ), ExpectedResult::Hash(130, "3872625fdb5d1bd8d2d87c61b2c5d2b9"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(a),
      #|       c-d,
      #|       d
      #|  FROM t1
      #| WHERE b>c
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR (e>c OR e<d)
      #| ORDER BY 4,6,5,1,3,7,2
    ), ExpectedResult::Hash(203, "449a18d19874d7ee976c4c9fc953e3f4"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR c>d
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(81, "3bd0cf1b195cb05eea3e0621c5a4f38e"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "1692ce3bd9941e0f21090da530fd3ed8"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3,
      #|       a+b*2,
      #|       d-e
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,3,7,2,5,6,4
    ), ExpectedResult::Hash(203, "9cc51c802e6d11db1eb947a0431c0898"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b,
      #|       d,
      #|       a
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 6,2,4,3,1,7,5
    ), ExpectedResult::Hash(70, "e83d593c583f1a0cfb445b1c4ab673b7"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a-b,
      #|       b,
      #|       a+b*2,
      #|       a
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND (e>c OR e<d)
      #|   AND d>e
      #| ORDER BY 4,2,5,3,1
    ), ExpectedResult::Hash(25, "4d716c3a4be4e2c0fcaeb771d9557147"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d,
      #|       e,
      #|       c-d,
      #|       a+b*2+c*3+d*4,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND c>d
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,4,3,2,5,6
    ), ExpectedResult::Hash(60, "49ec3df5c9e8b7e47d18c5d97b1d9016"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a,
      #|       abs(a),
      #|       abs(b-c),
      #|       a+b*2+c*3,
      #|       e
      #|  FROM t1
      #| WHERE d>e
      #|   AND (e>a AND e<b)
      #| ORDER BY 7,2,6,1,3,4,5
    ), ExpectedResult::Hash(14, "f5cc6a1ae440bad52d8adeea6cd6cc2e"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       d-e,
      #|       abs(a),
      #|       a,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE a>b
      #|    OR c>d
      #| ORDER BY 1,5,3,2,4
    ), ExpectedResult::Hash(130, "9873ab86b9fa0eef10810ba4277fd1bf"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       abs(a),
      #|       a-b,
      #|       d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND b>c
      #| ORDER BY 4,6,3,1,5,2
    ), ExpectedResult::Hash(84, "c1c96a830016492c89e9fe7b92275b24"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR a>b
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(56, "fedff1b28e56669aacb1dc79b927abf9"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c-d,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND (a>b-2 AND a<b+2)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,2,3
    ), ExpectedResult::Values(["333", "-3", "1000"]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c-d,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 4,2,1,5,3
    ), ExpectedResult::Hash(80, "06c104cf923af770f3cf98700c2428d0"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT e
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "41762f74ba25ab0f9b0448f319f2f292"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       b,
      #|       d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 4,3,5,6,2,1
    ), ExpectedResult::Hash(84, "e1b8a5e4a3649a2976b00eaf0962058b"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       c-d,
      #|       a,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a-b
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR b>c
      #| ORDER BY 4,2,1,5,3
    ), ExpectedResult::Hash(145, "d7e8eaed9394e826f4fdcccf068acdec"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b-c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE c>d
      #|   AND b>c
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 3,4,1,2
    ), ExpectedResult::Values(["4", "1", "1240", "738"]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "8d2279ba80763220505cecac39786e90"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(b-c),
      #|       a-b
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND c>d
      #| ORDER BY 6,5,4,1,3,2
    ), ExpectedResult::Hash(78, "f8b104ce0c1d6a8d02976b512c224c33"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d,
      #|       e
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(108, "e6f51d286e2a4011462e5e862a19f461"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2,
      #|       a-b,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE a>b
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR d>e
      #| ORDER BY 2,1,3,4
    ), ExpectedResult::Hash(120, "227ac1db8da88813615a7e008801fba7"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR b>c
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(84, "aa77bd3dacaadb8d94850b7457313394"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       d,
      #|       e,
      #|       a+b*2+c*3+d*4,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b-c,
      #|       a
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 3,2,7,6,4,1,5
    ), ExpectedResult::Hash(49, "59469ea88ee1e7a74590c514b7eb4fe0"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       d,
      #|       a+b*2+c*3,
      #|       a-b,
      #|       e
      #|  FROM t1
      #| ORDER BY 3,2,1,5,4
    ), ExpectedResult::Hash(150, "2064f4d12bd17daef2792157a3fa01ac"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b-c,
      #|       (a+b+c+d+e)/5,
      #|       abs(b-c),
      #|       a+b*2+c*3,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND (e>c OR e<d)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 6,7,2,1,3,4,5
    ), ExpectedResult::Values(["-3", "13", "1", "167", "1", "1000", "333"]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3,
      #|       d-e
      #|  FROM t1
      #| WHERE a>b
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 2,3,4,1,5
    ), ExpectedResult::Hash(20, "d6130a18387e9029c427520c8fdd0b08"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2,
      #|       a,
      #|       abs(b-c),
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR b>c
      #| ORDER BY 3,5,4,2,6,7,1
    ), ExpectedResult::Hash(196, "ce60e2883fe7a0c41c29c17e9b62bf51"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(a),
      #|       a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR d>e
      #|    OR b>c
      #| ORDER BY 2,3,1,5,4,6
    ), ExpectedResult::Hash(150, "c31247552305ea7108b6c15517e4e50e"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a+b*2,
      #|       a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,3,6,2,5,4
    ), ExpectedResult::Hash(18, "d03c3163674ffb21402396369c50ac14"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND d>e
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(32, "274f52e7976f1e1a7151a9a4804ccd13"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b,
      #|       abs(a)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "909ebdb8fc6864d4dffee74235090ed7"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a+b*2+c*3+d*4+e*5,
      #|       b,
      #|       c-d,
      #|       abs(b-c),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 5,1,4,7,3,2,6
    ), ExpectedResult::Hash(210, "24fae43b38fe9736d9fc79f183773c0f"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND (e>c OR e<d)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Values(["3331"]), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       b,
      #|       a-b
      #|  FROM t1
      #| WHERE c>d
      #|    OR d>e
      #|    OR b>c
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(84, "35aa92c733c1c60fedff6d6a36a4e64f"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a-b
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "c2001bebc4d3d2d6b01a5a50ce4282ca"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a-b
      #|  FROM t1
      #| WHERE a>b
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 3,2,4,1
    ), ExpectedResult::Hash(104, "57317371c67d5ca0360d9860ff06b5f6"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       e,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 2,4,1,5,3
    ), ExpectedResult::Hash(150, "b77fe449c8203b5d18b816d00d4a9229"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       c,
      #|       d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR b>c
      #| ORDER BY 3,5,4,2,1
    ), ExpectedResult::Hash(140, "db6ada3c6b4c6105c96c56f98bd679d1"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE b>c
      #|   AND a>b
      #|   AND (e>a AND e<b)
      #| ORDER BY 2,1
    ), ExpectedResult::Values([]), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       b-c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE b>c
      #|   AND a>b
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(21, "47e5ff2f412981bf5017a3fcd7dcbfce"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       d,
      #|       b-c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND b>c
      #|   AND c>d
      #| ORDER BY 3,5,1,4,2
    ), ExpectedResult::Hash(10, "f7cc18e47d7f1cfbd32b65f410f3661f"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       (a+b+c+d+e)/5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 2,1,3,4
    ), ExpectedResult::Hash(108, "3646f1aa507ad28fc4b6bcb6b18ef7d8"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND c>d
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(12, "536e87880b7535393cfec01b6b44b09e"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND d>e
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Values(["222"]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       b-c
      #|  FROM t1
      #| WHERE b>c
      #|   AND d>e
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(14, "d2bcb971c3fe19befbef456f67ecb854"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b,
      #|       d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(42, "fdf2c9075b2487f82c8ad837755619d7"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "52abcdd72ea8512b37c16f4859ec7416"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c,
      #|       a+b*2
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(87, "ccf71f7ab4716bebd70a7047162430d0"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "3c13dee48d9356ae19af2515e05e6b54"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(28, "7626a6dc10da4bbb0672aba278414d7f"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a,
      #|       a+b*2+c*3,
      #|       b,
      #|       d
      #|  FROM t1
      #| WHERE c>d
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 4,5,1,3,2
    ), ExpectedResult::Hash(150, "6704b1d160521eabdc6985e64f098711"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       b-c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(57, "e46ef205fe944f0d32288b2138a40f06"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       (a+b+c+d+e)/5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 3,1,2,5,4
    ), ExpectedResult::Hash(150, "34ca74f90850eff35ac3a230238544be"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2,
      #|       c-d
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 5,3,2,4,1
    ), ExpectedResult::Values([]), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a+b*2,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE b>c
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(57, "25d96795a29f85eafc1253b3af853f3d"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d-e,
      #|       a+b*2+c*3+d*4,
      #|       c,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 7,3,2,6,4,5,1
    ), ExpectedResult::Hash(210, "295b9d736969e666ddf559dd8479c415"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       abs(a),
      #|       a-b
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(45, "c5572ef5e70213b43133e2248770b61d"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "549bae2f0c4b97245bbc42bc5ab31a00"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       abs(b-c),
      #|       c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(a),
      #|       e
      #|  FROM t1
      #| WHERE b>c
      #|   AND d>e
      #| ORDER BY 4,5,6,3,2,1
    ), ExpectedResult::Hash(48, "8b118828e8caafc9faa4a21d0f3f4ea5"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 1
    ), ExpectedResult::Hash(22, "5d0ecdbff39863d98aa5a23e0424ac1e"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b,
      #|       a
      #|  FROM t1
      #| WHERE b>c
      #|   AND d>e
      #| ORDER BY 4,1,3,2
    ), ExpectedResult::Hash(32, "3ff228db977b596ebd4901df4462b000"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5,
      #|       a,
      #|       abs(a),
      #|       c-d,
      #|       c
      #|  FROM t1
      #| ORDER BY 2,5,4,6,3,1
    ), ExpectedResult::Hash(180, "5e503b736a28f01aee385b8265f1f970"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(22, "1e52dd7b5731c2e28fbbaa8fccc86f65"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       b,
      #|       e
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(57, "3b71140e165ea6e7999b7cafbbcf505e"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a-b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(b-c),
      #|       d-e
      #|  FROM t1
      #| ORDER BY 3,1,4,5,2
    ), ExpectedResult::Hash(150, "9af213128ae7e4d07c408d80d61aa3e9"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       e
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(28, "574174bf2275d3475e01cc0a0bf79a10"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "aae77ef6a7bbfce44e353697e1736636"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d
      #|  FROM t1
      #| WHERE a>b
      #|   AND (e>a AND e<b)
      #| ORDER BY 7,2,4,6,1,3,5
    ), ExpectedResult::Values([]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "52abcdd72ea8512b37c16f4859ec7416"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b,
      #|       e
      #|  FROM t1
      #| WHERE d>e
      #|    OR (a>b-2 AND a<b+2)
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(50, "21c42d24d668ed183a14ca91e1fccc01"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2
      #|  FROM t1
      #| WHERE a>b
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(34, "b663d3edefc8630f2d6777c28f5c29ab"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       d,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(63, "67014c0f59103ab6dc50f88f61063545"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       c-d
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "375f2a2c47ba21a5304489027a18978e"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       a+b*2
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR a>b
      #|    OR b>c
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(112, "ac8288fa97219e018be4a8600f11d525"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4+e*5,
      #|       d,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE b>c
      #|   AND (c<=d-2 OR c>=d+2)
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,3,1,6,4,5
    ), ExpectedResult::Hash(42, "8ce8889165dbfc2a153b8e41d6eac176"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c,
      #|       b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "068283feddad9ffb2ebce753740a6ff6"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4+e*5,
      #|       c-d,
      #|       d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,3,4,2
    ), ExpectedResult::Hash(88, "271cfc0737d448d8e0ae9b778205fcad"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT b
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "bac2461f7c1f964c0863658a20e1c90b"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "20bb63abd067ae8ef5a05f08be3b6762"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND d NOT BETWEEN 110 AND 150
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Values(["205", "222", "168", "333", "182", "333", "201", "333"]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       d-e
      #|  FROM t1
      #| WHERE d>e
      #|   AND (e>a AND e<b)
      #|   AND b>c
      #| ORDER BY 1,5,3,4,2
    ), ExpectedResult::Values(["247", "743", "3706", "245", "2"]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3
      #|  FROM t1
      #| WHERE b>c
      #|    OR a>b
      #|    OR (e>a AND e<b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(28, "8a2f1569db1be3db575496e85928f459"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       e,
      #|       a-b
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND b>c
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(24, "197dccd8f3680b77a75b13440eff5f55"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       a,
      #|       b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(120, "5a3b2a8f188159e2277f9a1be70537c7"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c),
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2
      #|  FROM t1
      #| WHERE d>e
      #|   AND c>d
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 6,5,2,1,3,4
    ), ExpectedResult::Hash(36, "655fcbfb8bb7e6d53f5f1c6bbbacbaac"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE b>c
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(58, "689847f49b3867b87e7c46dfeb0da7c1"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       c-d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE d>e
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 1,2,4,3
    ), ExpectedResult::Hash(108, "709932df0abe61ded2f95a3b2b8e9c34"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       abs(a),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a-b,
      #|       a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| ORDER BY 3,5,1,2,7,4,6
    ), ExpectedResult::Hash(210, "d312440b05a05bd531e9e6b7ad183255"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       abs(a),
      #|       d,
      #|       (a+b+c+d+e)/5,
      #|       c-d
      #|  FROM t1
      #| WHERE d>e
      #|   AND (e>c OR e<d)
      #| ORDER BY 2,1,3,5,4
    ), ExpectedResult::Hash(80, "c2a7201b8a94fbc5ee1c17b8cb6ac369"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,5,3,2,4
    ), ExpectedResult::Hash(75, "1cdfc134eae0ccc6b2fdb86041b2f365"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2,
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b-c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND d>e
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 7,2,1,5,6,4,3
    ), ExpectedResult::Hash(14, "d8e81dbe9389b8a7fb955726d1018688"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 7,6,5,2,1,3,4
    ), ExpectedResult::Hash(133, "e0e2d07862532072e37e60225da99516"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE a>b
      #|   AND (c<=d-2 OR c>=d+2)
      #|   AND c>d
      #| ORDER BY 6,5,4,2,3,1
    ), ExpectedResult::Hash(18, "7b37fd650c93c3580d86ed2112de3518"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a+b*2,
      #|       e
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(78, "a88e3903af86c39edba2d15c2acfc4b3"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4,
      #|       b,
      #|       b-c,
      #|       e,
      #|       a
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (e>a AND e<b)
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 3,2,1,6,5,4
    ), ExpectedResult::Values([]), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4,
      #|       c
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(54, "cbda5acbecfd69e4351d6c31044f2a08"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c-d
      #|  FROM t1
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "01e6705b8ce30b74a653cb8e3458effa"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       abs(b-c),
      #|       (a+b+c+d+e)/5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND (e>a AND e<b)
      #|   AND a>b
      #| ORDER BY 3,4,1,2
    ), ExpectedResult::Values([]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3,
      #|       b-c,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 1,2,3,4
    ), ExpectedResult::Hash(120, "8d7ff24438c0a277a9bbed686f335d28"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(12, "bb2456b338921ab7c0396823cc0ec31d"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       d,
      #|       a+b*2+c*3+d*4,
      #|       c,
      #|       d-e,
      #|       a+b*2
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND (a>b-2 AND a<b+2)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 4,6,2,5,1,3
    ), ExpectedResult::Hash(24, "d3ad3f7ebd6091fc1b026ddaa4b37bd8"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       abs(b-c),
      #|       c,
      #|       a-b,
      #|       c-d,
      #|       a+b*2+c*3+d*4,
      #|       b
      #|  FROM t1
      #| ORDER BY 2,6,7,4,1,5,3
    ), ExpectedResult::Hash(210, "819f805dd8c8f59e2159f9e38ff4eac6"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b,
      #|       d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #|    OR a>b
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(87, "3bc9e8a82df39cae8e27bb5a0fff18d3"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a+b*2+c*3+d*4,
      #|       d,
      #|       e
      #|  FROM t1
      #| ORDER BY 2,4,1,3
    ), ExpectedResult::Hash(120, "fa86590cde28cc33911bb46fb0ec59e1"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       c-d,
      #|       d-e,
      #|       abs(a),
      #|       a-b,
      #|       c,
      #|       b
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 3,2,1,4,7,5,6
    ), ExpectedResult::Hash(133, "ec7e7648bfc1da6386905d63a1ef52a3"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       e,
      #|       a+b*2+c*3+d*4,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3,
      #|       abs(a),
      #|       c-d
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (e>c OR e<d)
      #| ORDER BY 1,4,2,5,7,3,6
    ), ExpectedResult::Hash(189, "225b9220120f5debc0a77757e6a544a7"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       c
      #|  FROM t1
      #| WHERE d>e
      #|    OR (e>a AND e<b)
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,3,1,4,5,6
    ), ExpectedResult::Hash(174, "bfaefefd9e122c30da40356d11e517b0"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 1
    ), ExpectedResult::Hash(28, "f52dd949bc4f482c1ca7166a80d2304d"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,3,2,4
    ), ExpectedResult::Hash(88, "fcc8243428e8bf0faa312279fec704a0"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b,
      #|       c,
      #|       abs(a)
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 1,3,2,4,5
    ), ExpectedResult::Hash(80, "4cf6188a63134ebf831c245aed6fd46d"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       c-d
      #|  FROM t1
      #| ORDER BY 4,1,2,3,5
    ), ExpectedResult::Hash(150, "00fcc8fc925a74eb4ec0f853929e555f"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       e,
      #|       a+b*2+c*3,
      #|       c
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR d>e
      #| ORDER BY 3,4,2,5,1
    ), ExpectedResult::Hash(110, "7c7ca7dc3909bad67db7afb2ce90ee58"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(a)
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "d1361dd52a9236110ba64b28a64f850d"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       d,
      #|       a-b,
      #|       abs(a),
      #|       c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 5,2,1,4,6,3
    ), ExpectedResult::Hash(132, "d551d268f45008968f8d65e271eab053"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(a),
      #|       a-b,
      #|       a+b*2+c*3,
      #|       d-e,
      #|       b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,5,6,2,4,7,3
    ), ExpectedResult::Hash(91, "e0fe8de872329c82af624de95132584e"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3,
      #|       a-b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c,
      #|       a
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (e>a AND e<b)
      #|   AND a>b
      #| ORDER BY 2,4,6,5,1,3
    ), ExpectedResult::Values([]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 4,1,3,2
    ), ExpectedResult::Hash(56, "68bfd05b60394ed25ff6ddecdef16e10"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1
    ), ExpectedResult::Hash(22, "4c13d7a8f6f0787460deb4f3b6773d2e"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c-d,
      #|       b-c,
      #|       a+b*2+c*3+d*4,
      #|       c,
      #|       abs(a)
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 2,1,4,5,6,3,7
    ), ExpectedResult::Hash(112, "7d1953113f7f07c9266eb09edadd82f9"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a+b*2+c*3+d*4,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a,
      #|       abs(b-c),
      #|       abs(a)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 5,4,2,1,3,6
    ), ExpectedResult::Hash(24, "c056e4645726c5e6382dbf4704692804"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       a,
      #|       abs(b-c),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b-c,
      #|       (a+b+c+d+e)/5,
      #|       e
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR (a>b-2 AND a<b+2)
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,5,1,4,7,6,2
    ), ExpectedResult::Hash(210, "aa06fc327d04c2ee6a642cd3025e7a4b"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b
      #|  FROM t1
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(90, "17d30af1540fc60a9630b9e47d95bc9f"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a-b,
      #|       c,
      #|       abs(b-c),
      #|       d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,6,4,5,2,7,3
    ), ExpectedResult::Hash(203, "7e5bd83081d1dfafd0fe247ffd00be89"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       a+b*2+c*3+d*4,
      #|       a,
      #|       abs(b-c),
      #|       abs(a),
      #|       (a+b+c+d+e)/5,
      #|       c
      #|  FROM t1
      #| ORDER BY 2,4,5,6,3,7,1
    ), ExpectedResult::Hash(210, "3aeee1754c550f295bd6081aa0496d47"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(a),
      #|       e,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d,
      #|       a-b
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (e>a AND e<b)
      #| ORDER BY 7,4,1,2,6,5,3
    ), ExpectedResult::Hash(168, "13eedb15c528a86a89d4e94d334639e6"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       b,
      #|       d-e,
      #|       a,
      #|       abs(b-c),
      #|       d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,2,5,4,3,6
    ), ExpectedResult::Hash(132, "b3cd55701ddc8e4db4b9247dcda03ec4"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "dd2f68e88e982f64348a02e0ea88e9e6"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(a),
      #|       d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a,
      #|       a+b*2
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 5,6,3,1,2,4,7
    ), ExpectedResult::Hash(49, "d9af3c86c55045321eccea3c3f39b048"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d-e
      #|  FROM t1
      #| WHERE b>c
      #|   AND d>e
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(10, "e43fc83490b72542af8316746a9d8313"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE b>c
      #|    OR (e>a AND e<b)
      #| ORDER BY 2,4,1,3
    ), ExpectedResult::Hash(64, "ad2644ea3960ffbe041c9a505773a231"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND b>c
      #| ORDER BY 1
    ), ExpectedResult::Values(["905", "1000", "1391", "1416"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       abs(b-c),
      #|       a-b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3,
      #|       e,
      #|       b
      #|  FROM t1
      #| ORDER BY 2,6,3,5,7,4,1
    ), ExpectedResult::Hash(210, "f14eeff1f1479bf32bacc054fa720071"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "b07b2168ff53b46689e49c06ab4331fc"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(a),
      #|       d-e,
      #|       b,
      #|       abs(b-c),
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 6,1,4,2,5,3,7
    ), ExpectedResult::Hash(210, "029d94ade68a27ab16900e1e1f6f3c54"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3,
      #|       e
      #|  FROM t1
      #| WHERE c>d
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,3,4,1
    ), ExpectedResult::Hash(120, "2aa5f26c8186061ab63b692ca759a624"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a,
      #|       a+b*2+c*3,
      #|       abs(b-c),
      #|       c-d,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 3,2,6,4,5,1
    ), ExpectedResult::Hash(24, "f58bc57bc11bb9db10f81aa30edc7829"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       a+b*2+c*3+d*4,
      #|       d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a-b,
      #|       b
      #|  FROM t1
      #| WHERE c>d
      #|   AND a>b
      #| ORDER BY 2,4,3,6,1,5
    ), ExpectedResult::Hash(42, "9aa7acd8fc07cfd1d6e0028928e8342b"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(b-c)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND c>d
      #| ORDER BY 1
    ), ExpectedResult::Values(["1", "1", "2"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       c-d,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(b-c),
      #|       (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND a>b
      #|   AND c>d
      #| ORDER BY 7,1,5,3,2,4,6
    ), ExpectedResult::Hash(42, "719b82439155e612b0a13ee9e8496dea"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR d>e
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(58, "fca9ff5897fd8bf220dfd03ebf9bf41d"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4,
      #|       c-d,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| ORDER BY 2,3,4,5,1
    ), ExpectedResult::Hash(150, "1536add5230caaf9675672fd3bbbc85b"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE a>b
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(10, "c457994b9b0d51a0004a2e98359bf04c"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d-e
      #|  FROM t1
      #| WHERE a>b
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(10, "85ba30eef17fc9cad69f60d48a75b0b9"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR b>c
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "60438bc97433575b27692732a1fc3a1a"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR d>e
      #|    OR (e>c OR e<d)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(56, "693fcab084970cc9c34f84cb13c7533e"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 2,4,5,1,3
    ), ExpectedResult::Hash(30, "7f66566999f88b34321d64aafb17b34d"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       abs(a),
      #|       (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(120, "322fbb90672f08ec55b91dd2b85b8bc5"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2,
      #|       b,
      #|       abs(b-c),
      #|       c-d
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND d>e
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 3,5,6,7,2,1,4
    ), ExpectedResult::Hash(35, "af0cf854a2303f03902c08706147e8d9"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a-b,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE c>d
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(69, "21fb0616ea7789afb7e48ef466387e01"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE b>c
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(87, "9f14eddd318ce87987f67ec027255159"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a,
      #|       b
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(66, "6ceda7f4ed630291e9090bc96e62be7c"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a-b,
      #|       abs(a),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a
      #|  FROM t1
      #| ORDER BY 2,4,5,1,3
    ), ExpectedResult::Hash(150, "3d333b73ba68315675c5463fb4536269"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a-b,
      #|       a+b*2+c*3,
      #|       abs(b-c),
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR d>e
      #|    OR a>b
      #| ORDER BY 5,3,2,4,1
    ), ExpectedResult::Hash(140, "fc266d3bd870c2607aaf5ba9f695a329"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(b-c),
      #|       b-c,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND (c<=d-2 OR c>=d+2)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 2,5,4,6,3,1
    ), ExpectedResult::Hash(60, "755f345cafbb73c0340e12a2580bb1e8"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       abs(b-c),
      #|       a,
      #|       abs(a),
      #|       b,
      #|       a+b*2
      #|  FROM t1
      #| WHERE a>b
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 1,6,3,5,4,2
    ), ExpectedResult::Hash(138, "2c0e002c91f6421ebd123815070f3033"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(b-c)
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "ebf2696a89b67ae7c2bb5d796d902b72"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       b-c,
      #|       d-e,
      #|       a+b*2+c*3+d*4,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 6,4,1,5,3,7,2
    ), ExpectedResult::Hash(14, "89b8c971ba8b5b3394998a86198c12f6"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5,
      #|       c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 2,4,5,6,1,3
    ), ExpectedResult::Hash(156, "7133d2c62ac44540d9e489748fb517d0"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "8d2279ba80763220505cecac39786e90"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT e
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "41762f74ba25ab0f9b0448f319f2f292"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a+b*2
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(48, "431151c60a9de2bc6ff9aa315143615e"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "95dc79fe00aff04819a8779833b65771"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1
    ), ExpectedResult::Hash(22, "998be35e038bf206f9c89e0d7e73dd6d"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a,
      #|       d,
      #|       c,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 4,2,3,1,5
    ), ExpectedResult::Hash(150, "669ba5af7838e6691a8c9d82c2fe58d8"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4,
      #|       d,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 4,5,3,2,1
    ), ExpectedResult::Hash(145, "3c0e6f9113f9cdb790a510df17043eae"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d-e
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 1
    ), ExpectedResult::Hash(22, "1c223baf885ce762193d10b87614346e"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a+b*2+c*3,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(90, "63183180942512db4a775679869a001e"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a,
      #|       d-e,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE d>e
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 4,3,5,1,2
    ), ExpectedResult::Hash(80, "1a37211e113e1cc55cffc131c9892bb1"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       e,
      #|       a+b*2,
      #|       a,
      #|       a-b
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,2,5,3,6,4
    ), ExpectedResult::Hash(90, "1b3e2c80abe73c47dce4a903782ad899"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       b-c,
      #|       a+b*2+c*3+d*4,
      #|       b,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND d NOT BETWEEN 110 AND 150
      #|   AND (e>a AND e<b)
      #| ORDER BY 4,1,5,6,2,3
    ), ExpectedResult::Hash(12, "622a1ca6f971aae91058cf1067b530ff"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(b-c),
      #|       b-c,
      #|       c,
      #|       a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND b>c
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 3,5,2,1,6,4
    ), ExpectedResult::Values([]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a-b,
      #|       a,
      #|       abs(a)
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,2,3,4
    ), ExpectedResult::Hash(88, "2820aafd42976a6213cb2b0499401103"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       c,
      #|       b-c,
      #|       a+b*2+c*3+d*4,
      #|       a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND (e>a AND e<b)
      #| ORDER BY 7,5,3,2,6,4,1
    ), ExpectedResult::Hash(14, "6ae7f7555d748317d1f77e0f76a877fc"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       b-c,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "577bb9d41043fa7499fca863c9201ba8"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND (a>b-2 AND a<b+2)
      #|   AND c>d
      #| ORDER BY 1,2,3
    ), ExpectedResult::Values([]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       e,
      #|       abs(a),
      #|       c-d,
      #|       a,
      #|       b-c
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 7,1,5,3,4,6,2
    ), ExpectedResult::Hash(196, "3f2cca604f78daaa5c238d7f0fa01745"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2+c*3,
      #|       a-b,
      #|       abs(b-c),
      #|       a+b*2
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 2,1,5,4,3
    ), ExpectedResult::Hash(125, "71783a534966e0cd68c32a87f62c08ec"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR (a>b-2 AND a<b+2)
      #|    OR d>e
      #| ORDER BY 1,3,2,4
    ), ExpectedResult::Hash(112, "6c6d4d118f8a7982bfb86d67579436e7"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "9a0d83a47e9ea85f0da38e0f9ca27f2e"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       c
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(30, "0f5786c35d6a3334fe23ccebd6d6b4f8"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(b-c),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 3,2,1,6,4,5
    ), ExpectedResult::Hash(174, "a414c5a3ec57033e4ca2e3c9988f6f81"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b,
      #|       a,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 1,2,3,4,5
    ), ExpectedResult::Hash(150, "cd311c880932c0ed3363877a87566def"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(90, "a8152191b3cd5070f3841704cd959495"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a+b*2,
      #|       abs(a),
      #|       b
      #|  FROM t1
      #| ORDER BY 4,2,1,3
    ), ExpectedResult::Hash(120, "3cd408ee0d03339fac22eca8ec8d2bb8"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       b-c,
      #|       d-e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 5,3,2,1,4
    ), ExpectedResult::Hash(75, "893e24339a4507d442b4fa21e8520989"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4,
      #|       b-c
      #|  FROM t1
      #| ORDER BY 6,1,3,5,4,2
    ), ExpectedResult::Hash(180, "58102a16454762090d8cca488692e7fa"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "0c542471646c50440dc6eda5bb1b61a8"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a-b,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(75, "8d30bfb2d85041d1a0419ccbf6a5b78f"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       e,
      #|       b-c
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND b>c
      #|   AND c>d
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(9, "f43d74c9e89e35866c98a91869e403da"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d,
      #|       b-c
      #|  FROM t1
      #| WHERE c>d
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND a>b
      #| ORDER BY 2,4,3,5,1
    ), ExpectedResult::Hash(30, "70df2aeb36f371ec975106f8a74d10ee"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE a>b
      #|    OR (e>a AND e<b)
      #| ORDER BY 4,6,2,5,1,3
    ), ExpectedResult::Hash(138, "226c6ba76feacd2b0d92d3dee611399d"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "7233f8ee208b3d2922a1c079ce9f785a"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "32eaa03d1690e6a79bee8609c596e8e4"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b,
      #|       a,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE a>b
      #|   AND (e>c OR e<d)
      #| ORDER BY 3,7,2,5,6,4,1
    ), ExpectedResult::Hash(126, "a3c1afa7c92832ab10d89a3cdd218e17"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4+e*5,
      #|       b-c,
      #|       a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4,
      #|       a-b
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND c>d
      #|   AND b>c
      #| ORDER BY 6,5,7,4,3,1,2
    ), ExpectedResult::Values(["192", "2878", "1", "191", "444", "1918", "-3"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       c,
      #|       abs(a),
      #|       d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE d>e
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND (e>a AND e<b)
      #| ORDER BY 2,4,5,6,3,7,1
    ), ExpectedResult::Hash(14, "94dc1eae57798c8862e7d5b4cfd12cff"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 2,1
    ), ExpectedResult::Values(["115", "3", "191", "18", "220", "24", "245", "29"]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 4,5,3,2,1
    ), ExpectedResult::Hash(150, "41a342f4212e2a14116ba83427e049be"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Values(["222"]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR d>e
      #|    OR a>b
      #| ORDER BY 1
    ), ExpectedResult::Hash(26, "7dcc836442eac90a7fa906c12d0ffba1"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       b-c
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(22, "5df231969b8d5bdc0ea1ed90ff3b23d2"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(a),
      #|       a+b*2+c*3,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE b>c
      #|   AND (c<=d-2 OR c>=d+2)
      #|   AND c>d
      #| ORDER BY 2,1,5,6,4,3
    ), ExpectedResult::Values(["-3", "1918", "18", "191", "1158", "382"]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a-b
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "3b45a32bacb258a454a82f10a8146228"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (a+b+c+d+e)/5,
      #|       b,
      #|       c-d,
      #|       a+b*2,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE c>d
      #|   AND (e>c OR e<d)
      #|   AND d>e
      #| ORDER BY 4,7,5,2,1,6,3
    ), ExpectedResult::Hash(42, "f778b6cfbf38f0fadd2c9175abb14947"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       a-b,
      #|       b,
      #|       b-c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 1,5,4,3,2,6,7
    ), ExpectedResult::Hash(210, "e53b6730271bb74da608aeb6d75ea354"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(a)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR b>c
      #| ORDER BY 2,4,3,1
    ), ExpectedResult::Hash(76, "ae99c64007a7ed5e938cc3f7d79c5d00"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d,
      #|       abs(a),
      #|       e,
      #|       a+b*2
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 3,4,2,1,5
    ), ExpectedResult::Hash(110, "56d7502cb25a03f7170e568d9124ecc9"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       abs(b-c),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b-c
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #|   AND (e>c OR e<d)
      #| ORDER BY 2,1,4,3
    ), ExpectedResult::Values(["105", "1", "333", "-1", "129", "4", "333", "4"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       e,
      #|       c-d,
      #|       a-b
      #|  FROM t1
      #| WHERE b>c
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 4,1,2,3
    ), ExpectedResult::Hash(116, "e51d5af527372bac218e0b5c21153013"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5,
      #|       b
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "532651aa8e5c293b169f68dbcbc547ff"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       (a+b+c+d+e)/5,
      #|       abs(b-c),
      #|       c,
      #|       d
      #|  FROM t1
      #| WHERE c>d
      #|    OR a>b
      #| ORDER BY 4,2,3,1,5
    ), ExpectedResult::Hash(130, "621684d11a2a5694126393ed924fd34b"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       d,
      #|       abs(b-c)
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "94a68989fa6a8cf9e887b617692bb101"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a+b*2+c*3,
      #|       abs(b-c),
      #|       d-e
      #|  FROM t1
      #| ORDER BY 1,3,4,2
    ), ExpectedResult::Hash(120, "5dc183edf914e31f94314b7bc288848d"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       abs(a),
      #|       d-e,
      #|       e
      #|  FROM t1
      #| ORDER BY 2,4,1,3
    ), ExpectedResult::Hash(120, "e70daaeccb2899ae3ab5a338ca45c0fa"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR c>d
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(30, "907d0240f42a1141b7870e0424b0dd04"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a-b,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "421f11d9db40e5b3cfea3a86c2b3bf1c"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(58, "91d6869d5b9abdb04ae95cba62e03774"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(a),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND c>d
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(9, "0598e89fd314145ba8f06f228456f4ba"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c-d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR d>e
      #| ORDER BY 1
    ), ExpectedResult::Hash(28, "ae8b5e96b30d88fb1ab70fe4095e3a96"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       d,
      #|       a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (a+b+c+d+e)/5,
      #|       b,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 1,5,3,7,4,6,2
    ), ExpectedResult::Hash(210, "e2f7b27ca407bf9df4acb3be08c64524"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       a,
      #|       c-d,
      #|       abs(b-c),
      #|       b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 4,3,2,5,1,6
    ), ExpectedResult::Hash(180, "7e45631d2b6d6694abd0f917d9c07c4a"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       (a+b+c+d+e)/5,
      #|       d,
      #|       b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c
      #|  FROM t1
      #| ORDER BY 4,6,2,1,5,3
    ), ExpectedResult::Hash(180, "e636f30eea1a3449e5944de44985d2c5"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       a+b*2+c*3+d*4+e*5,
      #|       b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       e,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 1,4,5,3,6,2
    ), ExpectedResult::Hash(180, "a41f3eb3f1b24084c9ad20c7fa2cadc4"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(a)
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 1
    ), ExpectedResult::Hash(19, "7935ab41ef16fa86550d2ecd13497930"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(15, "21fef18aeb42508fd385db124bd2a8cc"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a-b,
      #|       b-c,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR b>c
      #| ORDER BY 4,6,3,1,5,7,2
    ), ExpectedResult::Hash(210, "166de7592ef32109aae1d9670d3e23bf"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4+e*5,
      #|       b-c
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 3,4,5,1,2
    ), ExpectedResult::Hash(50, "6d77d0e395c0c3bb7ebe48a114a7a9a5"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "52abcdd72ea8512b37c16f4859ec7416"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(b-c),
      #|       c,
      #|       a-b,
      #|       abs(a)
      #|  FROM t1
      #| ORDER BY 6,1,3,5,2,4
    ), ExpectedResult::Hash(180, "864ee28e245ce38778cd4be32d567b92"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c,
      #|       a,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 2,3,1,4
    ), ExpectedResult::Hash(120, "62c5856425278965c1b1a7b2686bb1a4"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(a)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND d>e
      #|   AND (e>a AND e<b)
      #| ORDER BY 1
    ), ExpectedResult::Values(["220", "245"]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (a+b+c+d+e)/5,
      #|       c-d
      #|  FROM t1
      #| ORDER BY 2,4,5,1,3
    ), ExpectedResult::Hash(150, "d2ce913033e84a4c69b91191db3b8a07"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(100, "75b6e86f949d9a728fe5a891632d62a6"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 3,2,4,5,7,1,6
    ), ExpectedResult::Hash(210, "a5fffe20bb1c7a1e393e2560a6e79be6"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       abs(a),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b-c,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 4,5,3,2,1
    ), ExpectedResult::Hash(150, "6c74a3313ad194acb0f970e759de70e8"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,2,1,4
    ), ExpectedResult::Hash(12, "fae09a9a32247b430470a8b81fbc6cc9"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c,
      #|       d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR c>d
      #| ORDER BY 1,2,4,5,6,3
    ), ExpectedResult::Hash(102, "1a7c46130532fbc982bba080af7ee291"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5,
      #|       d,
      #|       e,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 2,3,4,1,5
    ), ExpectedResult::Hash(150, "9f8c9a18fe3256a5427a7cbef090f435"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b,
      #|       e,
      #|       b-c
      #|  FROM t1
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(90, "600c8683d405cc652ef67b480900c83f"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       abs(a),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND (e>a AND e<b)
      #| ORDER BY 1,5,3,4,6,2,7
    ), ExpectedResult::Hash(21, "d87da634fb840b1c06fbe4a9044e809d"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND (e>c OR e<d)
      #|   AND c>d
      #| ORDER BY 2,1
    ), ExpectedResult::Values(["-3", "0", "-1", "0", "-1", "0"]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a+b*2,
      #|       d,
      #|       b-c,
      #|       a-b,
      #|       d-e
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND c>d
      #| ORDER BY 3,1,2,5,6,4
    ), ExpectedResult::Hash(30, "d39306fef5d6bbbd904608305c01b290"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "15596791cdb51704f8ab6f597e39790d"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(18, "f3239d2a5434ca8e937f4aed1cb80ccd"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       e
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "7275ca47f09492dd08ec32ff81fb9e1f"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2+c*3+d*4,
      #|       a-b,
      #|       a+b*2
      #|  FROM t1
      #| WHERE d>e
      #|   AND c>d
      #|   AND a>b
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(12, "22099d5488a4d865c8fe18b2de1567c6"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a+b*2+c*3,
      #|       d-e
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(33, "4464e6b6019973b9357faf1898fdb3f3"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a,
      #|       d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c),
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 4,5,1,6,3,2
    ), ExpectedResult::Hash(24, "0cdc4c325ebe279be7c16130db81e299"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       abs(a),
      #|       a+b*2+c*3,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 4,2,5,1,3
    ), ExpectedResult::Hash(150, "744565fa85149ebe3ea996326d3b8b13"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2
      #|  FROM t1
      #| WHERE a>b
      #|    OR (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(28, "accae7212929fbefc8d634ddef286572"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(90, "d4c08d26fb7262abff3283495e53ef07"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3,
      #|       b,
      #|       d
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 1,5,4,2,3
    ), ExpectedResult::Hash(95, "1a8655839cdf4d5e78d3243ea63e7d46"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a+b*2
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR (a>b-2 AND a<b+2)
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(58, "6e904065f56e9d17cd6aa8d20a330f24"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a-b,
      #|       d-e,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,2,5,4,1
    ), ExpectedResult::Values([]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2,
      #|       b,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE a>b
      #|    OR (e>c OR e<d)
      #| ORDER BY 4,3,6,5,2,1
    ), ExpectedResult::Hash(168, "14f600ab97eac8730eb4e16e5d99c249"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       e,
      #|       d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 4,2,5,1,3
    ), ExpectedResult::Hash(150, "3fdfec9cdbff8e41bfa6e3add56c1ee2"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(90, "1f593201ad9d2210fa9b56b756bc1237"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       a+b*2+c*3+d*4+e*5,
      #|       c-d
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND (e>a AND e<b)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 3,2,1
    ), ExpectedResult::Values(["245", "3706", "-1", "220", "3331", "2"]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "ec9f02c46c399db521c47dd9cb6a40dd"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4+e*5,
      #|       b,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 5,2,1,7,3,4,6
    ), ExpectedResult::Hash(98, "42243c8de628bef73888c710837ce1fe"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d,
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(42, "adb133664f189e7397ae8b901fdafabc"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b,
      #|       b-c
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(60, "537018406f031d7e81f5a1a9ee9d4b64"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       c-d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 1,4,3,2,5
    ), ExpectedResult::Hash(150, "034d9cdf4634c24ca574f76ba23ed550"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a-b,
      #|       abs(a),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE b>c
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 4,3,1,5,6,2
    ), ExpectedResult::Hash(114, "d289034237130317cf469cf3bc27c879"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4,
      #|       b
      #|  FROM t1
      #| WHERE c>d
      #|    OR d>e
      #| ORDER BY 2,5,1,3,4
    ), ExpectedResult::Hash(120, "6b7c62f6dba560a1b1cfb4a0de687636"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b,
      #|       a-b,
      #|       b-c,
      #|       d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR (e>a AND e<b)
      #| ORDER BY 2,6,1,4,3,5
    ), ExpectedResult::Hash(144, "9266b31632a5347c36e4390e5c199fb9"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       d-e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4+e*5,
      #|       e,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 6,5,1,7,2,3,4
    ), ExpectedResult::Hash(210, "0b9d7c7d7a7c7cc0a5d90f1990a043e9"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE b>c
      #|    OR (e>c OR e<d)
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 3,2,1,4
    ), ExpectedResult::Hash(116, "033ab3b385a760384a80f7c2f8116b27"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(45, "c53f1f88bc7b92d941462d1081bacb46"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 1
    ), ExpectedResult::Hash(22, "59cac8a106613a4b6a96e597e54b11bc"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a-b
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 1
    ), ExpectedResult::Hash(14, "28d7a52ffd1e2866a0fa7582a43ec38e"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       d,
      #|       e,
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(a),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE a>b
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,4,5,2,6,7,3
    ), ExpectedResult::Hash(119, "3a6edab399d6a254ca226d567f101ed2"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a,
      #|       abs(a),
      #|       c,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 5,4,1,2,3
    ), ExpectedResult::Hash(150, "33c133cd531a8c83b0e12c1bf2816a47"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a,
      #|       d-e,
      #|       e
      #|  FROM t1
      #| ORDER BY 4,3,2,1,5,7,6
    ), ExpectedResult::Hash(210, "72748aa05256149f5b609735556600ee"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(11, "6d95745357c8d363bb187f409b7252c8"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d,
      #|       c
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "69d4ff328a48a4f568bea511642fb2b6"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d-e
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND a>b
      #| ORDER BY 1
    ), ExpectedResult::Hash(18, "a5e48a0153bf4c438302b48fadaaa38e"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2,
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 4,3,2,5,7,1,6
    ), ExpectedResult::Hash(154, "48148b8db7389fcfe7ce1305fd4c4baa"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       b-c,
      #|       a-b,
      #|       a+b*2+c*3+d*4,
      #|       abs(a)
      #|  FROM t1
      #| ORDER BY 1,5,3,4,2
    ), ExpectedResult::Hash(150, "7b23e04dc880c8d57e7ebf2ce767fde5"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(33, "83af9d93602ea54fa991d265574a4c3a"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (a+b+c+d+e)/5,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c-d,
      #|       d-e
      #|  FROM t1
      #| WHERE b>c
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 2,3,6,7,4,1,5
    ), ExpectedResult::Hash(182, "9bb679937b36be78dd530a683782d10a"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a+b*2+c*3+d*4,
      #|       c-d,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 2,4,3,1
    ), ExpectedResult::Hash(120, "7c9d31e357ba5e9ca4d8d2ef8f56117a"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(108, "4213133a1f82afa8019caa346d9e5849"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "4ff348b6082ffad99447100b2c77aca6"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       b-c,
      #|       a+b*2+c*3,
      #|       abs(a),
      #|       c-d,
      #|       a,
      #|       d-e
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 4,6,1,3,7,2,5
    ), ExpectedResult::Hash(98, "8420ffda963b1647bef090ee5739449a"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR c>d
      #| ORDER BY 1
    ), ExpectedResult::Hash(25, "3a8c1f92b5515a90e97181b7aaf6970b"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "70364ca416eb4255377b03cd243b032a"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a+b*2+c*3,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| ORDER BY 4,1,2,3
    ), ExpectedResult::Hash(120, "a6627a0078cbf942e660977a942b5987"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b-c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 6,4,5,1,2,3
    ), ExpectedResult::Hash(66, "80d5784436f12d6111be1755171b13d4"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d-e,
      #|       a,
      #|       abs(a)
      #|  FROM t1
      #| ORDER BY 3,1,4,2
    ), ExpectedResult::Hash(120, "9fdbbe77da4a2d6902d4d55104121739"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(90, "fb63c0da23b6869a02b06048ea39681c"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND a>b
      #| ORDER BY 1
    ), ExpectedResult::Values(["0", "1"]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b,
      #|       b-c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| ORDER BY 5,3,1,2,6,4
    ), ExpectedResult::Hash(180, "8308675248fdb458de9cb714090daf99"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(58, "9646b8b8b446280ab97d4f5e30a51bae"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(b-c),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a-b,
      #|       abs(a)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR d>e
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 4,1,5,6,3,2
    ), ExpectedResult::Hash(144, "87705ab033397683288724d8d8a8303e"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR (e>a AND e<b)
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(58, "62ca5e1d2214a5edbe47153dda5696b9"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a
      #|  FROM t1
      #| WHERE b>c
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND (e>c OR e<d)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(16, "8f1e0e0c04143148e7f0b70519bcc456"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       b,
      #|       abs(a),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR a>b
      #| ORDER BY 2,3,4,1
    ), ExpectedResult::Hash(96, "045d2c4fc1e63a274a28e442878914b1"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       d-e,
      #|       a+b*2+c*3+d*4,
      #|       d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(a)
      #|  FROM t1
      #| WHERE b>c
      #|   AND (e>c OR e<d)
      #| ORDER BY 2,3,4,5,6,1
    ), ExpectedResult::Hash(78, "68b9d7afd5c62e5c4bb2c20478a07a61"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(b-c)
      #|  FROM t1
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(90, "ea5d42bf4b76916f27ca2207d5f3a1cb"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3,
      #|       a-b
      #|  FROM t1
      #| WHERE a>b
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(30, "6ad8accda9cddcf28817fbf053942483"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT b
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(11, "c11ff9c2a7e1278b7c296c552128c88a"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d,
      #|       a,
      #|       a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 2,5,3,1,4
    ), ExpectedResult::Hash(110, "76487e705db851d7db9ddf5ba8be0c56"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b,
      #|       c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 5,3,2,1,4
    ), ExpectedResult::Hash(15, "49314335687b2ed3cd15a37ace339ff2"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a-b,
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "eb08dc2a0f14d493bfe5f8cf91fb03ba"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(42, "0b30094aec5125c1843b3e6e1e41a6e8"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "91d685ea328c85b4182c8973881038bf"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b-c,
      #|       b
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,4,2,1
    ), ExpectedResult::Hash(100, "028c01fd1a3fde99ed6dcf60c1113942"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       c,
      #|       b,
      #|       (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 6,5,3,1,2,4
    ), ExpectedResult::Hash(96, "d43f79239513169ba12520f7a149dee7"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT b-c
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "789bee9c1319bb51fce441fc48c889eb"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (a+b+c+d+e)/5,
      #|       abs(a),
      #|       abs(b-c),
      #|       c-d
      #|  FROM t1
      #| ORDER BY 3,7,1,4,6,2,5
    ), ExpectedResult::Hash(210, "83f9eb2c991235ceaf943aab7abde5f6"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       e
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(81, "93d7b3b407d166dc7e232faf70b8c121"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c,
      #|       a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 5,1,2,4,3,6,7
    ), ExpectedResult::Hash(105, "6f1348d248b462331e2adebdb5140a95"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(11, "7ba247a09824fc0a1f84d576feb5c1ba"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #|   AND c>d
      #| ORDER BY 2,1
    ), ExpectedResult::Values(["1826", "333", "1529", "555"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3,
      #|       a,
      #|       (a+b+c+d+e)/5,
      #|       b
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 4,2,6,5,3,7,1
    ), ExpectedResult::Hash(98, "9672e04e6af85e083efc6d3a01ad003c"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a-b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 1,3,4,2
    ), ExpectedResult::Hash(120, "aba88e7aab9b448d205e6978445e0e60"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (a+b+c+d+e)/5,
      #|       d,
      #|       d-e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR (e>c OR e<d)
      #| ORDER BY 5,4,2,3,1
    ), ExpectedResult::Hash(150, "13d3c2f83fa3cf186cf6ebda9e14254f"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c,
      #|       d
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 4,5,2,1,3
    ), ExpectedResult::Hash(55, "a7ad6c80c65b6fa1575e15a286ab717b"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       abs(b-c),
      #|       a+b*2
      #|  FROM t1
      #| WHERE d>e
      #|   AND a>b
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(30, "0c419a3b667dc7ff35fb414aaaaa747d"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR b>c
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(58, "1ffc5abf8d6961518c76505d9de3ccda"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "8d2279ba80763220505cecac39786e90"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       b,
      #|       a+b*2
      #|  FROM t1
      #| WHERE b>c
      #|   AND (e>a AND e<b)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 5,1,2,3,4
    ), ExpectedResult::Hash(10, "b1ede94648229b93b2cbc4b745c90874"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "a693972973d8fc824fbad0bfa2fd3a4a"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4,
      #|       a,
      #|       abs(a),
      #|       a-b
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 5,4,1,2,7,6,3
    ), ExpectedResult::Values(["112", "114", "1120", "1130", "111", "111", "-1"]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 6,3,1,2,4,5
    ), ExpectedResult::Hash(132, "fd0adbb2bc4037a6ef6fcec0141f7aa1"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       d-e,
      #|       d,
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 3,2,4,1
    ), ExpectedResult::Hash(120, "437e9c1325f85bf8fe189bd06339009d"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(b-c)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(10, "957f34bd4f6530b19d41aade9e48d932"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c
      #|  FROM t1
      #| WHERE d>e
      #|    OR a>b
      #| ORDER BY 4,3,2,1,5
    ), ExpectedResult::Hash(125, "9fcf17184ac87f3ca33f5aa74b552242"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(a),
      #|       a+b*2
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 2,4,3,1
    ), ExpectedResult::Hash(120, "d1679dff50b535f67256f37abd94fa60"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       b-c,
      #|       a+b*2+c*3+d*4,
      #|       c-d,
      #|       d-e
      #|  FROM t1
      #| WHERE c>d
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 7,3,6,5,2,1,4
    ), ExpectedResult::Hash(119, "2dfa1a701af66a88618468f9f2eca6d7"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d-e
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 1,3,2,4
    ), ExpectedResult::Values(["111", "113", "111", "4"]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       c-d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| ORDER BY 1,6,5,3,4,2
    ), ExpectedResult::Hash(180, "149fa3187b59deeaf8ca7bc9937e9c50"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1
    ), ExpectedResult::Hash(28, "c029877def2553b6b07b4b2447e85a59"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "891035696f9a04823f3dbdce5a5c13d9"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       e,
      #|       b
      #|  FROM t1
      #| WHERE d>e
      #|   AND (a>b-2 AND a<b+2)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,3,2
    ), ExpectedResult::Values(["167", "165", "167", "182", "180", "181"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a+b*2+c*3,
      #|       (a+b+c+d+e)/5,
      #|       b-c
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1,3,2,4
    ), ExpectedResult::Hash(64, "0019a4d9f417a2e0b2bee1637e4db8e5"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a-b
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "c2001bebc4d3d2d6b01a5a50ce4282ca"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       d-e,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(66, "d267b7520137b39e8d2ace7f0e1ef90a"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(27, "f46e34330cef7bee4b17e127fcb2433f"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       abs(b-c),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| ORDER BY 2,4,3,1
    ), ExpectedResult::Hash(120, "c5eed4dd2096983dedfd37fc4de11557"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(a)
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "d1361dd52a9236110ba64b28a64f850d"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 1,3,4,2
    ), ExpectedResult::Hash(120, "9d8ae71d1d4851666a75fec8bc675773"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       b,
      #|       (a+b+c+d+e)/5,
      #|       a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 4,5,6,1,3,2
    ), ExpectedResult::Hash(96, "a762a09cf2fc3bb7b96a1bacd3516820"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(b-c),
      #|       c-d
      #|  FROM t1
      #| ORDER BY 2,1,3,4,5
    ), ExpectedResult::Hash(150, "9fa5902ee5ef32c5318e0331bdd35651"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c-d,
      #|       e,
      #|       abs(a),
      #|       d
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (e>a AND e<b)
      #| ORDER BY 6,1,5,2,4,7,3
    ), ExpectedResult::Hash(28, "20c5a451edebc73adbd8b3afd216f599"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d
      #|  FROM t1
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(90, "4ef8091171bdcd75f14227ae962a986b"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       a-b,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 3,2,4,5,1
    ), ExpectedResult::Hash(150, "02281452fc49042060157771c16a930d"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c-d
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR (e>a AND e<b)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(90, "b5050d48797882b2954b2bb7278991db"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       e
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "81c7f303422ff0623fdd74a5b0bdbcd9"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c,
      #|       a+b*2+c*3,
      #|       d-e,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| ORDER BY 3,4,6,5,1,2
    ), ExpectedResult::Hash(180, "2161c1bb9bf5dcc5d41eb7df1b167b6c"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a-b,
      #|       c,
      #|       a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 5,3,2,7,4,6,1
    ), ExpectedResult::Hash(203, "a70de5f3561fda65160a44d7ad57fc73"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(b-c)
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "ebf2696a89b67ae7c2bb5d796d902b72"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       c,
      #|       abs(a),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b-c,
      #|       e
      #|  FROM t1
      #| ORDER BY 4,5,1,6,2,3
    ), ExpectedResult::Hash(180, "8c1ed130d0125560ee81e819bc8451af"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1,4,3,5,2
    ), ExpectedResult::Hash(30, "b72fdab2abc695b36a856741c6479ebf"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a,
      #|       c
      #|  FROM t1
      #| WHERE d>e
      #|    OR b>c
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(50, "522548ede2edcdbad05472fed877bcf0"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       c-d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2,
      #|       b,
      #|       b-c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 5,2,4,1,6,3,7
    ), ExpectedResult::Hash(210, "ad750cadd33a9416af71d69c5fac509d"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a,
      #|       b,
      #|       abs(a),
      #|       a+b*2,
      #|       c-d
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1,6,5,3,4,2
    ), ExpectedResult::Hash(84, "0ecaed2bac05ece627b8a5c6f2cb4b2e"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "a97f06c7abca35ed0602e7a54b6ca0ac"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4,
      #|       e,
      #|       a+b*2,
      #|       a+b*2+c*3,
      #|       d,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 2,1,5,3,6,4,7
    ), ExpectedResult::Hash(210, "161ac3c1cf64f016c4aef4116ee3199f"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       c-d,
      #|       a
      #|  FROM t1
      #| WHERE b>c
      #|   AND (e>a AND e<b)
      #|   AND c>d
      #| ORDER BY 1,2,3
    ), ExpectedResult::Values(["-2", "3", "191"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b-c,
      #|       a,
      #|       abs(a)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR d>e
      #| ORDER BY 3,5,6,2,1,7,4
    ), ExpectedResult::Hash(196, "ab60be6b2b2d576e28c474ce597e7441"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       e,
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR d>e
      #| ORDER BY 1,4,2,3
    ), ExpectedResult::Hash(116, "2a17d36050e5bdef7be9ed7b01e0a9c9"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c-d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       b-c,
      #|       a+b*2,
      #|       d-e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND (e>a AND e<b)
      #| ORDER BY 3,4,1,5,6,2,7
    ), ExpectedResult::Hash(21, "677c2b291c4593e92612ecd64d0703bc"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3,
      #|       a,
      #|       a-b,
      #|       d
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 6,1,2,3,5,4
    ), ExpectedResult::Hash(12, "01ab6b4f408df903621edf08828ba7a5"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c-d
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(27, "4f0b87d21ae9d581463d0337566933ca"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       abs(a),
      #|       c-d
      #|  FROM t1
      #| ORDER BY 2,3,4,1
    ), ExpectedResult::Hash(120, "a4578cf950facb85e767ae2f602ba469"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       c
      #|  FROM t1
      #| WHERE d>e
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(54, "7ef904f67c0bd193d03e91e943f2254d"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       a+b*2+c*3+d*4,
      #|       d
      #|  FROM t1
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(90, "b368ccf9ec5229d5659d6054528d110f"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d-e,
      #|       abs(a),
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 3,2,1,5,4
    ), ExpectedResult::Hash(150, "76e5018cbc30cd20144c127779caf4e4"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       (a+b+c+d+e)/5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(a),
      #|       d-e,
      #|       abs(b-c),
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 6,4,5,3,1,2,7
    ), ExpectedResult::Hash(210, "cf1b2c11f53350ce1f0c0a031cc6e450"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1
    ), ExpectedResult::Values(["101", "108", "114", "116", "122", "128"]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       abs(a),
      #|       a-b,
      #|       b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 5,4,3,2,1,6
    ), ExpectedResult::Hash(84, "14526e3289f9c25f8ddec1f33ed95aa2"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE c>d
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1
    ), ExpectedResult::Hash(17, "fd124b0d49b605a982ab65f59bf5aac4"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE d>e
      #|    OR (e>a AND e<b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(18, "00eaa2dde5ee48c9fad5b73a356050c3"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       a+b*2+c*3,
      #|       a
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "7c21a2e1ae8c9a9f0c09afe41b297db1"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c>d
      #|   AND b>c
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Values(["137", "222", "142", "222"]), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       abs(a),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(87, "2e112c9fa195e0196b96e9bc6865f855"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 1
    ), ExpectedResult::Hash(25, "dc50dec43bf5c7dc2083e3bab2eaf863"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(b-c)
      #|  FROM t1
      #| WHERE c>d
      #|   AND d NOT BETWEEN 110 AND 150
      #|   AND a>b
      #| ORDER BY 1
    ), ExpectedResult::Values(["1", "2", "2", "3", "3", "4"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a
      #|  FROM t1
      #| ORDER BY 4,2,3,1
    ), ExpectedResult::Hash(120, "cdadd86b806e762ee9d7d03f0058ff4a"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3,
      #|       c-d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 1,2,5,3,4,7,6
    ), ExpectedResult::Hash(98, "22e6c9d358a8b1d08d6e48554c7f9c03"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a-b,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(33, "42122d82d5402dcfd82d6a76041c1f84"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       abs(a),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 3,2,4,1
    ), ExpectedResult::Hash(108, "19afedc91ac4b2e557c09139d88f4464"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       c-d,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE a>b
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(72, "d376c0c0a239bc9353aca7c75bfea493"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a+b*2+c*3,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c-d
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR (e>c OR e<d)
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,3,2,4
    ), ExpectedResult::Hash(120, "e4051c95ff9075750460d662b42d72d5"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c>d
      #|   AND b>c
      #| ORDER BY 2,1
    ), ExpectedResult::Values(["-3", "222", "-3", "222", "-1", "222", "-1", "222"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       b-c,
      #|       abs(b-c),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1,3,4,2
    ), ExpectedResult::Hash(24, "7f41fdcc58ab92f66267d95eaee41293"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 3,4,2,1
    ), ExpectedResult::Hash(88, "8a7565aef4b4ff5dc5b2669162892999"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d,
      #|       c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 4,2,3,1,5,6
    ), ExpectedResult::Hash(24, "9e80b3c7e910457fc023a082297c66a6"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "0267d5a030ef7be744b11e28265acf35"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(b-c),
      #|       abs(a),
      #|       a+b*2,
      #|       a,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       e
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND d NOT BETWEEN 110 AND 150
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 4,2,3,7,1,5,6
    ), ExpectedResult::Hash(21, "55e9888ae6ebbdb592c80dceb129e53a"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(a),
      #|       c,
      #|       d
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 2,1,5,3,4
    ), ExpectedResult::Hash(15, "f7f59b0d893d8b24a77e45c84e33a4dc"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a-b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c,
      #|       e
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 2,5,1,4,3
    ), ExpectedResult::Hash(80, "90c813844bf5d6adeffa4f21f6ca28f2"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4+e*5,
      #|       b,
      #|       d-e,
      #|       c
      #|  FROM t1
      #| WHERE c>d
      #|   AND d>e
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,4,1,5,3,6
    ), ExpectedResult::Hash(36, "13898e32c711a65529fa502c0c91de6e"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       abs(b-c),
      #|       a+b*2+c*3,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(a)
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 3,4,1,5,2
    ), ExpectedResult::Hash(80, "e86e8f12a1e9c6fcfe83ba56451cc897"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       d-e,
      #|       abs(a)
      #|  FROM t1
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(90, "9e6b6e593015eae16b128f67c55d6d78"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT e
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (c<=d-2 OR c>=d+2)
      #|   AND (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(12, "d3120a0926c913ba6ee017b144ef600c"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "0c542471646c50440dc6eda5bb1b61a8"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       abs(a),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3,
      #|       c-d
      #|  FROM t1
      #| ORDER BY 4,1,5,3,2
    ), ExpectedResult::Hash(150, "63a41e4b01b852b0ffe5c3d2e944e835"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       e,
      #|       a+b*2,
      #|       b,
      #|       abs(a)
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,5,3,1,4
    ), ExpectedResult::Hash(145, "2c21a6af40d74c2a9f8da0749a4b959d"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       abs(a),
      #|       c-d,
      #|       a,
      #|       c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 2,7,6,5,3,1,4
    ), ExpectedResult::Hash(154, "37f9bacc7a12ddc6b1beae763457ddda"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #|    OR (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "20bb63abd067ae8ef5a05f08be3b6762"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a-b,
      #|       c,
      #|       a
      #|  FROM t1
      #| ORDER BY 1,4,2,3
    ), ExpectedResult::Hash(120, "66537dce5d5a5988d8089fe9e8d59800"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b,
      #|       b-c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND d NOT BETWEEN 110 AND 150
      #|   AND c>d
      #| ORDER BY 3,4,6,5,1,2
    ), ExpectedResult::Hash(30, "05c651750e0c527bc2e97d4ddbe13bf0"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       abs(b-c),
      #|       e,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(a),
      #|       a
      #|  FROM t1
      #| WHERE d>e
      #|   AND b>c
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 4,3,6,1,2,5
    ), ExpectedResult::Hash(42, "bb2e37cf59a5b762b43ef4271a54e000"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4,
      #|       a-b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| ORDER BY 2,5,3,6,4,1
    ), ExpectedResult::Hash(180, "9167d3aa65f67301e2a34753a02afd02"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d-e,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 1,3,4,2
    ), ExpectedResult::Hash(120, "dbf19b42301e4f161c0a991b57d13101"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "dd50b82fcddc54ffd76449a8ba2f945d"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b,
      #|       a-b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(24, "d649f2039986a74e6ec3591a11b8ed4b"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(45, "9bbac471733a3ae401dbe561ea2c5055"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       abs(a),
      #|       a,
      #|       e,
      #|       b-c
      #|  FROM t1
      #| ORDER BY 2,4,3,1,5
    ), ExpectedResult::Hash(150, "85a750970f2a3cfd014b8df3cb52a6f6"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR b>c
      #|    OR d>e
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(78, "bbceeaaca7afd780d5aa5173c0f3df16"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a-b,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 1,4,3,2
    ), ExpectedResult::Hash(120, "5d82db974f8caa9127d640fcf6cc1a40"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(54, "851593a9a226d556e165b5765819e242"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a-b,
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 4,1,3,5,2
    ), ExpectedResult::Hash(55, "9b60d91226b0f2f8659270ea5306163d"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       e,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "5e58fb2a3eb3e54d048b0a60f2d6e477"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR (e>c OR e<d)
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(81, "b9b1ef0a70997d40f2cb0c0b5b6ea761"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       e,
      #|       d
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 6,2,5,4,3,1
    ), ExpectedResult::Hash(84, "e05d2e123bb3c8af78b16346f8a4b290"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "0c542471646c50440dc6eda5bb1b61a8"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND (a>b-2 AND a<b+2)
      #|   AND b>c
      #| ORDER BY 1,3,2
    ), ExpectedResult::Values([]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c-d,
      #|       b-c,
      #|       b,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE b>c
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 4,2,5,6,1,3
    ), ExpectedResult::Hash(48, "04bb6be1da657237947cd4ab3392c384"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a+b*2,
      #|       a+b*2+c*3+d*4,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR b>c
      #|    OR (e>a AND e<b)
      #| ORDER BY 6,5,4,2,1,3
    ), ExpectedResult::Hash(126, "4161a7ee8a4386f6d3b97abc196c2dc3"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(b-c)
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND c>d
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Values([]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       d-e
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(22, "afe0aa8cffc769721328534eeed4055a"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b,
      #|       b-c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE b>c
      #|    OR a>b
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 3,2,4,1,5
    ), ExpectedResult::Hash(140, "0147eff9aa1fd447ee41ccda073598b9"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       d-e,
      #|       c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,2,4,3
    ), ExpectedResult::Hash(88, "db4da1f3c45a5823d3ebc705f0762179"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "85404c9e49e9c58a47120a703e4457da"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND c>d
      #|   AND d>e
      #| ORDER BY 1
    ), ExpectedResult::Values(["1828", "2125", "2226"]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c-d,
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b,
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 4,2,1,3,5,6
    ), ExpectedResult::Hash(180, "e80b8346172b01fad12a7248e5bbc7a4"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b,
      #|       abs(a),
      #|       d,
      #|       c,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE a>b
      #|    OR b>c
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 2,1,3,6,4,5
    ), ExpectedResult::Hash(168, "18cbf31793b3aca41197e3f46d641650"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a,
      #|       c-d
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "b22ea8da7d71e791d7a5b66555b3a4c4"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "8d2279ba80763220505cecac39786e90"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND a>b
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(34, "0628c0094e162251c0635877ab466eba"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(b-c)
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1
    ), ExpectedResult::Hash(14, "32902ce891f5ed9983da19527e07808b"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c
      #|  FROM t1
      #| WHERE b>c
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(52, "b2f2322e57f6b0850906b8c53b5a2ff9"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       abs(a)
      #|  FROM t1
      #| WHERE d>e
      #|   AND b>c
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(16, "12f8d853019df95cb95b40b12e8f9502"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       e,
      #|       a,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND c>d
      #| ORDER BY 1,5,2,6,3,4
    ), ExpectedResult::Hash(66, "cd02907c94bef262defa2744db1d76fe"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b,
      #|       a-b
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 1,3,2,4
    ), ExpectedResult::Hash(116, "2f04f12bdebfaef35c093d47a9aedc6f"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR c>d
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(51, "4f655063e72bf8214c8975e0d0e231da"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1
    ), ExpectedResult::Hash(22, "986d884c71dc223ac25f3dd12e7d7540"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       abs(a),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4,
      #|       d
      #|  FROM t1
      #| WHERE c>d
      #|   AND (e>c OR e<d)
      #| ORDER BY 3,1,4,5,2
    ), ExpectedResult::Hash(55, "50319241cf069b222e20cb31cfb4f023"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(b-c),
      #|       d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND (a>b-2 AND a<b+2)
      #|   AND (e>c OR e<d)
      #| ORDER BY 4,1,3,2,5
    ), ExpectedResult::Hash(40, "af112915702fba60916e6620c26c935a"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a+b*2+c*3,
      #|       c-d,
      #|       abs(b-c),
      #|       d-e
      #|  FROM t1
      #| ORDER BY 3,4,1,2,5
    ), ExpectedResult::Hash(150, "3565717d74e8461a76a1e7e96613a5ee"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(90, "0c2274d4a8a3ec90ea6a28620767869e"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT e,
      #|       d-e
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR d>e
      #|    OR (e>a AND e<b)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(50, "7d469028ffef98c82d5862c6bbf65688"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (a+b+c+d+e)/5,
      #|       b-c,
      #|       e,
      #|       c-d
      #|  FROM t1
      #| ORDER BY 5,4,6,2,1,3
    ), ExpectedResult::Hash(180, "083d6dcd4c56b50a9ad85c893885dd3a"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c,
      #|       b
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR d>e
      #|    OR a>b
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(81, "389ca962469d417d7d784deab102aa5c"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       c,
      #|       abs(a),
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR d>e
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 3,4,2,5,1
    ), ExpectedResult::Hash(100, "ae8f5af162e72304474e2e771076f23d"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b-c,
      #|       e,
      #|       c
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 3,5,1,4,6,2
    ), ExpectedResult::Hash(24, "b83deb2ebe00ba61b55a923385ad7c76"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a+b*2+c*3,
      #|       c-d,
      #|       abs(a),
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE d>e
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR (e>c OR e<d)
      #| ORDER BY 1,3,5,2,4
    ), ExpectedResult::Hash(150, "e834952c1069424e50b2d0658964596f"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a+b*2
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR c>d
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(56, "954fd515b57c6e2aca8a512c3caebd11"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(12, "ab6ddb0019d35b32de0f257c78d20c9b"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(a),
      #|       abs(b-c),
      #|       b-c
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR d>e
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 3,4,2,1,5
    ), ExpectedResult::Hash(140, "70533a0a1bba09436341d84b243a4d16"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       a+b*2+c*3+d*4,
      #|       d,
      #|       a-b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| ORDER BY 2,1,5,3,4
    ), ExpectedResult::Hash(150, "3a8d86075da3f005fd88521f81f2f974"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a,
      #|       a+b*2+c*3+d*4,
      #|       c-d,
      #|       c,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 6,3,1,4,5,2
    ), ExpectedResult::Hash(162, "259c4cf3a04280b83bf34b2a39668d47"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "9a0d83a47e9ea85f0da38e0f9ca27f2e"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       e,
      #|       a+b*2,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR c>d
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 1,5,3,2,4
    ), ExpectedResult::Hash(110, "e63740c8db541190c40a2cdce9b2ff5c"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a-b,
      #|       b,
      #|       a,
      #|       b-c
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 3,2,4,6,1,5
    ), ExpectedResult::Hash(36, "79bf841ac5e002d600a8a35aefc6d105"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR a>b
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "c9e7690c4046a45d8d94c281e987f883"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a-b
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 1
    ), ExpectedResult::Values(["-1", "-1", "-1", "-1", "1", "1", "1", "1"]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(b-c)
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "ebf2696a89b67ae7c2bb5d796d902b72"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 3,2,5,7,1,6,4
    ), ExpectedResult::Hash(210, "9c29cdd6374772e5c26eae66ae64c8f1"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a-b,
      #|       c-d,
      #|       (a+b+c+d+e)/5,
      #|       b-c
      #|  FROM t1
      #| ORDER BY 3,1,4,2,6,5
    ), ExpectedResult::Hash(180, "4d08f00ee53c5830f926a4a0dcee2b20"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(b-c),
      #|       d
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 4,2,1,6,5,3
    ), ExpectedResult::Hash(24, "9562b71ed2cfd2ce3c5dfccb3132cd56"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d,
      #|       b,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(81, "6a859601ac2f0273b048c199ef8ded71"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       d-e,
      #|       c-d,
      #|       abs(a),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (e>a AND e<b)
      #| ORDER BY 3,1,5,2,4
    ), ExpectedResult::Hash(20, "4e83e03b524b4f7701d39592cde60aff"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       c-d,
      #|       abs(b-c),
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 3,2,4,1
    ), ExpectedResult::Hash(44, "580a921598a37aa858154461b5444c7d"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       e,
      #|       b,
      #|       abs(a),
      #|       d,
      #|       a
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 5,3,2,1,4,6
    ), ExpectedResult::Hash(150, "5838057b68bfbd02adaa6d9666ea3af7"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a+b*2
      #|  FROM t1
      #| WHERE b>c
      #|    OR c>d
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(48, "90d735f794a41b2883dfdd912dba4f9b"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       abs(b-c)
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "1d73e78ee7cae0bf0f75c7981d0eccbc"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       a+b*2+c*3,
      #|       a-b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE d>e
      #|    OR (e>a AND e<b)
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,4,1,2
    ), ExpectedResult::Hash(88, "e1744981c67868b64dd4f2f8bd8f9849"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       d-e,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       b,
      #|       c,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE a>b
      #|    OR b>c
      #| ORDER BY 3,1,5,6,4,2
    ), ExpectedResult::Hash(156, "d8680cf0d12c8706c82bb5ef1ad597f0"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(90, "8da0927096315212d55d743020af322c"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c-d,
      #|       a,
      #|       b
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR c>d
      #| ORDER BY 1,2,5,3,4
    ), ExpectedResult::Hash(115, "4f24f48edeed6bafc24320280f45feca"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       c-d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND d>e
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 1,2,5,3,4
    ), ExpectedResult::Hash(10, "d1f0237fc8125db019f7ae5fc6432c34"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE d>e
      #|    OR (a>b-2 AND a<b+2)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(87, "158ce2b3d64a46f7d519bc187ec472b1"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       b-c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b
      #|  FROM t1
      #| ORDER BY 3,1,2,5,4
    ), ExpectedResult::Hash(150, "563e461ea233b38ad878b56e5d269fba"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a+b*2+c*3+d*4,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       b,
      #|       c-d,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 3,5,2,1,4,6
    ), ExpectedResult::Hash(180, "48d8489ba2d0cd0db78ff89d7c25090e"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a+b*2+c*3+d*4,
      #|       a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c,
      #|       b-c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE a>b
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,4,7,6,5,3,2
    ), ExpectedResult::Hash(168, "d460bea3b5d3f177ff5befb82bf9b9c1"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c>d
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND (e>c OR e<d)
      #| ORDER BY 6,2,5,4,1,3
    ), ExpectedResult::Hash(66, "a8f6dd606793116aa2ce7b0e208adc9b"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       abs(a),
      #|       e,
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR a>b
      #| ORDER BY 5,2,4,1,3,6
    ), ExpectedResult::Hash(168, "23425d8f076e222594024d8bf9b642ec"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       abs(a),
      #|       d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b-c
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 5,1,3,2,4
    ), ExpectedResult::Hash(70, "5b3117153cd6e1dc100280e8fa82eb28"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(b-c),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 3,1,6,4,2,5
    ), ExpectedResult::Hash(132, "ec8164a205d1e3a7ff6159a6c54f9b38"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a+b*2,
      #|       b
      #|  FROM t1
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "1b9686dadfd2cec59f0bce345217b20d"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d
      #|  FROM t1
      #| WHERE a>b
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,2
    ), ExpectedResult::Values(["1", "108"]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(27, "96f1b2d40968aae8aa5efb71c05401fd"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a+b*2+c*3+d*4,
      #|       c-d,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| ORDER BY 4,1,3,2
    ), ExpectedResult::Hash(120, "6e197d6c621de72f9288f1e3f27b08a8"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(b-c),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "a6b4585e286a4224213e0d992c98fd0d"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b-c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "16f9d5fdf4a5fcefd72fd63af183a51a"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d,
      #|       a+b*2+c*3,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(90, "57c895300deda1eb561d3d1a25b41458"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT e,
      #|       abs(b-c),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "9d9798514ef43949fb86972a47e697e3"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "70364ca416eb4255377b03cd243b032a"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE d>e
      #|   AND (c<=d-2 OR c>=d+2)
      #|   AND (e>a AND e<b)
      #| ORDER BY 1
    ), ExpectedResult::Values(["444"]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE b>c
      #|   AND (a>b-2 AND a<b+2)
      #|   AND (e>a AND e<b)
      #| ORDER BY 2,1
    ), ExpectedResult::Values([]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(a)
      #|  FROM t1
      #| WHERE c>d
      #|   AND b>c
      #| ORDER BY 2,1
    ), ExpectedResult::Values(["1240", "121", "1390", "138", "1430", "142", "382", "191"]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       b-c,
      #|       a+b*2+c*3+d*4,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 2,4,6,1,5,3
    ), ExpectedResult::Hash(24, "b7c695cb8604d8cb2f0122673ea20eed"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 1
    ), ExpectedResult::Hash(16, "952e6c754c450612dd99b9d315977052"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1
    ), ExpectedResult::Hash(14, "840c9b8b71971d5911654f07be8e4708"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4,
      #|       abs(b-c),
      #|       e
      #|  FROM t1
      #| ORDER BY 3,4,5,1,2
    ), ExpectedResult::Hash(150, "f41eec7f0f9967f843cdb1d031db245e"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       b-c,
      #|       abs(b-c),
      #|       a+b*2+c*3+d*4+e*5,
      #|       c-d,
      #|       abs(a)
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 3,6,2,1,5,4
    ), ExpectedResult::Hash(84, "a0e691ea866b76ed4cc40d7ce202b53e"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT b-c
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "970be304ddec1d2bede8d8e2f14368c6"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(a),
      #|       c,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 3,4,6,1,2,5
    ), ExpectedResult::Hash(114, "febb658aae6d009e8938057c8e3daa16"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND b>c
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(26, "6673d5d82c58407244159d79db5fcf0e"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE d>e
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 1,4,3,2
    ), ExpectedResult::Hash(92, "e17ecafd5a53c4ca237b9d25520aebd8"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       abs(a),
      #|       b-c
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(45, "3b82e1c6f07bf10caed84828ec3568ca"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1
    ), ExpectedResult::Hash(14, "18666cb3224ae801a1972a186fe5843f"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a,
      #|       a+b*2,
      #|       c,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND b>c
      #| ORDER BY 6,1,5,7,4,3,2
    ), ExpectedResult::Hash(98, "73fcbe214cbf5ab7cc9bcf09d8b85acf"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 3,4,7,5,2,6,1
    ), ExpectedResult::Hash(210, "278b40264305ba138427722b9dcc7b78"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d-e,
      #|       a+b*2+c*3,
      #|       a-b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       b-c
      #|  FROM t1
      #| WHERE b>c
      #|   AND a>b
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 5,1,3,6,2,4
    ), ExpectedResult::Hash(24, "651f715b7e5976e9d63b17b91ea8d333"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       a-b,
      #|       a+b*2,
      #|       abs(a),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 1,5,4,2,6,3
    ), ExpectedResult::Hash(180, "b5ab822caa140090fa0cd1d265333e1c"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       abs(b-c),
      #|       b-c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(64, "40f0d6be4ced8de2eb7231e0a581b408"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       b-c
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 1,2
    ), ExpectedResult::Values(["1", "-1"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       c,
      #|       a+b*2,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       e,
      #|       b-c,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 7,2,5,4,1,3,6
    ), ExpectedResult::Hash(210, "48556c805f6f4da3a00f4e3b981ae954"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(a),
      #|       b-c,
      #|       a-b,
      #|       a,
      #|       c-d
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 3,6,1,2,4,5
    ), ExpectedResult::Hash(36, "101e7b5dd4d24f8db95eca3c47633127"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       d
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND a>b
      #|   AND c>d
      #| ORDER BY 2,1
    ), ExpectedResult::Values([]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       c,
      #|       e,
      #|       a+b*2+c*3,
      #|       abs(b-c),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND d>e
      #|   AND (e>c OR e<d)
      #| ORDER BY 1,5,3,6,4,2
    ), ExpectedResult::Hash(30, "7d5b2116bf7aa55ca493903a6ba75996"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "52abcdd72ea8512b37c16f4859ec7416"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT e,
      #|       abs(a)
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "d44dd4e43f4cb9731693c04088d26dcb"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       b
      #|  FROM t1
      #| WHERE b>c
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(58, "29d7f19c885dc86951cfbe1cd84d3d72"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       b,
      #|       b-c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE d>e
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 3,4,2,1
    ), ExpectedResult::Hash(116, "8a927705b4fec3a4b0d85784481196d6"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE b>c
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "f81c86b5ccfceb91643fed162f9e5413"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d,
      #|       c-d,
      #|       a
      #|  FROM t1
      #| ORDER BY 3,4,2,5,1
    ), ExpectedResult::Hash(150, "1effee3fa900abed1f10e47b0c1d1e65"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "f2bf77f8cfb62666ab72c866ed4d4f1a"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND a>b
      #|   AND (e>a AND e<b)
      #| ORDER BY 2,1
    ), ExpectedResult::Values([]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       abs(b-c),
      #|       d,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 2,3,4,1
    ), ExpectedResult::Hash(24, "00467ddc8858d6cf90c3f1b9b193edbc"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE d>e
      #|    OR b>c
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 1,5,6,4,2,3
    ), ExpectedResult::Hash(144, "e3990bba8316035d78dfbcd37a2d37d3"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE b>c
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(84, "38047852bbef0987776d99a21d30ff30"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       e,
      #|       d-e,
      #|       b,
      #|       c,
      #|       b-c
      #|  FROM t1
      #| ORDER BY 3,5,6,2,4,1
    ), ExpectedResult::Hash(180, "aab6e51c445fb06f5af7263688587491"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       b
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "93d843e5c13d5f55222d50bb9152eb1e"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "a97f06c7abca35ed0602e7a54b6ca0ac"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(b-c),
      #|       d
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(60, "e3257bfeb0e05898a093d9dd74a5c6f2"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       e,
      #|       a+b*2,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3,
      #|       c-d
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 4,2,6,1,7,3,5
    ), ExpectedResult::Hash(77, "a07d85e50adee8e8d352265890fa3df5"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(a),
      #|       e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d-e
      #|  FROM t1
      #| WHERE a>b
      #|   AND (e>a AND e<b)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,1,5,4,2
    ), ExpectedResult::Values([]), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(b-c)
      #|  FROM t1
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(90, "414fb777710c67b685fbdaaccf65e7a3"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND d>e
      #| ORDER BY 1
    ), ExpectedResult::Hash(10, "aa2c9e190b3da5017e764235b4370941"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       (a+b+c+d+e)/5,
      #|       a-b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE b>c
      #|   AND (a>b-2 AND a<b+2)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,3,4,2,5
    ), ExpectedResult::Hash(20, "9964756282ad7457273037379c9aa122"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2,
      #|       abs(a)
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1,3,4
    ), ExpectedResult::Hash(104, "77df3a421913fee04cac70de094f07da"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a-b
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR b>c
      #|    OR a>b
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(90, "430c4c38368b95466b685c4e550fd8f9"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       d-e,
      #|       a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (a+b+c+d+e)/5,
      #|       abs(b-c)
      #|  FROM t1
      #| ORDER BY 2,4,3,1,5,6
    ), ExpectedResult::Hash(180, "0f795dad72b6ea42fe6e007088398156"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       a+b*2,
      #|       e,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND (e>c OR e<d)
      #| ORDER BY 2,4,3,1
    ), ExpectedResult::Hash(20, "f9ae000b64540486fbd54647bf5d6c23"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       d
      #|  FROM t1
      #| WHERE a>b
      #|   AND (a>b-2 AND a<b+2)
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(21, "a9adff4c78600e1bb516fe971d672dee"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(a),
      #|       a+b*2+c*3+d*4,
      #|       (a+b+c+d+e)/5,
      #|       e,
      #|       b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR (a>b-2 AND a<b+2)
      #|    OR b>c
      #| ORDER BY 2,1,3,7,5,4,6
    ), ExpectedResult::Hash(154, "b9a9dc5ffa8928273db7bcd669c53cd7"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 4,1,5,2,3
    ), ExpectedResult::Hash(95, "19afe88a8ec0b6ac1a596dcfbe7a73ef"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       c,
      #|       d-e
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR c>d
      #| ORDER BY 2,5,3,4,1
    ), ExpectedResult::Hash(100, "d6ab882caeb85ea55130fe69c466a44e"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       c-d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(44, "018884fc71c9cebc4bb35146e7140fc4"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(a)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND (e>a AND e<b)
      #| ORDER BY 1,3,2
    ), ExpectedResult::Values(["119", "1757", "115"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d-e,
      #|       b,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 1,3,2,4
    ), ExpectedResult::Hash(120, "238444a65f715eb041390b17898802ba"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "d3e4cefb53c165b66f678c56a86c8314"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       a,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE b>c
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "f6d4cc8f5712412b43f67a3e8970ea9f"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE c>d
      #|   AND (c<=d-2 OR c>=d+2)
      #|   AND (e>c OR e<d)
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(9, "401e6addcfa1c054285b2d9d1a3b7161"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c),
      #|       c-d,
      #|       a
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND (e>c OR e<d)
      #|   AND c>d
      #| ORDER BY 3,4,2,1
    ), ExpectedResult::Hash(20, "c7b97476a8b2de6d251ac49288730b61"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR c>d
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(45, "311eac4b65f312512b9dab39b0e930f1"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (e>c OR e<d)
      #|    OR (e>a AND e<b)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(58, "1ced196f5801ed37a6183f2f20dff45c"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND (e>a AND e<b)
      #| ORDER BY 1,3,5,4,2
    ), ExpectedResult::Hash(15, "abd13e32a5a8a00bfe03cdf0f269bfc8"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       b,
      #|       a+b*2+c*3+d*4,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b-c
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND b>c
      #| ORDER BY 2,3,1,4,5
    ), ExpectedResult::Hash(65, "2fd8bd04880dbafe31b9a7c85fce3d0e"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(b-c),
      #|       (a+b+c+d+e)/5,
      #|       c-d
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 1,3,2,4,5
    ), ExpectedResult::Hash(95, "aac8ab5a470f3df896b0eae56bbde7a3"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a,
      #|       abs(b-c),
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(a),
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 4,1,2,7,5,3,6
    ), ExpectedResult::Hash(210, "4973d50dd296f034d899cf6e73423904"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "b4271452f1ca2257b0b5b6b13b626884"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR c>d
      #|    OR (e>a AND e<b)
      #| ORDER BY 4,1,5,2,3
    ), ExpectedResult::Hash(150, "b79cec047b7b2b03bba14eb36429fac0"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,4,3,1
    ), ExpectedResult::Hash(60, "d2507af6237b5dfa47976be28455cdc2"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(42, "ba254e8d09c76b7cbc07d9d591025883"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       d,
      #|       a,
      #|       a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 2,3,5,1,4
    ), ExpectedResult::Hash(30, "a33bb527d06a2910c9a6c62eca6505b7"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       abs(b-c),
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE a>b
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #|   AND (e>a AND e<b)
      #| ORDER BY 3,4,1,2
    ), ExpectedResult::Values([]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4,
      #|       c-d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR (e>c OR e<d)
      #|    OR (e>a AND e<b)
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(120, "83b1577bbc723a5e639e4d936a9dc9df"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(27, "56366183f13626643e62133d31b97fab"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b-c,
      #|       c,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE c>d
      #|   AND (e>c OR e<d)
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,3,2,5,4
    ), ExpectedResult::Hash(50, "3ee816fcef04a3eec0ebe12b5f6d1358"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       c-d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3+d*4,
      #|       a
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,2,5,3,4
    ), ExpectedResult::Hash(75, "91e95036e8737e2902f3561cf2148b7c"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a+b*2,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c-d
      #|  FROM t1
      #| ORDER BY 6,2,1,3,4,7,5
    ), ExpectedResult::Hash(210, "2086c3df1975d9993bfa394053028c8f"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c-d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       d
      #|  FROM t1
      #| WHERE a>b
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 5,6,3,7,2,4,1
    ), ExpectedResult::Hash(105, "32404e31bbeb9f3a9e286caaf42683bf"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       e,
      #|       abs(a)
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "5efa9ce21ccae8f703640e43d2d946c0"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT e
      #|  FROM t1
      #| WHERE c>d
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 1
    ), ExpectedResult::Hash(27, "d8936a5a1a3837cd7f42c18b75761e64"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(a),
      #|       a+b*2,
      #|       a
      #|  FROM t1
      #| WHERE d>e
      #|    OR c>d
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 6,2,1,7,5,4,3
    ), ExpectedResult::Hash(175, "1086608e130bcb51302b4bfea65791e1"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(42, "fd6fa77bdab5731313460a6946f62f9c"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a-b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND (e>a AND e<b)
      #|   AND d>e
      #| ORDER BY 3,4,1,5,7,6,2
    ), ExpectedResult::Hash(14, "21927ded75a33b0171059772011e3c39"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c,
      #|       abs(a),
      #|       d,
      #|       d-e
      #|  FROM t1
      #| WHERE b>c
      #|   AND d>e
      #| ORDER BY 1,6,2,4,3,7,5
    ), ExpectedResult::Hash(56, "8f75e59b84b486d20c41620c1756b110"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (c<=d-2 OR c>=d+2)
      #|   AND (e>c OR e<d)
      #| ORDER BY 3,4,2,1,5
    ), ExpectedResult::Hash(60, "19758056af97d83f5f52767382901cec"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       abs(b-c),
      #|       a+b*2+c*3,
      #|       c,
      #|       e,
      #|       d
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR b>c
      #| ORDER BY 6,3,5,2,1,4
    ), ExpectedResult::Hash(174, "96589425bb0eb66f4f90e1e5a55c016a"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR (a>b-2 AND a<b+2)
      #|    OR c>d
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "c44e044af3e6b6a0496d51ab6945c210"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 1
    ), ExpectedResult::Hash(19, "48eb7e59034740832c393d911a912d77"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4,
      #|       d-e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR a>b
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 1,4,2,3
    ), ExpectedResult::Hash(112, "206a85e9f59a2b97c6c2e3b771da6364"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT b-c
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 1
    ), ExpectedResult::Hash(16, "c5cb15074dbce6c2853b664f05e5a06a"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(54, "e0a9aff1c8ce9380036deac54055bb55"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT b
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR b>c
      #| ORDER BY 1
    ), ExpectedResult::Hash(28, "500599c81c6d8eaa90fb53c0b081fa78"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(b-c),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE d>e
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 2,5,3,1,7,6,4
    ), ExpectedResult::Hash(203, "69f1ab3523d66c81419f77f0fdbf1df0"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       d-e,
      #|       a-b
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR d>e
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(87, "680b619be1265b7bc4eb9d45e3fcb324"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 2,5,4,3,1
    ), ExpectedResult::Hash(150, "1ed27c9e9967fcf30b0548861bbd897d"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "23fade28502d6270c32ef8abb80c2587"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2
      #|  FROM t1
      #| WHERE b>c
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,3,1,4
    ), ExpectedResult::Hash(116, "4aba029d043e5101b15151e670342702"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a-b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 4,2,1,3
    ), ExpectedResult::Hash(120, "c0fb0d9f06fa5550406b035929522753"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       b,
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(76, "398f40cd078cf29a60f7cac9350455b5"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d,
      #|       c,
      #|       a
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND d>e
      #|   AND a>b
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(30, "c3498c035170a43e2fdea03d899bdbf0"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1
    ), ExpectedResult::Hash(14, "af1d86a32171d08bae1f8f3033e8a3dc"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       b-c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| ORDER BY 4,3,1,2
    ), ExpectedResult::Hash(120, "407743609243bf0254fd9ead4673cfca"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3,
      #|       a-b
      #|  FROM t1
      #| WHERE a>b
      #|   AND (a>b-2 AND a<b+2)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 3,4,1,2
    ), ExpectedResult::Hash(16, "59f365656ebcdfed6ff46a2d5c6d6341"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d,
      #|       b
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (e>a AND e<b)
      #| ORDER BY 6,3,1,5,4,2
    ), ExpectedResult::Hash(144, "8fcce962010f9d02b8f88fe335f942d6"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a-b
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(27, "e7100a9a9684fb20d83162187da839e4"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE c>d
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "622e9a88d60bdd5066c19a3843a170f7"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b,
      #|       a+b*2,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 5,1,3,6,4,2
    ), ExpectedResult::Hash(12, "b5316f8c767620ab06f63c854fd35548"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR b>c
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(36, "05293d133ca2cac2f19e4e30db84dfda"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #|   AND d>e
      #| ORDER BY 1
    ), ExpectedResult::Values(["0", "0", "0"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR c>d
      #| ORDER BY 1,3,2,4
    ), ExpectedResult::Hash(108, "a55defafbbd45ee8744132dd35910cbf"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c),
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2,
      #|       d
      #|  FROM t1
      #| ORDER BY 3,1,2,5,4,6
    ), ExpectedResult::Hash(180, "d24051044659497869bcab93873c4188"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b-c,
      #|       b,
      #|       d-e,
      #|       d,
      #|       a-b
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 6,3,2,1,4,5
    ), ExpectedResult::Hash(132, "5847451a2d973ff076a6917a24df31ce"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE a>b
      #|    OR (e>a AND e<b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(23, "170b11bfad55c44388691ff914c121af"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       b-c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       abs(b-c),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE d>e
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,3,6,2,4,5
    ), ExpectedResult::Hash(180, "25be50217edd1dde9c08a20bbaa92559"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4+e*5,
      #|       d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 1,3,6,2,5,4
    ), ExpectedResult::Hash(180, "76cb0f185711243083f4b8769f948815"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c-d,
      #|       abs(b-c),
      #|       a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND a>b
      #| ORDER BY 4,1,5,3,2
    ), ExpectedResult::Hash(35, "3af25b67f93d88c1a5f7c4641a52f3f5"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a,
      #|       (a+b+c+d+e)/5,
      #|       b-c,
      #|       e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR a>b
      #| ORDER BY 3,1,2,5,4
    ), ExpectedResult::Hash(120, "9fc494d65a15058f4386b7654088f517"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       d-e,
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 2,3,5,4,1
    ), ExpectedResult::Hash(20, "bc0a728a029d400d4c19f501f51eb828"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c,
      #|       c,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,5,6,3,1,4
    ), ExpectedResult::Hash(174, "bd1cf8c2ce872c289ac27e250ab8c77e"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       e,
      #|       d,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 2,3,4,5,6,1
    ), ExpectedResult::Hash(180, "dd0992af784793780e0941bfc46d5c17"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 1
    ), ExpectedResult::Hash(24, "27eeb568907f3b4f8a48a13652124dd5"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 5,4,3,1,2
    ), ExpectedResult::Hash(70, "2fc87ee25975a40d8f08b0d9bf0d3d90"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       abs(a)
      #|  FROM t1
      #| WHERE b>c
      #|    OR a>b
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(52, "e6db37d26bb91829602e9d68636d1265"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 2,1,4,3
    ), ExpectedResult::Hash(56, "21573d64e6cae82382f9e87571cb6cbb"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "9a0d83a47e9ea85f0da38e0f9ca27f2e"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "46131633c62f2d9e6f547c327a590045"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(a),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 5,3,1,2,4
    ), ExpectedResult::Hash(75, "810738d2ed0af0a3f1387238b5a684c0"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND c>d
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(22, "5084ee86fa8b2112bfe752d383673d51"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a-b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND d NOT BETWEEN 110 AND 150
      #|   AND d>e
      #| ORDER BY 3,1,2
    ), ExpectedResult::Values(["666", "-3", "440", "743", "-4", "490"]), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c,
      #|       d-e,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR (e>c OR e<d)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "cbb944ed49603f3bb266d18fac726795"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(48, "d0ea668a25e020372a556318afe192ab"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a,
      #|       (a+b+c+d+e)/5,
      #|       c,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 3,5,1,4,2
    ), ExpectedResult::Hash(135, "0a7ff196c476089cbcb92e49c1c62442"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(a)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 2,1
    ), ExpectedResult::Values(["3", "115", "18", "191", "24", "220", "29", "245"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       abs(b-c),
      #|       b-c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| ORDER BY 3,2,1,4
    ), ExpectedResult::Hash(120, "9489097f8d6868c4869ed10c8d568245"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3+d*4,
      #|       e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a,
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| ORDER BY 6,7,4,1,5,3,2
    ), ExpectedResult::Hash(210, "e42e3eeea8a43cab0293df373b4ac9be"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       d-e
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "5639deaedd6db9d4c5fa492fa1c5b3c8"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       b-c,
      #|       a+b*2+c*3,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a
      #|  FROM t1
      #| ORDER BY 3,4,2,1,5
    ), ExpectedResult::Hash(150, "f5251080e285634a78600eb37689b6bd"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE b>c
      #|   AND a>b
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(14, "09449abc628f43f2b2cfd09cb028fcbd"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 6,5,3,2,4,1
    ), ExpectedResult::Hash(84, "4eacead92f2a04db9b0334482576382b"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a-b
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR d>e
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(58, "0ca31be7aa54df86423f9f699007a2df"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a-b
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1
    ), ExpectedResult::Values(["-3", "-3", "-2", "-1", "2"]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       d,
      #|       b-c,
      #|       a,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 4,3,6,1,2,5
    ), ExpectedResult::Hash(180, "eba90a7042d20ae635380f2920638d69"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR b>c
      #| ORDER BY 1,4,2,5,6,3
    ), ExpectedResult::Hash(174, "742703bb047dc6b6254470d20be52ae0"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4,
      #|       a-b,
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND (a>b-2 AND a<b+2)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1,3,4,5,2
    ), ExpectedResult::Values(["222", "1130", "-1", "110", "2"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       abs(a),
      #|       d,
      #|       b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a
      #|  FROM t1
      #| ORDER BY 1,4,3,5,6,7,2
    ), ExpectedResult::Hash(210, "c101599893954e2d252da01e33c73937"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c,
      #|       a+b*2+c*3,
      #|       b
      #|  FROM t1
      #| WHERE b>c
      #|    OR c>d
      #| ORDER BY 3,5,6,4,2,1
    ), ExpectedResult::Hash(144, "02ea802456562964743e691697e71348"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(87, "9885e26259a0f584d0909ce4a0955e2f"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       e
      #|  FROM t1
      #| WHERE b>c
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND c>d
      #| ORDER BY 1,2
    ), ExpectedResult::Values(["382", "192", "1240", "120", "1390", "135", "1430", "144"]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a-b
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND (e>a AND e<b)
      #| ORDER BY 1,2
    ), ExpectedResult::Values(["220", "-3", "245", "-4"]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       c-d
      #|  FROM t1
      #| WHERE d>e
      #|    OR b>c
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(58, "51eb92d661a225afae03f1e126f36433"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d
      #|  FROM t1
      #| WHERE b>c
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (e>c OR e<d)
      #| ORDER BY 6,2,1,3,5,4
    ), ExpectedResult::Hash(78, "2bc2b9f40afbeff305b8b1bbb990f54d"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE b>c
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(56, "1c07d83cba1f6b2c7cdb4c807846b2be"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a+b*2+c*3,
      #|       abs(b-c),
      #|       a-b
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(108, "afe26ac66d541da5ff913b7699def87c"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3,
      #|       d,
      #|       b
      #|  FROM t1
      #| ORDER BY 2,1,3,4
    ), ExpectedResult::Hash(120, "7cc11574f6ea460034eb783876fd7af5"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c-d
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(11, "03dc6d78aaa470425875f87a9c9eeab5"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE c>d
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 4,3,5,2,1
    ), ExpectedResult::Hash(10, "2d123a0355480421449ef9e36dafe214"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(44, "c717f7f71db4237a894aeac4be41b23d"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a-b,
      #|       c-d
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(57, "ef45e87dcde7a60906a6839e404a6b19"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       a+b*2+c*3,
      #|       a+b*2,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND d>e
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,2,3,5,4
    ), ExpectedResult::Hash(10, "e577677386407b04f8bdb559232e1085"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3,
      #|       c,
      #|       d-e,
      #|       a+b*2+c*3+d*4+e*5,
      #|       d,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 3,1,7,6,4,2,5
    ), ExpectedResult::Hash(210, "170ee3d655d116f8524c3fcfc94ff7eb"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       e,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| ORDER BY 4,1,3,2
    ), ExpectedResult::Hash(120, "179b1a322c10a0b9d1ec5b326ea081e1"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "d8520212db20c57541d0c28d4fddae94"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(b-c),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(a),
      #|       c
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND b>c
      #|   AND (e>a AND e<b)
      #| ORDER BY 4,6,2,5,7,3,1
    ), ExpectedResult::Values([]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND b>c
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,2
    ), ExpectedResult::Values(["193", "222"]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       c
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "5dbfa03f06c7e5ccaaab18dc8fe14c36"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3,
      #|       c-d
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR (e>c OR e<d)
      #|    OR c>d
      #| ORDER BY 3,2,6,5,4,1
    ), ExpectedResult::Hash(180, "97f125b8bdce9deb0111aa11307179d3"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 1
    ), ExpectedResult::Hash(16, "8e559d439152e33138660c7aa7710793"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(120, "f614d7af58f04a09e4b5dda636fb7790"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       e,
      #|       c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND b>c
      #| ORDER BY 5,3,6,1,4,2
    ), ExpectedResult::Hash(48, "603d52ce942c28eb4f224d7e9ea74524"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       b-c,
      #|       abs(a)
      #|  FROM t1
      #| ORDER BY 4,1,3,2
    ), ExpectedResult::Hash(120, "6a046c7033b3c6303622e32e104e981f"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       abs(a),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 1,3,4,2
    ), ExpectedResult::Hash(76, "10d6eaf3cbdaaff42d6460c350423046"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a+b*2+c*3,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "a94a0b4568605d51d7e9a369e55805d8"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3,
      #|       c,
      #|       abs(a)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR (e>a AND e<b)
      #| ORDER BY 2,4,1,3,5,6
    ), ExpectedResult::Hash(54, "b0cf52609ba06d12170fa285e22df845"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d,
      #|       a+b*2
      #|  FROM t1
      #| WHERE b>c
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(56, "8e9a734c55398ee1e2d087d50531c3db"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE a>b
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(52, "fb874a11725bff133c5555192c29d1d4"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT b
      #|  FROM t1
      #| WHERE d>e
      #|    OR (e>a AND e<b)
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(24, "94f786f5e40682c2bbc4979d44bfbe20"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       b-c,
      #|       a
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "7ead3c920199ae810a2ae8119e9797cd"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(a)
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "60ed925e6266c564dc3551acfa13417d"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c,
      #|       e
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR (e>c OR e<d)
      #| ORDER BY 3,2,4,1
    ), ExpectedResult::Hash(112, "3bff9edf646027ba054d0234b3c9852d"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       d-e,
      #|       a+b*2+c*3,
      #|       abs(b-c),
      #|       d,
      #|       b-c,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 3,7,1,6,5,2,4
    ), ExpectedResult::Hash(189, "23d53e2a95ea74676a3bcce44e2c6fea"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       b-c,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(48, "40e60735f1fdf2e1d665a6c00b9bd1d3"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c-d
      #|  FROM t1
      #| WHERE a>b
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 5,3,1,4,2
    ), ExpectedResult::Hash(115, "87b7852145d2cd4b4aef60d7fde294ca"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b
      #|  FROM t1
      #| ORDER BY 2,6,3,1,4,5
    ), ExpectedResult::Hash(180, "0237184a8878edf72b431a6c9bcfcbf2"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(57, "c8d389e6c270e554bc93a318ef21e848"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(44, "892187bfe8f83478b3118df7af04c478"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a,
      #|       a+b*2
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(45, "b667af4ebb350909eba296967ceeb7db"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT b
      #|  FROM t1
      #| WHERE a>b
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "bac2461f7c1f964c0863658a20e1c90b"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       c-d,
      #|       d,
      #|       a
      #|  FROM t1
      #| ORDER BY 3,2,1,4
    ), ExpectedResult::Hash(120, "99149ba966bceda06aa78c50f1a92ceb"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a+b*2+c*3+d*4,
      #|       c-d,
      #|       a,
      #|       d-e,
      #|       c
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 3,4,1,5,6,2
    ), ExpectedResult::Hash(96, "a2adef429b6e4247068b4049bbe324c2"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       c,
      #|       abs(a),
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND (e>c OR e<d)
      #| ORDER BY 1,4,2,3
    ), ExpectedResult::Hash(88, "df51c546808c5d4db3a7d7c4d020b7dc"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       abs(b-c),
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND (e>a AND e<b)
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(9, "722881c1ff15283d5c95a5ef39fccb6d"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 2,3,1,4
    ), ExpectedResult::Hash(44, "4ee79810a1704816bba77ef7c8033bfb"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       a,
      #|       c,
      #|       d-e,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| ORDER BY 1,6,3,5,4,2
    ), ExpectedResult::Hash(180, "dfff98b6d7e9b049c8feace97a7eb622"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       c,
      #|       a+b*2+c*3,
      #|       b,
      #|       d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c-d
      #|  FROM t1
      #| ORDER BY 4,3,5,6,2,1,7
    ), ExpectedResult::Hash(210, "97070114fe06bdcda7ac636afcb1201d"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       d-e,
      #|       c,
      #|       a+b*2,
      #|       e
      #|  FROM t1
      #| WHERE a>b
      #|    OR c>d
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,3,5,4,1
    ), ExpectedResult::Hash(140, "9644b07604668d80e82ada3908306f8b"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b-c,
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       c,
      #|       a,
      #|       a+b*2
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND (e>c OR e<d)
      #| ORDER BY 3,6,2,1,5,7,4
    ), ExpectedResult::Hash(14, "b3cdf8a3a0bfb3e38e63a70a6887354d"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 2,3,1,5,4
    ), ExpectedResult::Hash(150, "1db48656258028dd2a0274c1f20a4e6c"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d-e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 3,5,4,6,2,1
    ), ExpectedResult::Hash(162, "ec8ccfd9d87f0f620283a1dae7d24434"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a+b*2+c*3,
      #|       (a+b+c+d+e)/5,
      #|       b,
      #|       c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 3,5,7,2,4,6,1
    ), ExpectedResult::Hash(42, "86eba634c2a25d3e9a0aca99b8b9b7a3"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a-b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3,
      #|       c,
      #|       c-d
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 5,3,4,6,1,2
    ), ExpectedResult::Hash(90, "81d55ba8fc8d4f980c895049d3ced18b"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c-d
      #|  FROM t1
      #| ORDER BY 5,2,1,4,3,6
    ), ExpectedResult::Hash(180, "8290882412be354b12366d09fa630d1e"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b-c,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND (e>a AND e<b)
      #|   AND d>e
      #| ORDER BY 2,1,4,3
    ), ExpectedResult::Values(["1", "24", "-1", "2226", "2", "29", "2", "2476"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b,
      #|       a+b*2+c*3+d*4,
      #|       a,
      #|       a+b*2+c*3+d*4+e*5,
      #|       c-d
      #|  FROM t1
      #| WHERE d>e
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 7,3,2,4,6,1,5
    ), ExpectedResult::Hash(154, "ead80733a2080af9498e2ac38198e68e"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       (a+b+c+d+e)/5,
      #|       d-e,
      #|       a,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND (c<=d-2 OR c>=d+2)
      #|   AND a>b
      #| ORDER BY 5,2,1,4,3
    ), ExpectedResult::Values([]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d-e,
      #|       c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND c>d
      #| ORDER BY 1,2,3,4
    ), ExpectedResult::Hash(40, "ce114edef775ad5ff5fdc63fd86c4a61"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (a+b+c+d+e)/5,
      #|       b
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "05b2f3f52d4f5af4cf24810c343f5954"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 1
    ), ExpectedResult::Hash(16, "952e6c754c450612dd99b9d315977052"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "ec9f02c46c399db521c47dd9cb6a40dd"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(90, "87301227ae0731f419456d467d0e095f"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4+e*5,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "c3cc9ca279f400ed756a653cbb97dccc"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       b-c,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(81, "87ef93a2fb3074f84f96ba99640b4492"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4,
      #|       abs(b-c),
      #|       a+b*2,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 4,3,1,7,2,5,6
    ), ExpectedResult::Hash(210, "88c288699fde739ddfb7111b020b384f"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a,
      #|       abs(b-c),
      #|       e
      #|  FROM t1
      #| ORDER BY 2,3,1,4
    ), ExpectedResult::Hash(120, "7211dd9c92df062c6baa152703efc0cc"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 1
    ), ExpectedResult::Hash(27, "65b034305850359755cf9f64c93c650b"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "4f865c5fb99fc326faf2828fc7d2509e"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       abs(a)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 4,3,1,2
    ), ExpectedResult::Hash(12, "c334c687262c72da162e191703935928"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       c,
      #|       e,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (a+b+c+d+e)/5,
      #|       b-c
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND a>b
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 5,6,1,2,4,3
    ), ExpectedResult::Values(["105", "106", "109", "1612", "107", "-1"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       e
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(24, "746dff67b6166bb25993d89eaa93e7a3"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND d>e
      #|   AND b>c
      #| ORDER BY 2,1
    ), ExpectedResult::Values(["1226", "4", "1272", "5"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (a+b+c+d+e)/5,
      #|       c-d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d,
      #|       a+b*2+c*3+d*4,
      #|       abs(a)
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,5,1,3,7,6,4
    ), ExpectedResult::Hash(105, "b3e0305b909d1f2abf1dc3c1745ac029"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a-b,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE b>c
      #|   AND a>b
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(21, "6e285698d68e49feed2cfcec62881d8f"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT b,
      #|       d,
      #|       b-c
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(72, "db08ffa5ab591ad342518407f8decdc7"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2,
      #|       a+b*2+c*3,
      #|       e,
      #|       abs(b-c),
      #|       abs(a)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 4,3,1,5,6,2
    ), ExpectedResult::Hash(18, "76184d922629d1e6f7e15aab28e5b2fb"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND (e>a AND e<b)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1
    ), ExpectedResult::Values([]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2,
      #|       abs(a),
      #|       d-e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 2,5,4,3,1
    ), ExpectedResult::Values(["169", "2501", "502", "168", "4"]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2,
      #|       abs(b-c),
      #|       a+b*2+c*3,
      #|       c-d,
      #|       a
      #|  FROM t1
      #| ORDER BY 1,4,2,7,3,6,5
    ), ExpectedResult::Hash(210, "28e76d3a573df0173c0a1f7ea2963336"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE a>b
      #|   AND b>c
      #|   AND (e>c OR e<d)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(14, "b4343c8fa35241f0314e777c2fdc9fa9"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b-c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d-e
      #|  FROM t1
      #| ORDER BY 3,1,4,2
    ), ExpectedResult::Hash(120, "d9c1f2d45e8e78ed66f251b5f29547da"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "28225a47a6332aa64342b0faecc4ffde"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       d-e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE b>c
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR (e>a AND e<b)
      #| ORDER BY 4,3,1,2
    ), ExpectedResult::Hash(108, "f4b156b39e020d0c3585f410af194c2d"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(11, "0e007f7dde263c5d47ba4a5ac5ad1b3d"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3,
      #|       a-b,
      #|       c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR d>e
      #|    OR b>c
      #| ORDER BY 4,2,1,6,5,3
    ), ExpectedResult::Hash(144, "a794024d0a6d2be248d44841cdc86d7e"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (a+b+c+d+e)/5,
      #|       abs(a),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE c>d
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #|    OR (e>a AND e<b)
      #| ORDER BY 2,1,4,3,5,6,7
    ), ExpectedResult::Hash(126, "3eae10241cff4d5ecd95c9792c471b0d"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "8d2279ba80763220505cecac39786e90"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c-d
      #|  FROM t1
      #| WHERE d>e
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #|   AND a>b
      #| ORDER BY 1
    ), ExpectedResult::Values([]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       d,
      #|       e,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE d>e
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 2,1,3,4
    ), ExpectedResult::Hash(20, "2d46a1ed7e70a6d2dcfc116ba3311d17"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       e,
      #|       a+b*2+c*3+d*4,
      #|       a,
      #|       a+b*2+c*3,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 7,4,2,6,5,3,1
    ), ExpectedResult::Hash(98, "1a15f531b014dbe47026fef24f6aecb2"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c,
      #|       a,
      #|       (a+b+c+d+e)/5,
      #|       c,
      #|       a+b*2
      #|  FROM t1
      #| WHERE d>e
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 6,1,4,2,5,3
    ), ExpectedResult::Hash(96, "aee43ab9a5e0fb5c53440c7841c59a1d"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3,
      #|       abs(a),
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE a>b
      #|   AND (e>a AND e<b)
      #| ORDER BY 6,3,1,5,2,4
    ), ExpectedResult::Values([]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c
      #|  FROM t1
      #| WHERE d>e
      #|   AND (a>b-2 AND a<b+2)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 1
    ), ExpectedResult::Values(["113", "134", "137", "166", "184"]), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(63, "77cf402238c411fd045a6a991c7dec12"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Values(["1", "3", "5"]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a-b
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR (e>a AND e<b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "c2001bebc4d3d2d6b01a5a50ce4282ca"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c-d
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND (e>c OR e<d)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(24, "5321af8590c0715986885546b3b2f12e"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|   AND a>b
      #|   AND (e>c OR e<d)
      #| ORDER BY 2,5,3,4,1
    ), ExpectedResult::Hash(45, "75ef6cb7d694759a04fb38d0d80ea6fb"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT e,
      #|       c-d
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR a>b
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "467e5d25c71478e4f23e2aadc3c9a524"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       e,
      #|       b-c,
      #|       c-d
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 5,6,2,4,3,1
    ), ExpectedResult::Hash(180, "9d090400bed173943daf9f4bed32cdab"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND d>e
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(20, "1f44c045307d237a4088fc48e14eba67"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(33, "0d04ad4d6f78c431e80e40adc93c38ef"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a-b,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "08eac84b9bd0c5c4ddaab249f3aa5246"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (e>c OR e<d)
      #|    OR a>b
      #| ORDER BY 1
    ), ExpectedResult::Hash(28, "a76dc8384405fa57100e5dffbbd99b99"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 2,3,1,5,4
    ), ExpectedResult::Hash(55, "625bcace071d982d6c04cc1ddfe8378c"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a-b,
      #|       b-c,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 1,4,3,2
    ), ExpectedResult::Hash(88, "6d6ee761ad491517a71dab0f2bf6175e"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4,
      #|       a+b*2
      #|  FROM t1
      #| ORDER BY 6,2,5,1,4,7,3
    ), ExpectedResult::Hash(210, "b7fc5840ce267465864efec4638ec6ad"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1
    ), ExpectedResult::Hash(14, "e353df4d3a72978b3f4fd672cd9bf5fd"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a,
      #|       a+b*2+c*3+d*4,
      #|       d
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND c>d
      #|   AND d>e
      #| ORDER BY 4,2,3,1
    ), ExpectedResult::Hash(12, "8ffc4e78f33b8122501c601b2692870a"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d-e,
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3,
      #|       a+b*2,
      #|       abs(b-c),
      #|       d
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 3,4,2,6,5,7,1
    ), ExpectedResult::Hash(112, "3a34b6923ab936224547f54261b88bd9"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (a+b+c+d+e)/5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 4,2,3,6,1,5
    ), ExpectedResult::Hash(24, "62d82f1e4e94140d5a55bf0f49db26a6"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3,
      #|       e,
      #|       a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b-c
      #|  FROM t1
      #| ORDER BY 6,4,3,1,2,5
    ), ExpectedResult::Hash(180, "556b45dc32fac9b388e107b2d9afe3ae"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       d,
      #|       e
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(63, "a5dc7cb38ce2fbae14e0a18eb8623b58"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2,
      #|       c,
      #|       a+b*2+c*3+d*4+e*5,
      #|       d-e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR c>d
      #|    OR b>c
      #| ORDER BY 4,2,3,5,1
    ), ExpectedResult::Hash(135, "4305481e9a7ca71ef955b400497b8a93"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d,
      #|       a+b*2+c*3+d*4+e*5,
      #|       e
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 3,5,1,2,4
    ), ExpectedResult::Hash(55, "057345435f09100b127853a55a907dd8"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       c-d,
      #|       b
      #|  FROM t1
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(120, "343df600fb44be4495c01502f42dbc1c"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       e,
      #|       a+b*2,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3,
      #|       abs(a)
      #|  FROM t1
      #| ORDER BY 1,2,7,6,4,3,5
    ), ExpectedResult::Hash(210, "ef988543f649244c2dc67ed8612cff61"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 2,3,1,4
    ), ExpectedResult::Hash(120, "1e0e23f922af975b4024bd2bfd71ca2e"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR c>d
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "4f5f0d9293917c38b9f4b02cd5186710"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (a+b+c+d+e)/5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR b>c
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(76, "ea6edb85e6478b917bdf5a7a0901f86b"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4+e*5,
      #|       a+b*2,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND a>b
      #| ORDER BY 3,4,2,1
    ), ExpectedResult::Hash(68, "efb249f37bdc0e2144ea0f8a265caab5"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT e,
      #|       d-e,
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "77b9f35e0dae20699e29f95090443b31"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       e,
      #|       a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c-d,
      #|       abs(a),
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #| ORDER BY 1,5,7,2,6,4,3
    ), ExpectedResult::Hash(189, "68a37db290f70ca9adb813d802835da0"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       c-d,
      #|       d-e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR (e>a AND e<b)
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(48, "07d61cbdc1b1a770028513bc1000183b"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2+c*3,
      #|       a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4,
      #|       e,
      #|       d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 6,4,7,5,2,3,1
    ), ExpectedResult::Hash(154, "f4bd4639e1c015beb228d4ba3986b11a"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 3,4,1,2
    ), ExpectedResult::Hash(60, "d5adb2536f4ed1202bbffe836134c8b8"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1
    ), ExpectedResult::Values(["1", "2", "3", "4", "5"]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(11, "5342191adb4582935088b2c750a16dc2"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR (a>b-2 AND a<b+2)
      #|    OR d>e
      #| ORDER BY 1
    ), ExpectedResult::Hash(26, "94e65afbe9fac7f180c1e29f697217ae"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a+b*2,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| ORDER BY 2,3,1,4,5
    ), ExpectedResult::Hash(150, "260624a74ca814f56655f5c39009bc4b"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c-d,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 2,4,1,3
    ), ExpectedResult::Hash(76, "c842520d07c8a4805c0e9c46781e4e44"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       d,
      #|       a-b,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,5,3,2,4
    ), ExpectedResult::Hash(150, "d087f943e514e865042916bf98488126"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       a,
      #|       a+b*2,
      #|       a-b,
      #|       abs(a),
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 2,3,1,6,4,5
    ), ExpectedResult::Hash(180, "5bc599555f212b9894d3c9b017a542ae"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       c,
      #|       a+b*2+c*3,
      #|       b,
      #|       abs(a),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND d>e
      #|   AND c>d
      #| ORDER BY 3,5,1,2,4,6,7
    ), ExpectedResult::Hash(42, "8a2061b95c0b1ec21cb1a6a698c4b102"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c,
      #|       a+b*2+c*3,
      #|       b,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1,4,6,3,5,2
    ), ExpectedResult::Hash(84, "01735d043bb36ecd392f6788eca95cf8"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a-b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE d>e
      #| ORDER BY 1,6,2,5,4,3
    ), ExpectedResult::Hash(96, "521dca6d96de8a96e1ee4b3bfd22ca84"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 1
    ), ExpectedResult::Values(["3", "18", "24", "29"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,4,3,1
    ), ExpectedResult::Hash(116, "7475b1713d2bb04b2f15460ec5487648"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(28, "7bb527bc1d2528e5b09d04fcd8e6a1fb"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       abs(b-c),
      #|       a+b*2+c*3+d*4,
      #|       d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d-e,
      #|       abs(a)
      #|  FROM t1
      #| WHERE a>b
      #|    OR b>c
      #|    OR c>d
      #| ORDER BY 1,4,5,2,6,7,3
    ), ExpectedResult::Hash(203, "ecb118bb9e9db9c6c1db84c7e8cb1b33"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       c,
      #|       a+b*2,
      #|       a+b*2+c*3+d*4,
      #|       d,
      #|       a
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 5,3,4,1,6,2
    ), ExpectedResult::Hash(174, "f3280dee3c50f4448b3fb0aca3875e60"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND d>e
      #| ORDER BY 1,2
    ), ExpectedResult::Values(["-1", "440", "2", "490"]), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       c-d,
      #|       b
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(12, "b1152eb06806863ed3686d7bf4c6c661"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 6,1,2,3,7,4,5
    ), ExpectedResult::Hash(154, "c4f2247a413e6c36412edaf2b966c320"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       a-b,
      #|       b
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(66, "e2757dcba60a847a3e85e457f395d8bb"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       e,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 3,4,2,5,1
    ), ExpectedResult::Hash(40, "5da9e4294d1be3ea4eacb08929e80c0d"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d-e
      #|  FROM t1
      #| WHERE d>e
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(10, "a6bef4e5aecb8450ab3ccc03b43c85ee"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(a),
      #|       c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       b,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 6,7,5,4,1,3,2
    ), ExpectedResult::Hash(210, "c53ff9905145a6e1db5f31d239b8c108"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d-e
      #|  FROM t1
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "4693bcd1d8668b362b0c8373297c511b"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND (e>a AND e<b)
      #|   AND (a>b-2 AND a<b+2)
      #| ORDER BY 1
    ), ExpectedResult::Values([]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       e
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "38d959c66fd021952542450eb9e1d47c"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a,
      #|       b-c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE c>d
      #|   AND (e>c OR e<d)
      #| ORDER BY 3,1,2,5,4
    ), ExpectedResult::Hash(55, "6b6e83f1a6fcf8df5ccc17e6cacd05b3"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       a+b*2+c*3,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(a),
      #|       d,
      #|       b-c
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND (e>a AND e<b)
      #|   AND c>d
      #| ORDER BY 1,5,4,6,3,2,7
    ), ExpectedResult::Hash(14, "36b2a781a944b283d58e7a573cab851b"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       a+b*2,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b-c,
      #|       d-e,
      #|       b
      #|  FROM t1
      #| ORDER BY 6,1,4,3,5,2
    ), ExpectedResult::Hash(180, "6f2020f467ce29412c031650b8237f76"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a,
      #|       c-d,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 6,4,3,2,5,1
    ), ExpectedResult::Hash(180, "0dcd430be5b1500b15daaa5fbb28fb46"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       abs(b-c),
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE b>c
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,1,3,4
    ), ExpectedResult::Hash(112, "1e8b8e47469f6adc40399d99b37817d3"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(22, "1d743292f7c8b06b88b42a776aa4c895"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a-b,
      #|       a+b*2
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR d>e
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(81, "e402ef9e6993672296cd0149b030ea63"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2+c*3,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| ORDER BY 3,5,1,4,2,6
    ), ExpectedResult::Hash(180, "fda423ac986fe8647b30d631dafb83fa"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(a)
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "95d01ba1e4d6c81aed6a9218884a3a6a"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (a+b+c+d+e)/5,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE d>e
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 4,5,3,1,2
    ), ExpectedResult::Hash(75, "9e486b13339a5038bd257b9ad9e10e59"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE a>b
      #|   AND (e>a AND e<b)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 1,2,3
    ), ExpectedResult::Values([]), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       (a+b+c+d+e)/5,
      #|       a+b*2,
      #|       a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 6,7,3,4,5,2,1
    ), ExpectedResult::Hash(77, "6d81bf51d35f0068319f1cfe4f925630"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c
      #|  FROM t1
      #| WHERE c>d
      #| ORDER BY 1,3,4,2
    ), ExpectedResult::Hash(56, "cc7ce87dc30f7946610a5123e11cb223"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       abs(b-c),
      #|       d,
      #|       a-b,
      #|       d-e,
      #|       c
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 2,5,1,4,6,3
    ), ExpectedResult::Hash(132, "6ce5ff5deff42e42bea3970fee72519b"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a,
      #|       d
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #| ORDER BY 4,2,3,1
    ), ExpectedResult::Hash(44, "ee99a0c1ec04aeb1fc52a185ff627c65"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1
    ), ExpectedResult::Values(["1014", "1067", "1130", "1172", "1226", "1272"]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       a+b*2
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR a>b
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(52, "645a7d1f1ea6951d2ea4ad569bb7fb6d"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       b,
      #|       abs(b-c),
      #|       e,
      #|       a+b*2,
      #|       d-e,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE b>c
      #|   AND c>d
      #| ORDER BY 6,1,7,2,5,4,3
    ), ExpectedResult::Hash(28, "0b0814cb234a17e666c66c7674f50432"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a-b,
      #|       e,
      #|       d,
      #|       abs(a),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND d>e
      #| ORDER BY 2,1,5,3,6,4,7
    ), ExpectedResult::Hash(105, "ad1f447f56a3bc9d467abea530124a7c"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c-d
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(30, "8d21e20a71a7efb567bf98815988b2ca"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       e,
      #|       a-b,
      #|       d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a,
      #|       b
      #|  FROM t1
      #| WHERE b>c
      #|    OR c>d
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 6,5,7,2,3,1,4
    ), ExpectedResult::Hash(182, "1e66a41fd384508140aef80d5ac47ef4"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d,
      #|       a+b*2+c*3,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND b>c
      #|   AND c>d
      #| ORDER BY 3,4,1,2,5
    ), ExpectedResult::Hash(20, "cfb7c2f188b2c59ec68ec61e00d4ec65"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a-b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND c>d
      #| ORDER BY 1,2,3,5,4
    ), ExpectedResult::Hash(45, "170723580d1cb9c1114c2269200ebca6"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b,
      #|       a+b*2+c*3,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 4,3,5,2,7,1,6
    ), ExpectedResult::Hash(210, "7a0a8f77c3a0e99e5adda38c1771c18e"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       b,
      #|       abs(b-c),
      #|       c,
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 4,6,7,2,5,3,1
    ), ExpectedResult::Hash(42, "5c9d21598cbe05f19f9f285bbffd7fb2"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       c,
      #|       abs(a),
      #|       b,
      #|       d-e
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR c>d
      #| ORDER BY 5,2,3,1,4
    ), ExpectedResult::Hash(100, "fa488a9496d55b35f2ff191b3ad1a2d8"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND b>c
      #| ORDER BY 1
    ), ExpectedResult::Values(["416", "428", "475", "502", "595", "685"]), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       d-e,
      #|       a+b*2,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR c>d
      #| ORDER BY 4,2,3,1
    ), ExpectedResult::Hash(112, "740c8b35a809b741f6b92e076bb4bec9"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 1,2,3,4
    ), ExpectedResult::Hash(16, "8c43f9413cb17457b4374d71b31ea8d3"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(45, "f0eaad06d4e85740bf5623d60f120f17"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "ffc02cccce8d6bfd112727aa04ef7943"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d-e,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a
      #|  FROM t1
      #| ORDER BY 6,4,5,3,2,1
    ), ExpectedResult::Hash(180, "360a865da8121bc0977f7658d1dfd557"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       a-b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 2,1,3
    ), ExpectedResult::Hash(18, "bac6343c72e0117368fd6a22ef3a5b6e"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       e,
      #|       d-e
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND c BETWEEN b-2 AND d+2
      #|   AND d>e
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(30, "2901062890d6f99efdf4d841b7f489d0"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c-d,
      #|       e
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(12, "775f4f09449defb997247686b8993684"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|   AND (e>c OR e<d)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(38, "6ea9d603b4c575b610fd90c9144e7536"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       a+b*2+c*3,
      #|       abs(a),
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #|   AND (e>c OR e<d)
      #| ORDER BY 4,2,5,1,3,6
    ), ExpectedResult::Values([]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       (a+b+c+d+e)/5,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d-e,
      #|       a,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 1,5,3,6,4,2
    ), ExpectedResult::Hash(180, "9e77f9ed9bd331d9f1eeb06feec44f16"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       d,
      #|       abs(a),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE b>c
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,3,1,4
    ), ExpectedResult::Hash(120, "09e9f16109a33c112566d23c35fe3d34"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3+d*4+e*5,
      #|       abs(b-c),
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 4,3,2,1
    ), ExpectedResult::Hash(16, "acd94553d4809152603a3ec981fbca5a"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "0874808674154c9f9a4da6b693d9aab4"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(b-c),
      #|       abs(a)
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND d>e
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(45, "102582469cb62371cfbc186e014c296e"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d-e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE b>c
      #|   AND a>b
      #| ORDER BY 3,4,2,5,1
    ), ExpectedResult::Hash(35, "7cb0b4009eb9e0011b93c5af70485d17"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| WHERE a>b
      #|   AND c>d
      #|   AND d>e
      #| ORDER BY 1
    ), ExpectedResult::Values(["364", "426", "1300"]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d,
      #|       c
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND d>e
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(30, "06a7d44acf151628b3050a8ebc708745"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a,
      #|       c-d,
      #|       c,
      #|       (a+b+c+d+e)/5,
      #|       abs(b-c),
      #|       b
      #|  FROM t1
      #| ORDER BY 1,2,5,4,6,3
    ), ExpectedResult::Hash(180, "9df8e505f6af7d80e748782b27be48b2"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       d,
      #|       abs(a),
      #|       c-d,
      #|       a
      #|  FROM t1
      #| ORDER BY 1,3,4,2,5
    ), ExpectedResult::Hash(150, "9d11482f04d6dd368144c2aceb19836e"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       e,
      #|       a,
      #|       d-e,
      #|       b-c,
      #|       d
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #| ORDER BY 1,7,6,2,3,4,5
    ), ExpectedResult::Hash(154, "6950c3ac5c51bd413a03bd20fdf5c976"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d,
      #|       b-c,
      #|       c
      #|  FROM t1
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(120, "0c20126a16dd6d7a591cb8c94260de86"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c
      #|  FROM t1
      #| WHERE b>c
      #|    OR (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(28, "3a0971879ea1b00ced3f4fa214148c62"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       e
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 3,1,2
    ), ExpectedResult::Hash(90, "c964aaa8de202304aab370f57877598f"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d-e,
      #|       c,
      #|       abs(a)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 4,1,3,5,2
    ), ExpectedResult::Hash(20, "df599e2a0626cb1e74ef62133e945cfd"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       e,
      #|       c-d,
      #|       a+b*2+c*3,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a-b
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 5,4,3,1,2,6
    ), ExpectedResult::Hash(162, "3cf670f964b843cd91099d29391e12a1"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b,
      #|       c
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "2276c23f13eb557d0c37f88904c8e9c6"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       a-b,
      #|       b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       e
      #|  FROM t1
      #| ORDER BY 1,5,4,3,2
    ), ExpectedResult::Hash(150, "37ae594d2c57e581ced3eaa5665cc2db"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3,
      #|       e,
      #|       d,
      #|       b-c,
      #|       a
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR (a>b-2 AND a<b+2)
      #| ORDER BY 2,4,5,6,1,3
    ), ExpectedResult::Hash(96, "49b0c161d380556b862b1c030de7d8af"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 1,3,2
    ), ExpectedResult::Hash(90, "57f2ebca5511fd3dcdb1aaaa1085afb9"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       e,
      #|       d,
      #|       b-c,
      #|       (a+b+c+d+e)/5,
      #|       abs(b-c),
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 4,3,5,1,7,2,6
    ), ExpectedResult::Hash(210, "fa048abe30ca7228144722825635bdc3"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       c-d,
      #|       a+b*2+c*3+d*4,
      #|       d-e,
      #|       b-c,
      #|       e,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| ORDER BY 7,1,2,4,6,5,3
    ), ExpectedResult::Hash(210, "e422c1ef11d9f9184ad371f3657b668a"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT c,
      #|       b
      #|  FROM t1
      #| WHERE a>b
      #|    OR b>c
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(52, "fde099baa23ed9f3ff2a2988e2603220"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       a,
      #|       a+b*2,
      #|       a+b*2+c*3,
      #|       e
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 1,5,2,4,6,3
    ), ExpectedResult::Hash(162, "6884437b1ac60811ec97a729b331546c"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1
    ), ExpectedResult::Values(["610", "635", "674", "708", "738", "760"]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(b-c),
      #|       abs(a),
      #|       b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND d>e
      #| ORDER BY 1,5,3,2,4
    ), ExpectedResult::Hash(50, "6d4c0ad38c9599f7bdb7ced14ae8b892"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       d-e,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 1,3,4,2
    ), ExpectedResult::Hash(16, "812c454e8d6a9bac1766cce23665de1c"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|    OR d>e
      #|    OR a>b
      #| ORDER BY 2,3,1,4
    ), ExpectedResult::Hash(108, "51ad3b8a1b881292bb3b372941aa523b"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       abs(b-c),
      #|       a-b,
      #|       abs(a),
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|   AND d NOT BETWEEN 110 AND 150
      #|   AND c>d
      #| ORDER BY 5,4,2,3,1,6
    ), ExpectedResult::Hash(12, "f218928f7ff745a50e68c3871945867e"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT e
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR (e>a AND e<b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(30, "41762f74ba25ab0f9b0448f319f2f292"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|   AND (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(11, "7cff5fb0ba5055909312c4b824f401ab"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(a)
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR d>e
      #|    OR (e>c OR e<d)
      #| ORDER BY 1
    ), ExpectedResult::Hash(27, "96f1b2d40968aae8aa5efb71c05401fd"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       c,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       c-d,
      #|       a-b,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 4,2,3,6,1,5
    ), ExpectedResult::Hash(180, "9b4cb30346c93dd34c34827896cc7bb2"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR d NOT BETWEEN 110 AND 150
      #| ORDER BY 1
    ), ExpectedResult::Hash(24, "72a0bad4364ab5cec9197874c8214b90"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       d,
      #|       a+b*2,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b-c,
      #|       c-d,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 6,7,2,4,1,5,3
    ), ExpectedResult::Hash(210, "7ffed25a409fdd72f938a3e0fee5ef7b"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       (a+b+c+d+e)/5,
      #|       b,
      #|       a,
      #|       a+b*2,
      #|       d-e
      #|  FROM t1
      #| ORDER BY 5,1,6,7,2,3,4
    ), ExpectedResult::Hash(210, "74f1e38191ea22e127c181fd2a5f4653"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a-b,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "8b44d6b0b5b725aa2cd8736b08f75844"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       e,
      #|       a-b,
      #|       a,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       d-e
      #|  FROM t1
      #| WHERE a>b
      #|    OR d NOT BETWEEN 110 AND 150
      #|    OR b>c
      #| ORDER BY 4,6,1,2,3,5
    ), ExpectedResult::Hash(168, "1293b2b1eae0693b834b1a25534ecbf6"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND (c<=d-2 OR c>=d+2)
      #| ORDER BY 4,2,1,6,5,3
    ), ExpectedResult::Hash(78, "e662492b4b865e6d9fd38fb95f92da0a"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a+b*2+c*3,
      #|       a+b*2,
      #|       c-d,
      #|       (a+b+c+d+e)/5,
      #|       a-b
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND d NOT BETWEEN 110 AND 150
      #|   AND d>e
      #| ORDER BY 6,1,5,3,2,4
    ), ExpectedResult::Values([]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(a),
      #|       a+b*2,
      #|       a,
      #|       d-e
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 4,2,3,5,1
    ), ExpectedResult::Hash(150, "6065f66c11928caa117acd16babff4dd"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       b,
      #|       a-b
      #|  FROM t1
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(90, "99b07f07bebaeafdec57423602e76a03"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       abs(b-c),
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b-c
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR (c<=d-2 OR c>=d+2)
      #|    OR d>e
      #| ORDER BY 2,1,3,5,6,4
    ), ExpectedResult::Hash(138, "99d143bc2979104655dbd53c1ebb9daf"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "53a93bddba583cbe7defea013e483a67"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3+d*4,
      #|       e,
      #|       d,
      #|       a,
      #|       b-c
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR (e>c OR e<d)
      #| ORDER BY 5,1,7,2,3,6,4
    ), ExpectedResult::Hash(196, "06165cd2f1d7e6848c2f2ba05e529931"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT abs(a),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE a>b
      #|    OR b>c
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(56, "bf65a13599405ccdb81b751e0eaf27c3"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a-b
      #|  FROM t1
      #| WHERE d NOT BETWEEN 110 AND 150
      #|   AND (e>c OR e<d)
      #|   AND a>b
      #| ORDER BY 1
    ), ExpectedResult::Hash(16, "069bf04f1be08ea67a9cba4d0956654b"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       (a+b+c+d+e)/5,
      #|       c
      #|  FROM t1
      #| WHERE a>b
      #|    OR c BETWEEN b-2 AND d+2
      #|    OR (e>c OR e<d)
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(84, "c828eac130a15276b156f6996aa2ef92"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       a-b,
      #|       b,
      #|       a+b*2+c*3+d*4,
      #|       a+b*2+c*3,
      #|       d-e,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE b>c
      #|   AND a>b
      #|   AND c>d
      #| ORDER BY 4,2,1,7,5,6,3
    ), ExpectedResult::Values([]), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 1
    ), ExpectedResult::Hash(19, "b35d36526e48396f7cd935a35558bee5"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       d-e
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(44, "92f9e63f8b59a420e62314c4205c9e7f"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT d
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR (e>a AND e<b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(9, "f851aa58719d4436cbe2f9ed3c9e76e5"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       c-d,
      #|       b,
      #|       b-c,
      #|       abs(b-c),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 5,3,4,2,6,1
    ), ExpectedResult::Hash(96, "3633ea792216aff36f581f5be1c322ba"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4,
      #|       d,
      #|       c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 6,3,7,2,1,5,4
    ), ExpectedResult::Hash(210, "94e6e09b48ec1cac7fc85786190df3cf"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND (e>a AND e<b)
      #|   AND e+d BETWEEN a+b-10 AND c+130
      #| ORDER BY 1
    ), ExpectedResult::Values([]), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT a+b*2,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE b>c
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(28, "287303499a01f42db629b309cc2a7bf5"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT b-c,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #|   AND EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(42, "ab72cc439cc82497430fcb1fbd96b135"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT e,
      #|       a+b*2+c*3+d*4+e*5,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END
      #|  FROM t1
      #| ORDER BY 2,3,4,1
    ), ExpectedResult::Hash(120, "3ce25b7100fcbfe7c7142b3160cb9ebf"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT abs(b-c)
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 1
    ), ExpectedResult::Hash(22, "a2ba0b24ef26c9654b970fe085456049"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5,
      #|       b,
      #|       abs(a),
      #|       (a+b+c+d+e)/5,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 6,5,4,1,3,2
    ), ExpectedResult::Hash(24, "bb41bc9d567aceee980f88f2371a8184"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a-b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2,
      #|       d
      #|  FROM t1
      #| WHERE (a>b-2 AND a<b+2)
      #|    OR a>b
      #| ORDER BY 1,3,4,5,2
    ), ExpectedResult::Hash(115, "5d36f45159c9d74c2031ff38615d53af"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END,
      #|       c-d,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d),
      #|       b,
      #|       abs(a),
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 2,3,6,7,1,5,4
    ), ExpectedResult::Hash(28, "b0f5cf1d8e139fbcd94d22a04596c191"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|   AND c BETWEEN b-2 AND d+2
      #| ORDER BY 1
    ), ExpectedResult::Hash(22, "59cac8a106613a4b6a96e597e54b11bc"), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       c-d,
      #|       d-e
      #|  FROM t1
      #| WHERE d>e
      #|   AND (e>c OR e<d)
      #| ORDER BY 2,1,3,4,5
    ), ExpectedResult::Hash(80, "7d08c5a3aa675527d19f5b1d2356e2a4"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       c,
      #|       d
      #|  FROM t1
      #| ORDER BY 3,2,1
    ), ExpectedResult::Hash(90, "618667761e11a57327170cb4090cd805"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       c
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #| ORDER BY 1,2
    ), ExpectedResult::Values(["-2", "193", "-1", "119", "1", "224", "2", "247"]), false),
    Record::Query("IIIII", SortMode::NoSort, None, (
      #|SELECT (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       b-c,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       abs(b-c),
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE d>e
      #|    OR EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1,3,2,5,4
    ), ExpectedResult::Hash(145, "8e4ad0f9d069ab8e76d695d74888fe89"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #|    OR c>d
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "faddb4b17fdd475b0069e959e1fd775b"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2
      #|  FROM t1
      #| WHERE (e>c OR e<d)
      #|    OR (e>a AND e<b)
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(58, "c78692ff94d85fe79f2b10611c86bec7"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       e,
      #|       a-b,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       (a+b+c+d+e)/5,
      #|       abs(b-c)
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|   AND c>d
      #| ORDER BY 1,3,5,2,6,4
    ), ExpectedResult::Hash(18, "195ca5c056027e19b7098549fb30a259"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT a+b*2
      #|  FROM t1
      #| WHERE c>d
      #|    OR e+d BETWEEN a+b-10 AND c+130
      #|    OR (c<=d-2 OR c>=d+2)
      #| ORDER BY 1
    ), ExpectedResult::Hash(24, "853518e87c34debe4bc0fa37ef0bfc3e"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT c,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.c>t1.c AND x.d<t1.d)
      #|  FROM t1
      #| WHERE b>c
      #|   AND (e>a AND e<b)
      #|   AND d>e
      #| ORDER BY 1,2
    ), ExpectedResult::Values(["247", "0"]), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT a-b,
      #|       d,
      #|       d-e,
      #|       a,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       CASE a+1 WHEN b THEN 111 WHEN c THEN 222
      #|        WHEN d THEN 333  WHEN e THEN 444 ELSE 555 END
      #|  FROM t1
      #| WHERE a>b
      #| ORDER BY 3,5,4,2,1,6
    ), ExpectedResult::Hash(114, "a182ab374cf9de5884edf48ee0c3c177"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT a+b*2+c*3+d*4+e*5,
      #|       b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       e
      #|  FROM t1
      #| ORDER BY 2,3,4,1
    ), ExpectedResult::Hash(120, "4c834557bb398bae031a4a6cb6c44609"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT c,
      #|       a+b*2+c*3+d*4,
      #|       a
      #|  FROM t1
      #| WHERE (e>a AND e<b)
      #|    OR c BETWEEN b-2 AND d+2
      #| ORDER BY 1,2,3
    ), ExpectedResult::Hash(72, "78ce08b9b47effca273ed6c5e973307f"), false),
    Record::Query("IIIIIII", SortMode::NoSort, None, (
      #|SELECT (a+b+c+d+e)/5,
      #|       b,
      #|       a+b*2+c*3+d*4+e*5,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       e,
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 1,3,2,5,4,7,6
    ), ExpectedResult::Hash(154, "50e2f80bf6231e054e926c9951e17478"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT d-e,
      #|       a+b*2+c*3
      #|  FROM t1
      #| ORDER BY 2,1
    ), ExpectedResult::Hash(60, "66a495f8d2f4e26e2f3cd7a2b8bbbbe1"), false),
    Record::Query("II", SortMode::NoSort, None, (
      #|SELECT CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a
      #|  FROM t1
      #| ORDER BY 1,2
    ), ExpectedResult::Hash(60, "41e0a49d9d4fd26beeaf2dca0ab67873"), false),
    Record::Query("IIII", SortMode::NoSort, None, (
      #|SELECT abs(b-c),
      #|       a+b*2+c*3+d*4+e*5,
      #|       b,
      #|       d-e
      #|  FROM t1
      #| WHERE (c<=d-2 OR c>=d+2)
      #|    OR d>e
      #| ORDER BY 3,1,2,4
    ), ExpectedResult::Hash(88, "8fe84624e1e5fa5f699f29a4bcb25bc1"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT c-d,
      #|       CASE WHEN a<b-3 THEN 111 WHEN a<=b THEN 222
      #|        WHEN a<b+3 THEN 333 ELSE 444 END,
      #|       a+b*2,
      #|       e,
      #|       c,
      #|       a+b*2+c*3+d*4
      #|  FROM t1
      #| WHERE e+d BETWEEN a+b-10 AND c+130
      #|    OR (e>c OR e<d)
      #| ORDER BY 2,4,6,5,3,1
    ), ExpectedResult::Hash(168, "3cff8fa2e319bf668edb7b07c5437a21"), false),
    Record::Query("IIIIII", SortMode::NoSort, None, (
      #|SELECT b,
      #|       a-b,
      #|       (SELECT count(*) FROM t1 AS x WHERE x.b<t1.b),
      #|       CASE WHEN c>(SELECT avg(c) FROM t1) THEN a*2 ELSE b*10 END,
      #|       a+b*2+c*3,
      #|       a+b*2+c*3+d*4+e*5
      #|  FROM t1
      #| WHERE c BETWEEN b-2 AND d+2
      #| ORDER BY 5,2,4,1,3,6
    ), ExpectedResult::Hash(132, "96d9a79e7b27fe306bc987a453cfcebe"), false),
    Record::Query("III", SortMode::NoSort, None, (
      #|SELECT a,
      #|       a+b*2+c*3,
      #|       (a+b+c+d+e)/5
      #|  FROM t1
      #| ORDER BY 2,3,1
    ), ExpectedResult::Hash(90, "a94a0b4568605d51d7e9a369e55805d8"), false),
    Record::Query("I", SortMode::NoSort, None, (
      #|SELECT c
      #|  FROM t1
      #| WHERE EXISTS(SELECT 1 FROM t1 AS x WHERE x.b<t1.b)
      #| ORDER BY 1
    ), ExpectedResult::Hash(29, "20a327dd7dddd406aa915b0ee3795434"), false),
  ]
  let mut i : Int = 0
  while i < records.length() {
    match records[i] {
      Statement(expect_ok, sql, skip) => {
        if !skip { run_statement(db.val, sql, expect_ok) }
      }
      Query(types, sort_mode, label, sql, expected, skip) => {
        run_query(db.val, types, sort_mode, label, sql, expected, skip, hash_threshold, label_map)
      }
      HashThreshold(v) => { hash_threshold = v }
      Halt => { break }
    }
    i = i + 1
  }
  let close_rc = @sqlite3sys.sqlite3_close(db.val)
  assert_true(close_rc == @sqlite3sys.SQLITE_OK)
}
