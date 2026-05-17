--------------------------------------------------------
--  DDL for Package Body PKG_API_DASHBOARD
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_API_DASHBOARD" AS

  PROCEDURE API_GET_THAMPHAN
(
--  V_TOAANID IN NUMBER,
--  V_THAMPHANID IN NUMBER,
  CURRETURN OUT SYS_REFCURSOR 
) AS
    V_TOAANID               NUMBER DEFAULT 1;
    V_THAMPHANID            NUMBER DEFAULT 0;

    V_CURSOR_TD             SYS_REFCURSOR;

    FETCH_THAMPHANID        NUMBER;
    FETCH_HOTEN             VARCHAR(250);
    FETCH_HOTEN_CHUCVU      VARCHAR(250);

    V_TABLE_TIMKIEM         T_DASHBOARD_THAMPHAN;

  BEGIN

    V_TABLE_TIMKIEM := T_DASHBOARD_THAMPHAN();

    PKG_DASHBOARD.GET_THAMPHAN_TOICAO(TO_CHAR(V_TOAANID), V_THAMPHANID,  V_CURSOR_TD);            
    LOOP
        FETCH V_CURSOR_TD
        INTO    FETCH_THAMPHANID, FETCH_HOTEN_CHUCVU, FETCH_HOTEN;
        EXIT WHEN V_CURSOR_TD%NOTFOUND;

        V_TABLE_TIMKIEM.EXTEND;
        V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_DASHBOARD_THAMPHAN(FETCH_HOTEN_CHUCVU,  FETCH_THAMPHANID, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
    END LOOP;

    OPEN curReturn FOR 
        SELECT A.THAMPHAN_HOTEN judge_name , A.THAMPHANID id
        FROM (SELECT * FROM TABLE(V_TABLE_TIMKIEM)) A;

  END API_GET_THAMPHAN;

  PROCEDURE API_GET_DANHSACH_TOAAN
( 
    DONVIID IN NUMBER,
	CURRETURN    OUT       SYS_REFCURSOR
)
IS 
    V_TOAANID               NUMBER DEFAULT 1;
    V_THAMPHANID            NUMBER DEFAULT 0;

    V_CURSOR_TD             SYS_REFCURSOR;

    FETCH_THAMPHANID        NUMBER;
    FETCH_HOTEN             VARCHAR(250);
    FETCH_HOTEN_CHUCVU      VARCHAR(250);

    V_TABLE_TIMKIEM         T_DASHBOARD_THAMPHAN;
BEGIN

    V_TABLE_TIMKIEM := T_DASHBOARD_THAMPHAN();

    PKG_DASHBOARD.GET_THAMPHAN_TOICAO(TO_CHAR(V_TOAANID), V_THAMPHANID,  V_CURSOR_TD);            
    LOOP
        FETCH V_CURSOR_TD
        INTO    FETCH_THAMPHANID, FETCH_HOTEN_CHUCVU, FETCH_HOTEN;
        EXIT WHEN V_CURSOR_TD%NOTFOUND;

        V_TABLE_TIMKIEM.EXTEND;
        V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_DASHBOARD_THAMPHAN(FETCH_HOTEN_CHUCVU,  FETCH_THAMPHANID, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
    END LOOP;

    OPEN curReturn FOR 
        SELECT A.THAMPHAN_HOTEN judge_name , A.THAMPHANID id
        FROM (SELECT * FROM TABLE(V_TABLE_TIMKIEM)) A;

END API_GET_DANHSACH_TOAAN;

  PROCEDURE API_DASHBOARD_GDT_EXP
(  
    VTOAANID	IN	VARCHAR2,
    VTHAMPHANID IN NUMBER,
    VTUNGAY	IN VARCHAR2,
    VDENNGAY	IN VARCHAR2,
    CURRETURN OUT SYS_REFCURSOR 
) AS

    V_CURSOR_TD sys_refcursor;

    V_TABLE_TIMKIEM             T_TYPE_OF_15_COLUMN_VARCHAR;

    FETCH_LOAIAN       VARCHAR2(25 CHAR);
    FETCH_COLUMN_1     VARCHAR2(10 CHAR);
    FETCH_COLUMN_2     VARCHAR2(10 CHAR);
    FETCH_COLUMN_3     VARCHAR2(10 CHAR); 
    FETCH_COLUMN_4     VARCHAR2(10 CHAR);
    FETCH_COLUMN_5     VARCHAR2(10 CHAR);
    FETCH_COLUMN_6     VARCHAR2(10 CHAR);  
    FETCH_COLUMN_7     VARCHAR2(10 CHAR);
    FETCH_COLUMN_8     VARCHAR2(10 CHAR);
    FETCH_COLUMN_9     VARCHAR2(10 CHAR);
    FETCH_COLUMN_10    VARCHAR2(10 CHAR);
    FETCH_COLUMN_11    VARCHAR2(10 CHAR);

  BEGIN

    V_TABLE_TIMKIEM := T_TYPE_OF_15_COLUMN_VARCHAR();

    PKG_DASHBOARD.DASHBOARD_GDT_EXP(VTOAANID, VTHAMPHANID, VTUNGAY, VDENNGAY, V_CURSOR_TD);            
    LOOP
        FETCH V_CURSOR_TD
        INTO    FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11;
        EXIT WHEN V_CURSOR_TD%NOTFOUND;

        V_TABLE_TIMKIEM.EXTEND;
        V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                                                                                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                                                                                FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11,
                                                                                '13','14','15');
    END LOOP;

    OPEN curReturn FOR 

        SELECT A.COLUMN_1 AS case_type,
               A.COLUMN_2 AS total_order,
               A.COLUMN_3 AS total,
               A.COLUMN_4 AS replied_cases,
               A.COLUMN_5 AS appeal_cases,
               A.COLUMN_6 AS dismissed_cases,
               A.COLUMN_7 AS unresolved_cases,
               A.COLUMN_8 AS total_decisions,
               A.COLUMN_9 AS chief_judge_appeals,
               A.COLUMN_10 AS prosecutor_general_appeals,
               A.COLUMN_11 AS tried_cases,
               A.COLUMN_12 AS untried_cases

        FROM (SELECT * FROM TABLE(V_TABLE_TIMKIEM)) A;

  END API_DASHBOARD_GDT_EXP;

  PROCEDURE API_DASHBOARD_GDT_QH_EXP
(  
    VTOAANID	IN	VARCHAR2,
    VTHAMPHANID IN NUMBER,
    VTUNGAY	IN VARCHAR2,    
    VDENNGAY	IN VARCHAR2,
    CURRETURN OUT SYS_REFCURSOR 
) AS

    V_CURSOR_TD sys_refcursor;

    V_TABLE_TIMKIEM             T_TYPE_OF_15_COLUMN_VARCHAR;

    FETCH_LOAIAN       VARCHAR2(25 CHAR);
    FETCH_COLUMN_1     VARCHAR2(10 CHAR);
    FETCH_COLUMN_2     VARCHAR2(10 CHAR);
    FETCH_COLUMN_3     VARCHAR2(10 CHAR); 
    FETCH_COLUMN_4     VARCHAR2(10 CHAR);
    FETCH_COLUMN_5     VARCHAR2(10 CHAR);
    FETCH_COLUMN_6     VARCHAR2(10 CHAR);  
    FETCH_COLUMN_7     VARCHAR2(10 CHAR);
    FETCH_COLUMN_8     VARCHAR2(10 CHAR);
    FETCH_COLUMN_9     VARCHAR2(10 CHAR);
    FETCH_COLUMN_10    VARCHAR2(10 CHAR);
    FETCH_COLUMN_11    VARCHAR2(10 CHAR);

  BEGIN

    V_TABLE_TIMKIEM := T_TYPE_OF_15_COLUMN_VARCHAR();

    PKG_DASHBOARD.DASHBOARD_GDT_QH_EXP(VTOAANID, VTHAMPHANID, VTUNGAY, VDENNGAY, V_CURSOR_TD);            
    LOOP
        FETCH V_CURSOR_TD
        INTO    FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11;
        EXIT WHEN V_CURSOR_TD%NOTFOUND;

        V_TABLE_TIMKIEM.EXTEND;
        V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                                                                                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                                                                                FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11,
                                                                                '13','14','15');
    END LOOP;

    OPEN curReturn FOR 

        SELECT A.COLUMN_1 AS case_type,
               A.COLUMN_2 AS total_order,
               A.COLUMN_3 AS total,
               A.COLUMN_4 AS replied_cases,
               A.COLUMN_5 AS appeal_cases,
               A.COLUMN_6 AS dismissed_cases,
               A.COLUMN_7 AS unresolved_cases,
               A.COLUMN_8 AS total_decisions,
               A.COLUMN_9 AS chief_judge_appeals,
               A.COLUMN_10 AS prosecutor_general_appeals,
               A.COLUMN_11 AS tried_cases,
               A.COLUMN_12 AS untried_cases

        FROM (SELECT * FROM TABLE(V_TABLE_TIMKIEM)) A;
  END API_DASHBOARD_GDT_QH_EXP;

  PROCEDURE API_DASHBOARD_GDT_THOIHIEU_EXP
