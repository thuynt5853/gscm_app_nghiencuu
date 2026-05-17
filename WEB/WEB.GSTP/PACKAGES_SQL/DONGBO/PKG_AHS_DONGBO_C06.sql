CREATE OR REPLACE PACKAGE pkg_ahs_dongbo_c06 AS 

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


CREATE OR REPLACE PACKAGE BODY pkg_ahs_dongbo_c06 AS

  /* GTEL-DUCPH 23-09-2025 tach package xu ly rieng cho man dong bo */
  PROCEDURE c06_ahs_history (
        v_bicanid        IN    NUMBER,
        v_vuanid        IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    )as
    begin
    open curreturn for SELECT
                              ROW_NUMBER() OVER(
                                  ORDER BY
                                      a.NGAYTHUHOI DESC
                              ) stt,
                              COUNT(*) OVER() AS countall,
                              a.*
                          FROM ( select 
                          'Hình sự' as LOAI_AN_TEN,
                          va.mavuan,
                          va.tenvuan,

                                                                h.LYDO_THUHOI as GHICHU,
                                                                h.NGUOITHUHOI as NGUOITHUCHIEN,
                                                                h.NGAYTHUHOI,
                                                                to_char(h.NGAYTHUHOI,'dd/MM/yyyy') as NGAYTHUCHIEN,
                                                                h.action_type as LOAI_HANH_DONG,
                                                                h.NOIDUNG
    from c06_toaan_hinhsu_history h
    inner join ahs_vuan va on h.vuanid = va.id
    where h.vuanid = v_vuanid and h.bicanid = v_bicanid) a;
    end;
   PROCEDURE c06_ahs_thuhoi (
  vID in number,
  vBICanId in number,
  vVuAnId in number,
  vGhiChu in varchar2,
  vNguoiThuHoi in varchar2
  )as
  begin
  -- update các bản ghi bị thu hồi cũ về giá trị status = 0
  update C06_TOAAN_HINHSU set status = '0' where bicanid = vBiCanId and vuAnId = vVuAnId and TRANGTHAIAHS = 'THU_HOI'  and id <> vId;
  --update bản ghi bị thu hồi hiện tại về status = 1 và thêm các thông tin ghichu, nguoithuhoi, ngaythuhoi
  update C06_TOAAN_HINHSU set status = '1',TRANGTHAIAHS = 'THU_HOI', ghichu = vGhiChu, NGUOITHUHOI = vNguoiThuHoi, NGAYTHUHOI = sysdate  where id = vId;
  end;
  PROCEDURE c06_ahs_toidanh_hinhphat_getbyid (
        vbicanid    IN NUMBER,
        v_toidanhId in number,
        v_capxx     IN VARCHAR2,
        v_loaiba_qd IN VARCHAR2,
        v_ismain    IN VARCHAR2,
        curreturn   OUT SYS_REFCURSOR
    ) AS
        v_quyetdinhid NUMBER;
    BEGIN
        CASE
            WHEN v_capxx = 'SO_THAM' THEN -- nếu là sơ thẩm


                OPEN curreturn FOR SELECT
                                                          dm.*,
                                                          asbdc.*
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet asbdc

                                               -- inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                               -- inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                          INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                   WHERE
                                           asbdc.bicanid = vbicanid
                                       AND asbdc.toidanhid = v_toidanhId;

            ELSE
                IF ( v_loaiba_qd = '1' ) THEN -- là bản án
         -- Kiểm tra quyetdinhid
                    SELECT
                        a.ketquaphucthamid
                    INTO v_quyetdinhid
                    FROM
                             ahs_phuctham_banan a
                        INNER JOIN ahs_phuctham_banan_bicao b ON b.bananid = a.id
                    WHERE
                        b.bicaoid = vbicanid;

                    IF ( v_quyetdinhid = 1 )  -- nếu giữ nguyên thì lấy ở sơ thẩm

                     THEN

                      OPEN curreturn FOR SELECT
                                                          dm.*,
                                                          asbdc.*
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet asbdc

                                               -- inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                               -- inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                          INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                   WHERE
                                           asbdc.bicanid = vbicanid
                                      AND asbdc.toidanhid = v_toidanhId;


                    ELSE -- không thì lấy ở phúc thẩm
                        OPEN curreturn FOR SELECT
                                                                  dm.*,
                                                                  asbdc.*
                                                              FROM
                                                                       ahs_phuctham_banan_dieu_ct asbdc

                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                                --inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                                --inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                                  INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                           WHERE
                                                   asbdc.bicanid = vbicanid
                                               AND asbdc.toidanhid = v_toidanhId;
                    END IF;

                ELSE -- nếu là quyết định lấy ở sơ thẩm

                      OPEN curreturn FOR SELECT
                                                          dm.*,
                                                          asbdc.*
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet asbdc

                                               -- inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                               -- inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                          INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                   WHERE
                                           asbdc.bicanid = vbicanid
                                       AND asbdc.toidanhid = v_toidanhId;
                END IF;
        END CASE;
    END;
  PROCEDURE getdulieuchon_thuhoigannhat (
        V_BICANID   IN NUMBER,
        curreturn OUT SYS_REFCURSOR
    ) AS
    BEGIN    

    ---------------------------------------
        OPEN curreturn FOR
                --TH1: Bản án không có kháng cao kháng nghi
         SELECT
                                                  b.id,
                                                  b.bicanid,
                                                  b.status
                                              FROM
                                                  c06_toaan_hinhsu b
                           WHERE
                                   b.bicanid = V_BICANID

                               AND b.trangthaiahs = 'THU_HOI'
                              AND b.id = (
                                   SELECT
                                       MAX(id)
                                   FROM
                                       c06_toaan_hinhsu
                                   WHERE
                                           bicanid = V_BICANID

                                       AND trangthaiahs = 'THU_HOI'
                               );

    END getdulieuchon_thuhoigannhat;
  PROCEDURE c06_toaan_hinhsu_getbyid(
    vId in number,
    curreturn  OUT SYS_REFCURSOR
    )as
    begin
    open curreturn for select * from c06_toaan_hinhsu where id = vId;
    end;
    PROCEDURE c06_ahs_dieuct_getall (
        bi_can_id IN INT,
        vu_an_id  IN INT,
        v_capxx   IN VARCHAR2,
        curreturn OUT SYS_REFCURSOR
    ) AS
    v_loaiba_qd varchar2(20);
    v_quyetdinhid NUMBER;
    v_count       NUMBER;
    BEGIN
        CASE
            WHEN v_capxx = 'SO_THAM' THEN
                OPEN curreturn FOR SELECT
                                                          *
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet a
                                                          INNER JOIN dm_boluat         b ON a.dieuluatid = b.id
                                                          INNER JOIN dm_boluat_toidanh c ON a.toidanhid = c.id
                                   WHERE
                                           a.vuanid = vu_an_id
                                       AND a.bicanid = bi_can_id;

            ELSE
              -- Lấy loại bản án quyết định

              select NVL(BQD,'1') into v_loaiba_qd from c06_toaan_hinhsu a where a.vuanid = vu_an_id
                                       AND a.bicanid = bi_can_id and trangthaiahs = 'HIEU_LUC';

              if(v_loaiba_qd = '1') -- Là bản án
              then
               -- Kiểm tra quyetdinhid
                    SELECT
                        a.ketquaphucthamid
                    INTO v_quyetdinhid
                    FROM
                             ahs_phuctham_banan a
                        INNER JOIN ahs_phuctham_banan_bicao b ON b.bananid = a.id
                    WHERE
                        a.vuanid = vu_an_id and
                         b.bicaoid = bi_can_id;

                    IF ( v_quyetdinhid = 1 )  -- nếu giữ nguyên thì lấy ở sơ thẩm

                     THEN
                                OPEN curreturn FOR SELECT
                                                          *
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet a
                                                          INNER JOIN dm_boluat         b ON a.dieuluatid = b.id
                                                          INNER JOIN dm_boluat_toidanh c ON a.toidanhid = c.id
                                   WHERE
                                           a.vuanid = vu_an_id
                                       AND a.bicanid = bi_can_id;
                    else
                    --Kiểm tra thêm logic nếu không có kháng cáo thì lấy theo phúc thẩm, có kháng cáo thì lấy theo sơ thẩm
                       -- Lấy số lượng
                        SELECT
                            COUNT(1)
                        INTO v_count
                        FROM
                                 ahs_sotham_khangcao a
                            JOIN ahs_sotham_rutkhangcao b ON a.id = b.khangcaoid
                        WHERE
                            a.nguoikcid = bi_can_id;
                        IF v_count > 0 THEN -- lấy ở sơ thẩm
                           OPEN curreturn FOR SELECT
                                                          *
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet a
                                                          INNER JOIN dm_boluat         b ON a.dieuluatid = b.id
                                                          INNER JOIN dm_boluat_toidanh c ON a.toidanhid = c.id
                                   WHERE
                                           a.vuanid = vu_an_id
                                       AND a.bicanid = bi_can_id;

                        ELSE -- không có thì lấy ở phúc thẩm
                OPEN curreturn FOR SELECT
                                                          *
                                                      FROM
                                                               ahs_phuctham_banan_dieu_ct a
                                                          INNER JOIN dm_boluat          b ON a.dieuluatid = b.id
                                                          INNER JOIN ahs_phuctham_banan b ON a.bananid = b.id
                                                          INNER JOIN dm_boluat_toidanh  c ON a.toidanhid = c.id
                                   WHERE
                                           b.vuanid = vu_an_id
                                       AND a.bicanid = bi_can_id;
                    END IF;
                    END IF;
                    ELSE -- Là quyết định thì lấy ở sơ thẩm
                    open curreturn for SELECT
                                                          *
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet a
                                                          INNER JOIN dm_boluat         b ON a.dieuluatid = b.id
                                                          INNER JOIN dm_boluat_toidanh c ON a.toidanhid = c.id
                                   WHERE
                                           a.vuanid = vu_an_id
                                       AND a.bicanid = bi_can_id;
                    END IF;

        END CASE;
    END;

    PROCEDURE c06_ahs_bican_getbyid (
        vbicanid    IN NUMBER,
        v_capxx     IN VARCHAR2,
        v_loaiba_qd IN VARCHAR2,
        curreturn   OUT SYS_REFCURSOR
    ) AS
    BEGIN
        ---- TH là án sơn thẩm
        CASE
            WHEN v_capxx = 'SO_THAM' THEN
                OPEN curreturn FOR SELECT
                                                          ba.sobanan                                            AS sobananorqd,
                                                          to_char(ba.ngaybanan, 'dd/MM/yyyy')                   AS ngayrabanan,
                                                          dm.ma                                                 madonvirabanan,
                                                          dm.ten                                                tendonvirabanan,
                                                          '1'                                                   bqd,
                                                          to_char(asbb.ngayhieulucbanan, 'dd/MM/yyyy')          ngayhieulucba,
                                                          bc.hoten                                              hotenbicao,
                                                          bc.so_cccd                                           sogiaytobicao,
                                                          to_char(bc.ngaysinh, 'dd/MM/yyyy')                    ngaysinhbicao,
                                                          dd.ma                                                 maquoctichbicao,
                                                          dd.ten                                                tenquoctichbicao,
                                                          to_char(dht.ma)                                       mathanhphotinhbicao,
                                                          dht.ten                                               tenthanhphotinhbicao,
                                                          to_char(xht.ma)                                       maquanhuyenbicao,
                                                          xht.ten                                               tenquanhuyenbicao,
                                                          to_char(xht.ma)                                       maphuongxabicao,
                                                          xht.ten                                               tenphuongxabicao,
                                                          bc.khttchitiet                                        diachibicao,
                                                          ''                                                    ghichu,
                                                          va.tenvuan                                            tenvuan,
                                                          decode(ast.truonghopthuly, 1777, 'Thụ lý xét xử lại do GDT hủy', 236, 'Thụ lý xét xử lại do PT hủy'
                                                          ,
                                                                 235, 'Thụ lý từ tòa án khác chuyển đến', 234, 'Tóa án trả hồ sơ -VKS không chấp nhận điều tra bổ sung'
                                                                 , 233,
                                                                 'Viện kiểm sát truy tố lần đầu', 'Thụ lý mới') thuly,
                                                          va.id                                                 vuanid,
                                                          bc.id                                                 bicanid,
                                                          'SO_THAM'                                             capxx,
                                                           thhp.tentoidanh_st                           toidanh_th,
                                                                  to_char(thhp.hinhphat_st)                     AS hinhphat_th,
                                                            dc.hoten                                     AS thamphan
                                                      FROM
                                                               ahs_bicanbicao bc

                                                          INNER JOIN ahs_sotham_banan_bicao asbb ON bc.id = asbb.bicaoid
                                                          INNER JOIN ahs_vuan               va ON bc.vuanid = va.id
                                                          INNER JOIN dm_toaan               dm ON dm.id = va.toaanid
                                                          INNER JOIN ahs_sotham_banan       ba ON ba.vuanid = va.id
                                                          INNER JOIN ahs_thamphangiaiquyet         atpgq ON atpgq.vuanid = va.id  and atpgq.mavaitro ='VTTP_GIAIQUYETSOTHAM' 
                                                                  LEFT JOIN ahs_tonghophinhphat           thhp ON thhp.bicaoid = bc.id
                                                                                                        AND thhp.vuanid = va.id
                                                          INNER JOIN ahs_sotham_thuly       ast ON va.id = ast.vuanid
                                                          LEFT JOIN dm_hanhchinh           dht ON dht.id = bc.hktt
                                                          LEFT JOIN dm_hanhchinh           xht ON xht.id = bc.hktt_huyen
                                                          LEFT JOIN dm_dataitem            dd ON bc.quoctichid = dd.id
                                                           LEFT JOIN dm_canbo                      dc ON dc.id = atpgq.canboid
                               -- left join dm_canbo dc on dc.id = atpgq.canboid
                                --left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                                   WHERE
                                       bc.id = vbicanid;

            ELSE
                IF ( v_loaiba_qd = '1' ) THEN --Là bản án lấy bản ghi ở bản án phúc thẩm
                    OPEN curreturn FOR SELECT
                                                              ba.sobanan                                                                                                AS
                                                              sobananorqd,
                                                              to_char(ba.ngaybanan, 'dd/MM/yyyy')                                                                       AS
                                                              ngayrabanan,
                                                              dm.ma                                                                                                     madonvirabanan
                                                              ,
                                                              dm.ten                                                                                                    tendonvirabanan
                                                              ,
                                                              '1'                                                                                                       bqd
                                                              ,
                                                              to_char(ba.ngaybanan, 'dd/MM/yyyy')                                                                       ngayhieulucba
                                                              ,
                                                              bc.hoten                                                                                                  hotenbicao
                                                              ,
                                                              bc.so_cccd                                                                                               sogiaytobicao
                                                              ,
                                                              to_char(bc.ngaysinh, 'dd/MM/yyyy')                                                                        ngaysinhbicao
                                                              ,
                                                              dd.ma                                                                                                     maquoctichbicao
                                                              ,
                                                              dd.ten                                                                                                    tenquoctichbicao
                                                              ,
                                                              to_char(dht.ma)                                                                                           mathanhphotinhbicao
                                                              ,
                                                              dht.ten                                                                                                   tenthanhphotinhbicao
                                                              ,
                                                              to_char(xht.ma)                                                                                           maquanhuyenbicao
                                                              ,
                                                              xht.ten                                                                                                   tenquanhuyenbicao
                                                              ,
                                                              to_char(xht.ma)                                                                                           maphuongxabicao
                                                              ,
                                                              xht.ten                                                                                                   tenphuongxabicao
                                                              ,
                                                              bc.khttchitiet                                                                                            diachibicao
                                                              ,
                                                              ''                                                                                                        ghichu
                                                              ,
                                                              va.tenvuan                                                                                                tenvuan
                                                              ,
                                                              decode(ast.truonghopthuly, 1079, 'Do có kháng cáo và kháng nghị phúc thẩm'
                                                              , 1078, 'Do có kháng nghị phúc thẩm',
                                                                     998, 'Giám đốc thẩm hủy để xét xử lại phúc thẩm', 1058, 'Do có kháng cáo phúc thẩm'
                                                                     , 'Thụ lý mới') thuly,
                                                              va.id                                                                                                     vuanid
                                                              ,
                                                              bc.id                                                                                                     bicanid
                                                              ,
                                                              'PHUC_THAM'                                                                                               capxx,
                                                                             COALESCE(athp.tentoidanh_pt, athp.tentoidanh_st) toidanh_th,
                                                                                  COALESCE(athp.hinhphat_pt, athp.hinhphat_st) hinhphat_th,
                                                                                   dc.hoten                                     AS thamphan

                                                          FROM
                                                              ahs_bicanbicao           bc

                                                              INNER JOIN ahs_phuctham_banan_bicao asbb ON bc.id = asbb.bicaoid
                                                              INNER JOIN ahs_vuan                 va ON bc.vuanid = va.id
                                                              LEFT JOIN ahs_tonghophinhphat           athp ON athp.bicaoid = bc.id
                                                                                                        AND athp.vuanid = va.id
                                                              INNER JOIN dm_toaan                 dm ON dm.id = va.toaanid
                                                              INNER JOIN ahs_phuctham_banan       ba ON ba.vuanid = va.id
                                                              INNER JOIN ahs_phuctham_thuly       ast ON va.id = ast.vuanid
                                                              LEFT JOIN dm_hanhchinh             dht ON dht.id = bc.hktt
                                                              LEFT JOIN dm_hanhchinh             xht ON xht.id = bc.hktt_huyen
                                                              LEFT JOIN dm_dataitem              dd ON bc.quoctichid = dd.id
                                                               INNER JOIN ahs_thamphangiaiquyet    atpgq ON atpgq.vuanid = va.id
                                                                                                            AND atpgq.thukyid <> 0
                                                                                                            AND atpgq.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                                                  LEFT JOIN dm_canbo                 dc ON dc.id = atpgq.canboid
                                       WHERE
                                           bc.id = vbicanid;

                ELSE -- là quyết định
                    OPEN curreturn FOR SELECT
                                                              apb.soquyetdinh                                                                                           AS
                                                              sobananorqd,
                                                              to_char(apb.ngayqd, 'dd/MM/yyyy')                   AS ngayrabanan,

                                                              dm.ma                                                                                                     madonvirabanan
                                                              ,
                                                              dm.ten                                                                                                    tendonvirabanan
                                                              ,
                                                              '2'                                                                                                       bqd
                                                              ,
                                                              to_char(apb.ngayqd, 'dd/MM/yyyy')   as                                                            ngayhieulucba
                                                              ,
                                                              bc.hoten                                                                                                  hotenbicao
                                                              ,
                                                              bc.so_cccd                                                                                               sogiaytobicao
                                                              ,
                                                              to_char(bc.ngaysinh, 'dd/MM/yyyy')                                                                        ngaysinhbicao
                                                              ,
                                                              dd.ma                                                                                                     maquoctichbicao
                                                              ,
                                                              dd.ten                                                                                                    tenquoctichbicao
                                                              ,
                                                              to_char(dht.ma)                                                                                           mathanhphotinhbicao
                                                              ,
                                                              dht.ten                                                                                                   tenthanhphotinhbicao
                                                              ,
                                                              to_char(xht.ma)                                                                                           maquanhuyenbicao
                                                              ,
                                                              xht.ten                                                                                                   tenquanhuyenbicao
                                                              ,
                                                              to_char(xht.ma)                                                                                           maphuongxabicao
                                                              ,
                                                              xht.ten                                                                                                   tenphuongxabicao
                                                              ,
                                                              bc.khttchitiet                                                                                            diachibicao
                                                              ,
                                                              ''                                                                                                        ghichu
                                                              ,
                                                              va.tenvuan                                                                                                tenvuan
                                                              ,
                                                              decode(ast.truonghopthuly, 1079, 'Do có kháng cáo và kháng nghị phúc thẩm'
                                                              , 1078, 'Do có kháng nghị phúc thẩm',
                                                                     998, 'Giám đốc thẩm hủy để xét xử lại phúc thẩm', 1058, 'Do có kháng cáo phúc thẩm'
                                                                     , 'Thụ lý mới') thuly,
                                                              va.id                                                                                                     vuanid
                                                              ,
                                                              bc.id                                                                                                     bicanid
                                                              ,
                                                              'PHUC_THAM'                                                                                               capxx,
                                                              athp.tentoidanh_st                           AS toidanh_th, -- lấy tội danh ở bản án sơ thẩm
                                                                   athp.hinhphat_st                      AS hinhphat_th,-- lấy hình phạt ở bản án sơ thẩm
                                                                   dc.hoten                                     AS thamphan
                                                          FROM
                                                                   ahs_phuctham_quyetdinh_vuan apb
                                                              INNER JOIN ahs_vuan                     va ON apb.vuanid = va.id
                                                            --  INNER JOIN ahs_phuctham_quyetdinh_bican apbb ON apbb.vuanid = apb.id
                                                              INNER JOIN ahs_bicanbicao               bc ON bc.vuanid = va.id
                                                              LEFT JOIN ahs_tonghophinhphat           athp ON athp.bicaoid = bc.id
                                                                                                        AND athp.vuanid = va.id
                                                              INNER JOIN ahs_sotham_banan_bicao       asbb ON bc.id = asbb.bicaoid
                                                              INNER JOIN dm_toaan                     dm ON dm.id = va.toaanid
                                                              INNER JOIN ahs_phuctham_thuly           ast ON va.id = ast.vuanid
                                                              LEFT JOIN dm_hanhchinh                 dht ON dht.id = bc.hktt
                                                              LEFT JOIN dm_hanhchinh                 xht ON xht.id = bc.hktt_huyen
                                                              LEFT JOIN dm_dataitem                  dd ON bc.quoctichid = dd.id
                                                              INNER JOIN ahs_thamphangiaiquyet         atpgq ON atpgq.vuanid = va.id AND atpgq.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                                               LEFT JOIN dm_canbo                      dc ON dc.id = atpgq.canboid
                               -- left join dm_canbo dc on dc.id = atpgq.canboid
                                --left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                                       WHERE
                                           bc.id = vbicanid  and  apb.quyetdinhid IN ( 127, 203 );

                END IF;
        END CASE;
    END;

    FUNCTION create_ma_dongbo_random RETURN VARCHAR2 AS
        v_counts_madb NUMBER;
        v_ma_db       VARCHAR2(255);
        v_temp        VARCHAR2(255);
    BEGIN
    -- Sinh mã ngẫu nhiên
        SELECT
            dbms_random.string('x', 10)
        INTO v_ma_db
        FROM
            dual;

    -- Kiểm tra trùng trong DB
        SELECT
            CASE
                WHEN EXISTS (
                    SELECT
                        1
                    FROM
                        c06_toaan_tinhtranghonnhan
                    WHERE
                        madinhdanhbanan = v_ma_db
                ) THEN
                    1
                ELSE
                    0
            END
        INTO v_counts_madb
        FROM
            dual;

        IF v_counts_madb = 1 THEN
        -- Đệ quy gọi lại chính hàm này để tạo mã mới
            v_temp := create_ma_dongbo_random();  -- Gọi lại chính nó
            RETURN v_temp;
        ELSE
            RETURN v_ma_db;
        END IF;

    END create_ma_dongbo_random;

    PROCEDURE c06_ahs_add_history (
        vahsid       IN NUMBER,
        vnguoithuhoi IN VARCHAR2,
        vnoidung     IN VARCHAR2,
        vlydo        IN VARCHAR2,
        vBiCanId in number,
        vVuAnId in number,
        vAction_Type in varchar2
    ) AS
    BEGIN

