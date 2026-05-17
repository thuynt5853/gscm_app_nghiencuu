--------------------------------------------------------
--  DDL for Package PKG_GDTTTT_KNTP_CC
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_GDTTTT_KNTP_CC" AS 

  /* TODO enter package declarations (types, exceptions, methods etc) here */ 
    PROCEDURE  GDTTTT_KNTP_SEARCH
        ( 
          v_ID_USER VARCHAR2,
          v_colume  in varchar2,
          v_asc_desc in varchar2,
          vToaAnID in number,
          vPhongBanID  in number,
          vToaRaBAQD in number,
          vSoBAQD in varchar2,
          vNgayBAQD in varchar2,
          vNguoiGui in varchar2,
          vCoquanchuyendon in varchar2,
          vNguyendon in varchar2,
          vBidon in varchar2,
          vLoaiAn in number,
          vThamtravien in number,
          vLanhdao in number,

          vNgayThulyTu in date,
          vNgayThulyDen in date,
          vSoThuly in varchar2, 
          vTrangthai in number,
          vKetquathuly in number,  

          isTTMuonHS in number,
          LoaiAnDB in number,
          vNoidungKN in varchar2,
          v_SodonTLM        in number,
          
          v_loaingaysearch in number,
          v_NgaySearch_Tu in date,
          v_NgaySearch_Den in date,
          
          PageIndex	in	int,
          PageSize	in	int,  
          curReturn OUT sys_refcursor
        );
        
    FUNCTION GDTTT_KNTP_SEARCH_PRINT( 
          v_ID_USER VARCHAR2,
          v_colume  in varchar2,
          v_asc_desc in varchar2,
          vToaAnID in number,
          vPhongBanID  in number,
          vToaRaBAQD in number,
          vSoBAQD in varchar2,
          vNgayBAQD in varchar2,
          vNguoiGui in varchar2,
          vCoquanchuyendon in varchar2,
          vLoaiAn in number,
          vThamtravien in number,
          vLanhdao in number,
          vNgayThulyTu in date,
          vNgayThulyDen in date,
          vSoThuly in varchar2,
          vTrangthai in number,
          vKetquathuly in number,
          isTTMuonHS in number,
          LoaiAnDB in number,
          vNoidungKN in varchar2,
          v_SodonTLM        in number,
          v_loaingaysearch in number,
          v_NgaySearch_Tu in date,
          v_NgaySearch_Den in date
        ) RETURN SYS_REFCURSOR;

END PKG_GDTTTT_KNTP_CC;