(  
    VTOAANID	IN	VARCHAR2,
    VTHAMPHANID IN NUMBER,
    VTUNGAY	IN VARCHAR2,    
    VDENNGAY	IN VARCHAR2,
    CURRETURN OUT SYS_REFCURSOR 
) AS

    V_CURSOR_TD sys_refcursor;

    V_TABLE_TIMKIEM             T_TYPE_OF_15_COLUMN_VARCHAR;

    FETCH_LOAIAN       VARCHAR2(25 CHAR);
    FETCH_COLUMN_1     VARCHAR2(10 CHAR);
    FETCH_COLUMN_2     VARCHAR2(10 CHAR);
    FETCH_COLUMN_3     VARCHAR2(10 CHAR); 
    FETCH_COLUMN_4     VARCHAR2(10 CHAR);
    FETCH_COLUMN_5     VARCHAR2(10 CHAR);
    FETCH_COLUMN_6     VARCHAR2(10 CHAR);  
    FETCH_COLUMN_7     VARCHAR2(10 CHAR);
    FETCH_COLUMN_8     VARCHAR2(10 CHAR);
    FETCH_COLUMN_9     VARCHAR2(10 CHAR);
    FETCH_COLUMN_10    VARCHAR2(10 CHAR);
    FETCH_COLUMN_11    VARCHAR2(10 CHAR);

  BEGIN

    V_TABLE_TIMKIEM := T_TYPE_OF_15_COLUMN_VARCHAR();

    PKG_DASHBOARD.DASHBOARD_GDT_THOIHIEU_EXP(VTOAANID, VTHAMPHANID, VTUNGAY, VDENNGAY, V_CURSOR_TD);            
    LOOP
        FETCH V_CURSOR_TD
        INTO    FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11;
        EXIT WHEN V_CURSOR_TD%NOTFOUND;

        V_TABLE_TIMKIEM.EXTEND;
        V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                                                                                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                                                                                FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11,
                                                                                '13','14','15');
    END LOOP;

    OPEN curReturn FOR 

        SELECT A.COLUMN_1 AS case_type,
               A.COLUMN_2 AS total_order,
               A.COLUMN_3 AS total,
               A.COLUMN_4 AS replied_cases,
               A.COLUMN_5 AS appeal_cases,
               A.COLUMN_6 AS dismissed_cases,
               A.COLUMN_7 AS unresolved_cases,
               A.COLUMN_8 AS total_decisions,
               A.COLUMN_9 AS chief_judge_appeals,
               A.COLUMN_10 AS prosecutor_general_appeals,
               A.COLUMN_11 AS tried_cases,
               A.COLUMN_12 AS untried_cases

        FROM (SELECT * FROM TABLE(V_TABLE_TIMKIEM)) A;
  END API_DASHBOARD_GDT_THOIHIEU_EXP;

  PROCEDURE API_GET_DASHBOARD_M1_TPTATC
