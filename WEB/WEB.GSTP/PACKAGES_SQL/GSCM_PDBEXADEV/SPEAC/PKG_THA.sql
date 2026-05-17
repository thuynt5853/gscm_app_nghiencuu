CREATE OR REPLACE PACKAGE GSCM.PKG_THA AS 

    PROCEDURE  THA_THULY_GETLIST 
    ( 
        vBiAnID in number,
        vVUANID  in number,
        curReturn OUT sys_refcursor
    );
    PROCEDURE GetBiAnTrongTHA
    ( 
      toa_an_id in number,
      ma_bi_an in nvarchar2,
      ten_bi_an in nvarchar2,
      ma_vu_an in nvarchar2, ten_vu_an in nvarchar2,
      so_ban_an in varchar2, ngay_ban_an in date,
      PageIndex	in	number,
      PageSize	in	number,
      curReturn    OUT   sys_refcursor
    );

    PROCEDURE GetBiAnNgoaiTHA
    ( 
      toa_an_id in number,
      ma_bi_an in nvarchar2,
      ten_bi_an in nvarchar2,
      ma_vu_an in nvarchar2, ten_vu_an in nvarchar2,
      so_ban_an in varchar2, ngay_ban_an in date,
      PageIndex	in	number,
      PageSize	in	number,
      curReturn    OUT   sys_refcursor
    );

END PKG_THA;