-- insert vao history
        INSERT INTO c06_toaan_hinhsu_history (
            id,
            lydo_thuhoi,
            noidung,
            c06_ahs_id,
            nguoithuhoi,
            ngaythuhoi,
            VUANID,
            BICANID,
            ACTION_TYPE
        ) VALUES ( c06_toaan_hinhsu_history_seq.NEXTVAL,
                   vlydo,
                   vnoidung,
                   vahsid,
                   vnguoithuhoi,
                   sysdate, vVuAnId,vBiCanId,vAction_Type   );

    END;

    PROCEDURE c06_ahs_sotham_hinhphat_th_getbyid (
        vbicanid  IN NUMBER,
        curreturn OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                                                  a.*,
                                                  a.hinhphatid mahinhphat,
                                                  b.tenhinhphat
                                              FROM
                                                  ahs_sotham_banan_dieu_tonghop a
                                                  LEFT JOIN dm_hinhphat                   b ON b.id = a.hinhphatid
                           WHERE
                                   a.bicanid = vbicanid
                               AND a.ismain = 1;

    END;

    PROCEDURE c06_ahs_hinhphat_tonghop_getbyid (
        vbicanid  IN NUMBER,
        curreturn OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                                                  a.*
                                                  --a.hinhphatid AS mahinhphat,
                                                  --d.tenhinhphat
                                              FROM
                                                  ahs_tonghophinhphat a
                                                  --LEFT JOIN dm_hinhphat                   d ON d.id = a.hinhphatid
                           WHERE
                               a.bicaoid = vbicanid;

    END;

    PROCEDURE c06_ahs_hinhphat_getbyid (
        vbicanid    IN NUMBER,
        v_capxx     IN VARCHAR2,
        v_loaiba_qd IN VARCHAR2,
        v_ismain    IN VARCHAR2,
        curreturn   OUT SYS_REFCURSOR
    ) AS
        v_quyetdinhid NUMBER;
    BEGIN
        CASE
            WHEN v_capxx = 'SO_THAM' THEN -- nếu là sơ thẩm
                if v_ismain = '1' then -- nếu lấy hình phạt chính thì lấy ở điều tổng hợp

                OPEN curreturn FOR SELECT
                                                          dm.*,
                                                          asbdc.*
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet asbdc

                                               -- inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                               -- inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                          INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                   WHERE
                                           asbdc.bicanid = vbicanid
                                       AND asbdc.ischange = '0';
                else -- lấy hình phạt bổ sung v_ismain = 0 -- lấy ở điều chi tiết
                OPEN curreturn FOR SELECT
                                                          dm.*,
                                                          asbdc.*
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet asbdc

                                               -- inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                               -- inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                          INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                   WHERE
                                           asbdc.bicanid = vbicanid
                                       AND (v_ismain = '0' and asbdc.ischange = '1'); --v_ismain = 1 lấy hình phạt chính, v_ismain = 0 bô sung = 0
                 end if;   

            ELSE
                IF ( v_loaiba_qd = '1' ) THEN -- là bản án
         -- Kiểm tra quyetdinhid
                    SELECT
                        a.ketquaphucthamid
                    INTO v_quyetdinhid
                    FROM
                             ahs_phuctham_banan a
                        INNER JOIN ahs_phuctham_banan_bicao b ON b.bananid = a.id
                    WHERE
                        b.bicaoid = vbicanid;

                    IF ( v_quyetdinhid = 1 )  -- nếu giữ nguyên thì lấy ở sơ thẩm

                     THEN
                     if v_ismain = '1' then -- nếu lấy hình phạt chính thì lấy ở điều tổng hợp
                      OPEN curreturn FOR SELECT
                                                          dm.*,
                                                          asbdc.*
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet asbdc

                                               -- inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                               -- inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                          INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                   WHERE
                                           asbdc.bicanid = vbicanid
                                       AND asbdc.ischange = '0';
                     else -- lấy hình phạt bổ sung v_ismain = 0 -- lấy ở điều chi tiết
                        OPEN curreturn FOR SELECT
                                                                  dm.*,
                                                                  asbdc.*
                                                              FROM
                                                                       ahs_sotham_banan_dieu_chitiet asbdc

                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                                --inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                                --inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                                  INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                           WHERE
                                                   asbdc.bicanid = vbicanid
                                               AND   (v_ismain = '0' and asbdc.ischange = '1');
                                               end if;
                    ELSE -- không thì lấy ở phúc thẩm
                        OPEN curreturn FOR SELECT
                                                                  dm.*,
                                                                  asbdc.*
                                                              FROM
                                                                       ahs_phuctham_banan_dieu_ct asbdc

                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                                --inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                                --inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                                  INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                           WHERE
                                                   asbdc.bicanid = vbicanid
                                               AND ((v_ismain = '1' and  asbdc.ischange = '0' and hinhphatid <> 0) or (v_ismain = '0' and asbdc.ischange = '1')); -- lấy hình phạt chính v_ismain = 1 or bổ sung = 0;
                    END IF;

                ELSE -- nếu là quyết định lấy ở sơ thẩm
                    if v_ismain = '1' then -- nếu lấy hình phạt chính thì lấy ở điều tổng hợp
                      OPEN curreturn FOR SELECT
                                                          dm.*,
                                                          asbdc.*
                                                      FROM
                                                               ahs_sotham_banan_dieu_chitiet asbdc

                                               -- inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                               -- inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                          INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                   WHERE
                                           asbdc.bicanid = vbicanid
                                       AND asbdc.ischange = '0';
                     else -- lấy hình phạt bổ sung v_ismain = 0 -- lấy ở điều chi tiết
                        OPEN curreturn FOR SELECT
                                                                  dm.*,
                                                                  asbdc.*
                                                              FROM
                                                                       ahs_sotham_banan_dieu_chitiet asbdc

                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                                --inner JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                                --inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                                                  INNER JOIN dm_hinhphat dm ON asbdc.hinhphatid = dm.id
                                           WHERE
                                                   asbdc.bicanid = vbicanid
                                               AND   (v_ismain = '0' and asbdc.ischange = '1');
                                               end if;
                END IF;
        END CASE;
    END;

    PROCEDURE c06_ahs_hinhphat_chinh_getbyid (
        vbicanid    IN NUMBER,
        v_capxx     IN VARCHAR2,
        v_loaiba_qd IN VARCHAR2,
        curreturn   OUT SYS_REFCURSOR
    ) AS
        v_quyetdinhid NUMBER;
    BEGIN
        OPEN curreturn FOR SELECT
                               1
                           FROM
                               dual;
--    case
--         when v_capxx = 'SO_THAM' then -- nếu là sơ thẩm
--         
--         OPEN curretun FOR SELECT dm.*
--                                            FROM
--                                                AHS_SOTHAM_BANAN_DIEU_CHITIET asbdc
--                                                
--                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
--                                                left JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
--                                                inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
--                                                inner join dm_hinhphat dm on abth.hinhphatid = dm.id
--                          WHERE
--                              asbdc.bicanid = vbicanid
--                              and asbdc.ismain = '1'; -- lấy hình phạt chính
--         
--         else
--         if (v_loaiba_qd = '1') then
--         -- Kiểm tra quyetdinhid
--         select a.ketquaphucthamid into  v_quyetdinhid from ahs_phuctham_banan a
--                    INNER JOIN ahs_phuctham_banan_bicao b ON b.bananid = a.id where b.BICAOID = vbicanid;
--         if( v_quyetdinhid = 1)  -- nếu giữ nguyên thì lấy ở sơ thẩm
--         then
--          OPEN curretun FOR SELECT dm.*
--                                            FROM
--                                                AHS_SOTHAM_BANAN_DIEU_CHITIET asbdc
--                                                
--                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
--                                                left JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
--                                                inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
--                                                inner join dm_hinhphat dm on abth.hinhphatid = dm.id
--                          WHERE
--                              asbdc.bicanid = vbicanid
--                              and asbdc.ismain = '1'; -- lấy hình phạt chính
--         
--         else -- không thì lấy ở phúc thẩm
--          OPEN curretun FOR 
--         SELECT dm.*
--                                                
--                                               
--                                            FROM
--                                                AHS_PHUCTHAM_BANAN_DIEU_CT asbdc
--                                                
--                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
--                                                left JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
--                                                inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
--                                                inner join dm_hinhphat dm on abth.hinhphatid = dm.id
--                          WHERE
--                              asbdc.bicanid = vbicanid
--                              and asbdc.ismain = '1'; -- lấy hình phạt chính;
--         end if;
--         else -- nếu là quyết định lấy ở sơ thẩm
--          OPEN curretun FOR SELECT dm.*
--                                            FROM
--                                                AHS_SOTHAM_BANAN_DIEU_CHITIET asbdc
--                                                
--                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
--                                                left JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
--                                                inner JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
--                                                inner join dm_hinhphat dm on abth.hinhphatid = dm.id
--                          WHERE
--                              asbdc.bicanid = vbicanid
--                              and asbdc.ismain = '1'; -- lấy hình phạt chính
--         end if;
--         end case;
    END;

    PROCEDURE c06_ahs_hinhphat_bosung_getbyid (
        vbicanid    IN NUMBER,
        v_capxx     IN VARCHAR2,
        v_loaiba_qd IN VARCHAR,
        curreturn   OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                                                  a.*,
                                                  d.mahinhphat,
                                                  d.tenhinhphat
                                              FROM
                                                  ahs_sotham_banan_dieu_chitiet a
                                                  LEFT JOIN dm_hinhphat                   d ON d.id = a.hinhphatid
                           WHERE
                                   a.bicanid = vbicanid
                               AND a.ismain <> 1;

    END;

    PROCEDURE c06_ahs_search_chuadongbo (
        v_loaian_id     IN VARCHAR2,
        v_loaibaqd      IN VARCHAR2,
        v_toaan_id      IN VARCHAR2,
        v_capxx         IN VARCHAR2,
        v_ten_vu_an     IN VARCHAR2,
        v_toidanh       IN VARCHAR2,
        v_ma_vu_an      IN VARCHAR2,
        v_bi_can        IN VARCHAR2,
        v_cccd          IN VARCHAR2,
        v_so_qd         IN VARCHAR2,
        v_tungay        IN VARCHAR2,
        v_denngay       IN VARCHAR2,
        v_thamphan_id   IN VARCHAR2,
        v_thuky_id      IN VARCHAR2,
        v_trangthai_gui IN VARCHAR2,
        v_ngaygui_tu    IN VARCHAR2,
        v_ngaygui_den   IN VARCHAR2,
        page_index      IN INT,
        page_size       IN INT,
        curreturn       OUT SYS_REFCURSOR
    ) AS
        totalitem NUMBER;
        minindex  NUMBER;
        maxindex  NUMBER;
    BEGIN
---------------------------------------
        minindex := page_size * ( page_index - 1 ) + 1;
        maxindex := page_index * page_size;
        OPEN curreturn FOR SELECT
                                                  tt.*
                                              FROM
                                                  (
                                                      SELECT
                                                          ROW_NUMBER()
                                                          OVER(
                                                              ORDER BY
                                                                  a.ngaytao DESC
                                                          )      stt,
                                                          COUNT(*)
                                                          OVER() AS countall,
                                                          a.*
                                                      FROM
                                                          (
                                                      -------- TH1: Lay ban an so tham 
                                                              SELECT DISTINCT
                                                                  va.id                                 AS vuanid,
                                                                  c.id as C06_AHS_ID,
                                                                  bc.id                                        AS bicaoid,
                                                                  bc.hoten                                     AS bican_ten,
                                                                  to_char(bc.ngaysinh, 'dd/MM/yyyy')           AS bican_ngaysinh,
                                                                  bc.so_cccd                                  AS bican_so_cccd,
                                                                  bc.socmnd                                    AS bican_socmnd,
                                                                  asbb.ngaynhanbanan                           AS bican_ngaynhanba,
                                                                  to_char(asbb.ngayhieulucbanan, 'dd/MM/yyyy') AS bican_ngayhieuluc,
                                                                  ba.sobanan                                   AS banan_so_ban_an,
                                                                  to_char(ba.ngaybanan, 'dd/MM/yyyy')          AS banan_ngay_ba,
                                                                  dc.id                                        AS thamphanid,
                                                                  dc.hoten                                     AS thamphan_ten,
                                                                  '1'                                          AS loaian_id,
                                                                  'Hình Sự'                                    AS loai_an_ten,
                                                                  '1'                                          AS loaibaqd,  --Ban an = 1
                                                                  ba.id                                        AS baqd_id,
                                                                  thhp.tentoidanh_st                           tentoidanh,
                                                                  to_char(thhp.hinhphat_st)                     AS tenhinhphat,
                                                                  to_char(va.mavuan)                           AS mavuan,
                                                                  va.tenvuan,
                                                                  decode(ast.truonghopthuly, 1777, 'Thụ lý xét xử lại do GDT hủy', 236
                                                                  , 'Thụ lý xét xử lại do PT hủy',
                                                                         235, 'Thụ lý từ tòa án khác chuyển đến', 234, 'Tóa án trả hồ sơ -VKS không chấp nhận điều tra bổ sung'
                                                                         , 233,
                                                                         'Viện kiểm sát truy tố lần đầu', 'Thụ lý mới')
                                                                  || ' - số '
                                                                  || ast.sothuly
                                                                  || ' ngày '
                                                                  || to_char(ast.ngaythuly, 'dd/MM/yyyy')      AS thuly,
                                                                  'SO_THAM'                                    AS capxx_ma,
                                                                  'Sơ Thẩm'                                    AS capxx,
                                                                  bc.xacthuc_dldcqg,
                                                                  TO_CHAR(va.ngaytao,'dd/MM/yyyy') as NgayTao,
                                                                  ba.nguoitao,
                                                                  'Chưa đồng bộ'                               AS trangthaibanghi,
                                                                  'CDB' as ma_trangthaibanghi,
                                                                 -- c.ghichu,
                                                                   ''                       AS ghichu,
                                                                ''                      AS nguoithuhoi,
                                                                '' AS ngaythuhoi,

                                                                to_char(c.ngaydongbo, 'dd/MM/yyyy')  AS ngaydongbo,
                                                                c.taikhoangui                        AS taikhoangui,
                                                                to_char(c.ngaygui, 'dd/MM/yyyy')     AS ngaygui,
                                                                  c.taikhoangui as nguoigui

                                                              FROM
                                                                       ahs_bicanbicao bc

                                                                  INNER JOIN ahs_sotham_banan_bicao        asbb ON bc.id = asbb.bicaoid
                                                                  INNER JOIN ahs_vuan                      va ON bc.vuanid = va.id
                                                                  INNER JOIN dm_toaan                      dm ON dm.id = va.toaanid
                                                                  INNER JOIN ahs_sotham_banan              ba ON ba.vuanid = va.id
                                                                  INNER JOIN ahs_sotham_hdxx               ashxx ON ashxx.vuanid = va.id
                                                                  INNER JOIN ahs_sotham_thuly              ast ON va.id = ast.vuanid
                                                                  INNER JOIN ahs_thamphangiaiquyet         atpgq ON atpgq.vuanid = va.id and atpgq.mavaitro ='VTTP_GIAIQUYETSOTHAM'
                                                                  LEFT JOIN ahs_tonghophinhphat           thhp ON thhp.bicaoid = bc.id
                                                                                                        AND thhp.vuanid = va.id
                                                                  inner JOIN ahs_sotham_banan_dieu_chitiet asbdc ON asbdc.bicanid = bc.id and asbdc.vuanid = va.id
                                                                 -- LEFT JOIN ahs_sotham_banan_dieu_tonghop asbdt ON asbdt.bicanid = bc.id -- join voi bang dieu_tonghop
                                                                  --left JOIN dm_boluat_toidanh_hinhphat    abth ON abth.toidanhid = asbdc.toidanhid
                                                                  --left JOIN dm_boluat_toidanh             dmbt ON dmbt.id = abth.toidanhid
                                                                  inner JOIN dm_hinhphat                   dhp ON dhp.id = asbdc.hinhphatid and asbdc.ischange = '0'
                                                                  LEFT JOIN dm_canbo                      dc ON dc.id = atpgq.canboid
                                --left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                                                                  LEFT JOIN c06_toaan_hinhsu              c ON c.bicanid = bc.id
                                                                                                  AND c.bqd = 1
                                                                                                  AND c.vuanid = va.id
                                                                                                  AND c.status = '1'
                                                                                                  AND c.capxx = 'SO_THAM'
                                                              WHERE
                                                                      1 = 1
                                -- Ngày hiệu lực của BA hoặc QĐ
                                                                  AND asbb.ngayhieulucbanan IS NOT NULL
                                -- thêm điều kiện khác các loại hành phạt canh cao, khien trach theo logi
                                                                  AND  (( dhp.mahinhphat IS NOT NULL
                                                                             AND dhp.mahinhphat NOT IN ( 'CANHCAO', 'KHIENTRACH', 'KCT_KCTTP'
                                                                             , 'KCT_CSPL', 'KHONGCOTOI',
                                                                                                         'MIENTNHS' ) -- 01/10/25 them mienhinhphat duoc dong bo
                                                                                                          ))
                                --kiểm tra tình trạng xác thực c06
                                                                  AND (bc.xacthuc_dldcqg != '0' and bc.xacthuc_dldcqg is not null) -- nếu chưa xác thực thì không lấy
                                -- xử lý logic nếu có kháng cáo  thì không đồng bộ
                                                                  AND NOT EXISTS (
                                                                      SELECT
                                                                          1
                                                                      FROM
                                                                          ahs_sotham_khangcao bck
                                                                      WHERE
                                                                              bck.vuanid = va.id
                                                                              and bck.NGUOIKCID = bc.id
                                                                          AND NOT EXISTS (
                                                                              SELECT
                                                                                  1
                                                                              FROM
                                                                                  ahs_sotham_rutkhangcao cck
                                                                              WHERE
                                                                                  cck.khangcaoid = bck.id
                                                                          ) -- nếu rút kháng cáo thì đồng bộ
                                                                          AND NOT EXISTS (
                                                                   --- Nếu có kháng nghị thì không đồng bộ 
                                                                              SELECT
                                                                                  1
                                                                              FROM
                                                                                  ahs_sotham_khangnghi bnck
                                                                              WHERE
                                                                                      bnck.vuanid = va.id
                                                                                      AND INSTR(',' || bnck.DSNGUOIBIKN || ',', ',' || bc.id || ',') > 0
                                                                                  AND NOT EXISTS (
                                                                                      SELECT
                                                                                          1
                                                                                      FROM
                                                                                          ahs_sotham_rutkhangnghi cnck
                                                                                      WHERE
                                                                                          cnck.khangnghiid = bnck.id
                                                                                  )
                                                                          )
                                                                  ) -- nếu rút kháng nghi thì đồng bộ
                                -- Chua dong bo sang C06--
                                                                  AND c.id IS NULL
                                                                  AND va.toaanid = v_toaan_id
                                                              UNION
                                                            -------- TH2: Lay ban an phuc tham
                                                              SELECT
                                                                 va.id                                 AS vuanid,
                                                                  c.id as C06_AHS_ID,
                                                                  bc.id                                   AS bicaoid,
                                                                  bc.hoten                                AS bican_ten,
                                                                  to_char(bc.ngaysinh, 'dd/MM/yyyy')      AS bican_ngaysinh,
                                                                  bc.so_cccd                             AS bican_so_cccd,
                                                                  bc.socmnd                               AS bican_socmnd,
                                                                  apb.ngaybanan                           AS bican_ngaynhanba,
                                                                  /*CASE apb.ketquaphucthamid
                                                                      WHEN 1 THEN
                                                                          (
                                                                              SELECT
                                                                                  to_char(st_bc.ngayhieulucbanan, 'dd/MM/yyyy')
                                                                              FROM
                                                                                  ahs_sotham_banan_bicao st_bc
                                                                              WHERE
                                                                                  st_bc.bicaoid = bc.id
                                                                          )
                                                                      ELSE

                                                                  END*/
                                                                  to_char(apb.ngaybanan, 'dd/MM/yyyy')    AS bican_ngayhieuluc,
                                                                  apb.sobanan                             AS banan_so_ban_an,
                                                                  to_char(apb.ngaybanan, 'dd/MM/yyyy')    AS banan_ngay_ba,
                                                                  dc.id                                   AS thamphanid,
                                                                  dc.hoten                                AS thamphan_ten,
                                                                  '1'                                     AS loaian_id,
                                                                  'Hình Sự'                               AS loai_an_ten,
                                                                  '1'                                     AS loaibaqd, --Ban an = 1
                                                                  apb.id                                  AS baqd_id,
                                                                  -- lấy tên tội danh
                                                                  CASE
                                                                      WHEN apb.ketquaphucthamid = 1 THEN
                                                                          (
                                                                              SELECT
                                                                                  to_char(tentoidanh_st)
                                                                              FROM
                                                                                  ahs_tonghophinhphat
                                                                              WHERE
                                                                                      bicaoid = bc.id
                                                                                  AND vuanid = va.id
                                                                          ) -- Nếu giữ nguyên thì lấy ở sơ thẩm 
                                                                      WHEN apb.ketquaphucthamid IN ( 2,4,49,21,64,65 ) -- Nếu có sửa đổi và có kháng cáo thì lấy ở sơ thẩm 
                                                                           AND NOT EXISTS (
                                                                          SELECT
                                                                              1
                                                                          FROM
                                                                                   ahs_sotham_khangcao a
                                                                              INNER JOIN ahs_sotham_rutkhangcao b ON a.id = b.khangcaoid
                                                                          WHERE
                                                                              a.nguoikcid = bc.id
                                                                      ) THEN
                                                                          (
                                                                              SELECT
                                                                                  to_char(tentoidanh_pt)
                                                                              FROM
                                                                                  ahs_tonghophinhphat
                                                                              WHERE
                                                                                      bicaoid = bc.id
                                                                                  AND vuanid = va.id
                                                                          -- Nếu giữ nguyên thì lấy ở sơ thẩm 
                                                                          )
                                                                      ELSE
                                                                          (
                                                                              SELECT
                                                                                  to_char(tentoidanh_pt)
                                                                              FROM
                                                                                  ahs_tonghophinhphat
                                                                              WHERE
                                                                                      bicaoid = bc.id
                                                                                  AND vuanid = va.id
                                                                          ) -- Không thì lấy ở phúc thẩm    
                                                                  END                                     AS tentoidanh,
                                                                  -- Lấy tên hình phạt
                                                                  CASE
                                                                      WHEN apb.ketquaphucthamid = 1 THEN
                                                                          (
                                                                              SELECT
                                                                                  to_char(hinhphat_st)
                                                                              FROM
                                                                                  ahs_tonghophinhphat
                                                                              WHERE
                                                                                      bicaoid = bc.id
                                                                                  AND vuanid = va.id
                                                                          ) -- Nếu giữ nguyên thì lấy ở sơ thẩm 
                                                                      WHEN apb.ketquaphucthamid IN ( 2,4,49,21, 64,65) -- Nếu có sửa đổi và có kháng cáo thì lấy ở sơ thẩm 
                                                                           AND NOT EXISTS (
                                                                          SELECT
                                                                              1
                                                                          FROM
                                                                                   ahs_sotham_khangcao a
                                                                              INNER JOIN ahs_sotham_rutkhangcao b ON a.id = b.khangcaoid
                                                                          WHERE
                                                                              a.nguoikcid = bc.id
                                                                      ) THEN
                                                                          (
                                                                              SELECT
                                                                                  to_char(hinhphat_pt)
                                                                              FROM
                                                                                  ahs_tonghophinhphat
                                                                              WHERE
                                                                                      bicaoid = bc.id
                                                                                  AND vuanid = va.id
                                                                          -- Nếu giữ nguyên thì lấy ở sơ thẩm 
                                                                          )
                                                                      ELSE
                                                                          (
                                                                              SELECT
                                                                                  to_char(hinhphat_pt)
                                                                              FROM
                                                                                  ahs_tonghophinhphat
                                                                              WHERE
                                                                                      bicaoid = bc.id
                                                                                  AND vuanid = va.id
                                                                          ) -- Không thì lấy ở phúc thẩm    
                                                                  END                                     AS tenhinhphat,
                                                                  to_char(va.mavuan)                      AS mavuan,
                                                                  va.tenvuan,
                                                                  decode(ast.truonghopthuly, 1079, 'Do có kháng cáo và kháng nghị phúc thẩm'
                                                                  , 1078, 'Do có kháng nghị phúc thẩm',
                                                                         998, 'Giám đốc thẩm hủy để xét xử lại phúc thẩm', 1058, 'Do có kháng cáo phúc thẩm'
                                                                         , 'Thụ lý mới')
                                                                  || ' - số '
                                                                  || ast.sothuly
                                                                  || ' ngày '
                                                                  || to_char(ast.ngaythuly, 'dd/MM/yyyy') AS thuly,
                                                                  'PHUC_THAM'                             AS capxx_ma,
                                                                  'Phúc Thẩm'                             AS capxx,
                                                                  bc.xacthuc_dldcqg,
                                                                  TO_CHAR(apb.ngaytao,'dd/MM/yyyy') as NgayTao,
                                                                  apb.nguoitao,
                                                                  'Chưa đồng bộ'                          AS trangthaibanghi,
                                                                  'CDB' as ma_trangthaibanghi,
                                                                 -- c.ghichu,
                                                                  ''                    AS ghichu,
                                                                ''                       AS nguoithuhoi,
                                                                '' AS ngaythuhoi,

                                                                to_char(c.ngaydongbo, 'dd/MM/yyyy')  AS ngaydongbo,
                                                                c.taikhoangui                        AS taikhoangui,
                                                                to_char(c.ngaygui, 'dd/MM/yyyy')     AS ngaygui,
                                                                  c.taikhoangui as nguoigui
                                                              FROM
                                                                       ahs_phuctham_banan apb
                                                                  INNER JOIN ahs_vuan                 va ON apb.vuanid = va.id
                                                                  INNER JOIN ahs_phuctham_banan_bicao apbb ON apbb.bananid = apb.id
                                                                  INNER JOIN ahs_bicanbicao           bc ON apbb.bicaoid = bc.id

                                                                  INNER JOIN ahs_phuctham_hdxx        ashxx ON ashxx.vuanid = va.id
                                                                  INNER JOIN ahs_phuctham_thuly       ast ON va.id = ast.vuanid
                                                                 -- LEFT JOIN ahs_tonghophinhphat        athp ON athp.bicaoid = bc.id 
                                                                  INNER JOIN ahs_thamphangiaiquyet    atpgq ON atpgq.vuanid = va.id
                                                                                                            AND atpgq.thukyid <> 0
                                                                                                            AND atpgq.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                                                  --INNER JOIN ahs_phuctham_banan_dieu_ct apbdc ON athp.bicaoid = apbdc.bicanid
                                                               --   INNER JOIN dm_hinhphat                dhp ON apbdc.hinhphatid = dhp.id
                                                                  LEFT JOIN dm_canbo                 dc ON dc.id = atpgq.canboid
                                                                  LEFT JOIN c06_toaan_hinhsu         c ON c.bicanid = bc.id and c.vuanid = va.id
                                                                                                  AND c.bqd = 1
                                                                                                  AND c.status = '1'
                                                                                                  AND c.capxx = 'PHUC_THAM'
                                                              WHERE
                                                                      apb.toaanid = v_toaan_id
                                                                  --AND athp.toaanid_pt = v_toaan_id

                                                                  AND ( ( apb.ketquaphucthamid = 1 ) -- Trường hợp Giữ nguyên bản án/quyết định sơ thẩm
                                                                        OR (  apb.ketquaphucthamid IN ( 2,4,49,21,65,64) -- Trường hợp sửa đổi bản án kiem tra danh mục hinh phat
                                                                               AND  EXISTS (
                                                                      SELECT
                                                                          1
                                                                      FROM
                                                                               ahs_tonghophinhphat a
                                                                          INNER JOIN ahs_phuctham_banan_dieu_ct b ON a.bicaoid = b.bicanid
                                                                          INNER JOIN dm_hinhphat                c ON b.hinhphatid = c.id
                                                                      WHERE
                                                                              a.bicaoid = bc.id
                                                                          AND a.vuanid = va.id
                                                                          AND c.mahinhphat NOT IN ( 'CANHCAO', 'KHIENTRACH', 'KCT_KCTTP'
                                                                          , 'KCT_CSPL', 'KHONGCOTOI',
                                                                                                    'MIENTNHS' ) -- 01/10/25 them mienhinhphat duoc dong bo
                                                                          --AND a.toaanid_pt = v_toaan_id
                                                                          AND b.hinhphatid <> 0
                                                                  ) )  )

                                --kiểm tra tình trạng xác thực c06
                                                                  AND bc.xacthuc_dldcqg != '0' and bc.xacthuc_dldcqg is not null -- nếu chưa xác thực thì không lấy
                                -- Chua dong bo sang C06--
                                                                  AND c.id IS NULL
                                                                  AND EXISTS (
                                                                      SELECT
                                                                          1
                                                                      FROM
                                                                          ahs_sotham_khangcao bck
                                                                      WHERE
                                                                              bck.vuanid = va.id
                                                                              and bck.NGUOIKCID = bc.id
                                                                          AND not EXISTS (
                                                                              SELECT
                                                                                  1
                                                                              FROM
                                                                                  ahs_sotham_rutkhangcao cck
                                                                              WHERE
                                                                                  cck.khangcaoid = bck.id and
                                                                                  cck.TINHTRANG = 2
                                                                          ) -- nếu rút kháng cáo thì đồng bộ
                                                                          AND not EXISTS (
                                                                   --- Nếu có kháng nghị thì không đồng bộ 
                                                                              SELECT
                                                                                  1
                                                                              FROM
                                                                                  ahs_sotham_khangnghi bnck
                                                                              WHERE
                                                                                      bnck.vuanid = va.id
                                                                                      AND INSTR(',' || bnck.DSNGUOIBIKN || ',', ',' || bc.id || ',') > 0
                                                                                  AND EXISTS (
                                                                                      SELECT
                                                                                          1
                                                                                      FROM
                                                                                          ahs_sotham_rutkhangnghi cnck
                                                                                      WHERE
                                                                                          cnck.khangnghiid = bnck.id and
                                                                                          cnck.TINHTRANG = 2
                                                                                  )
                                                                          )
                                                                  )
                                                                  -------- TH3: Lay QUYẾT ĐỊNH PT
                                                              UNION
                                                              SELECT
                                                                  va.id                                 AS vuanid,
                                                                  c.id as C06_AHS_ID,
                                                                  bc.id                                        AS bicaoid,
                                                                  bc.hoten                                     AS bican_ten,
                                                                  to_char(bc.ngaysinh, 'dd/MM/yyyy')           AS bican_ngaysinh,
                                                                  bc.so_cccd                                  AS bican_so_cccd,
                                                                  bc.socmnd                                    AS bican_socmnd,
                                                                  asbb.ngayhieulucbanan                        AS bican_ngaynhanba,
                                                                  to_char(apb.ngayqd, 'dd/MM/yyyy') AS bican_ngayhieuluc,
                                                                  apb.soquyetdinh                              AS banan_so_ban_an,
                                                                  to_char(apb.ngayqd, 'dd/MM/yyyy') AS banan_ngay_ba,
                                                                  dc.id                                        AS thamphanid,
                                                                  dc.hoten                                     AS thamphan_ten,
                                                                  '1'                                          AS loaian_id,
                                                                  'Hình Sự'                                    AS loai_an_ten,
                                                                  '2'                                          AS loaibaqd, -- Quyết định = 2
                                                                  apb.id                                       AS baqd_id,
                                                                  athp.tentoidanh_st                           AS tentoidanh, -- lấy tội danh ở bản án sơ thẩm
                                                                   athp.hinhphat_st                      AS tenhinhphat, -- lấy hình phạt ở bản án sơ thẩm
                                                                  to_char(va.mavuan)                           AS mavuan,
                                                                  va.tenvuan,
                                                                  decode(ast.truonghopthuly, 1079, 'Do có kháng cáo và kháng nghị phúc thẩm'
                                                                  , 1078, 'Do có kháng nghị phúc thẩm',
                                                                         998, 'Giám đốc thẩm hủy để xét xử lại phúc thẩm', 1058, 'Do có kháng cáo phúc thẩm'
                                                                         , 'Thụ lý mới')
                                                                  || ' - số '
                                                                  || ast.sothuly
                                                                  || ' ngày '
                                                                  || to_char(ast.ngaythuly, 'dd/MM/yyyy')      AS thuly,
                                                                  'PHUC_THAM'                                  AS capxx_ma,
                                                                  'Phúc Thẩm'                                  AS capxx,
                                                                  bc.xacthuc_dldcqg,
                                                                  apb.nguoitao,
                                                                  TO_CHAR(apb.ngaytao,'dd/MM/yyyy') as NgayTao,
                                                                  'Chưa đồng bộ'                               AS trangthaibanghi,
                                                                  'CDB' as ma_trangthaibanghi,
                                                                  --c.ghichu,
                                                                  ''                       AS ghichu,
                                                                ''                       AS nguoithuhoi,
                                                                '' AS ngaythuhoi,

                                                                to_char(c.ngaydongbo, 'dd/MM/yyyy')  AS ngaydongbo,
                                                                c.taikhoangui                        AS taikhoangui,
                                                                to_char(c.ngaygui, 'dd/MM/yyyy')     AS ngaygui,
                                                                  c.taikhoangui as nguoigui
                                                              FROM
                                                                       ahs_phuctham_quyetdinh_vuan apb
                                                                  INNER JOIN ahs_vuan                      va ON apb.vuanid = va.id
                                                                 -- INNER JOIN ahs_phuctham_quyetdinh_bican  apbb ON apbb.vuanid = apb.id
                                                                  INNER JOIN ahs_bicanbicao                bc ON bc.vuanid = va.id

                                                                  INNER JOIN ahs_sotham_banan_bicao        asbb ON bc.id = asbb.bicaoid
                                                                  INNER JOIN ahs_phuctham_hdxx             ashxx ON ashxx.vuanid = va.id
                                                                  INNER JOIN ahs_phuctham_thuly            ast ON va.id = ast.vuanid
                                                                  LEFT JOIN ahs_tonghophinhphat           athp ON athp.bicaoid = bc.id
                                                                                                        AND athp.vuanid = va.id
                                                                  INNER JOIN ahs_thamphangiaiquyet         atpgq ON atpgq.vuanid = va.id
                                                                --  INNER JOIN ahs_sotham_banan_dieu_tonghop apbdc ON athp.bicaoid = apbdc.bicanid
                                                                --  INNER JOIN dm_hinhphat                   dhp ON apbdc.hinhphatid = dhp.id
                                                                  LEFT JOIN dm_canbo                      dc ON dc.id = atpgq.canboid
                                                                  LEFT JOIN c06_toaan_hinhsu              c ON c.bicanid = bc.id and c.vuanid = va.id
                                                                                                  AND c.bqd = 2
                                                                                                  AND c.status = '1'
                                                                                                  AND c.capxx = 'PHUC_THAM'
                                                              WHERE
                                                                      1 = 1
                                                                  AND apb.quyetdinhid IN ( 127, 203 ) -- id quyết dịnh  Quyết định đình chỉ việc xét xử phúc thẩm (dùng cho Thẩm phán chủ tọa phiên tòa)/Quyết định đình chỉ việc xét xử phúc thẩm (dùng cho Hội đồng xét xử)
                                                                 -- and apb.TOA_GIAIQUYET_ID = 25
                                                                  AND ashxx.TOA_GIAIQUYET_ID = v_toaan_id
                                                                  AND atpgq.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM'
                                                                  --kiểm tra tình trạng xác thực c06
                                                                  AND bc.xacthuc_dldcqg != '0' and bc.xacthuc_dldcqg is not null -- nếu chưa xác thực thì không lấy
                                                                  AND c.id IS NULL
                                                                  AND EXISTS (
                                                                      SELECT
                                                                          1
                                                                      FROM
                                                                          ahs_sotham_khangcao bck
                                                                      WHERE
                                                                              bck.vuanid = va.id
                                                                              and bck.NGUOIKCID = bc.id
                                                                          AND not EXISTS (
                                                                              SELECT
                                                                                  1
                                                                              FROM
                                                                                  ahs_sotham_rutkhangcao cck
                                                                              WHERE
                                                                                  cck.khangcaoid = bck.id and
                                                                                  cck.TINHTRANG = 2
                                                                          ) -- nếu rút kháng cáo thì đồng bộ
                                                                          AND not EXISTS (
                                                                   --- Nếu có kháng nghị thì không đồng bộ 
                                                                              SELECT
                                                                                  1
                                                                              FROM
                                                                                  ahs_sotham_khangnghi bnck
                                                                              WHERE
                                                                                      bnck.vuanid = va.id
                                                                                      AND INSTR(',' || bnck.DSNGUOIBIKN || ',', ',' || bc.id || ',') > 0
                                                                                  AND EXISTS (
                                                                                      SELECT
                                                                                          1
                                                                                      FROM
                                                                                          ahs_sotham_rutkhangnghi cnck
                                                                                      WHERE
                                                                                          cnck.khangnghiid = bnck.id and
                                                                                          cnck.TINHTRANG = 2
                                                                                  )
                                                                          )
                                                                  )
                                                          ) a
                                                      WHERE
                                                          ( v_ten_vu_an IS NULL
                                                            OR a.tenvuan LIKE v_ten_vu_an || '%' )
                                                          AND ( v_ma_vu_an IS NULL
                                                                OR a.mavuan = v_ma_vu_an )
                                                          AND ( v_loaibaqd IS NULL
                                                                OR a.loaibaqd = v_loaibaqd )
                                                          AND ( v_capxx IS NULL
                                                                OR ( v_capxx = 2
                                                                     AND a.capxx_ma = 'SO_THAM' )
                                                                OR ( v_capxx = 3
                                                                     AND a.capxx_ma = 'PHUC_THAM' ) )
                                                          AND ( v_bi_can IS NULL
                                                                OR a.bican_ten = v_bi_can )
                                                          AND ( v_cccd IS NULL
                                                                OR a.bican_so_cccd = v_cccd )
                                                          AND ( v_so_qd IS NULL
                                                                OR a.banan_so_ban_an = v_so_qd )
                                                          AND ( v_tungay IS NULL
                                                                OR TO_DATE(a.banan_ngay_ba, 'dd/MM/yyyy') >= to_date(v_tungay,'dd/MM/yyyy') )
                                                          AND ( v_denngay IS NULL
                                                                OR TO_DATE(a.banan_ngay_ba, 'dd/MM/yyyy') <= to_date(v_denngay,'dd/MM/yyyy') )
                                                          AND ( v_toidanh IS NULL
                                                                OR ( fn_convert_to_vn(lower(a.tentoidanh)) LIKE '%'
                                                                                                                || fn_convert_to_vn(lower
                                                                                                                (v_toidanh))
                                                                                                                || '%' ) )--Quan hệ pháp luật tìm quan hệ pháp luật đã được gắn vào tên vụ án
                                                          AND ( v_thuky_id IS NULL
                                                                OR a.thamphanid = v_thuky_id )
                                                          AND ( v_thamphan_id IS NULL
                                                                OR a.thamphanid = v_thamphan_id )
                                                  ) tt
                           WHERE
                                   tt.stt >= minindex
                               AND tt.stt <= maxindex;

    END;

    PROCEDURE c06_ahs_search_dadongbo (
        v_loaian_id     IN VARCHAR2,
        v_toaan_id      IN VARCHAR2,
        v_capxx         IN VARCHAR2,
        v_ten_vu_an     IN VARCHAR2,
        v_toidanh       IN VARCHAR2,
        v_ma_vu_an      IN VARCHAR2,
        v_bi_can        IN VARCHAR2,
        v_cccd          IN VARCHAR2,
        v_so_qd         IN VARCHAR2,
        v_tungay        IN VARCHAR2,
        v_denngay       IN VARCHAR2,
        v_thamphan_id   IN VARCHAR2,
        v_thuky_id      IN VARCHAR2,
        v_trangthai_gui IN VARCHAR2,
        v_ngaygui_tu    IN VARCHAR2,
        v_ngaygui_den   IN VARCHAR2,
        page_index      IN INT,
        page_size       IN INT,
        curreturn       OUT SYS_REFCURSOR
    ) AS
        totalitem NUMBER;
        minindex  NUMBER;
        maxindex  NUMBER;
    BEGIN
        minindex := page_size * ( page_index - 1 ) + 1;
        maxindex := page_index * page_size;
        OPEN curreturn FOR SELECT
                                                  tt.*
                                              FROM
                                                  (
                                                      SELECT
                                                          ROW_NUMBER()
                                                          OVER(
                                                              ORDER BY
                                                                  a.ngaygui DESC
                                                          )      stt,
                                                          COUNT(*)
                                                          OVER() AS countall,
                                                          a.*
                                                      FROM
                                                          (
                                                              SELECT DISTINCT
                                                                  cth.id                                AS c06_ahs_id,
                                                                  bc.id                                 AS bicaoid,
                                                                  bc.hoten                              AS bican_ten,
                                                                  to_char(bc.ngaysinh, 'dd/MM/yyyy')    AS bican_ngaysinh,
                                                                  bc.so_cccd                           AS bican_so_cccd,
                                                                  bc.socmnd                             AS bican_socmnd,
                                                                 -- cth.ngayrabanan                           AS bican_ngaynhanba,
                                                                  cth.ngayhieulucba                     AS bican_ngayhieuluc,
                                                                  cth.sobananorqd                       AS banan_so_ban_an,
                                                                  cth.ngayrabanan                       AS banan_ngay_ba,
                                                                  dc.id                                 AS thamphanid,
                                                                  dc.hoten                              AS thamphan_ten,
                                                                  '1'                                   AS loaian_id,
                                                                  'Hình Sự'                             AS loai_an_ten,
                                                                  cth.bqd                               AS loaibaqd,
                                                                  cth.capxx                             AS capxx_ma,

                                                                  -- lấy tội danh theo cấp xét xử
                                                                  CASE
                                                                      WHEN cth.capxx = 'SO_THAM' THEN
                                                                          (
                                                                              SELECT
                                                                                  tentoidanh_st
                                                                              FROM
                                                                                  ahs_tonghophinhphat sa
                                                                              WHERE
                                                                                      sa.vuanid = va.id
                                                                                  AND sa.bicaoid = bc.id
                                                                          )
                                                                      ELSE
                                                                          CASE
                                                                          WHEN cth.BQD = '1' THEN -- Nếu là bản án thì lấy ở phúc thẩm
                                                                          (
                                                                              SELECT
                                                                                 COALESCE(sa.tentoidanh_pt, sa.tentoidanh_st)
                                                                              FROM
                                                                                  ahs_tonghophinhphat sa
                                                                              WHERE
                                                                                      sa.vuanid = va.id
                                                                                  AND sa.bicaoid = bc.id
                                                                          )
                                                                          ELSE -- Là quyết định thì lấy ở sơ thẩm
                                                                           (SELECT
                                                                                  tentoidanh_st
                                                                              FROM
                                                                                  ahs_tonghophinhphat sa
                                                                              WHERE
                                                                                      sa.vuanid = va.id
                                                                                  AND sa.bicaoid = bc.id)
                                                                          END 
                                                                  END                                   AS tentoidanh,
                                                                  -- Lấy hình phạt theo cấp xét xử
                                                                  cth.HINHPHAT_TH  AS tenhinhphat,
                                                                  to_char(va.mavuan)                    AS mavuan,
                                                                  va.id                                 AS vuanid,
                                                                  va.tenvuan,
                                                                  cth.thuly
                                                                  || ' - số '
                                                                  || 
                                                                  -- Lấy số thụ lý theo cấp xét xử
                                                                  CASE
                                                                      WHEN cth.capxx = 'SO_THAM' THEN
                                                                              sttl.sothuly
                                                                      ELSE
                                                                          pttl.sothuly
                                                                  END
                                                                  || ' ngày '
                                                                  || to_char(
                                                                      CASE
                                                                          WHEN cth.capxx = 'SO_THAM' THEN
                                                                              sttl.ngaythuly
                                                                          ELSE pttl.ngaythuly
                                                                      END, 'dd/MM/yyyy')                       AS thuly,
                                                                  CASE
                                                                      WHEN cth.capxx = 'SO_THAM' THEN
                                                                          'Sơ Thẩm'
                                                                      ELSE
                                                                          'Phúc thẩm'
                                                                  END                                   AS capxx,
                                                                  --'Sơ Thẩm'                               AS capxx,

                                                                  va.ngaytao,
                                                                  va.toaanid,
                                                                  'Đã đồng bộ'                          AS trangthaibanghi,
                                                                  'DDB' as ma_trangthaibanghi,
                                                                  cth.GHICHU                      AS ghichu,
                                                                  cth.NGUOITHUHOI                      AS nguoithuhoi,
                                                                to_char(cth.ngaythuhoi, 'dd/MM/yyyy') AS ngaythuhoi,
                                                              --  cth.ghichu                             AS ghichu,
                                                                to_char(cth.ngaydongbo, 'dd/MM/yyyy')  AS ngaydongbo,
                                                                cth.taikhoangui                        AS taikhoangui,
                                                                to_char(cth.ngaygui, 'dd/MM/yyyy')     AS ngaygui,
                                                                  cth.taikhoangui as nguoigui,
                                                                  atpgq.canboid                         AS canboid

                                                                  --cth.nguoidongbo

                                                              FROM
                                                                  c06_toaan_hinhsu         cth

                                                                 -- LEFT JOIN c06_toaan_hinhsu_history cthh ON cth.id = cthh.c06_ahs_id
                                                                  INNER JOIN ahs_bicanbicao           bc ON cth.bicanid = bc.id

                                                                  INNER JOIN ahs_vuan                 va ON bc.vuanid = va.id
                                                                  LEFT JOIN dm_toaan                 dm ON dm.id = va.toaanid
                                                                 -- INNER JOIN ahs_sotham_banan              ba ON ba.vuanid = va.id
                                                                  --INNER JOIN ahs_sotham_hdxx               ashxx ON ashxx.vuanid = va.id
                                                                  LEFT JOIN ahs_sotham_thuly         sttl ON va.id = sttl.vuanid
                                                                  LEFT JOIN ahs_phuctham_thuly       pttl ON pttl.vuanid = va.id
                                                                  LEFT JOIN ahs_thamphangiaiquyet    atpgq ON atpgq.vuanid = va.id
                                                                 -- INNER JOIN ahs_sotham_banan_dieu_chitiet asbdc ON asbdc.bicanid = bc.id
                                                                --  LEFT JOIN dm_boluat_toidanh_hinhphat    abth ON abth.toidanhid = asbdc.toidanhid
                                                                 -- LEFT JOIN dm_boluat_toidanh             dmbt ON dmbt.id = abth.toidanhid
                                                                 -- LEFT JOIN dm_hinhphat                   dhp ON dhp.id = abth.hinhphatid
                                                                  LEFT JOIN dm_canbo                 dc ON dc.id = atpgq.canboid
                                                              WHERE
                                                                      1 = 1
                                                                 -------- Bo sung logic lay ban an dong bo nha ----     
                                                                --  and cth.TRANGTHAIBANGHI = '1' --da dong bo
                                                                  AND cth.trangthaiahs = 'HIEU_LUC'
                                                                  --AND cth.trangthaijobshare = '0' --chưa đông bộ
                                                                --  AND asbdc.ismain = '1' -- lay hinh phat chinh
                                                                  AND ((cth.capxx = 'SO_THAM' and va.toaanid = v_toaan_id)
                                                                  or (cth.capxx = 'PHUC_THAM' and va.toaphucthamid = v_toaan_id))
                                                                  -- xử lý thêm tòa sơ thẩm và phúc thẩm
                                                                  AND ((cth.capxx = 'PHUC_THAM' and atpgq.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM')--AND atpgq.thukyid <> 0)
                                                                  or(cth.capxx = 'SO_THAM' and atpgq.mavaitro = 'VTTP_GIAIQUYETSOTHAM' )--AND atpgq.thukyid <> 0)
                                                                  )
                                                          ) a
                                                      WHERE
                                                          ( v_ten_vu_an IS NULL
                                                            OR a.tenvuan LIKE v_ten_vu_an || '%' )
                                                          AND ( v_ma_vu_an IS NULL
                                                                OR a.mavuan = v_ma_vu_an )
                                                          AND ( v_bi_can IS NULL
                                                                OR a.bican_ten = v_bi_can )
                                                          AND ( v_cccd IS NULL
                                                                OR a.bican_so_cccd = v_cccd )
                                                          AND ( v_so_qd IS NULL
                                                                OR a.banan_so_ban_an = v_so_qd )
                                                          AND ( v_capxx IS NULL
                                                                OR ( v_capxx = 2
                                                                     AND a.capxx_ma = 'SO_THAM' )
                                                                OR ( v_capxx = 3
                                                                     AND a.capxx_ma = 'PHUC_THAM' ) )
                                                          AND ( v_tungay IS NULL
                                                                OR TO_DATE(banan_ngay_ba, 'dd/MM/yyyy') >= v_tungay )
                                                          AND ( v_denngay IS NULL
                                                                OR TO_DATE(a.banan_ngay_ba, 'dd/MM/yyyy') <= v_denngay )
                                                          AND ( v_toidanh IS NULL
                                                                OR ( fn_convert_to_vn(lower(a.tentoidanh)) LIKE '%'
                                                                                                                || fn_convert_to_vn(lower
                                                                                                                (v_toidanh))
                                                                                                                || '%' ) )
                                                          AND ( v_thuky_id IS NULL
                                                                OR a.canboid = v_thuky_id )
                                                          AND ( v_thamphan_id IS NULL
                                                                OR a.canboid = v_thamphan_id )
                                                  ) tt
                           WHERE
                                   tt.stt >= minindex
                               AND tt.stt <= maxindex;

    END;

    PROCEDURE c06_ahs_search_thuhoi (
        v_loaian_id     IN VARCHAR2,
        v_toaan_id      IN VARCHAR2,
        v_capxx         IN VARCHAR2,
        v_ten_vu_an     IN VARCHAR2,
        v_toidanh       IN VARCHAR2,
        v_ma_vu_an      IN VARCHAR2,
        v_bi_can        IN VARCHAR2,
        v_cccd          IN VARCHAR2,
        v_so_qd         IN VARCHAR2,
        v_tungay        IN VARCHAR2,
        v_denngay       IN VARCHAR2,
        v_thamphan_id   IN VARCHAR2,
        v_thuky_id      IN VARCHAR2,
        v_trangthai_gui IN VARCHAR2,
        v_ngaygui_tu    IN VARCHAR2,
        v_ngaygui_den   IN VARCHAR2,
        page_index      IN INT,
        page_size       IN INT,
        curreturn       OUT SYS_REFCURSOR
    ) AS
        totalitem NUMBER;
        minindex  NUMBER;
        maxindex  NUMBER;
    BEGIN
        minindex := page_size * ( page_index - 1 ) + 1;
        maxindex := page_index * page_size;
        OPEN curreturn FOR SELECT
                               1
                           FROM
                               dual;

        OPEN curreturn FOR SELECT
                                                tt.*
                                            FROM
                                                (
                                                    SELECT
                                                        ROW_NUMBER()
                                                        OVER(
                                                            ORDER BY
                                                                a.ngaythuhoi DESC
                                                        )      stt,
                                                        COUNT(*)
                                                        OVER() AS countall,
                                                        a.*
                                                    FROM
                                                        (
                                                            SELECT
                                                                cth.id                                 AS c06_ahs_id,
                                                                bc.id                                  AS bicaoid,
                                                                bc.hoten                               AS bican_ten,
                                                                to_char(bc.ngaysinh, 'dd/MM/yyyy')     AS bican_ngaysinh,
                                                                bc.so_cccd                            AS bican_so_cccd,
                                                                bc.socmnd                              AS bican_socmnd,
                                                                 -- cth.ngayrabanan                           AS bican_ngaynhanba,
                                                                cth.ngayhieulucba                      AS bican_ngayhieuluc,
                                                                cth.sobananorqd                        AS banan_so_ban_an,
                                                                cth.ngayrabanan                        AS banan_ngay_ba,
                                                                dc.id                                  AS thamphanid,
                                                                dc.hoten                               AS thamphan_ten,
                                                                '1'                                    AS loaian_id,
                                                                'Hình Sự'                              AS loai_an_ten,
                                                                cth.bqd                                AS loaibaqd,
                                                                cth.capxx                              AS capxx_ma,
                                                                  -- lấy tội danh theo cấp xét xử
                                                                CASE
                                                                      WHEN cth.capxx = 'SO_THAM' THEN
                                                                          (
                                                                              SELECT
                                                                                  tentoidanh_st
                                                                              FROM
                                                                                  ahs_tonghophinhphat sa
                                                                              WHERE
                                                                                      sa.vuanid = va.id
                                                                                  AND sa.bicaoid = bc.id
                                                                          )
                                                                      ELSE
                                                                          CASE
                                                                          WHEN cth.BQD = '1' THEN -- Nếu là bản án thì lấy ở phúc thẩm
                                                                          (
                                                                              SELECT
                                                                                 COALESCE(sa.tentoidanh_pt, sa.tentoidanh_st)
                                                                              FROM
                                                                                  ahs_tonghophinhphat sa
                                                                              WHERE
                                                                                      sa.vuanid = va.id
                                                                                  AND sa.bicaoid = bc.id
                                                                          )
                                                                          ELSE -- Là quyết định thì lấy ở sơ thẩm
                                                                           (SELECT
                                                                                  tentoidanh_st
                                                                              FROM
                                                                                  ahs_tonghophinhphat sa
                                                                              WHERE
                                                                                      sa.vuanid = va.id
                                                                                  AND sa.bicaoid = bc.id)
                                                                          END 
                                                                  END                                   AS tentoidanh,
                                                                  -- Lấy hình phạt theo cấp xét xử
                                                                  cth.HINHPHAT_TH  AS tenhinhphat,
                                                                to_char(va.mavuan)                     AS mavuan,
                                                                va.id                                  AS vuanid,
                                                                va.tenvuan,
                                                                cth.thuly
                                                                || ' - số '
                                                                || 
                                                                  -- Lấy số thụ lý theo cấp xét xử
                                                                CASE
                                                                    WHEN cth.capxx = 'SO_THAM' THEN
                                                                            sttl.sothuly
                                                                    ELSE
                                                                        pttl.sothuly
                                                                END
                                                                || ' ngày '
                                                                || to_char(
                                                                    CASE
                                                                        WHEN cth.capxx = 'SO_THAM' THEN
                                                                            sttl.ngaythuly
                                                                        ELSE pttl.ngaythuly
                                                                    END, 'dd/MM/yyyy')                        AS thuly,
                                                                CASE
                                                                    WHEN cth.capxx = 'SO_THAM' THEN
                                                                        'Sơ Thẩm'
                                                                    ELSE
                                                                        'Phúc thẩm'
                                                                END                                    AS capxx,
                                                                  --'Sơ Thẩm'                               AS capxx,

                                                                va.ngaytao,
                                                                va.toaanid,
                                                                'Thu hồi'                              AS trangthaibanghi,
                                                                'TH' as ma_trangthaibanghi,
                                                                'Bị thu hồi'                           AS trangthaigui,
                                                                cth.ghichu                       AS ghichu,
                                                                cth.nguoithuhoi                       AS nguoithuhoi,
                                                                to_char(cth.ngaythuhoi, 'dd/MM/yyyy') AS ngaythuhoi,
                                                              --  cth.ghichu                             AS ghichu,
                                                                to_char(cth.ngaydongbo, 'dd/MM/yyyy')  AS ngaydongbo,
                                                                cth.taikhoangui                        AS taikhoangui,
                                                                to_char(cth.ngaygui, 'dd/MM/yyyy')     AS ngaygui,
                                                                  cth.taikhoangui as nguoigui,
                                                                atpgq.canboid                          AS canboid

                                                            FROM
                                                                c06_toaan_hinhsu         cth

                                                                INNER JOIN ahs_bicanbicao           bc ON cth.bicanid = bc.id

                                                                INNER JOIN ahs_vuan                 va ON bc.vuanid = va.id
                                                                INNER JOIN dm_toaan                 dm ON dm.id = va.toaanid
                                                                 -- INNER JOIN ahs_sotham_banan              ba ON ba.vuanid = va.id
                                                                  --INNER JOIN ahs_sotham_hdxx               ashxx ON ashxx.vuanid = va.id
                                                                LEFT JOIN ahs_sotham_thuly         sttl ON va.id = sttl.vuanid
                                                                LEFT JOIN ahs_phuctham_thuly       pttl ON pttl.vuanid = va.id
                                                                INNER JOIN ahs_thamphangiaiquyet    atpgq ON atpgq.vuanid = va.id
                                                                 -- INNER JOIN ahs_sotham_banan_dieu_chitiet asbdc ON asbdc.bicanid = bc.id
                                                                --  LEFT JOIN dm_boluat_toidanh_hinhphat    abth ON abth.toidanhid = asbdc.toidanhid
                                                                 -- LEFT JOIN dm_boluat_toidanh             dmbt ON dmbt.id = abth.toidanhid
                                                                 -- LEFT JOIN dm_hinhphat                   dhp ON dhp.id = abth.hinhphatid
                                                                LEFT JOIN dm_canbo                 dc ON dc.id = atpgq.canboid
                                                            WHERE
                                                                    1 = 1
                                                                 -- thu hoi -----------
                                                              --  AND cth.trangthaijobshare = '0' -- jobshared chưa lấy
                                                                AND cth.trangthaiahs = 'THU_HOI' -- Thu hồi
                                                                AND cth.status = '1'
                                                                AND ((cth.capxx = 'SO_THAM' and va.toaanid = v_toaan_id)
                                                                  or (cth.capxx = 'PHUC_THAM' and va.toaphucthamid = v_toaan_id))
                                                                  -- xử lý thêm tòa sơ thẩm và phúc thẩm
                                                                  AND ((cth.capxx = 'PHUC_THAM' and atpgq.mavaitro = 'VTTP_GIAIQUYETPHUCTHAM')
                                                                  or(cth.capxx = 'SO_THAM' and atpgq.mavaitro = 'VTTP_GIAIQUYETSOTHAM')
                                                                  )

                                                                 -- AND cth.STATUS = 1
                                                                 --AND cth.trangThaiBanGhi = 'THU_HOI'

                                                        ) a
                                                    WHERE
                                                        ( v_ten_vu_an IS NULL
                                                          OR a.tenvuan LIKE v_ten_vu_an || '%' )
                                                        AND ( v_ma_vu_an IS NULL
                                                              OR a.mavuan = v_ma_vu_an )
                                                        AND ( v_bi_can IS NULL
                                                              OR a.bican_ten = v_bi_can )
                                                        AND ( v_cccd IS NULL
                                                              OR a.bican_so_cccd = v_cccd )
                                                         AND ( v_capxx IS NULL
                                                                OR ( v_capxx = 2
                                                                     AND a.capxx_ma = 'SO_THAM' )
                                                                OR ( v_capxx = 3
                                                                     AND a.capxx_ma = 'PHUC_THAM' ) )
                                                        AND ( v_so_qd IS NULL
                                                              OR a.banan_so_ban_an = v_so_qd )
                                                        AND ( v_tungay IS NULL
                                                              OR TO_DATE(banan_ngay_ba, 'dd/MM/yyyy') >= v_tungay )
                                                        AND ( v_denngay IS NULL
                                                              OR TO_DATE(a.banan_ngay_ba, 'dd/MM/yyyy') <= v_denngay )
                                                        AND ( v_toidanh IS NULL
                                                              OR ( fn_convert_to_vn(lower(a.tentoidanh)) LIKE '%'
                                                                                                              || fn_convert_to_vn(lower
                                                                                                              (v_toidanh))
                                                                                                              || '%' ) )
                                                        AND ( v_thuky_id IS NULL
                                                              OR a.canboid = v_thuky_id )
                                                        AND ( v_thamphan_id IS NULL
                                                              OR a.canboid = v_thamphan_id )
                                                ) tt
                          WHERE
                                  tt.stt >= minindex
                              AND tt.stt <= maxindex;

    END;

    PROCEDURE c06_ahs_dongbo_get_bican (
        vbicanid  IN NUMBER,
        curreturn OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                                                  bc.id                                        AS bicaoid,
                                                  bc.hoten                                     AS bican_ten,
                                                  to_char(bc.ngaysinh, 'dd/MM/yyyy')           AS bican_ngaysinh,
                                                  bc.so_cccd                                  AS bican_so_cccd,
                                                  bc.socmnd                                    AS bican_socmnd,
                                                  asbb.ngaynhanbanan                           AS bican_ngaynhanba,
                                                  to_char(asbb.ngayhieulucbanan, 'dd/MM/yyyy') AS bican_ngayhieuluc,
                                                  ba.sobanan                                   AS banan_so_ban_an,
                                                  ba.ngaybanan                                 AS banan_ngay_ba,
                                                  dc.id                                        AS thamphanid,
                                                  dc.hoten                                     AS thamphan_ten,
                                                  '1'                                          AS loaian_id,
                                                  'Hinh Su'                                    AS loai_an_ten,
                                                  '1'                                          AS loaibaqd,
                                                  ba.id                                        AS baqd_id,
                                                  dmbt.tentoidanh,
                                                  dmbt.id                                      AS toidanhid,
                                                  to_char(va.mavuan)                           AS mavuan,
                                                  va.tenvuan,
                                                  decode(ast.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy'
                                                  ,
                                                         'Thụ lý mới')
                                                  || ' - số '
                                                  || ast.sothuly
                                                  || ' ngày '
                                                  || to_char(ast.ngaythuly, 'dd/MM/yyyy')      AS thuly,
                                                  'Sơ Thẩm'                                    AS capxx,
                                                  bc.xacthuc_dldcqg,
                                                  va.ngaytao,
                                                  'Chưa đồng bộ'                               AS trangthaibanghi
                                              FROM
                                                       ahs_bicanbicao bc

                                                  INNER JOIN ahs_sotham_banan_bicao        asbb ON bc.id = asbb.bicaoid
                                                  INNER JOIN ahs_vuan                      va ON bc.vuanid = va.id
                                                  INNER JOIN dm_toaan                      dm ON dm.id = va.toaanid
                                                  INNER JOIN ahs_sotham_banan              ba ON ba.vuanid = va.id
                                                  INNER JOIN ahs_sotham_hdxx               ashxx ON ashxx.vuanid = va.id
                                                  INNER JOIN ahs_sotham_thuly              ast ON va.id = ast.vuanid
                                                  INNER JOIN ahs_thamphangiaiquyet         atpgq ON atpgq.vuanid = va.id
                                                  LEFT JOIN ahs_sotham_banan_dieu_chitiet asbdc ON asbdc.bicanid = bc.id
                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                                  INNER JOIN dm_boluat_toidanh_hinhphat    abth ON abth.toidanhid = asbdc.toidanhid
                                                  INNER JOIN dm_boluat_toidanh             dmbt ON dmbt.id = abth.toidanhid
                                                  LEFT JOIN dm_hinhphat                   dhp ON dhp.id = abth.hinhphatid
                                                  LEFT JOIN dm_canbo                      dc ON dc.id = atpgq.canboid
                                --left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                           WHERE
                               bc.id = vbicanid;

    END;

    PROCEDURE c06_ahs_dongbo_get_toidanh (
        vbicanid    IN NUMBER,
        v_capxx     IN VARCHAR2,
        v_loaiba_qd IN VARCHAR2,
        curretun    OUT SYS_REFCURSOR
    ) AS
        v_quyetdinhid NUMBER;
        v_count       NUMBER;
    BEGIN
        CASE
            WHEN v_capxx = 'SO_THAM' THEN -- nếu là sơ thẩm
                BEGIN
                    OPEN curretun FOR SELECT DISTINCT
                                                            dmbt.id,
                                                            dmbt.tentoidanh
                                                        FROM
                                                            ahs_sotham_banan_dieu_chitiet asbdc
                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                              --  left JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                                            LEFT JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                      WHERE
                                          asbdc.bicanid = vbicanid;

                END;
            ELSE
                IF ( v_loaiba_qd = '1' ) THEN
         -- Kiểm tra quyetdinhid
                    SELECT
                        a.ketquaphucthamid
                    INTO v_quyetdinhid
                    FROM
                             ahs_phuctham_banan a
                        INNER JOIN ahs_phuctham_banan_bicao b ON b.bananid = a.id
                    WHERE
                        b.bicaoid = vbicanid;

                    IF ( v_quyetdinhid = 1 )  -- nếu giữ nguyên thì lấy ở sơ thẩm

                     THEN
                        OPEN curretun FOR SELECT DISTINCT
                                                                dmbt.id,
                                                                dmbt.tentoidanh
                                                            FROM
                                                                ahs_sotham_banan_dieu_chitiet asbdc
                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                              --  left JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                                                LEFT JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                          WHERE
                                              asbdc.bicanid = vbicanid;

                    ELSE -- không thì lấy ở phúc thẩm
                      --Kiểm tra thêm logic nếu không có kháng cáo thì lấy theo phúc thẩm, có kháng cáo thì lấy theo sơ thẩm
                       -- Lấy số lượng
                        SELECT
                            COUNT(1)
                        INTO v_count
                        FROM
                                 ahs_sotham_khangcao a
                            JOIN ahs_sotham_rutkhangcao b ON a.id = b.khangcaoid
                        WHERE
                            a.nguoikcid = vbicanid;

                        IF v_count > 0 THEN
                            OPEN curretun FOR SELECT DISTINCT
                                                                    dmbt.id,
                                                                    dmbt.tentoidanh
                                                                FROM
                                                                    ahs_sotham_banan_dieu_chitiet asbdc
                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                              --  left JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                                                    LEFT JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                              WHERE
                                                  asbdc.bicanid = vbicanid;

                        ELSE
                            OPEN curretun FOR SELECT DISTINCT
                                                                    dmbt.id,
                                                                    dmbt.tentoidanh
                                                                FROM
                                                                    ahs_phuctham_banan_dieu_ct asbdc
                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                              --  left JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                                                    LEFT JOIN dm_boluat_toidanh          dmbt ON dmbt.id = asbdc.toidanhid
                                              WHERE
                                                  asbdc.bicanid = vbicanid;

                        END IF;

                    END IF;

                ELSE -- nếu là quyết định lấy ở sơ thẩm
                    OPEN curretun FOR SELECT DISTINCT
                                                            dmbt.id,
                                                            dmbt.tentoidanh
                                                        FROM
                                                            ahs_sotham_banan_dieu_chitiet asbdc
                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                              --  left JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                                                            LEFT JOIN dm_boluat_toidanh             dmbt ON dmbt.id = asbdc.toidanhid
                                      WHERE
                                          asbdc.bicanid = vbicanid;

                END IF;
        END CASE;
    END;

    PROCEDURE c06_ahs_insert (
        sobananorqd          IN VARCHAR2,
        ngayrabanan          IN VARCHAR2,
        madonvirabanan       IN VARCHAR2,
        tendonvirabanan      IN VARCHAR2,
        bqd                  IN VARCHAR2,
        dstoidanh            IN VARCHAR2,
        mahinhphatchinh      IN VARCHAR2,
        tenhinhphatchinh     IN VARCHAR2,
        thamsohinhphatchinh  IN VARCHAR2,
        dshinhphatbosung     IN VARCHAR2,
        ngayhieulucba        IN VARCHAR2,
        hotenbicao           IN VARCHAR2,
        sogiaytobicao        IN VARCHAR2,
        ngaysinhbicao        IN VARCHAR2,
        maquoctichbicao      IN VARCHAR2,
        tenquoctichbicao     IN VARCHAR2,
        mathanhphotinhbicao  IN VARCHAR2,
        tenthanhphotinhbicao IN VARCHAR2,
        maquanhuyenbicao     IN VARCHAR2,
        tenquanhuyenbicao    IN VARCHAR2,
        maphuongxabicao      IN VARCHAR2,
        tenphuongxabicao     IN VARCHAR2,
        diachibicao          IN VARCHAR2,
        ghichu               IN VARCHAR2,
        vuanid               IN NUMBER,
        bicanid              IN NUMBER,
        taikhoangui          IN VARCHAR2,
        tenvuan              IN VARCHAR2,
        thuly                IN VARCHAR2,
        madongboid           IN VARCHAR2,
        capxx                IN VARCHAR2,
        toidanh_th in varchar2,
        hinhphat_th in varchar2,
        thamphan in varchar2
    ) AS
    p_check_count NUMBER;
    v_bicanid number;
    v_vuanid number;
    BEGIN
       v_bicanid := bicanid;
       v_vuanid := vuanid;

     --  select count(1) into p_check_count from c06_toaan_hinhsu ahs where ahs.vuanid = v_vuanid and ahs.bicanid = v_bicanid and trangthaiahs = 'THU_HOI';
       -- if p_check_count = 0 then --Nếu không tồn tại thì  insert
        -- Kiểm tra thêm nếu tồn tại bản ghi HIEU LUC thì không insert
        select count(1) into p_check_count from c06_toaan_hinhsu ahs where ahs.vuanid = v_vuanid and ahs.bicanid = v_bicanid and trangthaiahs = 'HIEU_LUC';
        if p_check_count = 0 then
        INSERT INTO c06_toaan_hinhsu (
            id,
            sobananorqd,
            ngayrabanan,
            madonvirabanan,
            tendonvirabanan,
            bqd,
            dstoidanh,
            mahinhphatchinh,
            tenhinhphatchinh,
            thamsohinhphatchinh,
            dshinhphatbosung,
            ngayhieulucba,
            hotenbicao,
            sogiaytobicao,
            ngaysinhbicao,
            maquoctichbicao,
            tenquoctichbicao,
            mathanhphotinhbicao,
            tenthanhphotinhbicao,
            maquanhuyenbicao,
            tenquanhuyenbicao,
            maphuongxabicao,
            tenphuongxabicao,
            diachibicao,
            ghichu,
            vuanid,
            bicanid,
            taikhoangui,
            tenvuan,
            thuly,
            madongboid,
            capxx,
            toidanh_th,
            hinhphat_th,
            thamphan
        ) VALUES ( c06_toaan_hinhsu_seq.NEXTVAL,
                   sobananorqd,
                   ngayrabanan,
                   madonvirabanan,
                   tendonvirabanan,
                   bqd,
                   dstoidanh,
                   mahinhphatchinh,
                   tenhinhphatchinh,
                   thamsohinhphatchinh,
                   dshinhphatbosung,
                   ngayhieulucba,
                   hotenbicao,
                   sogiaytobicao,
                   ngaysinhbicao,
                   maquoctichbicao,
                   tenquoctichbicao,
                   mathanhphotinhbicao,
                   tenthanhphotinhbicao,
                   maquanhuyenbicao,
                   tenquanhuyenbicao,
                   maphuongxabicao,
                   tenphuongxabicao,
                   diachibicao,
                   ghichu,
                   vuanid,
                   bicanid,
                   taikhoangui,
                   tenvuan,
                   thuly,
                   madongboid,
                   capxx,
                    toidanh_th,
            hinhphat_th,
            thamphan);

         END IF;
    END;
    PROCEDURE c06_ahs_insert_guilai (
        sobananorqd          IN VARCHAR2,
        ngayrabanan          IN VARCHAR2,
        madonvirabanan       IN VARCHAR2,
        tendonvirabanan      IN VARCHAR2,
        bqd                  IN VARCHAR2,
        dstoidanh            IN VARCHAR2,
        mahinhphatchinh      IN VARCHAR2,
        tenhinhphatchinh     IN VARCHAR2,
        thamsohinhphatchinh  IN VARCHAR2,
        dshinhphatbosung     IN VARCHAR2,
        ngayhieulucba        IN VARCHAR2,
        hotenbicao           IN VARCHAR2,
        sogiaytobicao        IN VARCHAR2,
        ngaysinhbicao        IN VARCHAR2,
        maquoctichbicao      IN VARCHAR2,
        tenquoctichbicao     IN VARCHAR2,
        mathanhphotinhbicao  IN VARCHAR2,
        tenthanhphotinhbicao IN VARCHAR2,
        maquanhuyenbicao     IN VARCHAR2,
        tenquanhuyenbicao    IN VARCHAR2,
        maphuongxabicao      IN VARCHAR2,
        tenphuongxabicao     IN VARCHAR2,
        diachibicao          IN VARCHAR2,
        ghichu               IN VARCHAR2,
        vuanid               IN NUMBER,
        bicanid              IN NUMBER,
        taikhoangui          IN VARCHAR2,
        tenvuan              IN VARCHAR2,
        thuly                IN VARCHAR2,
        madongboid           IN VARCHAR2,
        capxx                IN VARCHAR2,
        nguoiguilai IN VARCHAR2,
         toidanh_th in varchar2,
            hinhphat_th in varchar2,
            thamphan in varchar2
    ) AS
    p_check_count NUMBER;
    v_bicanid number;
    v_vuanid number;
    BEGIN
       v_bicanid := bicanid;
       v_vuanid := vuanid;

     --  select count(1) into p_check_count from c06_toaan_hinhsu ahs where ahs.vuanid = v_vuanid and ahs.bicanid = v_bicanid and trangthaiahs = 'THU_HOI';
       -- if p_check_count = 0 then --Nếu không tồn tại thì  insert
        -- Kiểm tra thêm nếu tồn tại bản ghi HIEU LUC thì không insert
        select count(1) into p_check_count from c06_toaan_hinhsu ahs where ahs.vuanid = v_vuanid and ahs.bicanid = v_bicanid and trangthaiahs = 'HIEU_LUC';
        if p_check_count = 0 then
        INSERT INTO c06_toaan_hinhsu (
            id,
            sobananorqd,
            ngayrabanan,
            madonvirabanan,
            tendonvirabanan,
            bqd,
            dstoidanh,
            mahinhphatchinh,
            tenhinhphatchinh,
            thamsohinhphatchinh,
            dshinhphatbosung,
            ngayhieulucba,
            hotenbicao,
            sogiaytobicao,
            ngaysinhbicao,
            maquoctichbicao,
            tenquoctichbicao,
            mathanhphotinhbicao,
            tenthanhphotinhbicao,
            maquanhuyenbicao,
            tenquanhuyenbicao,
            maphuongxabicao,
            tenphuongxabicao,
            diachibicao,
            ghichu,
            vuanid,
            bicanid,
            taikhoangui,
            tenvuan,
            thuly,
            madongboid,
            capxx,
            nguoiguilai,
            ngayguilai,
             toidanh_th,
            hinhphat_th,
            thamphan
        ) VALUES ( c06_toaan_hinhsu_seq.NEXTVAL,
                   sobananorqd,
                   ngayrabanan,
                   madonvirabanan,
                   tendonvirabanan,
                   bqd,
                   dstoidanh,
                   mahinhphatchinh,
                   tenhinhphatchinh,
                   thamsohinhphatchinh,
                   dshinhphatbosung,
                   ngayhieulucba,
                   hotenbicao,
                   sogiaytobicao,
                   ngaysinhbicao,
                   maquoctichbicao,
                   tenquoctichbicao,
                   mathanhphotinhbicao,
                   tenthanhphotinhbicao,
                   maquanhuyenbicao,
                   tenquanhuyenbicao,
                   maphuongxabicao,
                   tenphuongxabicao,
                   diachibicao,
                   ghichu,
                   vuanid,
                   bicanid,
                   taikhoangui,
                   tenvuan,
                   thuly,
                   madongboid,
                   capxx,
                   nguoiguilai,
                   sysdate,
                    toidanh_th,
            hinhphat_th,
            thamphan);

         END IF;
    END;
    PROCEDURE c06_ahs_bican_sotham_getbyid (
        vbicanid  IN NUMBER,
        curreturn OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                                                  ba.sobanan                                   AS sobananorqd,
                                                  to_char(ba.ngaybanan, 'dd/MM/yyyy')          AS ngayrabanan,
                                                  dm.ma                                        madonvirabanan,
                                                  dm.ten                                       tendonvirabanan,
                                                  '1'                                          bqd,
                                                  to_char(asbb.ngayhieulucbanan, 'dd/MM/yyyy') ngayhieulucba,
                                                  bc.hoten                                     hotenbicao,
                                                  bc.so_cccd                                  sogiaytobicao,
                                                  to_char(bc.ngaysinh, 'dd/MM/yyyy')           ngaysinhbicao,
                                                  dd.ma                                        maquoctichbicao,
                                                  dd.ten                                       tenquoctichbicao,
                                                  to_char(dht.ma)                              mathanhphotinhbicao,
                                                  dht.ten                                      tenthanhphotinhbicao,
                                                  to_char(xht.ma)                              maquanhuyenbicao,
                                                  xht.ten                                      tenquanhuyenbicao,
                                                  to_char(xht.ma)                              maphuongxabicao,
                                                  xht.ten                                      tenphuongxabicao,
                                                  bc.khttchitiet                               diachibicao,
                                                  ''                                           ghichu,
                                                  va.tenvuan                                   tenvuan,
                                                  ast.mathuly                                  thuly,
                                                  '0',
                                                  va.id                                        vuanid,
                                                  bc.id                                        bicanid
                                              FROM
                                                       ahs_bicanbicao bc

                                                  INNER JOIN ahs_sotham_banan_bicao asbb ON bc.id = asbb.bicaoid
                                                  INNER JOIN ahs_vuan               va ON bc.vuanid = va.id
                                                  INNER JOIN dm_toaan               dm ON dm.id = va.toaanid
                                                  INNER JOIN ahs_sotham_banan       ba ON ba.vuanid = va.id
                                --inner join ahs_thamphangiaiquyet atpgq on atpgq.vuanid = va.id
                                --inner join AHS_SOTHAM_HDXX ashxx on ashxx.vuanid = va.id
                                                  INNER JOIN ahs_sotham_thuly       ast ON va.id = ast.vuanid
                                                  LEFT JOIN dm_hanhchinh           dht ON dht.id = bc.hktt
                                                  LEFT JOIN dm_hanhchinh           xht ON xht.id = bc.hktt_huyen
                                                  LEFT JOIN dm_dataitem            dd ON bc.quoctichid = dd.id
                               -- left join dm_canbo dc on dc.id = atpgq.canboid
                                --left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                           WHERE
                               bc.id = vbicanid;

    END;

    PROCEDURE c06_ahs_dadongbo_getbyid (
        c06_ahs_id IN NUMBER,
        curreturn  OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                                                  *
                                              FROM
                                                  c06_toaan_hinhsu
                           WHERE
                                   id = c06_ahs_id;
    END;

END pkg_ahs_dongbo_c06;
/
