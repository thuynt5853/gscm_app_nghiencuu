CREATE OR REPLACE PACKAGE dlqgc06_ald AS
    PROCEDURE ald_xacthuc_c06_update (
        vid        IN   INT,
        vxacthuc   IN   INT,
        vkhongco   IN   VARCHAR2
    );

    PROCEDURE c06_ald_search_chuadongbo (
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

    PROCEDURE c06_ald_search_thuhoi (
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

    PROCEDURE c06_ald_search_dadongbo (
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

    PROCEDURE c06_ald_search_by_id (
        v_id        IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ald_duongsu_getbyid (
        v_duongsuid   IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        curreturn     OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ald_duongsu_thuhoigannhat (
        v_duongsuid   IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        curreturn     OUT   SYS_REFCURSOR
    );

    PROCEDURE ald_don_dsduongsu_getby (
        vdonid      IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ald_duongsu_cdb_getby (
        v_duongsuid     IN    NUMBER,
        v_capxx         IN    VARCHAR2,
        v_sobananorqd   IN    VARCHAR2,
        v_loaiba_qd     IN    VARCHAR2,
        curreturn       OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ald_duongsu_guilai (
        v_id     IN    NUMBER,
        curreturn       OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_ald_history_by_id (
        v_id        IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE ald_don_duongsu_notdaidien_doncha (
        vdonid      IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    );

    PROCEDURE getdulieuchon_thuhoigannhat (
        v_duongsuid   IN    NUMBER,
        curreturn     OUT   SYS_REFCURSOR
    );

    PROCEDURE c06_toaan_laodong_history_insert (
        vlydo          IN   VARCHAR2,
        vnoidung       IN   VARCHAR2,
        vnguoithuhoi   IN   VARCHAR2,
        vid            IN   NUMBER,
        vuanid         IN   NUMBER,
        duongsuid      IN   NUMBER,
        actiontype     IN   VARCHAR2
    );

END dlqgc06_ald;

/


CREATE OR REPLACE PACKAGE BODY dlqgc06_ald AS

    PROCEDURE ald_xacthuc_c06_update (
        vid        IN   INT,
        vxacthuc   IN   INT,
        vkhongco   IN   VARCHAR2
    ) AS
        p_count NUMBER;
    BEGIN
        SELECT
            COUNT(1)
        INTO p_count
        FROM
            ald_don_duongsu
        WHERE
            id = vid;

        IF ( p_count > 0 ) THEN
            UPDATE ald_don_duongsu
            SET
                xacthuc_dldcqg = vxacthuc,
                chk_khong_co = vkhongco
            WHERE
                id = vid;

        END IF;

    END ald_xacthuc_c06_update;

    PROCEDURE c06_ald_search_chuadongbo (
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
    ) AS
        totalitem   NUMBER;
        minindex    NUMBER;
        maxindex    NUMBER;
    BEGIN
---------------------------------------
        minindex := page_size * ( page_index - 1 ) + 1;
        maxindex := page_index * page_size;
        OPEN curreturn FOR SELECT
                               tt.*
                           FROM
                               (
                                   SELECT
                                       ROW_NUMBER() OVER(
                                           ORDER BY
                                               a.ngaytao DESC
                                       ) stt,
                                       COUNT(*) OVER() AS countall,
                                       a.*
                                   FROM
                                       (
                                            --TH1: Bản án so tham hieu luc 
                                           SELECT
                                               db.id                  AS c06_id,
                                               d.id                   AS vuanid,
                                               ndds.id                AS duongsuid,
                                               '5' AS loaian_id,
                                               'Lao Động' AS loai_an_ten,
                                               '1' AS loaibaqd, -- bản án
                                               to_char(d.mavuviec) AS mavuan,
                                               d.tenvuviec            AS tenvuan,
                                               'SO_THAM' AS capxx_ma,
                                               'Sơ Thẩm' AS capxx,
                                               st.sobanan             AS sobananorqd,
                                               to_char(st.ngaytuyenan, 'dd/MM/yyyy') AS ngayrabanan,
                                               to_char(st.ngayhieuluc, 'dd/MM/yyyy') AS ngayhieulucba,
                                               d.toaanid              AS madonvirabanan,
                                               dm.ma_ten              AS tendonvirabanan,
                                               decode(tl.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy'
                                               ,
                                                      'Thụ lý mới')
                                               || ' - số '
                                               || tl.sothuly
                                               || ' ngày '
                                               || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                               ndds.tenduongsu        AS hotenduongsu,
                                               ndds.so_cccd           AS sogiaytoduongsu,
                                               decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh
                                               , 'dd/MM/yyyy')) AS ngaysinhduongsu,
                                               ndh1.ma_ten            AS diachiduongsu,
                                               ndqtn.ma               AS maquoctichduongsu,
                                               ndqtn.ten              AS tenquoctichduongsu,
                                               ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                               ndds.tucachtotung_ma   AS matucachtotung,
                                               tctt.ten               AS tentucachtotung,
                                               to_char(st.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                               dc.id                  AS thamphanid,
                                               dc.hoten               AS thamphan,
                                               'Chưa đồng bộ' AS trangthaibanghi,
                                               'CDB' AS loaibang,
                                               db.ghichu,
                                               db.taikhoangui,
                                               db.ngaygui,
                                               d.nguoitao
                                           FROM
                                               ald_don              d
                                               LEFT JOIN ald_don_duongsu      ndds ON d.id = ndds.donid
                                               LEFT JOIN dm_dataitem          tctt ON tctt.ma = ndds.tucachtotung_ma
                                               INNER JOIN ald_sotham_banan     st ON st.donid = d.id
                                               INNER JOIN dm_toaan             dm ON dm.id = st.toaanid
                                               LEFT JOIN dm_hanhchinh         ndh1 ON ndh1.id = ndds.tamtruid
                                               LEFT JOIN dm_dataitem          ndqtn ON ndqtn.id = ndds.quoctichid
                                                                              AND ndqtn.groupid = 2
                                               LEFT JOIN ald_sotham_thuly     tl ON tl.donid = d.id
                                               INNER JOIN ald_don_thamphan     tp ON tp.donid = d.id
                                                                                 AND tp.mavaitro = 'VTTP_GIAIQUYETSOTHAM'
                                               LEFT JOIN dm_canbo             dc ON dc.id = tp.canboid
                                               LEFT JOIN c06_toaan_laodong    db ON db.vuanid = d.id
                                                                                 AND db.duongsuid = ndds.id
                                                                                 AND db.loaibaqd = 1
                                                                                 AND db.capxx = 'SO_THAM'
                                           WHERE
                                               st.ngayhieuluc IS NOT NULL
                                               AND db.id IS NULL
                                               AND d.toaanid = v_toaan_id
                                               AND NOT EXISTS (
                                                   SELECT
                                                       1
                                                   FROM
                                                       ald_sotham_khangcao bck
                                                   WHERE
                                                       bck.donid = d.id
                                                       AND bck.duongsuid = ndds.id
                                                       AND NOT EXISTS (
                                                           SELECT
                                                               1
                                                           FROM
                                                               ald_sotham_rutkckn cck
                                                           WHERE
                                                               cck.idkckn = bck.id
                                                               AND cck.iskckn = 1
                                                               AND cck.trangthai = 2
                                                       ) -- nếu rút kháng cáo thì đồng bộ
                                                       AND NOT EXISTS (
                                               --- Nếu có kháng nghị thì không đồng bộ 
                                                           SELECT
                                                               1
                                                           FROM
                                                               ald_sotham_khangnghi bnck
                                                           WHERE
                                                               bnck.donid = d.id
                                                               AND NOT EXISTS (
                                                                   SELECT
                                                                       1
                                                                   FROM
                                                                       ald_sotham_rutkckn cnck
                                                                   WHERE
                                                                       cnck.idkckn = bnck.id
                                                                       AND cnck.iskckn = 2
                                                                       AND cnck.trangthai = 2
                                                               )
                                                       )
                                               )
                                           UNION    
                                            -- TH2: lấy thông tin bản án Phúc Thẩm thỏa mãn điều kiện đẩy đi
                                           SELECT
                                               db.id                  AS c06_id,
                                               d.id                   AS vuanid,
                                               ndds.id                AS duongsuid,
                                               '5' AS loaian_id,
                                               'Lao Động' AS loai_an_ten,
                                               '1' AS loaibaqd, -- bản án
                                               to_char(d.mavuviec) AS mavuan,
                                               d.tenvuviec            AS tenvuan,
                                               'PHUC_THAM' AS capxx_ma,
                                               'Phúc Thẩm' AS capxx,
                                               st.sobanan             AS sobananorqd,
                                               to_char(st.ngaytuyenan, 'dd/MM/yyyy') AS ngayrabanan,
                                               to_char(st.ngayhieuluc, 'dd/MM/yyyy') AS ngayhieuluc,
                                               d.toaanid              AS madonvirabanan,
                                               dm.ma_ten              AS tendonvirabanan,
                                               decode(tl.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy'
                                               ,
                                                      'Thụ lý mới')
                                               || ' - số '
                                               || tl.sothuly
                                               || ' ngày '
                                               || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                               ndds.tenduongsu        AS hotenduongsu,
                                               ndds.so_cccd           AS sogiaytoduongsu,
                                               decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh
                                               , 'dd/MM/yyyy')) AS ngaysinhduongsu,
                                               ndh1.ma_ten            AS diachiduongsu,
                                               ndqtn.ma               AS maquoctichduongsu,
                                               ndqtn.ten              AS tenquoctichduongsu,
                                               ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                               ndds.tucachtotung_ma   AS matucachtotung,
                                               tctt.ten               AS tentucachtotung,
                                               to_char(st.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                               dc.id                  AS thamphanid,
                                               dc.hoten               AS thamphan,
                                               'Chưa đồng bộ' AS trangthaibanghi,
                                               'CDB' AS loaibang,
                                               db.ghichu,
                                               db.taikhoangui,
                                               db.ngaygui,
                                               d.nguoitao
                                           FROM
                                               ald_don              d
                                               LEFT JOIN ald_don_duongsu      ndds ON d.id = ndds.donid
                                               LEFT JOIN dm_dataitem          tctt ON tctt.ma = ndds.tucachtotung_ma
                                               INNER JOIN ald_phuctham_banan   st ON st.donid = d.id
                                               INNER JOIN dm_toaan             dm ON dm.id = st.toaanid
                                                 -- nguyên đơn
                                               LEFT JOIN dm_hanhchinh         ndh1 ON ndh1.id = ndds.tamtruid
                                               LEFT JOIN dm_dataitem          ndqtn ON ndqtn.id = ndds.quoctichid
                                                                              AND ndqtn.groupid = 2
                                               LEFT JOIN c06_toaan_laodong    db ON db.vuanid = d.id
                                                                                 AND db.duongsuid = ndds.id
                                                                                 AND db.loaibaqd = 1
                                                                                 AND db.capxx = 'PHUC_THAM'
                                               LEFT JOIN ald_phuctham_thuly   tl ON tl.donid = d.id
                                               INNER JOIN ald_don_thamphan     tp ON tp.donid = d.id
                                                                                 AND tp.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                               LEFT JOIN dm_canbo             dc ON dc.id = tp.canboid
                                           WHERE
                                               st.ngayhieuluc IS NOT NULL
                                               AND db.id IS NULL
                                               AND d.toaphucthamid = v_toaan_id
                                               AND EXISTS (
                                                   SELECT
                                                       1
                                                   FROM
                                                       ald_sotham_khangcao bck
                                                   WHERE
                                                       bck.donid = d.id
                                                       AND bck.duongsuid = ndds.id
                                                       AND NOT EXISTS (
                                                           SELECT
                                                               1
                                                           FROM
                                                               ald_sotham_rutkckn cck
                                                           WHERE
                                                               cck.idkckn = bck.id
                                                               AND cck.iskckn = 1
                                                               AND cck.trangthai = 2
                                                       ) -- nếu rút kháng cáo thì đồng bộ
                                                       AND NOT EXISTS (
                                               --- Nếu có kháng nghị thì không đồng bộ 
                                                           SELECT
                                                               1
                                                           FROM
                                                               ald_sotham_khangnghi bnck
                                                           WHERE
                                                               bnck.donid = d.id
                                                               AND NOT EXISTS (
                                                                   SELECT
                                                                       1
                                                                   FROM
                                                                       ald_sotham_rutkckn cnck
                                                                   WHERE
                                                                       cnck.idkckn = bnck.id
                                                                       AND cnck.iskckn = 2
                                                                       AND cnck.trangthai = 2
                                                               )
                                                       )
                                               )
                                           UNION    
                                           -- TH3: lấy thông tin quyết định sơ thẩm thỏa mãn điều kiện đẩy đi
                                           SELECT
                                               db.id                  AS c06_id,
                                               d.id                   AS vuanid,
                                               ndds.id                AS duongsuid,
                                               '5' AS loaian_id,
                                               'Lao Động' AS loai_an_ten,
                                               '2' AS loaibaqd, -- bản án
                                               to_char(d.mavuviec) AS mavuan,
                                               d.tenvuviec            AS tenvuan,
                                               'SO_THAM' AS capxx_ma,
                                               'Sơ Thẩm' AS capxx,
                                               qd.soqd                AS sobananorqd,
                                               to_char(qd.ngayqd, 'dd/MM/yyyy') AS ngayrabanan,
                                               decode(qd.hieuluctu, NULL, NULL, to_char(qd.hieuluctu, 'dd/MM/yyyy')) AS ngayhieulucba
                                               ,
                                               d.toaanid              AS madonvirabanan,
                                               dm.ma_ten              AS tendonvirabanan,
                                               decode(tl.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy'
                                               ,
                                                      'Thụ lý mới')
                                               || ' - số '
                                               || tl.sothuly
                                               || ' ngày '
                                               || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                               ndds.tenduongsu        AS hotenduongsu,
                                               ndds.so_cccd           AS sogiaytoduongsu,
                                               decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh
                                               , 'dd/MM/yyyy')) AS ngaysinhduongsu,
                                               ndh1.ma_ten            AS diachiduongsu,
                                               ndqtn.ma               AS maquoctichduongsu,
                                               ndqtn.ten              AS tenquoctichduongsu,
                                               ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                               ndds.tucachtotung_ma   AS matucachtotung,
                                               tctt.ten               AS tentucachtotung,
                                               to_char(qd.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                               dc.id                  AS thamphanid,
                                               dc.hoten               AS thamphan,
                                               'Chưa đồng bộ' AS trangthaibanghi,
                                               'CDB' AS loaibang,
                                               db.ghichu,
                                               db.taikhoangui,
                                               db.ngaygui,
                                               d.nguoitao
                                           FROM
                                               ald_don                d
                                               LEFT JOIN ald_don_duongsu        ndds ON d.id = ndds.donid
                                               LEFT JOIN dm_dataitem            tctt ON tctt.ma = ndds.tucachtotung_ma
                                               INNER JOIN ald_sotham_quyetdinh   qd ON qd.donid = d.id
                                               INNER JOIN dm_toaan               dm ON dm.id = qd.toaanid
    -- nguyên đơn
                                               LEFT JOIN dm_hanhchinh           ndh1 ON ndh1.id = ndds.tamtruid
                                               LEFT JOIN dm_dataitem            ndqtn ON ndqtn.id = ndds.quoctichid
                                                                              AND ndqtn.groupid = 2
                                               LEFT JOIN c06_toaan_laodong      db ON db.vuanid = d.id
                                                                                 AND db.duongsuid = ndds.id
                                                                                 AND db.loaibaqd = 2
                                                                                 AND db.capxx = 'SO_THAM'
                                               LEFT JOIN ald_sotham_thuly     tl ON tl.donid = d.id
                                               INNER JOIN ald_don_thamphan       tp ON tp.donid = d.id
                                                                                 AND tp.mavaitro = 'VTTP_GIAIQUYETSOTHAM'
                                               LEFT JOIN dm_canbo               dc ON dc.id = tp.canboid
                                               INNER JOIN dm_qd_quyetdinh        qdts ON qd.quyetdinhid = qdts.id
                                           WHERE
                                               qdts.ma IN (
                                                   '19-VDS',
                                                   '20-VDS',
                                                   '22-VDS',
                                                   '32-VDS',
                                                   '33-YDS',
                                                   '38-DS',
                                                   '39-DS',
                                                   '45-DS',
                                                   '46-DS'
                                               )
                                               AND qd.hieuluctu IS NOT NULL
                                               AND db.id IS NULL
                                               AND d.toaanid = v_toaan_id
                                               AND NOT EXISTS (
                                                   SELECT
                                                       1
                                                   FROM
                                                       ald_sotham_khangcao bck
                                                   WHERE
                                                       bck.donid = d.id
                                                       AND bck.duongsuid = ndds.id
                                                       AND NOT EXISTS (
                                                           SELECT
                                                               1
                                                           FROM
                                                               ald_sotham_rutkckn cck
                                                           WHERE
                                                               cck.idkckn = bck.id
                                                               AND cck.iskckn = 1
                                                               AND cck.trangthai = 2
                                                       ) -- nếu rút kháng cáo thì đồng bộ
                                                       AND NOT EXISTS (
                                               --- Nếu có kháng nghị thì không đồng bộ 
                                                           SELECT
                                                               1
                                                           FROM
                                                               ald_sotham_khangnghi bnck
                                                           WHERE
                                                               bnck.donid = d.id
                                                               AND NOT EXISTS (
                                                                   SELECT
                                                                       1
                                                                   FROM
                                                                       ald_sotham_rutkckn cnck
                                                                   WHERE
                                                                       cnck.idkckn = bnck.id
                                                                       AND cnck.iskckn = 2
                                                                       AND cnck.trangthai = 2
                                                               )
                                                       )
                                               )
                                           UNION
-- TH4: lấy thông tin quyết định phúc thẩm thỏa mãn điều kiện đẩy đi
                                           SELECT
                                               db.id                  AS c06_id,
                                               d.id                   AS vuanid,
                                               ndds.id                AS duongsuid,
                                               '5' AS loaian_id,
                                               'Lao Động' AS loai_an_ten,
                                               '2' AS loaibaqd, -- bản án
                                               to_char(d.mavuviec) AS mavuan,
                                               d.tenvuviec            AS tenvuan,
                                               'PHUC_THAM' AS capxx_ma,
                                               'Phúc Thẩm' AS capxx,
                                               qd.soqd                AS sobananorqd,
                                               to_char(qd.ngayqd, 'dd/MM/yyyy') AS ngayrabanan,
                                               decode(qd.hieuluctu, NULL, NULL, to_char(qd.hieuluctu, 'dd/MM/yyyy')) AS ngayhieulucba
                                               ,
                                               d.toaanid              AS madonvirabanan,
                                               dm.ma_ten              AS tendonvirabanan,
                                               decode(tl.truonghopthuly, 998, 'Giám đốc thẩm hủy để xét xử lại phúc thẩm', 269, 'Do có kháng nghị phúc thẩm'
                                               ,
                                                      268, 'Do có kháng cáo và kháng nghị phúc thẩm', 'Do có kháng cáo phúc thẩm'
                                                      )
                                               || ' - số '
                                               || tl.sothuly
                                               || ' ngày '
                                               || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                               ndds.tenduongsu        AS hotenduongsu,
                                               ndds.so_cccd           AS sogiaytoduongsu,
                                               decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh
                                               , 'dd/MM/yyyy')) AS ngaysinhduongsu,
                                               ndh1.ma_ten            AS diachiduongsu,
                                               ndqtn.ma               AS maquoctichduongsu,
                                               ndqtn.ten              AS tenquoctichduongsu,
                                               ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                               ndds.tucachtotung_ma   AS matucachtotung,
                                               tctt.ten               AS tentucachtotung,
                                               to_char(qd.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                               dc.id                  AS thamphanid,
                                               dc.hoten               AS thamphan,
                                               'Chưa đồng bộ' AS trangthaibanghi,
                                               'CDB' AS loaibang,
                                               db.ghichu,
                                               db.taikhoangui,
                                               db.ngaygui,
                                               d.nguoitao
                                           FROM
                                               ald_don                  d
                                               LEFT JOIN ald_don_duongsu          ndds ON d.id = ndds.donid
                                               LEFT JOIN dm_dataitem              tctt ON tctt.ma = ndds.tucachtotung_ma
                                               INNER JOIN ald_phuctham_quyetdinh   qd ON qd.donid = d.id
                                               INNER JOIN dm_toaan                 dm ON dm.id = qd.toaanid
    -- nguyên đơn
                                               LEFT JOIN dm_hanhchinh             ndh1 ON ndh1.id = ndds.tamtruid
                                               LEFT JOIN dm_dataitem              ndqtn ON ndqtn.id = ndds.quoctichid
                                                                              AND ndqtn.groupid = 2
                                               LEFT JOIN c06_toaan_laodong        db ON db.vuanid = d.id
                                                                                 AND db.duongsuid = ndds.id
                                                                                 AND db.loaibaqd = 2
                                                                                 AND db.capxx = 'PHUC_THAM'
                                               LEFT JOIN ald_phuctham_thuly       tl ON tl.donid = d.id
                                               INNER JOIN ald_don_thamphan         tp ON tp.donid = d.id
                                                                                 AND tp.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                               LEFT JOIN dm_canbo                 dc ON dc.id = tp.canboid
                                               INNER JOIN dm_qd_quyetdinh          qdts ON qd.quyetdinhid = qdts.id
                                           WHERE
                                               qdts.ma IN (
                                                   '26-VDS',
                                                   '27-VDS',
                                                   '69-DS',
                                                   '70-DS',
                                                   '71-DS',
                                                   '72-DS'
                                               )
                                               AND qd.hieuluctu IS NOT NULL
                                               AND db.id IS NULL
                                               AND d.toaphucthamid = v_toaan_id
                                               AND EXISTS (
                                                   SELECT
                                                       1
                                                   FROM
                                                       ald_sotham_khangcao bck
                                                   WHERE
                                                       bck.donid = d.id
                                                       AND bck.duongsuid = ndds.id
                                                       AND NOT EXISTS (
                                                           SELECT
                                                               1
                                                           FROM
                                                               ald_sotham_rutkckn cck
                                                           WHERE
                                                               cck.idkckn = bck.id
                                                               AND cck.iskckn = 1
                                                               AND cck.trangthai = 2
                                                       ) -- nếu rút kháng cáo thì đồng bộ
                                                       AND NOT EXISTS (
                                               --- Nếu có kháng nghị thì không đồng bộ 
                                                           SELECT
                                                               1
                                                           FROM
                                                               ald_sotham_khangnghi bnck
                                                           WHERE
                                                               bnck.donid = d.id
                                                               AND NOT EXISTS (
                                                                   SELECT
                                                                       1
                                                                   FROM
                                                                       ald_sotham_rutkckn cnck
                                                                   WHERE
                                                                       cnck.idkckn = bnck.id
                                                                       AND cnck.iskckn = 2
                                                                       AND cnck.trangthai = 2
                                                               )
                                                       )
                                               )
                                       ) a
                                   WHERE
                                       a.xacthuc_dldcqg != '0'
                                       AND a.sobananorqd IS NOT NULL
                                       AND ( v_loaibaqd IS NULL
                                             OR a.loaibaqd = v_loaibaqd )
                                       AND ( v_loaian_id IS NULL
                                             OR a.loaian_id = v_loaian_id )
                                       AND ( v_capxx IS NULL
                                             OR ( v_capxx = 2
                                                  AND a.capxx_ma = 'SO_THAM' )
                                             OR ( v_capxx = 3
                                                  AND a.capxx_ma = 'PHUC_THAM' ) )
                                       AND ( v_ten_vu_an IS NULL
                                             OR fn_convert_to_vn(upper(a.tenvuan)) LIKE '%'
                                                                                        || fn_convert_to_vn(upper(v_ten_vu_an))
                                                                                        || '%' )
                                       AND ( v_ma_vu_an IS NULL
                                             OR a.mavuan = v_ma_vu_an )
                                       AND ( v_bi_can IS NULL --Đương sự
                                             OR fn_convert_to_vn(upper(a.hotenduongsu)) LIKE '%'
                                                                                             || fn_convert_to_vn(upper(v_bi_can))
                                                                                             || '%' )
                                       AND ( v_cccd IS NULL
                                             OR a.sogiaytoduongsu = v_cccd )
                                       AND ( v_so_qd IS NULL
                                             OR a.sobananorqd = v_so_qd )
                                       AND ( v_tungay IS NULL
                                             OR a.ngayrabanan >= v_tungay )
                                       AND ( v_denngay IS NULL
                                             OR a.ngayrabanan <= v_denngay )
                                       AND ( v_toidanh IS NULL
                                             OR ( fn_convert_to_vn(lower(a.tenvuan)) LIKE '%'
                                                                                          || fn_convert_to_vn(lower(v_toidanh))
                                                                                          || '%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                                       AND ( v_thuky_id IS NULL
                                             OR EXISTS (
                                           SELECT
                                               'X'
                                           FROM
                                               ald_sotham_hdxx tp
                                           WHERE
                                               tp.canboid = v_thuky_id
                                               AND tp.donid = a.vuanid
                                       )
                                             OR EXISTS (
                                           SELECT
                                               'X'
                                           FROM
                                               ald_phuctham_hdxx tp
                                           WHERE
                                               tp.canboid = v_thuky_id
                                               AND tp.donid = a.vuanid
                                       )
                                             OR EXISTS (
                                           SELECT
                                               'X'
                                           FROM
                                               ald_don_thamphan tp
                                           WHERE
                                               tp.thukyid = v_thuky_id
                                               AND tp.donid = a.vuanid
                                       ) )
                                       AND ( v_thamphan_id IS NULL
                                             OR ( a.capxx_ma = 'SO_THAM'
                                                  AND EXISTS (
                                           SELECT
                                               'x'
                                           FROM
                                               ald_sotham_hdxx tp
                                           WHERE
                                               tp.donid = a.vuanid
                                               AND tp.mavaitro = 'THAMPHAN'
                                               AND tp.canboid = v_thamphan_id
                                       ) )
                                             OR ( a.capxx_ma = 'PHUC_THAM'
                                                  AND EXISTS (
                                           SELECT
                                               'x'
                                           FROM
                                               ald_phuctham_hdxx tp
                                           WHERE
                                               tp.donid = a.vuanid
                                               AND tp.mavaitro = 'THAMPHAN'
                                               AND tp.canboid = v_thamphan_id
                                       ) ) )
                               ) tt
                           WHERE
                               tt.stt >= minindex
                               AND tt.stt <= maxindex;

    END;

    PROCEDURE c06_ald_search_dadongbo (
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
    ) AS
        totalitem   NUMBER;
        minindex    NUMBER;
        maxindex    NUMBER;
    BEGIN
---------------------------------------
        minindex := page_size * ( page_index - 1 ) + 1;
        maxindex := page_index * page_size;
        OPEN curreturn FOR SELECT
                               tt.*
                           FROM
                               (
                                   SELECT
                                       ROW_NUMBER() OVER(
                                           ORDER BY
                                               a.ngaytao DESC
                                       ) stt,
                                       COUNT(*) OVER() AS countall,
                                       a.*
                                   FROM
                                       (
                                           SELECT
                                               c.id      AS c06_id,
                                               d.id      AS vuanid,
                                               '5' AS loaian_id,
                                               'Lao Động' AS loai_an_ten,
                                               c.loaibaqd, -- bản án
                                               to_char(d.mavuviec) AS mavuan,
                                               c.tenvuan,
                                               c.thuly,
                                               CASE
                                                   WHEN c.capxx = 'SO_THAM' THEN
                                                       to_char(st.ngaytao, 'dd/MM/yyyy')
                                                   ELSE
                                                       to_char(pt.ngaytao, 'dd/MM/yyyy')
                                               END AS ngaytao,
                                               to_char(c.ngaygui, 'dd/MM/yyyy') AS ngaygui,
                                               to_char(c.ngaydongbo, 'dd/MM/yyyy') AS ngaydongbo,
                                               'Đã đồng bộ' AS trangthaibanghi,
                                               CASE
                                                   WHEN c.capxx = 'SO_THAM' THEN
                                                       'Sơ Thẩm'
                                                   ELSE
                                                       'Phúc Thẩm'
                                               END AS capxx,
                                               c.capxx   AS capxx_ma,
                                               c.sobananorqd,
                                               c.duongsuid,
                                               c.ngayrabanan,
                                               c.madonvirabanan,
                                               c.tendonvirabanan,
                                               c.bqd,
                                               c.anphi,
                                               c.ngayhieulucba,
                                               c.hotenduongsu,
                                               c.sogiaytoduongsu,
                                               c.ngaysinhduongsu,
                                               c.maquoctichduongsu,
                                               c.tenquoctichduongsu,
                                               c.mathanhphotinhduongsu,
                                               c.tenthanhphotinhduongsu,
                                               c.maquanhuyenduongsu,
                                               c.tenquanhuyenduongsu,
                                               c.maphuongxaduongsu,
                                               c.tenphuongxaduongsu,
                                               c.diachiduongsu,
                                               ndds.xacthuc_dldcqg,
                                               CASE
                                                   WHEN c.capxx = 'SO_THAM' THEN
                                                       dcst.hoten
                                                   ELSE
                                                       dcpt.hoten
                                               END AS thamphan,
                                               c.matucachtotung,
                                               c.tentucachtotung,
                                               c.ghichu,
                                               'DDB' AS loaibang,
                                               c.taikhoangui,
                                               d.nguoitao,
                                               c.trangthaijobshare,
                                               CASE
                                                   WHEN c.capxx = 'SO_THAM' THEN
                                                       d.toaanid
                                                   ELSE
                                                       d.toaphucthamid
                                               END AS toaan
                                           FROM
                                               c06_toaan_laodong    c
                                               LEFT JOIN ald_don              d ON c.vuanid = d.id
                                               LEFT JOIN ald_don_duongsu      ndds ON ndds.id = c.duongsuid
                                               LEFT JOIN ald_sotham_banan     st ON st.donid = d.id
                                               LEFT JOIN ald_phuctham_banan   pt ON pt.donid = d.id
                                               LEFT JOIN dm_toaan             dm ON dm.id = d.toaanid
                                               LEFT JOIN ald_don_thamphan     tpst ON tpst.donid = d.id
                                                                                  AND tpst.mavaitro = 'VTTP_GIAIQUYETSOTHAM'
                                               LEFT JOIN dm_canbo             dcst ON dcst.id = tpst.canboid
                                               LEFT JOIN ald_don_thamphan     tppt ON tppt.donid = d.id
                                                                                  AND tppt.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                               LEFT JOIN dm_canbo             dcpt ON dcpt.id = tppt.canboid
                                           WHERE
                                               c.trangthaiald = 'HIEU_LUC'
                                               and c.status = '1'
                                       ) a
                                   WHERE
                                       a.toaan = v_toaan_id
                                       AND ( v_loaibaqd IS NULL
                                             OR a.loaibaqd = v_loaibaqd )
                                       AND ( v_loaian_id IS NULL
                                             OR a.loaian_id = v_loaian_id )
                                       AND ( v_capxx IS NULL
                                             OR ( v_capxx = 2
                                                  AND a.capxx = 'Sơ Thẩm' )
                                             OR ( v_capxx = 3
                                                  AND a.capxx = 'Phúc Thẩm' ) )
                                       AND ( v_ten_vu_an IS NULL
                                             OR fn_convert_to_vn(upper(a.tenvuan)) LIKE '%'
                                                                                        || fn_convert_to_vn(upper(v_ten_vu_an))
                                                                                        || '%' )
                                       AND ( v_ma_vu_an IS NULL
                                             OR a.mavuan = v_ma_vu_an )
                                       AND ( v_bi_can IS NULL --Đương sự
                                             OR fn_convert_to_vn(upper(a.hotenduongsu)) LIKE '%'
                                                                                             || fn_convert_to_vn(upper(v_bi_can))
                                                                                             || '%' )
                                       AND ( v_cccd IS NULL
                                             OR a.sogiaytoduongsu = v_cccd )
                                       AND ( v_so_qd IS NULL
                                             OR a.sobananorqd = v_so_qd )
                                       AND ( v_tungay IS NULL
                                             OR a.ngayrabanan >= v_tungay )
                                       AND ( v_denngay IS NULL
                                             OR a.ngayrabanan <= v_denngay )
                                       AND ( v_toidanh IS NULL
                                             OR ( fn_convert_to_vn(lower(a.tenvuan)) LIKE '%'
                                                                                          || fn_convert_to_vn(lower(v_toidanh))
                                                                                          || '%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                                       AND ( v_thuky_id IS NULL
                                             OR EXISTS (
                                           SELECT
                                               'X'
                                           FROM
                                               ald_sotham_hdxx tp
                                           WHERE
                                               tp.canboid = v_thuky_id
                                               AND tp.donid = a.vuanid
                                       )
                                             OR EXISTS (
                                           SELECT
                                               'X'
                                           FROM
                                               ald_phuctham_hdxx tp
                                           WHERE
                                               tp.canboid = v_thuky_id
                                               AND tp.donid = a.vuanid
                                       )
                                             OR EXISTS (
                                           SELECT
                                               'X'
                                           FROM
                                               ald_don_thamphan tp
                                           WHERE
                                               tp.thukyid = v_thuky_id
                                               AND tp.donid = a.vuanid
                                       ) )
                                       AND ( v_thamphan_id IS NULL
                                             OR ( a.capxx = 'Sơ Thẩm'
                                                  AND EXISTS (
                                           SELECT
                                               'x'
                                           FROM
                                               ald_sotham_hdxx tp
                                           WHERE
                                               tp.donid = a.vuanid
                                               AND tp.mavaitro = 'THAMPHAN'
                                               AND tp.canboid = v_thamphan_id
                                       ) )
                                             OR ( a.capxx = 'Phúc Thẩm'
                                                  AND EXISTS (
                                           SELECT
                                               'x'
                                           FROM
                                               ald_phuctham_hdxx tp
                                           WHERE
                                               tp.donid = a.vuanid
                                               AND tp.mavaitro = 'THAMPHAN'
                                               AND tp.canboid = v_thamphan_id
                                       ) ) )
                               ) tt
                           WHERE
                               tt.stt >= minindex
                               AND tt.stt <= maxindex;

    END;

    PROCEDURE c06_ald_search_thuhoi (
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
    ) AS
        totalitem   NUMBER;
        minindex    NUMBER;
        maxindex    NUMBER;
    BEGIN
---------------------------------------
        minindex := page_size * ( page_index - 1 ) + 1;
        maxindex := page_index * page_size;
        OPEN curreturn FOR SELECT
                               tt.*
                           FROM
                               (
                                   SELECT
                                       ROW_NUMBER() OVER(
                                           ORDER BY
                                               a.ngaytao DESC
                                       ) stt,
                                       COUNT(*) OVER() AS countall,
                                       a.*
                                   FROM
                                       (
                                           SELECT
                                               c.id      AS c06_id,
                                               d.id      AS vuanid,
                                               '5' AS loaian_id,
                                               'Lao Động' AS loai_an_ten,
                                               c.loaibaqd, -- bản án
                                               to_char(d.mavuviec) AS mavuan,
                                               c.tenvuan,
                                               c.thuly,
                                               CASE
                                                   WHEN c.capxx = 'SO_THAM' THEN
                                                       to_char(st.ngaytao, 'dd/MM/yyyy')
                                                   ELSE
                                                       to_char(pt.ngaytao, 'dd/MM/yyyy')
                                               END AS ngaytao,
                                               to_char(c.ngaygui, 'dd/MM/yyyy') AS ngaygui,
                                               to_char(c.ngaydongbo, 'dd/MM/yyyy') AS ngaydongbo,
                                               'Thu Hồi' AS trangthaibanghi,
                                               CASE
                                                   WHEN c.capxx = 'SO_THAM' THEN
                                                       'Sơ Thẩm'
                                                   ELSE
                                                       'Phúc Thẩm'
                                               END AS capxx,
                                               c.capxx   AS capxx_ma,
                                               c.sobananorqd,
                                               c.duongsuid,
                                               c.ngayrabanan,
                                               c.trangthaiald,
                                               c.madonvirabanan,
                                               c.tendonvirabanan,
                                               c.bqd,
                                               c.anphi,
                                               c.ngayhieulucba,
                                               c.hotenduongsu,
                                               c.sogiaytoduongsu,
                                               c.ngaysinhduongsu,
                                               c.maquoctichduongsu,
                                               c.tenquoctichduongsu,
                                               c.mathanhphotinhduongsu,
                                               c.tenthanhphotinhduongsu,
                                               c.maquanhuyenduongsu,
                                               c.tenquanhuyenduongsu,
                                               c.maphuongxaduongsu,
                                               c.tenphuongxaduongsu,
                                               c.diachiduongsu,
                                               ndds.xacthuc_dldcqg,
                                               CASE
                                                   WHEN c.capxx = 'SO_THAM' THEN
                                                       dcst.hoten
                                                   ELSE
                                                       dcpt.hoten
                                               END AS thamphan,
                                               c.matucachtotung,
                                               c.tentucachtotung,
                                               c.ghichu,
                                               'TH' AS loaibang,
                                               c.taikhoangui,
                                               d.nguoitao,
                                               c.trangthaijobshare
                                           FROM
                                               c06_toaan_laodong    c
                                               LEFT JOIN ald_don              d ON c.vuanid = d.id
                                               LEFT JOIN ald_don_duongsu      ndds ON ndds.id = c.duongsuid
                                               LEFT JOIN ald_sotham_banan     st ON st.donid = d.id
                                               LEFT JOIN ald_phuctham_banan   pt ON pt.donid = d.id
                                               LEFT JOIN dm_toaan             dm ON dm.id = d.toaanid
                                               LEFT JOIN ald_don_thamphan     tpst ON tpst.donid = d.id
                                                                                  AND tpst.mavaitro = 'VTTP_GIAIQUYETSOTHAM'
                                               LEFT JOIN dm_canbo             dcst ON dcst.id = tpst.canboid
                                               LEFT JOIN ald_don_thamphan     tppt ON tppt.donid = d.id
                                                                                  AND tppt.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                               LEFT JOIN dm_canbo             dcpt ON dcpt.id = tppt.canboid
                                           WHERE
                                               c.trangthaiald = 'THU_HOI'
                                               AND c.status = '1'
                                               and ((v_capxx = 2 and d.toaanid = v_toaan_id) or (v_capxx = 3 and d.TOAPHUCTHAMID = v_toaan_id))
                                       ) a
                                   WHERE
                                       ( v_loaibaqd IS NULL
                                         OR a.loaibaqd = v_loaibaqd )
                                       AND ( v_loaian_id IS NULL
                                             OR a.loaian_id = v_loaian_id )
                                       AND ( v_capxx IS NULL
                                             OR ( v_capxx = 2
                                                  AND a.capxx = 'Sơ Thẩm' )
                                             OR ( v_capxx = 3
                                                  AND a.capxx = 'Phúc Thẩm' ) )
                                       AND ( v_ten_vu_an IS NULL
                                             OR fn_convert_to_vn(upper(a.tenvuan)) LIKE '%'
                                                                                        || fn_convert_to_vn(upper(v_ten_vu_an))
                                                                                        || '%' )
                                       AND ( v_ma_vu_an IS NULL
                                             OR a.mavuan = v_ma_vu_an )
                                       AND ( v_bi_can IS NULL --Đương sự
                                             OR fn_convert_to_vn(upper(a.hotenduongsu)) LIKE '%'
                                                                                             || fn_convert_to_vn(upper(v_bi_can))
                                                                                             || '%' )
                                       AND ( v_cccd IS NULL
                                             OR a.sogiaytoduongsu = v_cccd )
                                       AND ( v_so_qd IS NULL
                                             OR a.sobananorqd = v_so_qd )
                                       AND ( v_tungay IS NULL
                                             OR a.ngayrabanan >= v_tungay )
                                       AND ( v_denngay IS NULL
                                             OR a.ngayrabanan <= v_denngay )
                                       AND ( v_toidanh IS NULL
                                             OR ( fn_convert_to_vn(lower(a.tenvuan)) LIKE '%'
                                                                                          || fn_convert_to_vn(lower(v_toidanh))
                                                                                          || '%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                                       AND ( v_thuky_id IS NULL
                                             OR EXISTS (
                                           SELECT
                                               'X'
                                           FROM
                                               ald_sotham_hdxx tp
                                           WHERE
                                               tp.canboid = v_thuky_id
                                               AND tp.donid = a.vuanid
                                       )
                                             OR EXISTS (
                                           SELECT
                                               'X'
                                           FROM
                                               ald_phuctham_hdxx tp
                                           WHERE
                                               tp.canboid = v_thuky_id
                                               AND tp.donid = a.vuanid
                                       )
                                             OR EXISTS (
                                           SELECT
                                               'X'
                                           FROM
                                               ald_don_thamphan tp
                                           WHERE
                                               tp.thukyid = v_thuky_id
                                               AND tp.donid = a.vuanid
                                       ) )
                                       AND ( v_thamphan_id IS NULL
                                             OR ( a.capxx = 'Sơ Thẩm'
                                                  AND EXISTS (
                                           SELECT
                                               'x'
                                           FROM
                                               ald_sotham_hdxx tp
                                           WHERE
                                               tp.donid = a.vuanid
                                               AND tp.mavaitro = 'THAMPHAN'
                                               AND tp.canboid = v_thamphan_id
                                       ) )
                                             OR ( a.capxx = 'Phúc Thẩm'
                                                  AND EXISTS (
                                           SELECT
                                               'x'
                                           FROM
                                               ald_phuctham_hdxx tp
                                           WHERE
                                               tp.donid = a.vuanid
                                               AND tp.mavaitro = 'THAMPHAN'
                                               AND tp.canboid = v_thamphan_id
                                       ) ) )
                               ) tt
                           WHERE
                               tt.stt >= minindex
                               AND tt.stt <= maxindex;

    END;

    PROCEDURE c06_ald_search_by_id (
        v_id        IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               ROW_NUMBER() OVER(
                                   ORDER BY
                                       a.ngaygui DESC
                               ) stt,
                               COUNT(*) OVER() AS countall,
                               a.*
                           FROM
                               (
                                   SELECT
                                       c.id      AS c06_id,
                                       d.id      AS vuanid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       c.loaibaqd, -- bản án
                                       to_char(d.mavuviec) AS mavuan,
                                       c.tenvuan,
                                       c.thuly,
                                       CASE
                                           WHEN c.capxx = 'SO_THAM' THEN
                                               to_char(st.ngaytao, 'dd/MM/yyyy')
                                           ELSE
                                               to_char(pt.ngaytao, 'dd/MM/yyyy')
                                       END AS ngaytao,
                                       to_char(c.ngaygui, 'dd/MM/yyyy') AS ngaygui,
                                       to_char(c.ngaydongbo, 'dd/MM/yyyy') AS ngaydongbo,
                                       'Đã đồng bộ' AS trangthaibanghi,
                                       CASE
                                           WHEN c.capxx = 'SO_THAM' THEN
                                               'Sơ Thẩm'
                                           ELSE
                                               'Phúc Thẩm'
                                       END AS capxx,
                                       c.capxx   AS capxx_ma,
                                       c.sobananorqd,
                                       c.ngayrabanan,
                                       c.duongsuid,
                                       c.trangthaiald,
                                       c.madonvirabanan,
                                       c.tendonvirabanan,
                                       c.bqd,
                                       c.anphi,
                                       c.ngayhieulucba,
                                       c.hotenduongsu,
                                       c.sogiaytoduongsu,
                                       c.ngaysinhduongsu,
                                       c.maquoctichduongsu,
                                       c.tenquoctichduongsu,
                                       c.mathanhphotinhduongsu,
                                       c.tenthanhphotinhduongsu,
                                       c.maquanhuyenduongsu,
                                       c.tenquanhuyenduongsu,
                                       c.maphuongxaduongsu,
                                       c.tenphuongxaduongsu,
                                       c.diachiduongsu,
                                       c.taikhoangui,
                                       ndds.xacthuc_dldcqg,
                                       c.matucachtotung,
                                       c.tentucachtotung,
                                       c.ghichu,
                                       'DDB' AS loaibang,
                                       d.nguoitao,
                                       c.trangthaijobshare,
                                       c.maquanhephapluat,
                                       c.tenquanhephapluat
                                   FROM
                                       c06_toaan_laodong    c
                                       LEFT JOIN ald_don              d ON c.vuanid = d.id
                                       LEFT JOIN ald_don_duongsu      ndds ON ndds.id = c.duongsuid
                                       LEFT JOIN ald_sotham_banan     st ON st.donid = d.id
                                       LEFT JOIN ald_phuctham_banan   pt ON pt.donid = d.id
                                       LEFT JOIN ald_don_thamphan     tpst ON tpst.donid = d.id
                                                                          AND tpst.mavaitro = 'VTTP_GIAIQUYETSOTHAM'
                                       LEFT JOIN dm_canbo             dcst ON dcst.id = tpst.canboid
                                       LEFT JOIN ald_don_thamphan     tppt ON tppt.donid = d.id
                                                                          AND tppt.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                       LEFT JOIN dm_canbo             dcpt ON dcpt.id = tppt.canboid
                                   WHERE
                                       c.id = v_id
                               ) a;

    END;

    PROCEDURE c06_ald_duongsu_getbyid (
        v_duongsuid   IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        curreturn     OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               ROW_NUMBER() OVER(
                                   ORDER BY
                                       a.ngaytao DESC
                               ) stt,
                               COUNT(*) OVER() AS countall,
                               a.*
                           FROM
                               (
                                   SELECT
                                       c.id   AS c06_id,
                                       d.id   AS vuanid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       c.loaibaqd, -- bản án
                                       to_char(d.mavuviec) AS mavuan,
                                       c.tenvuan,
                                       c.thuly,
                                       to_char(st.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                       to_char(c.ngaygui, 'dd/MM/yyyy') AS ngaygui,
                                       to_char(c.ngaydongbo, 'dd/MM/yyyy') AS ngaydongbo,
                                       'Đã đồng bộ' AS trangthaibanghi,
                                       CASE
                                           WHEN c.capxx = 'SO_THAM' THEN
                                               'Sơ Thẩm'
                                           ELSE
                                               'Phúc Thẩm'
                                       END AS capxx,
                                       c.sobananorqd,
                                       c.ngayrabanan,
                                       c.madonvirabanan,
                                       c.tendonvirabanan,
                                       c.bqd,
                                       c.anphi,
                                       c.ngayhieulucba,
                                       c.hotenduongsu,
                                       c.sogiaytoduongsu,
                                       c.ngaysinhduongsu,
                                       c.maquoctichduongsu,
                                       c.tenquoctichduongsu,
                                       c.mathanhphotinhduongsu,
                                       c.tenthanhphotinhduongsu,
                                       c.maquanhuyenduongsu,
                                       c.tenquanhuyenduongsu,
                                       c.maphuongxaduongsu,
                                       c.tenphuongxaduongsu,
                                       c.diachiduongsu,
                                       ndds.xacthuc_dldcqg
                                   FROM
                                       c06_toaan_laodong    c
                                       LEFT JOIN ald_don              d ON c.vuanid = d.id
                                       LEFT JOIN ald_don_duongsu      ndds ON d.id = ndds.donid
                                       LEFT JOIN ald_sotham_banan     st ON st.donid = d.id
                                       LEFT JOIN ald_phuctham_banan   pt ON pt.donid = d.id
                                   WHERE
                                       c.duongsuid = v_duongsuid
                                       AND c.loaibaqd = v_loaiba_qd
                                       AND c.capxx = v_capxx
                               ) a;

    END;

    PROCEDURE c06_ald_duongsu_cdb_getby (
        v_duongsuid     IN    NUMBER,
        v_capxx         IN    VARCHAR2,
        v_sobananorqd   IN    VARCHAR2,
        v_loaiba_qd     IN    VARCHAR2,
        curreturn       OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               ROW_NUMBER() OVER(
                                   ORDER BY
                                       a.ngaytao DESC
                               ) stt,
                               COUNT(*) OVER() AS countall,
                               a.*
                           FROM
                               (
                                            --TH1: Bản án so tham hieu luc 
                                   SELECT
                                       db.id                  AS c06_id,
                                       d.id                   AS vuanid,
                                       ndds.id                AS duongsuid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       '1' AS loaibaqd, -- bản án
                                       to_char(d.mavuviec) AS mavuan,
                                       d.tenvuviec            AS tenvuan,
                                       'SO_THAM' AS capxx_ma,
                                       'Sơ Thẩm' AS capxx,
                                       st.sobanan             AS sobananorqd,
                                       to_char(st.ngaytuyenan, 'dd/MM/yyyy') AS ngayrabanan,
                                       to_char(st.ngayhieuluc, 'dd/MM/yyyy') AS ngayhieulucba,
                                       d.toaanid              AS madonvirabanan,
                                       dm.ma_ten              AS tendonvirabanan,
                                       decode(tl.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy'
                                       ,
                                              'Thụ lý mới')
                                       || ' - số '
                                       || tl.sothuly
                                       || ' ngày '
                                       || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                       ndds.tenduongsu        AS hotenduongsu,
                                       ndds.so_cccd           AS sogiaytoduongsu,
                                       decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh, 'dd/MM/yyyy'
                                       )) AS ngaysinhduongsu,
                                       ndqtn.ma               AS maquoctichduongsu,
                                       ndqtn.ten              AS tenquoctichduongsu,
                                       ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                       ndds.tucachtotung_ma   AS matucachtotung,
                                       tctt.ten               AS tentucachtotung,
                                       to_char(st.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                       dc.id                  AS thamphanid,
                                       dc.hoten               AS thamphan,
                                       'Chưa đồng bộ' AS trangthaibanghi,
                                       'CDB' AS loaibang,
                                       db.ghichu,
                                       db.taikhoangui,
                                       db.ngaygui,
                                       d.nguoitao,
                                       to_char(dht.ma) mathanhphotinhduongsu,
                                       dht.ten                tenthanhphotinhduongsu,
                                       to_char(xht.ma) maquanhuyenduongsu,
                                       xht.ten                tenquanhuyenduongsu,
                                       to_char(xht.ma) maphuongxaduongsu,
                                       xht.ten                tenphuongxaduongsu,
                                       ndds.tamtruchitiet     diachiduongsu,
                                       qhpl.id                AS maquanhephapluat,
                                       qhpl.case_name         AS tenquanhephapluat
                                   FROM
                                       ald_don              d
                                       LEFT JOIN ald_don_duongsu      ndds ON d.id = ndds.donid
                                       LEFT JOIN dm_dataitem          tctt ON tctt.ma = ndds.tucachtotung_ma
                                       INNER JOIN ald_sotham_banan     st ON st.donid = d.id
                                       INNER JOIN dm_toaan             dm ON dm.id = d.toaanid
                                       LEFT JOIN dm_dataitem          ndqtn ON ndqtn.id = ndds.quoctichid
                                                                      AND ndqtn.groupid = 2
                                       LEFT JOIN ald_sotham_thuly     tl ON tl.donid = d.id
                                       INNER JOIN ald_don_thamphan     tp ON tp.donid = d.id
                                                                         AND tp.mavaitro = 'VTTP_GIAIQUYETSOTHAM'
                                       LEFT JOIN dm_canbo             dc ON dc.id = tp.canboid
                                       INNER JOIN dm_hanhchinh         dht ON dht.id = ndds.tamtrutinhid
                                       INNER JOIN dm_hanhchinh         xht ON xht.id = ndds.tamtruid
                                       INNER JOIN dm_qhpl_tk           qhpl ON qhpl.id = d.qhpltkid
                                       LEFT JOIN c06_toaan_laodong    db ON db.vuanid = d.id
                                                                         AND db.duongsuid = ndds.id
                                                                         AND db.loaibaqd = 1
                                                                         AND db.capxx = 'SO_THAM'
                                   WHERE
                                       st.ngayhieuluc IS NOT NULL
                                       AND db.id IS NULL
                                   UNION    
                                            -- TH2: lấy thông tin bản án Phúc Thẩm thỏa mãn điều kiện đẩy đi
                                   SELECT
                                       db.id                  AS c06_id,
                                       d.id                   AS vuanid,
                                       ndds.id                AS duongsuid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       '1' AS loaibaqd, -- bản án
                                       to_char(d.mavuviec) AS mavuan,
                                       d.tenvuviec            AS tenvuan,
                                       'PHUC_THAM' AS capxx_ma,
                                       'Phúc Thẩm' AS capxx,
                                       st.sobanan             AS sobananorqd,
                                       to_char(st.ngaytuyenan, 'dd/MM/yyyy') AS ngayrabanan,
                                       to_char(st.ngayhieuluc, 'dd/MM/yyyy') AS ngayhieuluc,
                                       d.toaanid              AS madonvirabanan,
                                       dm.ma_ten              AS tendonvirabanan,
                                       decode(tl.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy'
                                       ,
                                              'Thụ lý mới')
                                       || ' - số '
                                       || tl.sothuly
                                       || ' ngày '
                                       || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                       ndds.tenduongsu        AS hotenduongsu,
                                       ndds.so_cccd           AS sogiaytoduongsu,
                                       decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh, 'dd/MM/yyyy'
                                       )) AS ngaysinhduongsu,
                                       ndqtn.ma               AS maquoctichduongsu,
                                       ndqtn.ten              AS tenquoctichduongsu,
                                       ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                       ndds.tucachtotung_ma   AS matucachtotung,
                                       tctt.ten               AS tentucachtotung,
                                       to_char(st.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                       dc.id                  AS thamphanid,
                                       dc.hoten               AS thamphan,
                                       'Chưa đồng bộ' AS trangthaibanghi,
                                       'CDB' AS loaibang,
                                       db.ghichu,
                                       db.taikhoangui,
                                       db.ngaygui,
                                       d.nguoitao,
                                       to_char(dht.ma) mathanhphotinhduongsu,
                                       dht.ten                tenthanhphotinhduongsu,
                                       to_char(xht.ma) maquanhuyenduongsu,
                                       xht.ten                tenquanhuyenduongsu,
                                       to_char(xht.ma) maphuongxaduongsu,
                                       xht.ten                tenphuongxaduongsu,
                                       ndds.tamtruchitiet     diachiduongsu,
                                       qhpl.id                AS maquanhephapluat,
                                       qhpl.case_name         AS tenquanhephapluat
                                   FROM
                                       ald_don              d
                                       LEFT JOIN ald_don_duongsu      ndds ON d.id = ndds.donid
                                       LEFT JOIN dm_dataitem          tctt ON tctt.ma = ndds.tucachtotung_ma
                                       INNER JOIN ald_phuctham_banan   st ON st.donid = d.id
                                       INNER JOIN dm_toaan             dm ON dm.id = st.toaanid
                                       LEFT JOIN dm_dataitem          ndqtn ON ndqtn.id = ndds.quoctichid
                                                                      AND ndqtn.groupid = 2
                                       LEFT JOIN dm_hanhchinh         dht ON dht.id = ndds.tamtrutinhid
                                       LEFT JOIN dm_hanhchinh         xht ON xht.id = ndds.tamtruid
                                       LEFT JOIN c06_toaan_laodong    db ON db.vuanid = d.id
                                                                         AND db.duongsuid = ndds.id
                                                                         AND db.loaibaqd = 1
                                                                         AND db.capxx = 'PHUC_THAM'
                                       LEFT JOIN ald_phuctham_thuly   tl ON tl.donid = d.id
                                       INNER JOIN ald_don_thamphan     tp ON tp.donid = d.id
                                                                         AND tp.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                       LEFT JOIN dm_canbo             dc ON dc.id = tp.canboid
                                       INNER JOIN dm_qhpl_tk           qhpl ON qhpl.id = d.qhpltkid
                                   WHERE
                                       st.ngayhieuluc IS NOT NULL
                                       AND db.id IS NULL
                                   UNION    
                                            -- TH3: lấy thông tin quyết định sơ thẩm thỏa mãn điều kiện đẩy đi
                                   SELECT
                                       db.id                  AS c06_id,
                                       d.id                   AS vuanid,
                                       ndds.id                AS duongsuid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       '2' AS loaibaqd, -- bản án
                                       to_char(d.mavuviec) AS mavuan,
                                       d.tenvuviec            AS tenvuan,
                                       'SO_THAM' AS capxx_ma,
                                       'Sơ Thẩm' AS capxx,
                                       qd.soqd                AS sobananorqd,
                                       to_char(qd.ngayqd, 'dd/MM/yyyy') AS ngayrabanan,
                                       decode(qd.hieuluctu, NULL, NULL, to_char(qd.hieuluctu, 'dd/MM/yyyy')) AS ngayhieulucba,
                                       d.toaanid              AS madonvirabanan,
                                       dm.ma_ten              AS tendonvirabanan,
                                       decode(tl.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy'
                                       ,
                                              'Thụ lý mới')
                                       || ' - số '
                                       || tl.sothuly
                                       || ' ngày '
                                       || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                       ndds.tenduongsu        AS hotenduongsu,
                                       ndds.so_cccd           AS sogiaytoduongsu,
                                       decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh, 'dd/MM/yyyy'
                                       )) AS ngaysinhduongsu,
                                       ndqtn.ma               AS maquoctichduongsu,
                                       ndqtn.ten              AS tenquoctichduongsu,
                                       ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                       ndds.tucachtotung_ma   AS matucachtotung,
                                       tctt.ten               AS tentucachtotung,
                                       to_char(qd.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                       dc.id                  AS thamphanid,
                                       dc.hoten               AS thamphan,
                                       'Chưa đồng bộ' AS trangthaibanghi,
                                       'CDB' AS loaibang,
                                       db.ghichu,
                                       db.taikhoangui,
                                       db.ngaygui,
                                       d.nguoitao,
                                       to_char(dht.ma) mathanhphotinhduongsu,
                                       dht.ten                tenthanhphotinhduongsu,
                                       to_char(xht.ma) maquanhuyenduongsu,
                                       xht.ten                tenquanhuyenduongsu,
                                       to_char(xht.ma) maphuongxaduongsu,
                                       xht.ten                tenphuongxaduongsu,
                                       ndds.tamtruchitiet     diachiduongsu,
                                       qhpl.id                AS maquanhephapluat,
                                       qhpl.case_name         AS tenquanhephapluat
                                   FROM
                                       ald_don                d
                                       LEFT JOIN ald_don_duongsu        ndds ON d.id = ndds.donid
                                       LEFT JOIN dm_dataitem            tctt ON tctt.ma = ndds.tucachtotung_ma
                                       LEFT JOIN dm_dataitem            ndqtn ON ndqtn.id = ndds.quoctichid
                                                                      AND ndqtn.groupid = 2
                                       LEFT JOIN c06_toaan_laodong      db ON db.vuanid = d.id
                                                                         AND db.duongsuid = ndds.id
                                                                         AND db.loaibaqd = 2
                                                                         AND db.capxx = 'SO_THAM'
                                       LEFT JOIN ald_sotham_thuly     tl ON tl.donid = d.id
                                       INNER JOIN ald_sotham_quyetdinh   qd ON qd.donid = d.id
                                       INNER JOIN dm_toaan               dm ON dm.id = qd.toaanid
                                       INNER JOIN ald_don_thamphan       tp ON tp.donid = d.id
                                                                         AND tp.mavaitro = 'VTTP_GIAIQUYETSOTHAM'
                                       LEFT JOIN dm_canbo               dc ON dc.id = tp.canboid
                                       LEFT JOIN dm_hanhchinh           dht ON dht.id = ndds.tamtrutinhid
                                       LEFT JOIN dm_hanhchinh           xht ON xht.id = ndds.tamtruid
                                       INNER JOIN dm_qhpl_tk             qhpl ON qhpl.id = d.qhpltkid
                                   WHERE
                                       qd.hieuluctu IS NOT NULL
                                       AND db.id IS NULL
                                   UNION
-- TH4: lấy thông tin quyết định phúc thẩm thỏa mãn điều kiện đẩy đi
                                   SELECT
                                       db.id                  AS c06_id,
                                       d.id                   AS vuanid,
                                       ndds.id                AS duongsuid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       '2' AS loaibaqd, -- bản án
                                       to_char(d.mavuviec) AS mavuan,
                                       d.tenvuviec            AS tenvuan,
                                       'PHUC_THAM' AS capxx_ma,
                                       'Phúc Thẩm' AS capxx,
                                       qd.soqd                AS sobananorqd,
                                       to_char(qd.ngayqd, 'dd/MM/yyyy') AS ngayrabanan,
                                       decode(qd.hieuluctu, NULL, NULL, to_char(qd.hieuluctu, 'dd/MM/yyyy')) AS ngayhieulucba,
                                       d.toaanid              AS madonvirabanan,
                                       dm.ma_ten              AS tendonvirabanan,
                                       decode(tl.truonghopthuly, 998, 'Giám đốc thẩm hủy để xét xử lại phúc thẩm', 269, 'Do có kháng nghị phúc thẩm'
                                       ,
                                              268, 'Do có kháng cáo và kháng nghị phúc thẩm', 'Do có kháng cáo phúc thẩm')
                                       || ' - số '
                                       || tl.sothuly
                                       || ' ngày '
                                       || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                       ndds.tenduongsu        AS hotenduongsu,
                                       ndds.so_cccd           AS sogiaytoduongsu,
                                       decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh, 'dd/MM/yyyy'
                                       )) AS ngaysinhduongsu,
                                       ndqtn.ma               AS maquoctichduongsu,
                                       ndqtn.ten              AS tenquoctichduongsu,
                                       ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                       ndds.tucachtotung_ma   AS matucachtotung,
                                       tctt.ten               AS tentucachtotung,
                                       to_char(qd.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                       dc.id                  AS thamphanid,
                                       dc.hoten               AS thamphan,
                                       'Chưa đồng bộ' AS trangthaibanghi,
                                       'CDB' AS loaibang,
                                       db.ghichu,
                                       db.taikhoangui,
                                       db.ngaygui,
                                       d.nguoitao,
                                       to_char(dht.ma) mathanhphotinhduongsu,
                                       dht.ten                tenthanhphotinhduongsu,
                                       to_char(xht.ma) maquanhuyenduongsu,
                                       xht.ten                tenquanhuyenduongsu,
                                       to_char(xht.ma) maphuongxaduongsu,
                                       xht.ten                tenphuongxaduongsu,
                                       ndds.tamtruchitiet     diachiduongsu,
                                       qhpl.id                AS maquanhephapluat,
                                       qhpl.case_name         AS tenquanhephapluat
                                   FROM
                                       ald_don                  d
                                       LEFT JOIN ald_don_duongsu          ndds ON d.id = ndds.donid
                                       LEFT JOIN dm_dataitem              tctt ON tctt.ma = ndds.tucachtotung_ma
                                       LEFT JOIN dm_dataitem              ndqtn ON ndqtn.id = ndds.quoctichid
                                                                      AND ndqtn.groupid = 2
                                       LEFT JOIN c06_toaan_laodong        db ON db.vuanid = d.id
                                                                         AND db.duongsuid = ndds.id
                                                                         AND db.loaibaqd = 2
                                                                         AND db.capxx = 'PHUC_THAM'
                                       LEFT JOIN ald_phuctham_thuly       tl ON tl.donid = d.id
                                       INNER JOIN ald_phuctham_quyetdinh   qd ON qd.donid = d.id
                                       INNER JOIN dm_toaan                 dm ON dm.id = qd.toaanid
                                       INNER JOIN ald_don_thamphan         tp ON tp.donid = d.id
                                                                         AND tp.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                       LEFT JOIN dm_canbo                 dc ON dc.id = tp.canboid
                                       LEFT JOIN dm_hanhchinh             dht ON dht.id = ndds.tamtrutinhid
                                       LEFT JOIN dm_hanhchinh             xht ON xht.id = ndds.tamtruid
                                       INNER JOIN dm_qhpl_tk               qhpl ON qhpl.id = d.qhpltkid
                                   WHERE
                                       qd.hieuluctu IS NOT NULL
                                       AND db.id IS NULL
                               ) a
                           WHERE
                               a.duongsuid = v_duongsuid
                               AND a.capxx_ma = v_capxx
                               AND a.loaibaqd = v_loaiba_qd
                               AND a.sobananorqd = v_sobananorqd;

    END;

    PROCEDURE c06_ald_duongsu_guilai (
        v_id     IN    NUMBER,
        curreturn       OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               ROW_NUMBER() OVER(
                                   ORDER BY
                                       a.ngaytao DESC
                               ) stt,
                               COUNT(*) OVER() AS countall,
                               a.*
                           FROM
                               (
                                            --TH1: Bản án so tham hieu luc 
                                   SELECT
                                       db.id                  AS c06_id,
                                       d.id                   AS vuanid,
                                       ndds.id                AS duongsuid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       '1' AS loaibaqd, -- bản án
                                       to_char(d.mavuviec) AS mavuan,
                                       d.tenvuviec            AS tenvuan,
                                       'SO_THAM' AS capxx_ma,
                                       'Sơ Thẩm' AS capxx,
                                       st.sobanan             AS sobananorqd,
                                       to_char(st.ngaytuyenan, 'dd/MM/yyyy') AS ngayrabanan,
                                       to_char(st.ngayhieuluc, 'dd/MM/yyyy') AS ngayhieulucba,
                                       d.toaanid              AS madonvirabanan,
                                       dm.ma_ten              AS tendonvirabanan,
                                       decode(tl.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy'
                                       ,
                                              'Thụ lý mới')
                                       || ' - số '
                                       || tl.sothuly
                                       || ' ngày '
                                       || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                       ndds.tenduongsu        AS hotenduongsu,
                                       ndds.so_cccd           AS sogiaytoduongsu,
                                       decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh, 'dd/MM/yyyy'
                                       )) AS ngaysinhduongsu,
                                       ndqtn.ma               AS maquoctichduongsu,
                                       ndqtn.ten              AS tenquoctichduongsu,
                                       ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                       ndds.tucachtotung_ma   AS matucachtotung,
                                       tctt.ten               AS tentucachtotung,
                                       to_char(st.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                       dc.id                  AS thamphanid,
                                       dc.hoten               AS thamphan,
                                       'Chưa đồng bộ' AS trangthaibanghi,
                                       'CDB' AS loaibang,
                                       db.ghichu,
                                       db.taikhoangui,
                                       db.ngaygui,
                                       d.nguoitao,
                                       to_char(dht.ma) mathanhphotinhduongsu,
                                       dht.ten                tenthanhphotinhduongsu,
                                       to_char(xht.ma) maquanhuyenduongsu,
                                       xht.ten                tenquanhuyenduongsu,
                                       to_char(xht.ma) maphuongxaduongsu,
                                       xht.ten                tenphuongxaduongsu,
                                       ndds.tamtruchitiet     diachiduongsu,
                                       qhpl.id                AS maquanhephapluat,
                                       qhpl.case_name         AS tenquanhephapluat
                                   FROM
                                       ald_don              d
                                       LEFT JOIN ald_don_duongsu      ndds ON d.id = ndds.donid
                                       LEFT JOIN dm_dataitem          tctt ON tctt.ma = ndds.tucachtotung_ma
                                       INNER JOIN ald_sotham_banan     st ON st.donid = d.id
                                       INNER JOIN dm_toaan             dm ON dm.id = d.toaanid
                                       LEFT JOIN dm_dataitem          ndqtn ON ndqtn.id = ndds.quoctichid
                                                                      AND ndqtn.groupid = 2
                                       LEFT JOIN ald_sotham_thuly     tl ON tl.donid = d.id
                                       INNER JOIN ald_don_thamphan     tp ON tp.donid = d.id
                                                                         AND tp.mavaitro = 'VTTP_GIAIQUYETSOTHAM'
                                       LEFT JOIN dm_canbo             dc ON dc.id = tp.canboid
                                       LEFT JOIN dm_hanhchinh         dht ON dht.id = ndds.tamtrutinhid
                                       LEFT JOIN dm_hanhchinh         xht ON xht.id = ndds.tamtruid
                                       LEFT JOIN dm_qhpl_tk           qhpl ON qhpl.id = d.qhpltkid
                                       LEFT JOIN c06_toaan_laodong    db ON db.vuanid = d.id
                                                                         AND db.duongsuid = ndds.id
                                                                         AND db.loaibaqd = 1
                                                                         AND db.capxx = 'SO_THAM'
                                   WHERE
                                        db.id = v_id
                                   UNION    
                                            -- TH2: lấy thông tin bản án Phúc Thẩm thỏa mãn điều kiện đẩy đi
                                   SELECT
                                       db.id                  AS c06_id,
                                       d.id                   AS vuanid,
                                       ndds.id                AS duongsuid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       '1' AS loaibaqd, -- bản án
                                       to_char(d.mavuviec) AS mavuan,
                                       d.tenvuviec            AS tenvuan,
                                       'PHUC_THAM' AS capxx_ma,
                                       'Phúc Thẩm' AS capxx,
                                       st.sobanan             AS sobananorqd,
                                       to_char(st.ngaytuyenan, 'dd/MM/yyyy') AS ngayrabanan,
                                       to_char(st.ngayhieuluc, 'dd/MM/yyyy') AS ngayhieuluc,
                                       d.toaanid              AS madonvirabanan,
                                       dm.ma_ten              AS tendonvirabanan,
                                       decode(tl.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy'
                                       ,
                                              'Thụ lý mới')
                                       || ' - số '
                                       || tl.sothuly
                                       || ' ngày '
                                       || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                       ndds.tenduongsu        AS hotenduongsu,
                                       ndds.so_cccd           AS sogiaytoduongsu,
                                       decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh, 'dd/MM/yyyy'
                                       )) AS ngaysinhduongsu,
                                       ndqtn.ma               AS maquoctichduongsu,
                                       ndqtn.ten              AS tenquoctichduongsu,
                                       ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                       ndds.tucachtotung_ma   AS matucachtotung,
                                       tctt.ten               AS tentucachtotung,
                                       to_char(st.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                       dc.id                  AS thamphanid,
                                       dc.hoten               AS thamphan,
                                       'Chưa đồng bộ' AS trangthaibanghi,
                                       'CDB' AS loaibang,
                                       db.ghichu,
                                       db.taikhoangui,
                                       db.ngaygui,
                                       d.nguoitao,
                                       to_char(dht.ma) mathanhphotinhduongsu,
                                       dht.ten                tenthanhphotinhduongsu,
                                       to_char(xht.ma) maquanhuyenduongsu,
                                       xht.ten                tenquanhuyenduongsu,
                                       to_char(xht.ma) maphuongxaduongsu,
                                       xht.ten                tenphuongxaduongsu,
                                       ndds.tamtruchitiet     diachiduongsu,
                                       qhpl.id                AS maquanhephapluat,
                                       qhpl.case_name         AS tenquanhephapluat
                                   FROM
                                       ald_don              d
                                       LEFT JOIN ald_don_duongsu      ndds ON d.id = ndds.donid
                                       LEFT JOIN dm_dataitem          tctt ON tctt.ma = ndds.tucachtotung_ma
                                       INNER JOIN ald_phuctham_banan   st ON st.donid = d.id
                                       INNER JOIN dm_toaan             dm ON dm.id = st.toaanid
                                       LEFT JOIN dm_dataitem          ndqtn ON ndqtn.id = ndds.quoctichid
                                                                      AND ndqtn.groupid = 2
                                       LEFT JOIN dm_hanhchinh         dht ON dht.id = ndds.tamtrutinhid
                                       LEFT JOIN dm_hanhchinh         xht ON xht.id = ndds.tamtruid
                                       LEFT JOIN c06_toaan_laodong    db ON db.vuanid = d.id
                                                                         AND db.duongsuid = ndds.id
                                                                         AND db.loaibaqd = 1
                                                                         AND db.capxx = 'PHUC_THAM'
                                       LEFT JOIN ald_phuctham_thuly   tl ON tl.donid = d.id
                                       INNER JOIN ald_don_thamphan     tp ON tp.donid = d.id
                                                                         AND tp.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                       LEFT JOIN dm_canbo             dc ON dc.id = tp.canboid
                                       INNER JOIN dm_qhpl_tk           qhpl ON qhpl.id = d.qhpltkid
                                   WHERE
                                        db.id = v_id
                                   UNION    
                                            -- TH3: lấy thông tin quyết định sơ thẩm thỏa mãn điều kiện đẩy đi
                                   SELECT
                                       db.id                  AS c06_id,
                                       d.id                   AS vuanid,
                                       ndds.id                AS duongsuid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       '2' AS loaibaqd, -- bản án
                                       to_char(d.mavuviec) AS mavuan,
                                       d.tenvuviec            AS tenvuan,
                                       'SO_THAM' AS capxx_ma,
                                       'Sơ Thẩm' AS capxx,
                                       qd.soqd                AS sobananorqd,
                                       to_char(qd.ngayqd, 'dd/MM/yyyy') AS ngayrabanan,
                                       decode(qd.hieuluctu, NULL, NULL, to_char(qd.hieuluctu, 'dd/MM/yyyy')) AS ngayhieulucba,
                                       d.toaanid              AS madonvirabanan,
                                       dm.ma_ten              AS tendonvirabanan,
                                       decode(tl.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy'
                                       ,
                                              'Thụ lý mới')
                                       || ' - số '
                                       || tl.sothuly
                                       || ' ngày '
                                       || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                       ndds.tenduongsu        AS hotenduongsu,
                                       ndds.so_cccd           AS sogiaytoduongsu,
                                       decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh, 'dd/MM/yyyy'
                                       )) AS ngaysinhduongsu,
                                       ndqtn.ma               AS maquoctichduongsu,
                                       ndqtn.ten              AS tenquoctichduongsu,
                                       ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                       ndds.tucachtotung_ma   AS matucachtotung,
                                       tctt.ten               AS tentucachtotung,
                                       to_char(qd.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                       dc.id                  AS thamphanid,
                                       dc.hoten               AS thamphan,
                                       'Chưa đồng bộ' AS trangthaibanghi,
                                       'CDB' AS loaibang,
                                       db.ghichu,
                                       db.taikhoangui,
                                       db.ngaygui,
                                       d.nguoitao,
                                       to_char(dht.ma) mathanhphotinhduongsu,
                                       dht.ten                tenthanhphotinhduongsu,
                                       to_char(xht.ma) maquanhuyenduongsu,
                                       xht.ten                tenquanhuyenduongsu,
                                       to_char(xht.ma) maphuongxaduongsu,
                                       xht.ten                tenphuongxaduongsu,
                                       ndds.tamtruchitiet     diachiduongsu,
                                       qhpl.id                AS maquanhephapluat,
                                       qhpl.case_name         AS tenquanhephapluat
                                   FROM
                                       ald_don                d
                                       LEFT JOIN ald_don_duongsu        ndds ON d.id = ndds.donid
                                       LEFT JOIN dm_dataitem            tctt ON tctt.ma = ndds.tucachtotung_ma
                                       LEFT JOIN dm_dataitem            ndqtn ON ndqtn.id = ndds.quoctichid
                                                                      AND ndqtn.groupid = 2
                                       LEFT JOIN c06_toaan_laodong      db ON db.vuanid = d.id
                                                                         AND db.duongsuid = ndds.id
                                                                         AND db.loaibaqd = 2
                                                                         AND db.capxx = 'SO_THAM'
                                       LEFT JOIN ald_phuctham_thuly     tl ON tl.donid = d.id
                                       INNER JOIN ald_sotham_quyetdinh   qd ON qd.donid = d.id
                                       INNER JOIN dm_toaan               dm ON dm.id = qd.toaanid
                                       INNER JOIN ald_don_thamphan       tp ON tp.donid = d.id
                                                                         AND tp.mavaitro = 'VTTP_GIAIQUYETSOTHAM'
                                       LEFT JOIN dm_canbo               dc ON dc.id = tp.canboid
                                       LEFT JOIN dm_hanhchinh           dht ON dht.id = ndds.tamtrutinhid
                                       LEFT JOIN dm_hanhchinh           xht ON xht.id = ndds.tamtruid
                                       INNER JOIN dm_qhpl_tk               qhpl ON qhpl.id = d.qhpltkid
                                       INNER JOIN dm_qd_quyetdinh          qdts ON qd.quyetdinhid = qdts.id
                                   WHERE
                                       db.id = v_id
                                       and qdts.ma IN (
                                                   '19-VDS',
                                                   '20-VDS',
                                                   '22-VDS',
                                                   '32-VDS',
                                                   '33-YDS',
                                                   '38-DS',
                                                   '39-DS',
                                                   '45-DS',
                                                   '46-DS'
                                               )
                                   UNION
-- TH4: lấy thông tin quyết định phúc thẩm thỏa mãn điều kiện đẩy đi
                                   SELECT
                                       db.id                  AS c06_id,
                                       d.id                   AS vuanid,
                                       ndds.id                AS duongsuid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       '2' AS loaibaqd, -- bản án
                                       to_char(d.mavuviec) AS mavuan,
                                       d.tenvuviec            AS tenvuan,
                                       'PHUC_THAM' AS capxx_ma,
                                       'Phúc Thẩm' AS capxx,
                                       qd.soqd                AS sobananorqd,
                                       to_char(qd.ngayqd, 'dd/MM/yyyy') AS ngayrabanan,
                                       decode(qd.hieuluctu, NULL, NULL, to_char(qd.hieuluctu, 'dd/MM/yyyy')) AS ngayhieulucba,
                                       d.toaanid              AS madonvirabanan,
                                       dm.ma_ten              AS tendonvirabanan,
                                       decode(tl.truonghopthuly, 998, 'Giám đốc thẩm hủy để xét xử lại phúc thẩm', 269, 'Do có kháng nghị phúc thẩm'
                                       ,
                                              268, 'Do có kháng cáo và kháng nghị phúc thẩm', 'Do có kháng cáo phúc thẩm')
                                       || ' - số '
                                       || tl.sothuly
                                       || ' ngày '
                                       || to_char(tl.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                -- nguyên đơn       
                                       ndds.tenduongsu        AS hotenduongsu,
                                       ndds.so_cccd           AS sogiaytoduongsu,
                                       decode(to_char(ndds.ngaysinh, 'dd/MM/yyyy'), '01/01/0001', '', to_char(ndds.ngaysinh, 'dd/MM/yyyy'
                                       )) AS ngaysinhduongsu,
                                       ndqtn.ma               AS maquoctichduongsu,
                                       ndqtn.ten              AS tenquoctichduongsu,
                                       ndds.xacthuc_dldcqg    AS xacthuc_dldcqg,
                                       ndds.tucachtotung_ma   AS matucachtotung,
                                       tctt.ten               AS tentucachtotung,
                                       to_char(qd.ngaytao, 'dd/MM/yyyy') AS ngaytao,
                                       dc.id                  AS thamphanid,
                                       dc.hoten               AS thamphan,
                                       'Chưa đồng bộ' AS trangthaibanghi,
                                       'CDB' AS loaibang,
                                       db.ghichu,
                                       db.taikhoangui,
                                       db.ngaygui,
                                       d.nguoitao,
                                       to_char(dht.ma) mathanhphotinhduongsu,
                                       dht.ten                tenthanhphotinhduongsu,
                                       to_char(xht.ma) maquanhuyenduongsu,
                                       xht.ten                tenquanhuyenduongsu,
                                       to_char(xht.ma) maphuongxaduongsu,
                                       xht.ten                tenphuongxaduongsu,
                                       ndds.tamtruchitiet     diachiduongsu,
                                       qhpl.id                AS maquanhephapluat,
                                       qhpl.case_name         AS tenquanhephapluat
                                   FROM
                                       ald_don                  d
                                       LEFT JOIN ald_don_duongsu          ndds ON d.id = ndds.donid
                                       LEFT JOIN dm_dataitem              tctt ON tctt.ma = ndds.tucachtotung_ma
                                       LEFT JOIN dm_dataitem              ndqtn ON ndqtn.id = ndds.quoctichid
                                                                      AND ndqtn.groupid = 2
                                       LEFT JOIN c06_toaan_laodong        db ON db.vuanid = d.id
                                                                         AND db.duongsuid = ndds.id
                                                                         AND db.loaibaqd = 2
                                                                         AND db.capxx = 'PHUC_THAM'
                                       LEFT JOIN ald_phuctham_thuly       tl ON tl.donid = d.id
                                       INNER JOIN ald_phuctham_quyetdinh   qd ON qd.donid = d.id
                                       INNER JOIN dm_toaan                 dm ON dm.id = qd.toaanid
                                       INNER JOIN ald_don_thamphan         tp ON tp.donid = d.id
                                                                         AND tp.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                       LEFT JOIN dm_canbo                 dc ON dc.id = tp.canboid
                                       LEFT JOIN dm_hanhchinh             dht ON dht.id = ndds.tamtrutinhid
                                       LEFT JOIN dm_hanhchinh             xht ON xht.id = ndds.tamtruid
                                       INNER JOIN dm_qhpl_tk               qhpl ON qhpl.id = d.qhpltkid
                                       INNER JOIN dm_qd_quyetdinh          qdts ON qd.quyetdinhid = qdts.id
                                   WHERE
                                       db.id = v_id
                                       and qdts.ma IN (
                                                   '26-VDS',
                                                   '27-VDS',
                                                   '69-DS',
                                                   '70-DS',
                                                   '71-DS',
                                                   '72-DS'
                                               )
                               ) a;

    END;

    PROCEDURE c06_ald_duongsu_thuhoigannhat (
        v_duongsuid   IN    NUMBER,
        v_capxx       IN    VARCHAR2,
        v_loaiba_qd   IN    VARCHAR2,
        curreturn     OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               ROW_NUMBER() OVER(
                                   ORDER BY
                                       a.ngaytao DESC
                               ) stt,
                               COUNT(*) OVER() AS countall,
                               a.*
                           FROM
                               (
                                   SELECT
                                       c.id   AS c06_id,
                                       d.id   AS vuanid,
                                       '5' AS loaian_id,
                                       'Lao Động' AS loai_an_ten,
                                       c.loaibaqd, -- bản án
                                       c.tenvuan,
                                       c.thuly,
                                       CASE
                                           WHEN capxx = 'SO_THAN' THEN
                                               st.ngaytao
                                           ELSE
                                               pt.ngaytao
                                       END ngaytao,
                                       to_char(c.ngaygui, 'dd/MM/yyyy') AS ngaygui,
                                       to_char(c.ngaydongbo, 'dd/MM/yyyy') AS ngaydongbo,
                                       'Đã đồng bộ' AS trangthaibanghi,
                                       CASE
                                           WHEN c.capxx = 'SO_THAM' THEN
                                               'Sơ Thẩm'
                                           ELSE
                                               'Phúc Thẩm'
                                       END AS capxx,
                                       c.sobananorqd,
                                       c.ngayrabanan,
                                       c.madonvirabanan,
                                       c.tendonvirabanan,
                                       c.bqd,
                                       c.anphi,
                                       c.ngayhieulucba,
                                       c.hotenduongsu,
                                       c.sogiaytoduongsu,
                                       c.ngaysinhduongsu,
                                       c.maquoctichduongsu,
                                       c.tenquoctichduongsu,
                                       c.mathanhphotinhduongsu,
                                       c.tenthanhphotinhduongsu,
                                       c.maquanhuyenduongsu,
                                       c.tenquanhuyenduongsu,
                                       c.maphuongxaduongsu,
                                       c.tenphuongxaduongsu,
                                       c.diachiduongsu,
                                       ndds.xacthuc_dldcqg
                                   FROM
                                       c06_toaan_laodong    c
                                       LEFT JOIN ald_don              d ON c.vuanid = d.id
                                       LEFT JOIN ald_don_duongsu      ndds ON d.id = ndds.donid
                                       LEFT JOIN ald_sotham_banan     st ON st.donid = c.vuanid
                                       LEFT JOIN ald_phuctham_banan   pt ON pt.donid = c.vuanid
                                   WHERE
                                       c.duongsuid = v_duongsuid
                                       AND c.loaibaqd = v_loaiba_qd
                                       AND c.capxx = v_capxx
                                       AND c.trangthaiald = 'THU_HOI'
                                   ORDER BY
                                       c.id DESC
                               ) a;

    END;

    PROCEDURE ald_don_dsduongsu_getby (
        vdonid      IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               d.ngaysinh,
                               d.namsinh,
                               d.id,
                               d.tenduongsu,
                               d.ngaysinh,
                               d.namsinh,
                               decode(loaiduongsu, 1, 'Cá nhân ', 2, 'Cơ quan',
                                      3, 'Tổ chức', '') tenloaids,
                               decode(isdaidien, 1, 'X ', '') daidien,
                               CASE
                                   WHEN p.sobienlai IS NOT NULL
                                        OR p.tinhtrang = 1 THEN
                                       'X '
                                   ELSE
                                       ''
                               END AS thuly,
                               decode(loaiduongsu, 1, h1.ma_ten, h2.ma_ten) diachids,
                               i.ten               AS tentctt,
                               d.nguoitao,
                               d.ngaytao,
                               d.isphuctham,
                               ( d.tenduongsu
                                 || ' - '
                                 || decode(loaiduongsu, 1, h1.ma_ten, h2.ma_ten)
                                 || ' - '
                                 || i.ten ) AS arrduongsu,
                               d.tucachtotung_ma   tucachtotung,
                               d.toa_giaiquyet_id,
                               (
                                   CASE
                                       WHEN d.xacthuc_dldcqg IS NULL THEN
                                           0
                                       ELSE
                                           d.xacthuc_dldcqg
                                   END
                               ) AS xacthuc_dldcqg,
                               decode(d.xacthuc_dldcqg, 1, 'Đã xác thực', 3, 'Không thể làm sạch được',
                                      '') AS xacthuc_dldcqg_ten
                           FROM
                               ald_don_duongsu   d
                               LEFT JOIN dm_dataitem       i ON i.ma = d.tucachtotung_ma
                               LEFT JOIN dm_hanhchinh      h1 ON h1.id = d.tamtruid
                               LEFT JOIN dm_hanhchinh      h2 ON h2.id = d.ndd_diachiid
                               LEFT JOIN ald_anphi         p ON p.duongsu_id = d.id
                           WHERE
                               d.isdon = 1
                               AND ( d.donid = vdonid
                                     OR d.donid IN (
                                   SELECT
                                       id
                                   FROM
                                       ald_don
                                   WHERE
                                       vuangocid = vdonid
                                       AND is_tachan IS NULL
                               ) )
                           ORDER BY
                               d.isdaidien DESC,
                               d.tenduongsu;

    END;

    PROCEDURE c06_ald_history_by_id (
        v_id        IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
        vsobananorqd   VARCHAR2(100);
        vloaibaqd      VARCHAR2(100);
        vvuanid        NUMBER;
        vduongsuid     NUMBER;
    BEGIN
        SELECT
            sobananorqd,
            loaibaqd,
            vuanid,
            duongsuid
        INTO
            vsobananorqd,
            vloaibaqd,
            vvuanid,
            vduongsuid
        FROM
            c06_toaan_laodong c
        WHERE
            c.id = v_id;

        OPEN curreturn FOR SELECT
                              ROW_NUMBER() OVER(
                                  ORDER BY
                                      a.ngaygui DESC
                              ) stt,
                              COUNT(*) OVER() AS countall,
                              a.*
                          FROM
                              (
                                  SELECT
                                      c.id      AS c06_id,
                                      d.id      AS vuanid,
                                      '5' AS loaian_id,
                                      'Lao Động' AS loai_an_ten,
                                      c.loaibaqd, -- bản án
                                      to_char(d.mavuviec) AS mavuan,
                                      c.tenvuan,
                                      c.thuly,
                                      CASE
                                          WHEN c.capxx = 'SO_THAM' THEN
                                              to_char(st.ngaytao, 'dd/MM/yyyy')
                                          ELSE
                                              to_char(pt.ngaytao, 'dd/MM/yyyy')
                                      END AS ngaytao,
                                      to_char(c.ngaygui, 'dd/MM/yyyy') AS ngaygui,
                                      to_char(c.ngaydongbo, 'dd/MM/yyyy') AS ngaydongbo,
                                      'Đã đồng bộ' AS trangthaibanghi,
                                      CASE
                                          WHEN c.capxx = 'SO_THAM' THEN
                                              'Sơ Thẩm'
                                          ELSE
                                              'Phúc Thẩm'
                                      END AS capxx,
                                      c.capxx   AS capxx_ma,
                                      c.sobananorqd,
                                      c.duongsuid,
                                      c.ngayrabanan,
                                      c.madonvirabanan,
                                      c.tendonvirabanan,
                                      c.bqd,
                                      c.anphi,
                                      c.ngayhieulucba,
                                      c.hotenduongsu,
                                      c.sogiaytoduongsu,
                                      c.ngaysinhduongsu,
                                      c.maquoctichduongsu,
                                      c.tenquoctichduongsu,
                                      c.mathanhphotinhduongsu,
                                      c.tenthanhphotinhduongsu,
                                      c.maquanhuyenduongsu,
                                      c.tenquanhuyenduongsu,
                                      c.maphuongxaduongsu,
                                      c.tenphuongxaduongsu,
                                      c.diachiduongsu,
                                      ndds.xacthuc_dldcqg,
                                      CASE
                                          WHEN c.capxx = 'SO_THAM' THEN
                                              dcst.hoten
                                          ELSE
                                              dcpt.hoten
                                      END AS thamphan,
                                      c.matucachtotung,
                                      c.tentucachtotung,
                                      c.ghichu,
                                      'DDB' AS loaibang,
                                      c.taikhoangui,
                                      d.nguoitao,
                                      c.trangthaijobshare
                                  FROM
                                      c06_toaan_laodong    c
                                      LEFT JOIN ald_don              d ON c.vuanid = d.id
                                      LEFT JOIN ald_don_duongsu      ndds ON ndds.id = c.duongsuid
                                      LEFT JOIN ald_sotham_banan     st ON st.donid = d.id
                                      LEFT JOIN ald_phuctham_banan   pt ON pt.donid = d.id
                                      LEFT JOIN ald_don_thamphan     tpst ON tpst.donid = d.id
                                                                         AND tpst.mavaitro = 'VTTP_GIAIQUYETSOTHAM'
                                      LEFT JOIN dm_canbo             dcst ON dcst.id = tpst.canboid
                                      LEFT JOIN ald_don_thamphan     tppt ON tppt.donid = d.id
                                                                         AND tppt.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                      LEFT JOIN dm_canbo             dcpt ON dcpt.id = tppt.canboid
                                  WHERE
                                      c.vuanid = vvuanid
                                      AND c.duongsuid = vduongsuid
                              ) a;

    END;

    PROCEDURE ald_don_duongsu_notdaidien_doncha (
        vdonid      IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN curreturn FOR SELECT
                               d.id,
                               d.tenduongsu,
                               (
                                   CASE loaiduongsu
                                       WHEN 1   THEN
                                           'Cá nhân'
                                       WHEN 2   THEN
                                           'Cơ quan'
                                       WHEN 3   THEN
                                           'Tổ chức'
                                   END
                               ) AS tenloaids,
                               (
                                   CASE isdaidien
                                       WHEN 1 THEN
                                           'X'
                                       ELSE
                                           ''
                                   END
                               ) AS daidien,
                               (
                                   CASE loaiduongsu
                                       WHEN 1 THEN
                                           h1.ma_ten
                                       ELSE
                                           h2.ma_ten
                                   END
                               ) AS diachids,
                               d.tucachtotung_ma,
                               i.ten AS tentctt,
                               d.socmnd,
                               d.quoctichid,
                               d.nguoitao,
                               d.ngaytao,
                               ( d.tenduongsu
                                 || ' - '
                                 || (
                                   CASE loaiduongsu
                                       WHEN 1 THEN
                                           h1.ma_ten
                                       ELSE
                                           h2.ma_ten
                                   END
                               )
                                 || ' - '
                                 || i.ten ) AS arrduongsu,
                               d.toa_giaiquyet_id,
                               d.xacthuc_dldcqg,
                               decode(d.xacthuc_dldcqg, 1, 'Đã xác thực', 3, 'Không thể làm sạch được',
                                      '') AS xacthuc_dldcqg_ten
                           FROM
                               ald_don_duongsu   d
                               LEFT JOIN dm_dataitem       i ON i.ma = d.tucachtotung_ma
                               LEFT JOIN dm_hanhchinh      h1 ON h1.id = d.tamtruid
                               LEFT JOIN dm_hanhchinh      h2 ON h2.id = d.ndd_diachiid
                           WHERE
                               d.donid = vdonid
                               AND d.isdon = 1
                               AND d.isdaidien = 0
                               AND ( d.isdonchitiet IS NULL
                                     OR d.isdonchitiet = 0 )
                           ORDER BY
                               d.tenduongsu;

    END;

    PROCEDURE getdulieuchon_thuhoigannhat (
        v_duongsuid   IN    NUMBER,
        curreturn     OUT   SYS_REFCURSOR
    ) AS
    BEGIN    

    ---------------------------------------
        OPEN curreturn FOR SELECT
                               b.id AS c06_id,
                               b.duongsuid,
                               b.status
                           FROM
                               c06_toaan_laodong b
                           WHERE
                               b.duongsuid = v_duongsuid
                               AND b.trangthaiald = 'THU_HOI'
                               AND b.id = (
                                   SELECT
                                       MAX(id)
                                   FROM
                                       c06_toaan_laodong
                                   WHERE
                                       duongsuid = v_duongsuid
                                       AND trangthaiald = 'THU_HOI'
                               );

    END getdulieuchon_thuhoigannhat;

    PROCEDURE c06_toaan_laodong_history_insert (
        vlydo          IN   VARCHAR2,
        vnoidung       IN   VARCHAR2,
        vnguoithuhoi   IN   VARCHAR2,
        vid            IN   NUMBER,
        vuanid         IN   NUMBER,
        duongsuid      IN   NUMBER,
        actiontype     IN   VARCHAR2
    ) AS
    BEGIN
        INSERT INTO c06_toaan_laodong_history (
            lydo_thuhoi,
            noidung,
            dongboid,
            nguoithuhoi,
            ngaythuhoi,
            donid,
            duongsuid,
            action_type
        ) VALUES (
            vlydo,
            vnoidung,
            vid,
            vnguoithuhoi,
            sysdate,
            vuanid,
            duongsuid,
            actiontype
        );

    END;
END dlqgc06_ald;
/
