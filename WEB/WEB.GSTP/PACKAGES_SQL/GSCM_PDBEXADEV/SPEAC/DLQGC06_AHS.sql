--------------------------------------------------------
--  DDL for Package DLQGC06_AHS
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "GSCM"."DLQGC06_AHS" AS 

  /* 
  TODO enter package declarations (types, exceptions, methods etc) here 
  GTEL-Đức PHạm 11-09-2025 9h:00: Các nghiệp vụ cho phần nâng cấp Bản án Hình sự và Đồng bộ bản án hình sự sơ thẩm sang C06
  */
    PROCEDURE ahs_check_bican_da_dongbo (
        bi_can_id   IN    NUMBER,
        vu_an_id    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE ahs_check_bican_chuaxacthuc (
        vu_an_id    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE ahs_toidanh_chinh_getbybican (
        bi_can_id   IN    INT,
        vu_an_id    IN    INT,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE ahs_bicao_getall_by_vuanid_search (
        vu_an_id     IN    INT,
        textsearch   IN    NVARCHAR2,
        pageindex    IN    INT,
        pagesize     IN    INT,
        curreturn    OUT   SYS_REFCURSOR
    );

    PROCEDURE ahs_bicao_getall_by_vuanid (
        vu_an_id    IN    INT,
        pageindex   IN    INT,
        pagesize    IN    INT,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_dongbo_ahs_del (
        id IN NUMBER
    );

    PROCEDURE getdulieuchon_thuhoigannhat (
        v_bicanid   IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );



    PROCEDURE ahs_bibanbicao_c06_update (
        vbicanid      IN   NUMBER,
        vsocccd       IN   VARCHAR2,
        vsohc         IN   VARCHAR2,
        vxacthuc      IN   CHAR,
        vchkkhongco   IN   CHAR
    );

    PROCEDURE ahs_bibicao_c06_get_by_bicanid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE ahs_st_banan_bicao_getbyvuanid (
        vu_an_id    IN    INT,
        pageindex   IN    INT,
        pagesize    IN    INT,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE ahs_sotham_banan_bicao_update_ngayhieuluc (
        vbicaoid       IN   NUMBER,
        vngayhieuluc   IN   DATE
    );

/* ------------------- Đồng Bộ C06 ----------------------------- */

    FUNCTION create_ma_dongbo_random RETURN VARCHAR2;

    PROCEDURE c06_ahs_thuhoi_history (
        vahsid         IN   NUMBER,
        vnguoithuhoi   IN   VARCHAR2,
        vnoidung       IN   VARCHAR2,
        vlydo          IN   VARCHAR2
    );

    PROCEDURE c06_ahs_sotham_hinhphat_th_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_sotham_hinhphat_chinh_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_sotham_hinhphat_boxung_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );






    PROCEDURE c06_ahs_dongbo_get_bican (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_dongbo_get_toidanh (
        vbicanid   IN    NUMBER,
        curretun   OUT   SYS_REFCURSOR
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
        madongboid             IN   VARCHAR2
    );

    PROCEDURE c06_ahs_bican_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ahs_dadongbo_getbyid (
        c06_ahs_id   IN    NUMBER,
        curreturn    OUT   SYS_REFCURSOR
    );


    --------- XU ly Lich Sua chinh sua BiCan ----

    PROCEDURE ahs_bican_history_insert (
        his_nguoisua      IN   VARCHAR2,
        his_taikhoansua   IN   VARCHAR2,
        his_bican         IN   VARCHAR2,
        bicanid           IN   NUMBER
    );

    PROCEDURE ahs_bican_history_getlist (
        v_bicanid   IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );
/* ------------------- END ----------------------------- */

END dlqgc06_ahs;

/
