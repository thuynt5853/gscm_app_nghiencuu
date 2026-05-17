--------------------------------------------------------
--  DDL for Package PKG_AHS_DONGBO_C06
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."PKG_AHS_DONGBO_C06" AS 

  /* GTEL-DUCPH 23-09-2025 tach package xu ly rieng cho man dong bo */
  PROCEDURE c06_ahs_history (
        v_bicanid        IN    NUMBER,
        v_vuanid        IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );
  PROCEDURE c06_ahs_thuhoi (
  vID in number,
  vBICanId in number,
  vVuAnId in number,
  vGhiChu IN varchar2,
  vNguoiThuHoi IN varchar2
  );
    PROCEDURE c06_ahs_toidanh_hinhphat_getbyid (
        vbicanid      IN    NUMBER,
        v_toidanhid   IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        v_ismain      IN    VARCHAR2,
        curreturn     OUT   SYS_REFCURSOR
    );

    PROCEDURE getdulieuchon_thuhoigannhat (
        v_bicanid   IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_dieuct_getall (
        bi_can_id   IN    INT,
        vu_an_id    IN    INT,
        v_capxx     IN    VARCHAR2,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_bican_getbyid (
        vbicanid      IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        curreturn     OUT   SYS_REFCURSOR
    );

    FUNCTION create_ma_dongbo_random RETURN VARCHAR2;

    PROCEDURE c06_ahs_add_history (
        vahsid         IN   NUMBER,
        vnguoithuhoi   IN   VARCHAR2,
        vnoidung       IN   VARCHAR2,
        vlydo          IN   VARCHAR2,
        vBiCanId in number,
        vVuAnId in number,
        vAction_Type in varchar2
    );

    PROCEDURE c06_ahs_sotham_hinhphat_th_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_hinhphat_tonghop_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_hinhphat_getbyid (
        vbicanid      IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        v_ismain      IN    VARCHAR2,
        curreturn     OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_hinhphat_chinh_getbyid (
        vbicanid      IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        curreturn     OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_hinhphat_bosung_getbyid (
        vbicanid      IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR,
        curreturn     OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_search_chuadongbo (
        v_loaian_id       IN    VARCHAR2,
        v_loaibaqd        IN    VARCHAR2,
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

    PROCEDURE c06_ahs_search_dadongbo (
        v_loaian_id       IN    VARCHAR2,
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

    PROCEDURE c06_ahs_search_thuhoi (
        v_loaian_id       IN    VARCHAR2,
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

    PROCEDURE c06_ahs_dongbo_get_bican (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_dongbo_get_toidanh (
        vbicanid      IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        curretun      OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_insert (
        sobananorqd            IN   VARCHAR2,
        ngayrabanan            IN   VARCHAR2,
        madonvirabanan         IN   VARCHAR2,
        tendonvirabanan        IN   VARCHAR2,
        bqd                    IN   VARCHAR2,
        dstoidanh              IN   VARCHAR2,
        mahinhphatchinh        IN   VARCHAR2,
        tenhinhphatchinh       IN   VARCHAR2,
        thamsohinhphatchinh    IN   VARCHAR2,
        dshinhphatbosung       IN   VARCHAR2,
        ngayhieulucba          IN   VARCHAR2,
        hotenbicao             IN   VARCHAR2,
        sogiaytobicao          IN   VARCHAR2,
        ngaysinhbicao          IN   VARCHAR2,
        maquoctichbicao        IN   VARCHAR2,
        tenquoctichbicao       IN   VARCHAR2,
        mathanhphotinhbicao    IN   VARCHAR2,
        tenthanhphotinhbicao   IN   VARCHAR2,
        maquanhuyenbicao       IN   VARCHAR2,
        tenquanhuyenbicao      IN   VARCHAR2,
        maphuongxabicao        IN   VARCHAR2,
        tenphuongxabicao       IN   VARCHAR2,
        diachibicao            IN   VARCHAR2,
        ghichu                 IN   VARCHAR2,
        vuanid                 IN   NUMBER,
        bicanid                IN   NUMBER,
        taikhoangui            IN   VARCHAR2,
        tenvuan                IN   VARCHAR2,
        thuly                  IN   VARCHAR2,
        madongboid             IN   VARCHAR2,
        capxx                  IN   VARCHAR2,
        toidanh_th in varchar2,
        hinhphat_th in varchar2,
        thamphan in varchar2
    );
    PROCEDURE c06_ahs_insert_guilai (
        sobananorqd            IN   VARCHAR2,
        ngayrabanan            IN   VARCHAR2,
        madonvirabanan         IN   VARCHAR2,
        tendonvirabanan        IN   VARCHAR2,
        bqd                    IN   VARCHAR2,
        dstoidanh              IN   VARCHAR2,
        mahinhphatchinh        IN   VARCHAR2,
        tenhinhphatchinh       IN   VARCHAR2,
        thamsohinhphatchinh    IN   VARCHAR2,
        dshinhphatbosung       IN   VARCHAR2,
        ngayhieulucba          IN   VARCHAR2,
        hotenbicao             IN   VARCHAR2,
        sogiaytobicao          IN   VARCHAR2,
        ngaysinhbicao          IN   VARCHAR2,
        maquoctichbicao        IN   VARCHAR2,
        tenquoctichbicao       IN   VARCHAR2,
        mathanhphotinhbicao    IN   VARCHAR2,
        tenthanhphotinhbicao   IN   VARCHAR2,
        maquanhuyenbicao       IN   VARCHAR2,
        tenquanhuyenbicao      IN   VARCHAR2,
        maphuongxabicao        IN   VARCHAR2,
        tenphuongxabicao       IN   VARCHAR2,
        diachibicao            IN   VARCHAR2,
        ghichu                 IN   VARCHAR2,
        vuanid                 IN   NUMBER,
        bicanid                IN   NUMBER,
        taikhoangui            IN   VARCHAR2,
        tenvuan                IN   VARCHAR2,
        thuly                  IN   VARCHAR2,
        madongboid             IN   VARCHAR2,
        capxx                  IN   VARCHAR2,
        nguoiguilai IN VARCHAR2,
        toidanh_th in varchar2,
        hinhphat_th in varchar2,
        thamphan in varchar2
    );
    PROCEDURE c06_ahs_bican_sotham_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_dadongbo_getbyid (
        c06_ahs_id   IN    NUMBER,
        curreturn    OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_toaan_hinhsu_getbyid (
        vid         IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

END pkg_ahs_dongbo_c06;

/
