--------------------------------------------------------
--  DDL for Package PKG_DVCQG
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_DVCQG" 
AS
   PROCEDURE TB_TU_ANPHI_SEARCH (V_MA_THONGBAO   IN     VARCHAR2,
                                 V_CURSOR           OUT SYS_REFCURSOR);

   PROCEDURE TB_TU_ANPHI_THANHTOAN (
      v_MATRACUUTT           IN     VARCHAR2,
      v_MA_THONGBAO          IN     VARCHAR2,
      v_HOTENNGUOINOPTIEN    IN     VARCHAR2,
      v_SOCMNDNGUOINOP       IN     VARCHAR2,
      v_DIACHINGUOINOPTIEN   IN     VARCHAR2,
      v_TINHNGUOINOPTIEN     IN     VARCHAR2,
      v_HUYENNGUOINOPTIEN    IN     VARCHAR2,
      v_XANGUOINOPTIEN       IN     VARCHAR2,
      v_URLBIENLAI           IN     VARCHAR2,
      v_SOTIEN               IN     VARCHAR2,
      v_TRANGTHAITHANHTOAN   IN     NUMBER,
      v_FILE_ATTACH          IN     BLOB,
      v_FILE_NAME            IN     VARCHAR2,
      v_SOBIENLAI            IN     VARCHAR2,
      v_NGAYBIENLAI          IN     DATE,
      v_DONVITHUTIEN         IN     VARCHAR2,
      l_Cursor_ERRO             OUT SYS_REFCURSOR);

   PROCEDURE THANH_TOAN_SEARCH (
   V_MAGIAIDOAN IN NUMBER,
   V_DONXULY_ID     IN     NUMBER,
   V_ANPHI_ID     IN     NUMBER,
                                V_MALOAIVUVIEC   IN     VARCHAR2,
                                curReturn           OUT SYS_REFCURSOR);
   PROCEDURE THANH_TOAN_SEARCH_KC (
   V_MAGIAIDOAN IN NUMBER,
   V_DONXULY_ID     IN     NUMBER,
   V_MALOAIVUVIEC   IN     VARCHAR2,
   curReturn           OUT SYS_REFCURSOR);
END PKG_DVCQG;

/
