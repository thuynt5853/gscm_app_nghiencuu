CREATE OR REPLACE PACKAGE dlqgc06_ahs AS 

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


CREATE OR REPLACE PACKAGE BODY dlqgc06_ahs AS
   /* 
  TODO enter package declarations (types, exceptions, methods etc) here 
  GTEL-Đức PHạm 11-09-2025 9h:00: Các nghiệp vụ cho phần nâng cấp Bản án Hình sự và Đồng bộ bản án hình sự sơ thẩm sang C06
  */

    PROCEDURE ahs_check_bican_da_dongbo (
        bi_can_id   IN    NUMBER,
        vu_an_id    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               COUNT(1) total
                           FROM
                               c06_toaan_hinhsu
                           WHERE
                               bicanid = bi_can_id
                               AND vuanid = vu_an_id
                               AND trangthaiahs = 'HIEU_LUC';

    END;

    PROCEDURE ahs_check_bican_cohinhphat (
        bi_can_id   IN    INT,
        vu_an_id    IN    INT,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        NULL;
    END;

    PROCEDURE ahs_check_bican_chuaxacthuc (
        vu_an_id    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               COUNT(1) total
                           FROM
                               ahs_bicanbicao       a

                               INNER JOIN ahs_vuan             c ON a.vuanid = c.id
                           WHERE
                               a.xacthuc_dldcqg = '0' and a.xacthuc_dldcqg is not null -- trang thai chua xac thuc
                               AND c.id = vu_an_id; -- nếu muốn lọc theo vụ án

    END;

    PROCEDURE ahs_toidanh_chinh_getbybican (
        bi_can_id   IN    INT,
        vu_an_id    IN    INT,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               ROW_NUMBER() OVER(
                                   ORDER BY
                                       a.ngaytao, c.arrsapxep ASC
                               ) stt,
                               a.id,
                               a.dieuluatid,
                               b.tenboluat,
                               a.bicanid,
                               a.toidanhid,
                               c.chuong,
                               c.diem,
                               c.khoan,
                               c.dieu,
                               c.loaitoipham,
                               nvl(a.tentoidanh, c.tentoidanh) tentoidanh,
                               c.capchaid,
                               c.loai,
                               c.arrsapxep,
                               decode(c.loai, 2, 1, 3, 0,
                                      4, 0) isedit,
                               a.toa_giaiquyet_id
                           FROM
                               ahs_sotham_caotrang_dieuluat a
                               INNER JOIN (
                                   SELECT
                                       id,
                                       tenboluat,
                                       loai
                                   FROM
                                       dm_boluat
                                   WHERE
                                       hieuluc = 1
                                       AND ( loai = '01'
                                             OR loai = '1' )
                               ) b ON a.dieuluatid = b.id
                               INNER JOIN (
                                   SELECT
                                       id,
                                       luatid,
                                       chuong,
                                       diem,
                                       khoan,
                                       dieu,
                                       tentoidanh,
                                       capchaid,
                                       loai,
                                       arrsapxep,
                                       loaitoipham
                                   FROM
                                       dm_boluat_toidanh
                                   WHERE
                                       hieuluc = 1
                               ) c ON c.luatid = b.id
                                      AND a.toidanhid = c.id
                           WHERE
                               a.bicanid = bi_can_id
                               AND a.vuanid = vu_an_id
                               AND a.ismain = '1';

    END;
   --------- XU ly Lich Sua chinh sua BiCan ----

    PROCEDURE ahs_bican_history_insert (
        his_nguoisua      IN   VARCHAR2,
        his_taikhoansua   IN   VARCHAR2,
        his_bican         IN   VARCHAR2,
        bicanid           IN   NUMBER
    ) AS
    BEGIN
        INSERT INTO ahs_bicanbicao_history (
            his_nguoisua,
            his_taikhoansua,
            his_bican,
            bicanid
        ) VALUES (
            his_nguoisua,
            his_taikhoansua,
            his_bican,
            bicanid
        );

    END;

    PROCEDURE ahs_bican_history_getlist (
        v_bicanid   IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               his_nguoisua,
                               his_taikhoansua,
                               to_char(his_ngaysua, 'dd-MM-yyyy hh24:mm:ss') AS his_ngaysua,
                               his_bican,
                               bicanid
                           FROM
                               ahs_bicanbicao_history
                           WHERE
                               bicanid = v_bicanid
                           ORDER BY
                               his_ngaysua DESC;

    END;
  ------------- END  XU ly Lich Sua chinh sua BiCan -----------------------

    PROCEDURE ahs_bicao_getall_by_vuanid_search (
        vu_an_id     IN    INT,
        textsearch   IN    NVARCHAR2,
        pageindex    IN    INT,
        pagesize     IN    INT,
        curreturn    OUT   SYS_REFCURSOR
    ) AS
        totalitem     NUMBER;
        minindex      NUMBER;
        maxindex      NUMBER;
        checkdelete   NUMBER;
    BEGIN
        SELECT
            COUNT(id)
        INTO checkdelete
        FROM
            ahs_sotham_thuly
        WHERE
            vuanid = vu_an_id;
    ---------------------------------------------------

        minindex := pagesize * ( pageindex - 1 ) + 1;
        maxindex := pageindex * pagesize;

   --1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total      
        SELECT
            COUNT(a.id)
        INTO totalitem
        FROM
            ahs_bicanbicao               a
            LEFT JOIN (
                SELECT
                    id
                FROM
                    dm_hanhchinh
            ) hc ON hc.id = a.tamtru_huyen
        WHERE
            a.vuanid = vu_an_id
            AND 1 = (
                CASE
                    WHEN textsearch = '' THEN
                        1
                    WHEN ( ( lower(a.hoten) LIKE ( '%'
                                                   || lower(textsearch)
                                                   || '%' ) )
                           OR ( lower(a.tenkhac) LIKE ( '%'
                                                        || lower(textsearch)
                                                        || '%' ) ) ) THEN
                        1
                END
            );
        ---------------------------------------------------

        OPEN curreturn FOR SELECT
                              a.*,
                              totalitem AS countall,
                              nvl(checkdelete, 0) checkdelete
                          FROM
                              (
                                  SELECT
                                      ROW_NUMBER() OVER(
                                          ORDER BY
                                              nvl(a.bicandauvu, 0) DESC, a.ngaythamgia DESC
                                      ) stt,
                                      a.id,
                                      a.hoten AS tenbicao,
                                      a.bicandauvu,
                                      a.namsinh,
                                      a.ngaythamgia,
                                      a.tamtru,
                                      nvl(c.tentoidanh, '') tentoidanh,
                                      CASE
                                          WHEN ( ( a.tamtruchitiet IS NULL )
                                                 OR ( length(nvl(a.tamtruchitiet, '')) = 0 ) ) THEN
                                              hc.ma_ten
                                          WHEN ( ( a.tamtruchitiet IS NOT NULL )
                                                 AND ( length(nvl(a.tamtruchitiet, '')) > 0 ) ) THEN
                                              ( a.tamtruchitiet
                                                || ','
                                                || hc.ma_ten )
                                      END dctamtru,
                                      a.gdtaohs,
                                      a.toa_giaiquyet_id,
                                      CASE
                                          WHEN a.xacthuc_dldcqg = '1' THEN
                                              'Đã xác thực'
                                          WHEN a.xacthuc_dldcqg = '2' THEN
                                              'Không thể làm sạch được'
                                          ELSE
                                              ''
                                      END AS trangthaixacthuc -- GTEL DUCPH 18-09-2025 14h Lấy thêm thông tin trạng thái xác thực
                                  FROM
                                      ahs_bicanbicao                                                                                     a
                                      LEFT JOIN (
                                          SELECT
                                              id,
                                              ten,
                                              ma_ten
                                          FROM
                                              dm_hanhchinh
                                      )                                                        hc ON hc.id = a.tamtru_huyen
                                      LEFT JOIN (
                                          SELECT
                                              bicanid,
                                              tentoidanh,
                                              ismain
                                          FROM
                                              ahs_sotham_caotrang_dieuluat
                                          WHERE
                                              vuanid = vu_an_id
                                              AND ismain = 1
                                      ) c ON a.id = c.bicanid
                                  WHERE
                                      a.vuanid = vu_an_id
                                      AND 1 = (
                                          CASE
                                              WHEN textsearch = '' THEN
                                                  1
                                              WHEN ( ( lower(a.hoten) LIKE ( '%'
                                                                             || lower(textsearch)
                                                                             || '%' ) )
                                                     OR ( lower(a.tenkhac) LIKE ( '%'
                                                                                  || lower(textsearch)
                                                                                  || '%' ) ) ) THEN
                                                  1
                                          END
                                      )
                              ) a
                          WHERE
                              a.stt >= minindex
                              AND a.stt <= maxindex;

    END;

    PROCEDURE ahs_bicao_getall_by_vuanid (
        vu_an_id    IN    INT,
        pageindex   IN    INT,
        pagesize    IN    INT,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
        totalitem     NUMBER;
        minindex      NUMBER;
        maxindex      NUMBER;
        checkdelete   NUMBER;
    BEGIN
        SELECT
            COUNT(id)
        INTO checkdelete
        FROM
            ahs_sotham_thuly
        WHERE
            vuanid = vu_an_id;

        minindex := pagesize * ( pageindex - 1 ) + 1;
        maxindex := pageindex * pagesize;

   --1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total      
        SELECT
            COUNT(a.id)
        INTO totalitem
        FROM
            ahs_bicanbicao a 
    --left join (select ID from DM_HanhChinh where HieuLuc=1) b on a.TamTru = b.ID
        WHERE
            a.vuanid = vu_an_id;
        ---------------------------------------------------

        OPEN curreturn FOR SELECT
                              a.*,
                              totalitem AS countall,
                              nvl(checkdelete, 0) checkdelete
                          FROM
                              (
                                  SELECT
                                      ROW_NUMBER() OVER(
                                          ORDER BY
                                              nvl(a.bicandauvu, 0) DESC, a.id --, a.NgayThamGia desc
                                      ) stt,
                                      a.id,
                                      a.hoten,
                                      a.bicandauvu,
                                      a.namsinh,
                                      a.ngaythamgia,
                                      a.tamtru,
                                      a.tamtruchitiet,
                                      nvl(td.tentoidanh, '') tentoidanh,
                                      CASE
                                          WHEN a.xacthuc_dldcqg = '1' THEN
                                              'Đã xác thực'
                                          WHEN a.xacthuc_dldcqg = '2' THEN
                                              'Không thể làm sạch được'
                                          ELSE
                                              ''
                                      END AS trangthaixacthuc -- GTEL DUCPH 18-09-2025 14h Lấy thêm thông tin trạng thái xác thực
                                      ,
                                      b.getalltoidanh,
                                      a.toa_giaiquyet_id
                                  FROM
                                      ahs_bicanbicao       a
                                      LEFT JOIN (
                                          SELECT
                                              bicanid,
                                              tentoidanh,
                                              ismain
                                          FROM
                                              ahs_sotham_caotrang_dieuluat
                                          WHERE
                                              vuanid = vu_an_id
                                              AND ismain = 1
                                      ) td ON a.id = td.bicanid
                                      LEFT JOIN (
                                          SELECT
                                              bicanid,
                                              LISTAGG(tentoidanh, ', ') WITHIN GROUP(
                                                  ORDER BY
                                                      ismain DESC
                                              ) getalltoidanh
                                          FROM
                                              ahs_sotham_banan_dieu_chitiet ahs_ct
                                              INNER JOIN (
                                                  SELECT
                                                      id
                                                  FROM
                                                      dm_boluat_toidanh
                                                  WHERE
                                                      khoan IS NULL
                                                      AND diem IS NULL
                                              ) dm_bl_td ON dm_bl_td.id = ahs_ct.toidanhid
                                          WHERE
                                              hinhphatid = 0
                                          GROUP BY
                                              bicanid
                                      ) b ON b.bicanid = a.id
                                  WHERE
                                      a.vuanid = vu_an_id
                              ) a
                          WHERE
                              a.stt >= minindex
                              AND a.stt <= maxindex;

    END;

    PROCEDURE c06_dongbo_ahs_del (
        id IN NUMBER
    ) AS
    BEGIN
        DELETE c06_toaan_hinhsu
        WHERE
            id = id;

    END;

    PROCEDURE getdulieuchon_thuhoigannhat (
        v_bicanid   IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
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
                               b.bicanid = v_bicanid
                               AND b.status = 0 -- đã bị thay thế = bản ghi mới
                               AND b.trangthaiahs = 'THU_HOI'
                               AND b.id = (
                                   SELECT
                                       MAX(id)
                                   FROM
                                       c06_toaan_tinhtranghonnhan
                                   WHERE
                                       bicanid = v_bicanid
                                       AND status = 0 -- đã bị thay thế = bản ghi mới
                                       AND trangthaiahs = 'THU_HOI'
                               );

    END getdulieuchon_thuhoigannhat;



    PROCEDURE ahs_bibanbicao_c06_update (
        vbicanid      IN   NUMBER,
        vsocccd       IN   VARCHAR2,
        vsohc         IN   VARCHAR2,
        vxacthuc      IN   CHAR,
        vchkkhongco   IN   CHAR
    ) AS
        p_count     NUMBER;
        p_xacthuc   CHAR(1);
    BEGIN
        SELECT
            COUNT(1)
        INTO p_count
        FROM
            ahs_bicanbicao
        WHERE
            id = vbicanid;

        IF ( p_count > 0 ) THEN-- nếu tồn tại thì update
            UPDATE ahs_bicanbicao
            SET
                so_cccd = vsocccd,
                so_hochieu = vsohc,
                xacthuc_dldcqg = vxacthuc,
                chk_khong_co = vchkkhongco
            WHERE
                id = vbicanid;
        END IF;

    END;

    PROCEDURE ahs_bibicao_c06_get_by_bicanid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN curreturn FOR SELECT
                               *
                           FROM
                               ahs_bicanbicao
                           WHERE
                               id = vbicanid;

    END;

-- Thêm lấy ngày hiệu lực bản án

    PROCEDURE ahs_st_banan_bicao_getbyvuanid (
        vu_an_id    IN    INT,
        pageindex   IN    INT,
        pagesize    IN    INT,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
        totalitem   NUMBER;
        minindex    NUMBER;
        maxindex    NUMBER;
    BEGIN
        minindex := pagesize * ( pageindex - 1 ) + 1;
        maxindex := pageindex * pagesize;

   --1 :den tong so ban ghi trong bang tbltintuc va luu vao trog bien total      
        SELECT
            COUNT(a.id)
        INTO totalitem
        FROM
            ahs_bicanbicao a
            INNER JOIN (
                SELECT
                    id
                FROM
                    ahs_vuan
                WHERE
                    id = vu_an_id
            ) va ON va.id = a.vuanid
            LEFT JOIN (
                SELECT
                    id,
                    vuanid
                FROM
                    ahs_sotham_banan
                WHERE
                    vuanid = vu_an_id
            ) st ON st.vuanid = va.id
            LEFT JOIN (
                SELECT
                    bananid,
                    bicaoid,
                    isthamgiaphientoa,
                    anphi,
                    isdinhchi,
                    ngaynhanbanan
                FROM
                    ahs_sotham_banan_bicao
            ) b ON a.id = b.bicaoid
                   AND b.bananid = st.id
        WHERE
            a.vuanid = vu_an_id;
        ---------------------------------------------------

        OPEN curreturn FOR SELECT
                              a.*,
                              totalitem AS countall
                          FROM
                              (
                                  SELECT
                                      ROW_NUMBER() OVER(
                                          ORDER BY
                                              nvl(a.bicandauvu, 0) DESC, a.id
                                      ) stt--NVL(a.BiCanDauVu, 0) desc,a.NgayThamGia desc
                                      ,
                                      a.id,
                                      a.hoten,
                                      a.namsinh,
                                      a.ngaythamgia,
                                      a.tamtru,
                                      nvl(a.loaidoituong, 0) loaidoituong,
                                      nvl(a.bicandauvu, 0) bicandauvu,
                                      nvl(b.bicaoid, 0) bicaosotham_id,
                                      CASE
                                          WHEN nvl(b.bicaoid, 0) > 0 THEN
                                              1
                                          WHEN nvl(b.bicaoid, 0) = 0 THEN
                                              0
                                      END isshow,
                                      nvl(b.isthamgiaphientoa, 0) isthamgiaphientoa,
                                      nvl(b.anphi, 0) anphi,
                                      nvl(b.isdinhchi, 0) isdinhchi,
                                      b.ngaynhanbanan,
                                      b.toa_giaiquyet_id,
                                      b.ngayhieulucbanan AS ngayhieuluc
                                  FROM
                                      ahs_bicanbicao a
                                      INNER JOIN (
                                          SELECT
                                              id
                                          FROM
                                              ahs_vuan
                                          WHERE
                                              id = vu_an_id
                                      ) va ON va.id = a.vuanid
                                      LEFT JOIN (
                                          SELECT
                                              id,
                                              vuanid
                                          FROM
                                              ahs_sotham_banan
                                          WHERE
                                              vuanid = vu_an_id
                                      ) st ON st.vuanid = va.id
                                      LEFT JOIN (
                                          SELECT
                                              bananid,
                                              bicaoid,
                                              isthamgiaphientoa,
                                              anphi,
                                              isdinhchi,
                                              ngaynhanbanan,
                                              toa_giaiquyet_id,
                                              ngayhieulucbanan
                                          FROM
                                              ahs_sotham_banan_bicao
                                      ) b ON a.id = b.bicaoid
                                             AND b.bananid = st.id
                                  WHERE
                                      a.vuanid = vu_an_id
                              ) a
                          WHERE
                              a.stt >= minindex
                              AND a.stt <= maxindex;

    END ahs_st_banan_bicao_getbyvuanid;

    PROCEDURE ahs_sotham_banan_bicao_update_ngayhieuluc (
        vbicaoid       IN   NUMBER,
        vngayhieuluc   IN   DATE
    ) AS
    BEGIN
        UPDATE ahs_sotham_banan_bicao
        SET
            ngayhieulucbanan = vngayhieuluc
        WHERE
            bicaoid = vbicaoid;

    END;
/* ------------------- Đồng Bộ C06 ----------------------------- */

    FUNCTION create_ma_dongbo_random RETURN VARCHAR2 AS
        v_counts_madb   NUMBER;
        v_ma_db         VARCHAR2(255);
        v_temp          VARCHAR2(255);
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

    PROCEDURE c06_ahs_thuhoi_history (
        vahsid         IN   NUMBER,
        vnguoithuhoi   IN   VARCHAR2,
        vnoidung       IN   VARCHAR2,
        vlydo          IN   VARCHAR2
    ) AS
    BEGIN
        -- update vào ghi chú 
        UPDATE c06_toaan_hinhsu
        SET
            ghichu = vlydo
        WHERE
            id = vahsid;
-- insert vao history

        INSERT INTO c06_toaan_hinhsu_history (
            id,
            lydo_thuhoi,
            noidung,
            c06_ahs_id,
            nguoithuhoi,
            ngaythuhoi
        ) VALUES (
            c06_toaan_hinhsu_history_seq.NEXTVAL,
            vlydo,
            '',
            vahsid,
            vnguoithuhoi,
            sysdate
        );

    END;

    PROCEDURE c06_ahs_sotham_hinhphat_th_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               a.*,
                               a.hinhphatid mahinhphat,
                               b.tenhinhphat
                           FROM
                               ahs_sotham_banan_dieu_tonghop   a
                               LEFT JOIN dm_hinhphat                     b ON b.id = a.hinhphatid
                           WHERE
                               a.bicanid = vbicanid
                               AND a.ismain = 1;

    END;

    PROCEDURE c06_ahs_sotham_hinhphat_chinh_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               a.*,
                               a.hinhphatid AS mahinhphat,
                               d.tenhinhphat
                           FROM
                               ahs_sotham_banan_dieu_chitiet   a
                               LEFT JOIN dm_hinhphat                     d ON d.id = a.hinhphatid
                           WHERE
                               a.bicanid = vbicanid
                               AND a.ismain = 1;

    END;

    PROCEDURE c06_ahs_sotham_hinhphat_boxung_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               a.*,
                               d.mahinhphat,
                               d.tenhinhphat
                           FROM
                               ahs_sotham_banan_dieu_chitiet   a
                               LEFT JOIN dm_hinhphat                     d ON d.id = a.hinhphatid
                           WHERE
                               a.bicanid = vbicanid
                               AND a.ismain <> 1;

    END;


    PROCEDURE c06_ahs_dongbo_get_bican (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               bc.id                AS bicaoid,
                               bc.hoten             AS bican_ten,
                               to_char(bc.ngaysinh, 'dd/MM/yyyy') AS bican_ngaysinh,
                               bc.so_cccd          AS bican_so_cccd,
                               bc.socmnd            AS bican_socmnd,
                               asbb.ngaynhanbanan   AS bican_ngaynhanba,
                               to_char(asbb.ngayhieulucbanan, 'dd/MM/yyyy') AS bican_ngayhieuluc,
                               ba.sobanan           AS banan_so_ban_an,
                               ba.ngaybanan         AS banan_ngay_ba,
                               dc.id                AS thamphanid,
                               dc.hoten             AS thamphan_ten,
                               '1' AS loaian_id,
                               'Hinh Su' AS loai_an_ten,
                               '1' AS loaibaqd,
                               ba.id                AS baqd_id,
                               dmbt.tentoidanh,
                               dmbt.id              AS toidanhid,
                               to_char(va.mavuan) AS mavuan,
                               va.tenvuan,
                               decode(ast.truonghopthuly, 3, 'Thụ lý xét xử lại do GDT hủy', 2, 'Thụ lý xét xử lại do PT hủy',
                                      'Thụ lý mới')
                               || ' - số '
                               || ast.sothuly
                               || ' ngày '
                               || to_char(ast.ngaythuly, 'dd/MM/yyyy') AS thuly,
                               'Sơ Thẩm' AS capxx,
                               bc.xacthuc_dldcqg,
                               va.ngaytao,
                               'Chưa đồng bộ' AS trangthaibanghi
                           FROM
                               ahs_bicanbicao                  bc

                               INNER JOIN ahs_sotham_banan_bicao          asbb ON bc.id = asbb.bicaoid
                               INNER JOIN ahs_vuan                        va ON bc.vuanid = va.id
                               INNER JOIN dm_toaan                        dm ON dm.id = va.toaanid
                               INNER JOIN ahs_sotham_banan                ba ON ba.vuanid = va.id
                               INNER JOIN ahs_sotham_hdxx                 ashxx ON ashxx.vuanid = va.id
                               INNER JOIN ahs_sotham_thuly                ast ON va.id = ast.vuanid
                               INNER JOIN ahs_thamphangiaiquyet           atpgq ON atpgq.vuanid = va.id
                               LEFT JOIN ahs_sotham_banan_dieu_chitiet   asbdc ON asbdc.bicanid = bc.id
                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                               INNER JOIN dm_boluat_toidanh_hinhphat      abth ON abth.toidanhid = asbdc.toidanhid
                               INNER JOIN dm_boluat_toidanh               dmbt ON dmbt.id = abth.toidanhid
                               LEFT JOIN dm_hinhphat                     dhp ON dhp.id = abth.hinhphatid
                               LEFT JOIN dm_canbo                        dc ON dc.id = atpgq.canboid
                                --left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                           WHERE
                               bc.id = vbicanid;

    END;

    PROCEDURE c06_ahs_dongbo_get_toidanh (
        vbicanid   IN    NUMBER,
        curretun   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curretun FOR SELECT
                              asbdc.id,
                              dmbt.tentoidanh
                          FROM
                              ahs_sotham_banan_dieu_chitiet   asbdc
                                --left join  ahs_sotham_banan_dieu_tonghop asbdt on asbdt.bicanid = bc.id
                                              --  left JOIN dm_boluat_toidanh_hinhphat abth ON abth.toidanhid = asbdc.toidanhid
                              LEFT JOIN dm_boluat_toidanh               dmbt ON dmbt.id = asbdc.toidanhid
                          WHERE
                              asbdc.bicanid = vbicanid;

    END;

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
    ) AS
    BEGIN
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
            madongboid
        ) VALUES (
            c06_toaan_hinhsu_seq.NEXTVAL,
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
            madongboid
        );

    END;

    PROCEDURE c06_ahs_bican_getbyid (
        vbicanid    IN    NUMBER,
        curreturn   OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               ba.sobanan       AS sobananorqd,
                               to_char(ba.ngaybanan, 'dd/MM/yyyy') AS ngayrabanan,
                               dm.ma            madonvirabanan,
                               dm.ten           tendonvirabanan,
                               '1' bqd,
                               to_char(asbb.ngayhieulucbanan, 'dd/MM/yyyy') ngayhieulucba,
                               bc.hoten         hotenbicao,
                               bc.so_cccd      sogiaytobicao,
                               to_char(bc.ngaysinh, 'dd/MM/yyyy') ngaysinhbicao,
                               dd.ma            maquoctichbicao,
                               dd.ten           tenquoctichbicao,
                               to_char(dht.ma) mathanhphotinhbicao,
                               dht.ten          tenthanhphotinhbicao,
                               to_char(xht.ma) maquanhuyenbicao,
                               xht.ten          tenquanhuyenbicao,
                               to_char(xht.ma) maphuongxabicao,
                               xht.ten          tenphuongxabicao,
                               bc.khttchitiet   diachibicao,
                               '' ghichu,
                               va.tenvuan       tenvuan,
                               ast.mathuly      thuly,
                               '0',
                               va.id            vuanid,
                               bc.id            bicanid
                           FROM
                               ahs_bicanbicao           bc

                               INNER JOIN ahs_sotham_banan_bicao   asbb ON bc.id = asbb.bicaoid
                               INNER JOIN ahs_vuan                 va ON bc.vuanid = va.id
                               INNER JOIN dm_toaan                 dm ON dm.id = va.toaanid
                               INNER JOIN ahs_sotham_banan         ba ON ba.vuanid = va.id
                                --inner join ahs_thamphangiaiquyet atpgq on atpgq.vuanid = va.id
                                --inner join AHS_SOTHAM_HDXX ashxx on ashxx.vuanid = va.id
                               INNER JOIN ahs_sotham_thuly         ast ON va.id = ast.vuanid
                               LEFT JOIN dm_hanhchinh             dht ON dht.id = bc.hktt
                               LEFT JOIN dm_hanhchinh             xht ON xht.id = bc.hktt_huyen
                               LEFT JOIN dm_dataitem              dd ON bc.quoctichid = dd.id
                               -- left join dm_canbo dc on dc.id = atpgq.canboid
                                --left join DM_HANHCHINH h1 on h1.ID=NDS.TAMTRUID
                           WHERE
                               bc.id = vbicanid;

    END;

    PROCEDURE c06_ahs_dadongbo_getbyid (
        c06_ahs_id   IN    NUMBER,
        curreturn    OUT   SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN curreturn FOR SELECT
                               *
                           FROM
                               c06_toaan_hinhsu
                           WHERE
                               id = c06_ahs_id
                               AND trangthaijobshare = '0'; -- Nếu jobshare chua lay  thi moi xu ly tiep

    END;
/* ------------------- END ----------------------------- */

END dlqgc06_ahs;
/
