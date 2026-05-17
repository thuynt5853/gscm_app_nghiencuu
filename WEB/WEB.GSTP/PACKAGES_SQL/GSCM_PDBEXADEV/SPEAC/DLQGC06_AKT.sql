--------------------------------------------------------
--  DDL for Package DLQGC06_AKT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."DLQGC06_AKT" AS
    PROCEDURE akt_xacthuc_c06_update (
        vid        IN   INT,
        vxacthuc   IN   INT,
        vkhongco   IN   VARCHAR2
    );

    PROCEDURE c06_akt_search_chuadongbo (
        v_loaian_id       IN    VARCHAR2,
        v_loaibaqd        IN    VARCHAR2,
        v_baqd_id         IN    VARCHAR2,
        v_khangcaoqh      IN    VARCHAR2,
        v_toaan_id        IN    VARCHAR2,
        v_capxx           IN    VARCHAR2,
        v_ten_vu_an       IN    VARCHAR2,
        v_toidanh         IN    VARCHAR2,
        v_ma_vu_an        IN    VARCHAR2,
        v_bi_can          IN    VARCHAR2,
        v_cccd            IN    VARCHAR2,
        v_so_qd           IN    VARCHAR2,
        v_tungay          IN    VARCHAR2,
        v_denngay         IN    VARCHAR2,
        v_thamphan_id     IN    VARCHAR2,
        v_thuky_id        IN    VARCHAR2,
        v_trangthai_gui   IN    VARCHAR2,
        v_ngaygui_tu      IN    VARCHAR2,
        v_ngaygui_den     IN    VARCHAR2,
        page_index        IN    INT,
        page_size         IN    INT,
        curreturn         OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_akt_search_thuhoi (
        v_loaian_id       IN    VARCHAR2,
        v_loaibaqd        IN    VARCHAR2,
        v_baqd_id         IN    VARCHAR2,
        v_khangcaoqh      IN    VARCHAR2,
        v_toaan_id        IN    VARCHAR2,
        v_capxx           IN    VARCHAR2,
        v_ten_vu_an       IN    VARCHAR2,
        v_toidanh         IN    VARCHAR2,
        v_ma_vu_an        IN    VARCHAR2,
        v_bi_can          IN    VARCHAR2,
        v_cccd            IN    VARCHAR2,
        v_so_qd           IN    VARCHAR2,
        v_tungay          IN    VARCHAR2,
        v_denngay         IN    VARCHAR2,
        v_thamphan_id     IN    VARCHAR2,
        v_thuky_id        IN    VARCHAR2,
        v_trangthai_gui   IN    VARCHAR2,
        v_ngaygui_tu      IN    VARCHAR2,
        v_ngaygui_den     IN    VARCHAR2,
        page_index        IN    INT,
        page_size         IN    INT,
        curreturn         OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_akt_search_dadongbo (
        v_loaian_id       IN    VARCHAR2,
        v_loaibaqd        IN    VARCHAR2,
        v_baqd_id         IN    VARCHAR2,
        v_khangcaoqh      IN    VARCHAR2,
        v_toaan_id        IN    VARCHAR2,
        v_capxx           IN    VARCHAR2,
        v_ten_vu_an       IN    VARCHAR2,
        v_toidanh         IN    VARCHAR2,
        v_ma_vu_an        IN    VARCHAR2,
        v_bi_can          IN    VARCHAR2,
        v_cccd            IN    VARCHAR2,
        v_so_qd           IN    VARCHAR2,
        v_tungay          IN    VARCHAR2,
        v_denngay         IN    VARCHAR2,
        v_thamphan_id     IN    VARCHAR2,
        v_thuky_id        IN    VARCHAR2,
        v_trangthai_gui   IN    VARCHAR2,
        v_ngaygui_tu      IN    VARCHAR2,
        v_ngaygui_den     IN    VARCHAR2,
        page_index        IN    INT,
        page_size         IN    INT,
        curreturn         OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_akt_search_by_id (
        v_id        IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_akt_duongsu_getbyid (
        v_duongsuid   IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        curreturn     OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_akt_duongsu_thuhoigannhat (
        v_duongsuid   IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        curreturn     OUT   SYS_REFCURSOR
    );

    PROCEDURE akt_don_dsduongsu_getby (
        vdonid      IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_akt_duongsu_cdb_getby (
        v_duongsuid     IN    NUMBER,
        v_capxx         IN    VARCHAR2,
        v_sobananorqd   IN    VARCHAR2,
        v_loaiba_qd     IN    VARCHAR2,
        curreturn       OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_akt_duongsu_guilai (
        v_id     IN    NUMBER,
        curreturn       OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_akt_history_by_id (
        v_id        IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE akt_don_duongsu_notdaidien_doncha (
        vdonid      IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE getdulieuchon_thuhoigannhat (
        v_duongsuid   IN    NUMBER,
        curreturn     OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_toaan_kdtm_history_insert (
        vlydo          IN   VARCHAR2,
        vnoidung       IN   VARCHAR2,
        vnguoithuhoi   IN   VARCHAR2,
        vid            IN   NUMBER,
        vuanid         IN   NUMBER,
        duongsuid      IN   NUMBER,
        actiontype     IN   VARCHAR2
    );
END
dlqgc06_akt;

/
