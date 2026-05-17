--------------------------------------------------------
--  DDL for Package PKG_DVCQ_SEARCH_THUCONG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_DVCQ_SEARCH_THUCONG" AS 
PROCEDURE TB_TU_ANPHI_SEARCH (V_MA_THONGBAO   IN     VARCHAR2,
                                 V_CURSOR           OUT SYS_REFCURSOR);

END PKG_DVCQ_SEARCH_THUCONG;

/
