--------------------------------------------------------
--  DDL for Package Body PKG_DONVI_REPORT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_DONVI_REPORT" AS
FUNCTION GET_DONVI_BC
(
 v_capxx in varchar2,
 v_object_select in varchar2
)
RETURN SYS_REFCURSOR
IS 
  V_CURSOR sys_refcursor;
  var_arrsx  varchar2(250);
BEGIN
        IF(v_object_select='CAPHUYEN') THEN
            OPEN V_CURSOR FOR
                 SELECT 1 ID,0 CAPCHAID,'Danh sách đơn vị' TEN FROM DUAL
                    UNION ALL 
                 SELECT TT.ID,TT.CAPCHAID,TO_CHAR(TT.TEN)TEN FROM (
                         SELECT MN.ID,DECODE(MN.CAPCHAID,4,1,5,1,6,1,MN.CAPCHAID)CAPCHAID,MN.TEN FROM DM_TOAAN MN 
                         WHERE MN.LOAITOA IN ('CAPHUYEN') AND MN.HIEULUC = 1
                         ORDER BY MN.ARRTHUTU
                 )TT;
        ELSIF(v_object_select='TH' And v_capxx='CAPTINH') THEN
            OPEN V_CURSOR FOR
                 SELECT 1 ID,0 CAPCHAID,'Danh sách đơn vị' TEN FROM DUAL
               UNION ALL 
                 SELECT TT.ID,TT.CAPCHAID,TO_CHAR(TT.TEN)TEN FROM (
                 SELECT MN.ID,1 CAPCHAID,MN.TEN FROM DM_TOAAN MN 
                 WHERE MN.LOAITOA IN ('CAPTINH','CAPHUYEN') AND MN.HIEULUC = 1
                 ORDER BY MN.ARRTHUTU
                )TT;
        ELSIF(v_object_select='TH' And v_capxx='CAPCAO') THEN
            OPEN V_CURSOR FOR
                 SELECT 1 ID,0 CAPCHAID,'Danh sách đơn vị' TEN FROM DUAL
               UNION ALL 
                 SELECT TT.ID,TT.CAPCHAID,TO_CHAR(TT.TEN)TEN FROM (
                 SELECT MN.ID,1 CAPCHAID,MN.TEN FROM DM_TOAAN MN 
                 WHERE MN.LOAITOA IN ('CAPTINH','CAPHUYEN','CAPCAO') AND MN.HIEULUC = 1
                 ORDER BY MN.ARRTHUTU
                )TT;
        ELSIF(v_object_select='TH' And v_capxx='TOICAO') THEN
            select t.ARRSAPXEP into var_arrsx from DM_TOAAN t where t.ID=1;
             OPEN V_CURSOR FOR
--                 SELECT 1 ID,0 CAPCHAID,'Danh sách đơn vị' TEN FROM DUAL
--               UNION ALL 
                 SELECT TT.ID,TT.CAPCHAID,TO_CHAR(TT.TEN)TEN FROM (
                 SELECT MN.ID,MN.CAPCHAID,MN.TEN FROM DM_TOAAN MN 
                 WHERE MN.LOAITOA  IN ('CAPTINH','CAPHUYEN','CAPCAO','TOICAO') AND MN.HIEULUC = 1
                 ORDER BY MN.ARRTHUTU )TT;
--                   SELECT TT.ID,TT.CAPCHAID,TO_CHAR(TT.TEN)TEN FROM (
--                     SELECT t.ID,1 CAPCHAID, 
--                              ((CASE t.SOCAP WHEN 1 THEN '' WHEN 2 THEN '..' WHEN 3 THEN '....'  WHEN 4 THEN '......' END) || t.MA_TEN) as arrTEN,
--                              case when ROWNUM =1 then t.TEN when rownum>1 then '...'||t.TEN end as TEN
--                        from DM_TOAAN t
--                        Where t.HIEULUC=1 and
--                         (t.ARRSAPXEP like (var_arrsx ||'/%') or t.ARRSAPXEP=var_arrsx )
--                        Order by t.ARRTHUTU) TT;
        END IF;
  RETURN v_cursor;   
END;
FUNCTION GET_DONVI_TINH
(
 V_CAPCHAID in varchar2
)
RETURN SYS_REFCURSOR
IS 
  V_CURSOR sys_refcursor;
BEGIN
  OPEN V_CURSOR FOR
         SELECT 1 ID,0 CAPCHAID,'Danh sách đơn vị' TEN FROM DUAL
       UNION ALL 
         SELECT TT.ID,TT.CAPCHAID,TO_CHAR(TT.TEN)TEN FROM (
                 SELECT MN.ID,1 CAPCHAID,MN.TEN FROM DM_TOAAN MN 
                 WHERE MN.CAPCHAID=V_CAPCHAID AND mn.hieuluc = 1  
                 ORDER BY MN.ARRTHUTU
         )TT;
  RETURN v_cursor;   
END;

END PKG_DONVI_REPORT;