(  
    VTOAANID	IN	VARCHAR2,
    VTHAMPHANID IN NUMBER,
    VTUNGAY	IN VARCHAR2,
    VDENNGAY	IN VARCHAR2,
    CURRETURN OUT SYS_REFCURSOR 
) AS

    V_CURSOR_TD sys_refcursor;

    V_TABLE_TIMKIEM             T_DASHBOARD_THAMPHAN;

    FETCH_THAMPHAN_HOTEN       VARCHAR2(250 CHAR);
    FETCH_THAMPHANID   VARCHAR2(10 CHAR);
    FETCH_COLUMN_1     VARCHAR2(10 CHAR);
    FETCH_COLUMN_2     VARCHAR2(10 CHAR);
    FETCH_COLUMN_3     VARCHAR2(10 CHAR); 
    FETCH_COLUMN_4     VARCHAR2(10 CHAR);
    FETCH_COLUMN_5     VARCHAR2(10 CHAR);
    FETCH_COLUMN_6     VARCHAR2(10 CHAR);  
    FETCH_COLUMN_7     VARCHAR2(10 CHAR);
    FETCH_COLUMN_8     VARCHAR2(10 CHAR);
    FETCH_COLUMN_9     VARCHAR2(10 CHAR);
    FETCH_COLUMN_10    VARCHAR2(10 CHAR);

  BEGIN

    V_TABLE_TIMKIEM := T_DASHBOARD_THAMPHAN();

    PKG_DASHBOARD.DASHBOARD_M1_TPTATC(VTOAANID, VTHAMPHANID, VTUNGAY, VDENNGAY, V_CURSOR_TD);            
    LOOP
        FETCH V_CURSOR_TD
        INTO    FETCH_THAMPHAN_HOTEN, FETCH_THAMPHANID, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10;
        EXIT WHEN V_CURSOR_TD%NOTFOUND;

        V_TABLE_TIMKIEM.EXTEND;
        V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_DASHBOARD_THAMPHAN(FETCH_THAMPHAN_HOTEN, FETCH_THAMPHANID, 
                                                                                FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                                                                                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                                                                                FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10);
    END LOOP;

    OPEN curReturn FOR 

        SELECT A.THAMPHAN_HOTEN AS Name_judge,
               A.THAMPHANID AS Id_judge ,
               A.COLUMN_1 AS Total_order,
               A.COLUMN_2 AS unresolved_cases,
               A.COLUMN_3 AS resolved ,
               A.COLUMN_4 AS Total_cases,
               A.COLUMN_5 AS tried_cases,
               A.COLUMN_6 AS Untried_cases

        FROM (SELECT * FROM TABLE(V_TABLE_TIMKIEM)) A;

  END API_GET_DASHBOARD_M1_TPTATC;

  PROCEDURE API_GET_DASHBOARD_STPT_M1
