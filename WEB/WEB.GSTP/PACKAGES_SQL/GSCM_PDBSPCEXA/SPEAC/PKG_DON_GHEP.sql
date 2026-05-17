--------------------------------------------------------
--  DDL for Package PKG_DON_GHEP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE "GSCM"."PKG_DON_GHEP" AS

PROCEDURE Don_GETLIST
( 
  vToaanId in number,
  vMavuviec in varchar2,
  vTenvuviec  in varchar2,
  vNguoikhoikien in varchar2,
  vCmnd in varchar2,
  vNamsinh in varchar2, 
  vNguoibikien in varchar2,
  vNoidungkhoikien in varchar2,
  vmaloaian in varchar2,
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
);

PROCEDURE GetDonGhep
( 
  vToaanId in number,
  IdDon in number,
  LoaiAn in number,
  curReturn OUT sys_refcursor
);

PROCEDURE GetDonGhepDonKC
( 
  vToaanId in number,
  IdDon in number,
  LoaiAn in number,
  curReturn OUT sys_refcursor
);

PROCEDURE GetDonGhepDonKC_DUONGSUID
( 
  vToaanId in int,
  IdDon in int,
  IdDuongSu  in int,
  LoaiAnId in int,
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
);

PROCEDURE GetDonGhepDonKC_BIANID
( 
  vToaanId in int,
  IdDon in int,
  IdBiAn  in int,
  LoaiAnId in int,
  PageIndex	in	int,
  PageSize	in	int,  
  curReturn OUT sys_refcursor
);


end PKG_DON_GHEP;
