--------------------------------------------------------
--  DDL for Package Body PKG_XLHC_ST_KNKNKN
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_XLHC_ST_KNKNKN" 
IS
--
-- To modify this template, edit file PKGBODY.TXT in TEMPLATE
-- directory of SQL Navigator
--
-- Purpose: Briefly explain the functionality of the package body
--
-- MODIFICATION HISTORY
-- Person      Date    Comments
-- ---------   ------  ------------------------------------------
   -- Enter procedure, function bodies as shown below

   PROCEDURE SP_GET_QUYETDINH
    ( vDonID in NUMBER,
      vType in number, --1 Khieu nai, 2 Kien nghi, 3 Khang nghi
      curReturn    OUT       sys_refcursor
    )
    IS

   BEGIN
       OPEN curReturn FOR
       SELECT qd.id, stba.sobanan || ' - ' || qd.ten as FullTitleQD
       FROM  XLHC_SOTHAM_BANAN stba, DM_QD_QUYETDINH qd
       WHERE 1=1
       and stba.QUYETDINHID = qd.id
       and stba.donid = vDonID
       UNION ALL
       SELECT qd.id, dxhm.SO_QUYETDINH || ' - ' || qd.ten as FullQD
       FROM  XLHC_DONXIN_HOAN_MIEN dxhm, DM_QD_QUYETDINH qd
       WHERE 1=1
       and dxhm.DM_QUYETDINH_ID = qd.id
       and dxhm.donid = vDonID
       UNION ALL
       SELECT qd.id, qd.ma || ' - ' || qd.ten as FullQD
       FROM  DM_QD_QUYETDINH qd
       WHERE 1=1
       and qd.ID = 463
       and qd.ISSOTHAM = 1
       and qd.KET_THUC = 0
       ;
   EXCEPTION
      WHEN OTHERS THEN
        OPEN curReturn FOR
          SELECT qd.id, qd.ma || ' - ' || qd.ten as FullTitleQD
        FROM  DM_QD_QUYETDINH qd
        WHERE 0=1 ; --luôn trả ra blank
   END;

   -- Enter further code below as specified in the Package spec.
END;

/