(  
    VTOAANID	in	NUMBER,
    VTUNGAY	in VARCHAR2,
    VDENNGAY	in VARCHAR2,
    vTuNgayTruoc	in VARCHAR2,
    vDenNgayTruoc	in VARCHAR2,
    CURRETURN OUT SYS_REFCURSOR 
) AS

    V_CURSOR_TD sys_refcursor;

    V_TABLE_TIMKIEM             T_TYPE_OF_15_COLUMN_VARCHAR;

    FETCH_COLUMN_1     VARCHAR2(100 CHAR);
    FETCH_COLUMN_2     VARCHAR2(100 CHAR);
    FETCH_COLUMN_3     VARCHAR2(100 CHAR); 
    FETCH_COLUMN_4     VARCHAR2(100 CHAR);
    FETCH_COLUMN_5     VARCHAR2(100 CHAR);
    FETCH_COLUMN_6     VARCHAR2(100 CHAR);  
    FETCH_COLUMN_7     VARCHAR2(100 CHAR);
    FETCH_COLUMN_8     VARCHAR2(100 CHAR);
    FETCH_COLUMN_9     VARCHAR2(100 CHAR);

  BEGIN

    V_TABLE_TIMKIEM := T_TYPE_OF_15_COLUMN_VARCHAR();

    PKG_DASHBOARD.DASHBOARD_STPT_EXP(VTOAANID, VTUNGAY, VDENNGAY, vTuNgayTruoc, vDenNgayTruoc, V_CURSOR_TD);            
    LOOP
        FETCH V_CURSOR_TD
        INTO    FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                FETCH_COLUMN_8;
        EXIT WHEN V_CURSOR_TD%NOTFOUND;

        V_TABLE_TIMKIEM.EXTEND;
        V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                                                                                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                                                                                FETCH_COLUMN_8, '9', '10', '11','12',
                                                                                '13','14','15');
    END LOOP;

    OPEN curReturn FOR 
        SELECT A.COLUMN_1 AS Total_cases_received,
               A.COLUMN_2 AS Total_cases_resolved,
               A.COLUMN_3 AS Courts_with_resolution_rate_gt50,
               A.COLUMN_4 AS Courts_with_resolution_rate_lt50,
               A.COLUMN_5 AS Current_period,
               A.COLUMN_6 AS Compare_period,
               A.COLUMN_7 AS Reduce,
               A.COLUMN_8 AS Previous_period

        FROM (SELECT * FROM TABLE(V_TABLE_TIMKIEM)) A;

  END API_GET_DASHBOARD_STPT_M1;

  PROCEDURE API_GET_DASHBOARD_STPT_M2
(  
    VTOAANID	IN	VARCHAR2,
    VTUNGAY	IN VARCHAR2,
    VDENNGAY	IN VARCHAR2,
    VTUNGAYTRUOC	IN VARCHAR2,
    VDENNGAYTRUOC	IN VARCHAR2,
    VCOLUMN         IN VARCHAR2,
    CURRETURN OUT SYS_REFCURSOR 
) AS

    V_CURSOR_TD sys_refcursor;

    V_TABLE_TIMKIEM             T_TYPE_OF_15_COLUMN_VARCHAR;
    V_COLUMN           VARCHAR2(5 CHAR);

    FETCH_COLUMN_1     VARCHAR2(100 CHAR);
    FETCH_COLUMN_2     VARCHAR2(100 CHAR);
    FETCH_COLUMN_3     VARCHAR2(100 CHAR); 
    FETCH_COLUMN_4     VARCHAR2(100 CHAR);
    FETCH_COLUMN_5     VARCHAR2(100 CHAR);
    FETCH_COLUMN_6     VARCHAR2(100 CHAR);  
    FETCH_COLUMN_7     VARCHAR2(100 CHAR);
    FETCH_COLUMN_8     VARCHAR2(100 CHAR);

  BEGIN

           SELECT CASE VCOLUMN WHEN '1' THEN '1'
                         WHEN'2' THEN '2'
                         WHEN'3' THEN '3'
                         WHEN'4' THEN '4'
                         WHEN'5' THEN '3'
                         WHEN'6' THEN '3'
                         ELSE '1' END INTO V_COLUMN
                 FROM DUAL;

    V_TABLE_TIMKIEM := T_TYPE_OF_15_COLUMN_VARCHAR();

    PKG_DASHBOARD.DASHBOARD_M2_STPT(VTOAANID, VTUNGAY, VDENNGAY, VTUNGAYTRUOC, VDENNGAYTRUOC, VCOLUMN, V_CURSOR_TD);            
    LOOP
        FETCH V_CURSOR_TD
        INTO    FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                FETCH_COLUMN_8;
        EXIT WHEN V_CURSOR_TD%NOTFOUND;

        V_TABLE_TIMKIEM.EXTEND;
        V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                                                                                FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                                                                                FETCH_COLUMN_8, 'FETCH_COLUMN_9', 'FETCH_COLUMN_10', 'FETCH_COLUMN_11',
                                                                                'FETCH_COLUMN_12', 'FETCH_COLUMN_13', 'FETCH_COLUMN_14','15');
    END LOOP;

    OPEN curReturn FOR 
        SELECT A.COLUMN_2 AS unit_name,
               A.COLUMN_3 AS total_cases_received,
               A.COLUMN_4 AS total_cases_resolved,
               A.COLUMN_5 AS resolution_rate,
               A.COLUMN_6 AS Reduce,
               A.COLUMN_7 AS Compare_period ,
               A.COLUMN_8 AS previous_period

        FROM (SELECT * FROM TABLE(V_TABLE_TIMKIEM)) A;

  END API_GET_DASHBOARD_STPT_M2;

END PKG_API_DASHBOARD;

/
