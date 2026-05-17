create or replace NONEDITIONABLE PACKAGE BODY pkg_dvcqg_app AS

    PROCEDURE thanh_toan_up (
        v_anphi_id     IN NUMBER,
        v_maloaivuviec IN VARCHAR2
    ) AS

        v_counts       NUMBER;
        v_counts_tp    NUMBER;
        v_sothongbao   VARCHAR2(100);
        v_ngaythongbao DATE;
        v_tamunganphi  NUMBER;
        v_duongsu_id   NUMBER;
        v_duongsu_ids  VARCHAR2(250);
    BEGIN
        IF ( v_maloaivuviec = '2' ) THEN
            SELECT
                sothongbao,
                ngaythongbao,
                tamunganphi,
                duongsu_id,
                duongsu_ids
            INTO
                v_sothongbao,
                v_ngaythongbao,
                v_tamunganphi,
                v_duongsu_id,
                v_duongsu_ids
            FROM
                ads_anphi
            WHERE
                id = v_anphi_id;
            -----------DVCQG_THANH_TOAN
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec
                AND trangthaithanhtoan = 0;

            IF ( v_counts >= 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sothongbao = v_sothongbao,
                    ngaythongbao = v_ngaythongbao,
                    tongtien = v_tamunganphi,
                    duongsu_id = v_duongsu_id,
                    duongsu_ids = v_duongsu_ids
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec
                    AND trangthaithanhtoan = 0;

            END IF;
           ---------------TUPHAP_ANPHI
            SELECT
                COUNT(*)
            INTO v_counts_tp
            FROM
                tuphap_anphi     tp
                LEFT JOIN dvcqg_thanh_toan tt ON tt.id = tp.dvcqg_tt_id
            WHERE
                    tp.anphi_id = v_anphi_id
                AND tp.maloaivuviec = v_maloaivuviec
                AND tt.trangthaithanhtoan = 0;

            IF ( v_counts_tp = 1 ) THEN
                UPDATE tuphap_anphi
                SET
                    anphi = v_tamunganphi,
                    duongsu_id = v_duongsu_id,
                    duongsu_ids = v_duongsu_ids
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        ELSIF ( v_maloaivuviec = '3' ) THEN
            SELECT
                sothongbao,
                ngaythongbao,
                tamunganphi,
                duongsu_id,
                duongsu_ids
            INTO
                v_sothongbao,
                v_ngaythongbao,
                v_tamunganphi,
                v_duongsu_id,
                v_duongsu_ids
            FROM
                ahn_anphi
            WHERE
                id = v_anphi_id;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec
                AND trangthaithanhtoan = 0;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sothongbao = v_sothongbao,
                    ngaythongbao = v_ngaythongbao,
                    tongtien = v_tamunganphi,
                    duongsu_id = v_duongsu_id,
                    duongsu_ids = v_duongsu_ids
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec
                    AND trangthaithanhtoan = 0;

            END IF;
           ---------------
            SELECT
                COUNT(*)
            INTO v_counts_tp
            FROM
                tuphap_anphi     tp
                LEFT JOIN dvcqg_thanh_toan tt ON tt.id = tp.dvcqg_tt_id
            WHERE
                    tp.anphi_id = v_anphi_id
                AND tp.maloaivuviec = v_maloaivuviec
                AND tt.trangthaithanhtoan = 0;

            IF ( v_counts_tp = 1 ) THEN
                UPDATE tuphap_anphi
                SET
                    anphi = v_tamunganphi,
                    duongsu_id = v_duongsu_id,
                    duongsu_ids = v_duongsu_ids
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        ELSIF ( v_maloaivuviec = '4' ) THEN
            SELECT
                sothongbao,
                ngaythongbao,
                tamunganphi,
                duongsu_id
            INTO
                v_sothongbao,
                v_ngaythongbao,
                v_tamunganphi,
                v_duongsu_id
            FROM
                akt_anphi
            WHERE
                id = v_anphi_id;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec
                AND trangthaithanhtoan = 0;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sothongbao = v_sothongbao,
                    ngaythongbao = v_ngaythongbao,
                    tongtien = v_tamunganphi,
                    duongsu_id = v_duongsu_id
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec
                    AND trangthaithanhtoan = 0;

            END IF;  
              ---------------
            SELECT
                COUNT(*)
            INTO v_counts_tp
            FROM
                tuphap_anphi     tp
                LEFT JOIN dvcqg_thanh_toan tt ON tt.id = tp.dvcqg_tt_id
            WHERE
                    tp.anphi_id = v_anphi_id
                AND tp.maloaivuviec = v_maloaivuviec
                AND tt.trangthaithanhtoan = 0;

            IF ( v_counts_tp = 1 ) THEN
                UPDATE tuphap_anphi
                SET
                    anphi = v_tamunganphi,
                    duongsu_id = v_duongsu_id
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        ELSIF ( v_maloaivuviec = '5' ) THEN
            SELECT
                sothongbao,
                ngaythongbao,
                tamunganphi,
                duongsu_id,
                duongsu_ids
            INTO
                v_sothongbao,
                v_ngaythongbao,
                v_tamunganphi,
                v_duongsu_id,
                v_duongsu_ids
            FROM
                ald_anphi
            WHERE
                id = v_anphi_id;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec
                AND trangthaithanhtoan = 0;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sothongbao = v_sothongbao,
                    ngaythongbao = v_ngaythongbao,
                    tongtien = v_tamunganphi,
                    duongsu_id = v_duongsu_id,
                    duongsu_ids = v_duongsu_ids
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec
                    AND trangthaithanhtoan = 0;

            END IF;   
             ---------------
            SELECT
                COUNT(*)
            INTO v_counts_tp
            FROM
                tuphap_anphi     tp
                LEFT JOIN dvcqg_thanh_toan tt ON tt.id = tp.dvcqg_tt_id
            WHERE
                    tp.anphi_id = v_anphi_id
                AND tp.maloaivuviec = v_maloaivuviec
                AND tt.trangthaithanhtoan = 0;

            IF ( v_counts_tp = 1 ) THEN
                UPDATE tuphap_anphi
                SET
                    anphi = v_tamunganphi,
                    duongsu_id = v_duongsu_id
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        ELSIF ( v_maloaivuviec = '6' ) THEN
            SELECT
                sothongbao,
                ngaythongbao,
                tamunganphi,
                duongsu_id,
                duongsu_ids
            INTO
                v_sothongbao,
                v_ngaythongbao,
                v_tamunganphi,
                v_duongsu_id,
                v_duongsu_ids
            FROM
                ahc_anphi
            WHERE
                id = v_anphi_id;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec
                AND trangthaithanhtoan = 0;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sothongbao = v_sothongbao,
                    ngaythongbao = v_ngaythongbao,
                    tongtien = v_tamunganphi,
                    duongsu_id = v_duongsu_id,
                    duongsu_ids = v_duongsu_ids
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec
                    AND trangthaithanhtoan = 0;

            END IF;    
            ---------------
            SELECT
                COUNT(*)
            INTO v_counts_tp
            FROM
                tuphap_anphi     tp
                LEFT JOIN dvcqg_thanh_toan tt ON tt.id = tp.dvcqg_tt_id
            WHERE
                    tp.anphi_id = v_anphi_id
                AND tp.maloaivuviec = v_maloaivuviec
                AND tt.trangthaithanhtoan = 0;

            IF ( v_counts_tp = 1 ) THEN
                UPDATE tuphap_anphi
                SET
                    anphi = v_tamunganphi,
                    duongsu_id = v_duongsu_id,
                    duongsu_ids = v_duongsu_ids
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        ELSIF ( v_maloaivuviec = '7' ) THEN
            SELECT
                sothongbao,
                ngaythongbao,
                tamunganphi,
                duongsu_id
            INTO
                v_sothongbao,
                v_ngaythongbao,
                v_tamunganphi,
                v_duongsu_id
            FROM
                aps_anphi
            WHERE
                id = v_anphi_id;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec
                AND trangthaithanhtoan = 0;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sothongbao = v_sothongbao,
                    ngaythongbao = v_ngaythongbao,
                    tongtien = v_tamunganphi,
                    duongsu_id = v_duongsu_id
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec
                    AND trangthaithanhtoan = 0;

            END IF;    
            ---------------
            SELECT
                COUNT(*)
            INTO v_counts_tp
            FROM
                tuphap_anphi     tp
                LEFT JOIN dvcqg_thanh_toan tt ON tt.id = tp.dvcqg_tt_id
            WHERE
                    tp.anphi_id = v_anphi_id
                AND tp.maloaivuviec = v_maloaivuviec
                AND tt.trangthaithanhtoan = 0;

            IF ( v_counts_tp = 1 ) THEN
                UPDATE tuphap_anphi
                SET
                    anphi = v_tamunganphi,
                    duongsu_id = v_duongsu_id
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        END IF;
    END thanh_toan_up;

    PROCEDURE thanh_toan_up_from_thads (
        v_anphi_id     IN NUMBER,
        v_maloaivuviec IN VARCHAR2
    ) AS

        v_counts       NUMBER;
        v_sobienlai    VARCHAR2(255);
        v_ngaythongbao DATE;
        v_tamunganphi  NUMBER;
        v_duongsu_id   NUMBER;
        v_duongsu_ids  VARCHAR2(250);
    BEGIN
        IF ( v_maloaivuviec = '2' ) THEN
            SELECT
                sobienlai
            INTO v_sobienlai
            FROM
                tuphap_anphi
            WHERE
                    anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sobienlai = v_sobienlai,
                    trangthaithanhtoan = 1
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        ELSIF ( v_maloaivuviec = '3' ) THEN
            SELECT
                sobienlai
            INTO v_sobienlai
            FROM
                tuphap_anphi
            WHERE
                    anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sobienlai = v_sobienlai,
                    trangthaithanhtoan = 1
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        ELSIF ( v_maloaivuviec = '4' ) THEN
            SELECT
                sobienlai
            INTO v_sobienlai
            FROM
                tuphap_anphi
            WHERE
                    anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sobienlai = v_sobienlai,
                    trangthaithanhtoan = 1
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        ELSIF ( v_maloaivuviec = '5' ) THEN
            SELECT
                sobienlai
            INTO v_sobienlai
            FROM
                tuphap_anphi
            WHERE
                    anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    trangthaithanhtoan = 1
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        ELSIF ( v_maloaivuviec = '6' ) THEN
            SELECT
                sobienlai
            INTO v_sobienlai
            FROM
                tuphap_anphi
            WHERE
                    anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sobienlai = v_sobienlai,
                    trangthaithanhtoan = 1
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        ELSIF ( v_maloaivuviec = '7' ) THEN
            SELECT
                sobienlai
            INTO v_sobienlai
            FROM
                tuphap_anphi
            WHERE
                    anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;
            -----------
            SELECT
                COUNT(*)
            INTO v_counts
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec;

            IF ( v_counts = 1 ) THEN
                UPDATE dvcqg_thanh_toan
                SET
                    sobienlai = v_sobienlai,
                    trangthaithanhtoan = 1
                WHERE
                        anphi_id = v_anphi_id
                    AND maloaivuviec = v_maloaivuviec;

            END IF;

        END IF;
    END thanh_toan_up_from_thads;

    PROCEDURE check_thanh_toan_in_anphi (
        v_magiaidoan   IN NUMBER,
        v_donid        IN NUMBER,
        v_donxuly_id   IN NUMBER,
        v_anphi_id     IN NUMBER,
        v_maloaivuviec IN VARCHAR2,
        v_ds_ids       IN VARCHAR2,
        items_cursor   OUT SYS_REFCURSOR
    ) IS
    BEGIN
        OPEN items_cursor FOR SELECT
                                                        tt.*
                                                    FROM
                                                        dvcqg_thanh_toan tt
                              WHERE
                                      tt.anphi_id = v_anphi_id
                                  AND tt.donid = v_donid
                                  AND maloaivuviec = v_maloaivuviec
                                  AND magiaidoan = v_magiaidoan;

    END check_thanh_toan_in_anphi;

    PROCEDURE thanh_toan_in_anphi (
        v_magiaidoan   IN NUMBER,
        v_donid        IN NUMBER,
        v_donxuly_id   IN NUMBER,
        v_anphi_id     IN NUMBER,
        v_maloaivuviec IN VARCHAR2,
        v_ds_ids       IN VARCHAR2
    ) AS

        v_counts      NUMBER;
        v_counts_matb NUMBER;
        v_ma_thongbao VARCHAR2(255) := NULL;
        dvtha_id      NUMBER;
        v_count_ds    NUMBER := 0;
        v_count_tp    NUMBER;
        v_id          NUMBER;
    BEGIN
        SELECT
            instr(v_ds_ids, ',')
        INTO v_count_ds
        FROM
            dual;
  ---------------------
        SELECT
            COUNT(*)
        INTO v_counts
        FROM
            dvcqg_thanh_toan tt
        WHERE
                tt.anphi_id = v_anphi_id
            AND tt.donid = v_donid
            AND maloaivuviec = v_maloaivuviec
            AND magiaidoan = v_magiaidoan;

        IF ( v_counts = 0 ) THEN
       -----------
            v_ma_thongbao := pkg_dvcqg_app.create_ma_tb_random(v_ma_thongbao);
       -----------
            v_id := dvcqg_thanh_toan_seq.nextval;
        --------------
            IF ( v_maloaivuviec = '2' ) THEN
                IF ( v_count_ds = 0 ) THEN
                    FOR item_tp IN (
                        SELECT
                            dx.id                        donxuly_id,
                            ai.id                        anphi_id,
                            ai.donid,
                            tha.id                       donvitha_id,
                            lh.ma                        maloaihinhthu,
                            to_char(do.mavuviec)         mavuviec,
                            tk.sotk_khobac               sotaikhoankb,
                            tk.ma_khobac                 makhobac,
                            tk.tentk_khobac              tenkhobac,
                            tha.ma_dinh_danh             machicuc,
                            tha.ma_ten                   tenchicuc,
                            ai.ngaythongbao,
                            ai.sothongbao,
                            tn.ma_ten                    tentoathongbao,
                            lh.ten                       tenloaihinhthu,
                            du.tenduongsu                hotennguoinop,
                            du.socmnd                    socmndnguoinop,
                            du.tamtruchitiet             diachinguoinop,
                            hc.ten                       huyennguoinop,
                            hc1.ten                      tinhnguoinop,
                            replace(ai.tamunganphi, '.') tongtien,
                            ai.duongsu_id,
                            ai.duongsu_ids,
                            tk.ten_tk_thuhuong
                        FROM
                                 ads_anphi ai
                            INNER JOIN ads_don           do ON ai.donid = do.id
                            INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                            INNER JOIN ads_don_duongsu   du ON ai.duongsu_ids = du.id    --AI.DONID=DU.DONID cũ
                        --INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                            INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                            LEFT JOIN dm_hanhchinh      hc ON du.tamtruid = hc.id
                            LEFT JOIN dm_hanhchinh      hc1 ON du.tamtrutinhid = hc1.id
                            LEFT JOIN ads_don_xuly      dx ON dx.donid = ai.donid
                                                         AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
--                      LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
--                        LEFT JOIN ADS_FILE FL ON FL.DONID=AI.DONID AND FL.BIEUMAUID=67
                            LEFT JOIN (
                                SELECT
                                    qd.donid
                                FROM
                                         ads_sotham_quyetdinh qd
                                    INNER JOIN (
                                        SELECT
                                            qda.*
                                        FROM
                                            dm_qd_quyetdinh qda
                                        WHERE
                                            qda.loaiid = 3
                                    ) dmqd ON dmqd.id = qd.quyetdinhid
                            )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                            LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                            LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                        WHERE --AI.MAGIAIDOAN=V_MAGIAIDOAN AND 
                        --DU.TUCACHTOTUNG_MA='NGUYENDON' --TD.BIEUMAUID=67 --Thông báo nộp tiền tạm ứng án phí
                        --AND DU.ISDAIDIEN = 1 --AND FL.TENFILE IS NOT NULL
                        --AND 
                                ai.tamunganphi != 0
                            AND ai.id = v_anphi_id
                    ) LOOP
                        IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                            INSERT INTO dvcqg_thanh_toan (
                                id,
                                ma_thongbao,
                                donid,
                                tongdatid,
                                donxuly_id,
                                anphi_id,
                                maloaivuviec,
                                donvitha_id,
                                maloaihinhthu,
                                mavuviec,
                                sotaikhoankb,
                                makhobac,
                                tenkhobac,
                                machicuc,
                                tenchicuc,
                                ngaythongbao,
                                sothongbao,
                                tentoathongbao,
                                tenloaihinhthu,
                                hotennguoinop,
                                socmndnguoinop,
                                diachinguoinop,
                                huyennguoinop,
                                tinhnguoinop,
                                tongtien,
                                ngay_tao,
                                magiaidoan,
                                duongsu_id,
                                duongsu_ids,
                                ten_tk_thuhuong
                            ) VALUES ( v_id,
                                       v_ma_thongbao,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.donxuly_id,
                                       item_tp.anphi_id,
                                       v_maloaivuviec,
                                       item_tp.donvitha_id,
                                       item_tp.maloaihinhthu,
                                       item_tp.mavuviec,
                                       item_tp.sotaikhoankb,
                                       item_tp.makhobac,
                                       item_tp.tenkhobac,
                                       item_tp.machicuc,
                                       item_tp.tenchicuc,
                                       item_tp.ngaythongbao,
                                       item_tp.sothongbao,
                                       item_tp.tentoathongbao,
                                       item_tp.tenloaihinhthu,
                                       item_tp.hotennguoinop,
                                       item_tp.socmndnguoinop,
                                       item_tp.diachinguoinop,
                                       item_tp.huyennguoinop,
                                       item_tp.tinhnguoinop,
                                       item_tp.tongtien,
                                       sysdate,
                                       v_magiaidoan,
                                       item_tp.duongsu_id,
                                       item_tp.duongsu_ids,
                                       item_tp.ten_tk_thuhuong );
              ---------------------
                            SELECT
                                COUNT(*)
                            INTO v_count_tp
                            FROM
                                tuphap_anphi tp
                            WHERE
                                    tp.vuviecid = item_tp.donid
                                AND tp.anphi_id = v_anphi_id
                                AND tp.maloaivuviec = v_maloaivuviec;

                            IF ( v_count_tp = 0 ) THEN
                                INSERT INTO tuphap_anphi (
                                    id,
                                    maloaivuviec,
                                    vuviecid,
                                    sobienlai,
                                    anphi,
                                    vbtongdatid,
                                    donvi_thutien_id,
                                    ngaytao,
                                    nguoitao,
                                    nguoitaoid,
                                    nguoithutien,
                                    nop_isnguyendon,
                                    nop_hoten,
                                    nop_gioitinh,
                                    nop_namsinh,
                                    nop_cmnd,
                                    nop_tel,
                                    nop_email,
                                    nop_diachi,
                                    anphi_id,
                                    duongsu_ids,
                                    dvcqg_tt_id
                                ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                           v_maloaivuviec,
                                           item_tp.donid,
                                           NULL,
                                           item_tp.tongtien,
                                           NULL,
                                           item_tp.donvitha_id,
                                           sysdate,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           v_anphi_id,
                                           item_tp.duongsu_ids,
                                           v_id );

                            END IF;

                        END IF;
                    END LOOP;

                ELSIF ( v_count_ds > 0 ) THEN
                    FOR item_tp IN (
                        SELECT
                            dx.id                        donxuly_id,
                            ai.id                        anphi_id,
                            ai.donid,
                            tha.id                       donvitha_id,
                            lh.ma                        maloaihinhthu,
                            to_char(do.mavuviec)         mavuviec,
                            tk.sotk_khobac               sotaikhoankb,
                            tk.ma_khobac                 makhobac,
                            tk.tentk_khobac              tenkhobac,
                            tha.ma_dinh_danh             machicuc,
                            tha.ma_ten                   tenchicuc,
                            ai.ngaythongbao,
                            ai.sothongbao,
                            tn.ma_ten                    tentoathongbao,
                            lh.ten                       tenloaihinhthu,
                            ap.tenduongsu                hotennguoinop,
                            NULL                         socmndnguoinop,
                            NULL                         diachinguoinop,
                            NULL                         huyennguoinop,
                            NULL                         tinhnguoinop,
                            replace(ai.tamunganphi, '.') tongtien,
                            ai.duongsu_id,
                            ai.duongsu_ids,
                            tk.ten_tk_thuhuong
                        FROM
                                 ads_anphi ai
                            INNER JOIN ads_don           do ON ai.donid = do.id
                            INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                            INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                            LEFT JOIN (
                                SELECT
                                    LISTAGG(hn.tenduongsu, ', ') WITHIN GROUP(
                                    ORDER BY
                                        hn.tenduongsu
                                    ) tenduongsu,
                                    du.anphi_id
                                FROM
                                    ads_anphi_duongsu du
                                    LEFT JOIN ads_don_duongsu   hn ON hn.id = du.duongsu_id
                                GROUP BY
                                    du.anphi_id
                            )                 ap ON ap.anphi_id = ai.id
                            LEFT JOIN ads_don_xuly      dx ON dx.donid = ai.donid
                                                         AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                            LEFT JOIN (
                                SELECT
                                    qd.donid
                                FROM
                                         ads_sotham_quyetdinh qd
                                    INNER JOIN (
                                        SELECT
                                            qda.*
                                        FROM
                                            dm_qd_quyetdinh qda
                                        WHERE
                                            qda.loaiid = 3
                                    ) dmqd ON dmqd.id = qd.quyetdinhid
                            )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                            LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                            LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                        WHERE
                                replace(ai.tamunganphi, '.') != 0
                            AND ai.id = v_anphi_id
                            AND ROWNUM = 1
                    ) LOOP
                        IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                            INSERT INTO dvcqg_thanh_toan (
                                id,
                                ma_thongbao,
                                donid,
                                tongdatid,
                                donxuly_id,
                                anphi_id,
                                maloaivuviec,
                                donvitha_id,
                                maloaihinhthu,
                                mavuviec,
                                sotaikhoankb,
                                makhobac,
                                tenkhobac,
                                machicuc,
                                tenchicuc,
                                ngaythongbao,
                                sothongbao,
                                tentoathongbao,
                                tenloaihinhthu,
                                hotennguoinop,
                                socmndnguoinop,
                                diachinguoinop,
                                huyennguoinop,
                                tinhnguoinop,
                                tongtien,
                                ngay_tao,
                                duongsu_id,
                                duongsu_ids,
                                ten_tk_thuhuong
                            ) VALUES ( v_id,
                                       v_ma_thongbao,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.donxuly_id,
                                       item_tp.anphi_id,
                                       v_maloaivuviec,
                                       item_tp.donvitha_id,
                                       item_tp.maloaihinhthu,
                                       item_tp.mavuviec,
                                       item_tp.sotaikhoankb,
                                       item_tp.makhobac,
                                       item_tp.tenkhobac,
                                       item_tp.machicuc,
                                       item_tp.tenchicuc,
                                       item_tp.ngaythongbao,
                                       item_tp.sothongbao,
                                       item_tp.tentoathongbao,
                                       item_tp.tenloaihinhthu,
                                       item_tp.hotennguoinop,
                                       item_tp.socmndnguoinop,
                                       item_tp.diachinguoinop,
                                       item_tp.huyennguoinop,
                                       item_tp.tinhnguoinop,
                                       item_tp.tongtien,
                                       sysdate,
                                       item_tp.duongsu_id,
                                       item_tp.duongsu_ids,
                                       item_tp.ten_tk_thuhuong );
                                --------------------
                            SELECT
                                COUNT(*)
                            INTO v_count_tp
                            FROM
                                tuphap_anphi tp
                            WHERE
                                    tp.vuviecid = item_tp.donid
                                AND tp.anphi_id = v_anphi_id
                                AND tp.maloaivuviec = v_maloaivuviec;

                            IF ( v_count_tp = 0 ) THEN
                                INSERT INTO tuphap_anphi (
                                    id,
                                    maloaivuviec,
                                    vuviecid,
                                    sobienlai,
                                    anphi,
                                    vbtongdatid,
                                    donvi_thutien_id,
                                    ngaytao,
                                    nguoitao,
                                    nguoitaoid,
                                    nguoithutien,
                                    nop_isnguyendon,
                                    nop_hoten,
                                    nop_gioitinh,
                                    nop_namsinh,
                                    nop_cmnd,
                                    nop_tel,
                                    nop_email,
                                    nop_diachi,
                                    anphi_id,
                                    duongsu_ids,
                                    dvcqg_tt_id
                                ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                           v_maloaivuviec,
                                           item_tp.donid,
                                           NULL,
                                           item_tp.tongtien,
                                           NULL,
                                           item_tp.donvitha_id,
                                           sysdate,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           v_anphi_id,
                                           item_tp.duongsu_ids,
                                           v_id );

                            END IF;

                        END IF;
                    END LOOP;
                END IF;
            ELSIF ( v_maloaivuviec = '3' ) THEN
                IF ( v_count_ds = 0 ) THEN
                    FOR item_tp IN (
                        SELECT
                            dx.id                        donxuly_id,
                            ai.id                        anphi_id,
                            ai.donid,
                            tha.id                       donvitha_id,
                            lh.ma                        maloaihinhthu,
                            to_char(do.mavuviec)         mavuviec,
                            tk.sotk_khobac               sotaikhoankb,
                            tk.ma_khobac                 makhobac,
                            tk.tentk_khobac              tenkhobac,
                            tha.ma_dinh_danh             machicuc,
                            tha.ma_ten                   tenchicuc,
                            ai.ngaythongbao,
                            ai.sothongbao,
                            tn.ma_ten                    tentoathongbao,
                            lh.ten                       tenloaihinhthu,
                            du.tenduongsu                hotennguoinop,
                            du.socmnd                    socmndnguoinop,
                            du.tamtruchitiet             diachinguoinop,
                            hc.ten                       huyennguoinop,
                            hc1.ten                      tinhnguoinop,
                            replace(ai.tamunganphi, '.') tongtien,
                            ai.duongsu_id,
                            ai.duongsu_ids,
                            tk.ten_tk_thuhuong
                        FROM
                                 ahn_anphi ai
                            INNER JOIN ahn_don           do ON ai.donid = do.id
                            INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                            INNER JOIN ahn_don_duongsu   du ON ai.duongsu_ids = du.id--;  AI.DUONGSU_IDS like DU.ID || '%'   --AI.DONID=DU.DONID cũ
                                    --INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                            INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                            LEFT JOIN dm_hanhchinh      hc ON du.tamtruid = hc.id
                            LEFT JOIN dm_hanhchinh      hc1 ON du.tamtrutinhid = hc1.id
                            LEFT JOIN ahn_don_xuly      dx ON dx.donid = ai.donid
                                                         AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
            --                      LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
            --                      LEFT JOIN AHN_FILE FL ON FL.DONID=AI.DONID AND FL.BIEUMAUID=67
                            LEFT JOIN (
                                SELECT
                                    qd.donid
                                FROM
                                         ahn_sotham_quyetdinh qd
                                    INNER JOIN (
                                        SELECT
                                            qda.*
                                        FROM
                                            dm_qd_quyetdinh qda
                                        WHERE
                                            qda.loaiid = 3
                                    ) dmqd ON dmqd.id = qd.quyetdinhid
                            )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                            LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                            LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                        WHERE --DU.TUCACHTOTUNG_MA='NGUYENDON' --TD.BIEUMAUID=67 --Thông báo nộp tiền tạm ứng án phí
                                    --AND DU.ISDAIDIEN = 1 --AND FL.TENFILE IS NOT NULL
                                    --AND 
                                replace(ai.tamunganphi, '.') != 0
                            AND ai.id = v_anphi_id
                            AND ROWNUM = 1
                    ) LOOP
                        IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                            INSERT INTO dvcqg_thanh_toan (
                                id,
                                ma_thongbao,
                                donid,
                                tongdatid,
                                donxuly_id,
                                anphi_id,
                                maloaivuviec,
                                donvitha_id,
                                maloaihinhthu,
                                mavuviec,
                                sotaikhoankb,
                                makhobac,
                                tenkhobac,
                                machicuc,
                                tenchicuc,
                                ngaythongbao,
                                sothongbao,
                                tentoathongbao,
                                tenloaihinhthu,
                                hotennguoinop,
                                socmndnguoinop,
                                diachinguoinop,
                                huyennguoinop,
                                tinhnguoinop,
                                tongtien,
                                ngay_tao,
                                duongsu_id,
                                duongsu_ids,
                                ten_tk_thuhuong
                            ) VALUES ( v_id,
                                       v_ma_thongbao,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.donxuly_id,
                                       item_tp.anphi_id,
                                       v_maloaivuviec,
                                       item_tp.donvitha_id,
                                       item_tp.maloaihinhthu,
                                       item_tp.mavuviec,
                                       item_tp.sotaikhoankb,
                                       item_tp.makhobac,
                                       item_tp.tenkhobac,
                                       item_tp.machicuc,
                                       item_tp.tenchicuc,
                                       item_tp.ngaythongbao,
                                       item_tp.sothongbao,
                                       item_tp.tentoathongbao,
                                       item_tp.tenloaihinhthu,
                                       item_tp.hotennguoinop,
                                       item_tp.socmndnguoinop,
                                       item_tp.diachinguoinop,
                                       item_tp.huyennguoinop,
                                       item_tp.tinhnguoinop,
                                       item_tp.tongtien,
                                       sysdate,
                                       item_tp.duongsu_id,
                                       item_tp.duongsu_ids,
                                       item_tp.ten_tk_thuhuong );
                               ---------------------
                            SELECT
                                COUNT(*)
                            INTO v_count_tp
                            FROM
                                tuphap_anphi tp
                            WHERE
                                    tp.vuviecid = item_tp.donid
                                AND tp.anphi_id = v_anphi_id
                                AND tp.maloaivuviec = v_maloaivuviec;

                            IF ( v_count_tp = 0 ) THEN
                                INSERT INTO tuphap_anphi (
                                    id,
                                    maloaivuviec,
                                    vuviecid,
                                    sobienlai,
                                    anphi,
                                    vbtongdatid,
                                    donvi_thutien_id,
                                    ngaytao,
                                    nguoitao,
                                    nguoitaoid,
                                    nguoithutien,
                                    nop_isnguyendon,
                                    nop_hoten,
                                    nop_gioitinh,
                                    nop_namsinh,
                                    nop_cmnd,
                                    nop_tel,
                                    nop_email,
                                    nop_diachi,
                                    anphi_id,
                                    duongsu_id,
                                    dvcqg_tt_id
                                ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                           v_maloaivuviec,
                                           item_tp.donid,
                                           NULL,
                                           item_tp.tongtien,
                                           NULL,
                                           item_tp.donvitha_id,
                                           sysdate,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           v_anphi_id,
                                           item_tp.duongsu_id,
                                           v_id );

                            END IF;

                        END IF;
                    END LOOP;

                ELSIF ( v_count_ds > 0 ) THEN
                    FOR item_tp IN (
                        SELECT
                            dx.id                        donxuly_id,
                            ai.id                        anphi_id,
                            ai.donid,
                            tha.id                       donvitha_id,
                            lh.ma                        maloaihinhthu,
                            to_char(do.mavuviec)         mavuviec,
                            tk.sotk_khobac               sotaikhoankb,
                            tk.ma_khobac                 makhobac,
                            tk.tentk_khobac              tenkhobac,
                            tha.ma_dinh_danh             machicuc,
                            tha.ma_ten                   tenchicuc,
                            ai.ngaythongbao,
                            ai.sothongbao,
                            tn.ma_ten                    tentoathongbao,
                            lh.ten                       tenloaihinhthu,
                            ap.tenduongsu                hotennguoinop,
                            NULL                         socmndnguoinop,
                            NULL                         diachinguoinop,
                            NULL                         huyennguoinop,
                            NULL                         tinhnguoinop,
                            replace(ai.tamunganphi, '.') tongtien,
                            ai.duongsu_id,
                            ai.duongsu_ids,
                            tk.ten_tk_thuhuong
                        FROM
                                 ahn_anphi ai
                            INNER JOIN ahn_don           do ON ai.donid = do.id
                            INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                            INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                            LEFT JOIN (
                                SELECT
                                    LISTAGG(hn.tenduongsu, ', ') WITHIN GROUP(
                                    ORDER BY
                                        hn.tenduongsu
                                    ) tenduongsu,
                                    du.anphi_id
                                FROM
                                    ahn_anphi_duongsu du
                                    LEFT JOIN ahn_don_duongsu   hn ON hn.id = du.duongsu_id
                                GROUP BY
                                    du.anphi_id
                            )                 ap ON ap.anphi_id = ai.id
                            LEFT JOIN ahn_don_xuly      dx ON dx.donid = ai.donid
                                                         AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                            LEFT JOIN (
                                SELECT
                                    qd.donid
                                FROM
                                         ahn_sotham_quyetdinh qd
                                    INNER JOIN (
                                        SELECT
                                            qda.*
                                        FROM
                                            dm_qd_quyetdinh qda
                                        WHERE
                                            qda.loaiid = 3
                                    ) dmqd ON dmqd.id = qd.quyetdinhid
                            )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                            LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                            LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                        WHERE
                                replace(ai.tamunganphi, '.') != 0
                            AND ai.id = v_anphi_id
                            AND ROWNUM = 1
                    ) LOOP
                        IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                            INSERT INTO dvcqg_thanh_toan (
                                id,
                                ma_thongbao,
                                donid,
                                tongdatid,
                                donxuly_id,
                                anphi_id,
                                maloaivuviec,
                                donvitha_id,
                                maloaihinhthu,
                                mavuviec,
                                sotaikhoankb,
                                makhobac,
                                tenkhobac,
                                machicuc,
                                tenchicuc,
                                ngaythongbao,
                                sothongbao,
                                tentoathongbao,
                                tenloaihinhthu,
                                hotennguoinop,
                                socmndnguoinop,
                                diachinguoinop,
                                huyennguoinop,
                                tinhnguoinop,
                                tongtien,
                                ngay_tao,
                                duongsu_id,
                                duongsu_ids,
                                ten_tk_thuhuong
                            ) VALUES ( v_id,
                                       v_ma_thongbao,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.donxuly_id,
                                       item_tp.anphi_id,
                                       v_maloaivuviec,
                                       item_tp.donvitha_id,
                                       item_tp.maloaihinhthu,
                                       item_tp.mavuviec,
                                       item_tp.sotaikhoankb,
                                       item_tp.makhobac,
                                       item_tp.tenkhobac,
                                       item_tp.machicuc,
                                       item_tp.tenchicuc,
                                       item_tp.ngaythongbao,
                                       item_tp.sothongbao,
                                       item_tp.tentoathongbao,
                                       item_tp.tenloaihinhthu,
                                       item_tp.hotennguoinop,
                                       item_tp.socmndnguoinop,
                                       item_tp.diachinguoinop,
                                       item_tp.huyennguoinop,
                                       item_tp.tinhnguoinop,
                                       item_tp.tongtien,
                                       sysdate,
                                       item_tp.duongsu_id,
                                       item_tp.duongsu_ids,
                                       item_tp.ten_tk_thuhuong );
                                --------------------------
                            SELECT
                                COUNT(*)
                            INTO v_count_tp
                            FROM
                                tuphap_anphi tp
                            WHERE
                                    tp.vuviecid = item_tp.donid
                                AND tp.anphi_id = v_anphi_id
                                AND tp.maloaivuviec = v_maloaivuviec
                                AND tp.duongsu_ids = item_tp.duongsu_ids;

                            IF ( v_count_tp = 0 ) THEN
                                INSERT INTO tuphap_anphi (
                                    id,
                                    maloaivuviec,
                                    vuviecid,
                                    sobienlai,
                                    anphi,
                                    vbtongdatid,
                                    donvi_thutien_id,
                                    ngaytao,
                                    nguoitao,
                                    nguoitaoid,
                                    nguoithutien,
                                    nop_isnguyendon,
                                    nop_hoten,
                                    nop_gioitinh,
                                    nop_namsinh,
                                    nop_cmnd,
                                    nop_tel,
                                    nop_email,
                                    nop_diachi,
                                    anphi_id,
                                    duongsu_ids,
                                    dvcqg_tt_id
                                ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                           v_maloaivuviec,
                                           item_tp.donid,
                                           NULL,
                                           item_tp.tongtien,
                                           NULL,
                                           item_tp.donvitha_id,
                                           sysdate,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           v_anphi_id,
                                           item_tp.duongsu_ids,
                                           v_id );

                            END IF;

                        END IF;
                    END LOOP;
                END IF;  
              --VNPY LE BA THO SUA THEO MALOAIVUVIEC=2
            ELSIF ( v_maloaivuviec = '4' ) THEN
                IF ( v_count_ds = 0 ) THEN
                    FOR item_tp IN (
                        SELECT
                            dx.id                        donxuly_id,
                            ai.id                        anphi_id,
                            ai.donid,
                            tha.id                       donvitha_id,
                            lh.ma                        maloaihinhthu,
                            to_char(do.mavuviec)         mavuviec,
                            tk.sotk_khobac               sotaikhoankb,
                            tk.ma_khobac                 makhobac,
                            tk.tentk_khobac              tenkhobac,
                            tha.ma_dinh_danh             machicuc,
                            tha.ma_ten                   tenchicuc,
                            ai.ngaythongbao,
                            ai.sothongbao,
                            tn.ma_ten                    tentoathongbao,
                            lh.ten                       tenloaihinhthu,
                            du.tenduongsu                hotennguoinop,
                            du.socmnd                    socmndnguoinop,
                            du.tamtruchitiet             diachinguoinop,
                            hc.ten                       huyennguoinop,
                            hc1.ten                      tinhnguoinop,
                            replace(ai.tamunganphi, '.') tongtien,
                            ai.duongsu_id,
                            ai.duongsu_ids,
                            tk.ten_tk_thuhuong
                        FROM
                                 akt_anphi ai
                            INNER JOIN akt_don           do ON ai.donid = do.id
                            INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                        --VNPT LE BA THO SUA DUONGSU
                            INNER JOIN akt_don_duongsu   du ON ai.duongsu_ids = du.id    --AI.DONID=DU.DONID cũ
                        --INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                            INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                            LEFT JOIN dm_hanhchinh      hc ON du.tamtruid = hc.id
                            LEFT JOIN dm_hanhchinh      hc1 ON du.tamtrutinhid = hc1.id
                            LEFT JOIN akt_don_xuly      dx ON dx.donid = ai.donid
                                                         AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
--                      LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
--                      LEFT JOIN AKT_FILE FL ON FL.DONID=AI.DONID AND FL.BIEUMAUID=67
                            LEFT JOIN (
                                SELECT
                                    qd.donid
                                FROM
                                         akt_sotham_quyetdinh qd
                                    INNER JOIN (
                                        SELECT
                                            qda.*
                                        FROM
                                            dm_qd_quyetdinh qda
                                        WHERE
                                            qda.loaiid = 3
                                    ) dmqd ON dmqd.id = qd.quyetdinhid
                            )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                            LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                            LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                        WHERE --DU.TUCACHTOTUNG_MA='NGUYENDON' --AND TD.BIEUMAUID=67--TD.BIEUMAUID=67 --Thông báo nộp tiền tạm ứng án phí
                        --AND DU.ISDAIDIEN = 1 --AND FL.TENFILE IS NOT NULL
                        --AND 
                                replace(ai.tamunganphi, '.') != 0
                            AND ai.id = v_anphi_id
                    ) LOOP
                        IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                            INSERT INTO dvcqg_thanh_toan (
                                id,
                                ma_thongbao,
                                donid,
                                tongdatid,
                                donxuly_id,
                                anphi_id,
                                maloaivuviec,
                                donvitha_id,
                                maloaihinhthu,
                                mavuviec,
                                sotaikhoankb,
                                makhobac,
                                tenkhobac,
                                machicuc,
                                tenchicuc,
                                ngaythongbao,
                                sothongbao,
                                tentoathongbao,
                                tenloaihinhthu,
                                hotennguoinop,
                                socmndnguoinop,
                                diachinguoinop,
                                huyennguoinop,
                                tinhnguoinop,
                                tongtien,
                                ngay_tao,
                                magiaidoan,
                                duongsu_id,
                                duongsu_ids,
                                ten_tk_thuhuong
                            ) VALUES ( v_id,
                                       v_ma_thongbao,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.donxuly_id,
                                       item_tp.anphi_id,
                                       v_maloaivuviec,
                                       item_tp.donvitha_id,
                                       item_tp.maloaihinhthu,
                                       item_tp.mavuviec,
                                       item_tp.sotaikhoankb,
                                       item_tp.makhobac,
                                       item_tp.tenkhobac,
                                       item_tp.machicuc,
                                       item_tp.tenchicuc,
                                       item_tp.ngaythongbao,
                                       item_tp.sothongbao,
                                       item_tp.tentoathongbao,
                                       item_tp.tenloaihinhthu,
                                       item_tp.hotennguoinop,
                                       item_tp.socmndnguoinop,
                                       item_tp.diachinguoinop,
                                       item_tp.huyennguoinop,
                                       item_tp.tinhnguoinop,
                                       item_tp.tongtien,
                                       sysdate,
                                       v_magiaidoan,
                                       item_tp.duongsu_id,
                                       item_tp.duongsu_ids,
                                       item_tp.ten_tk_thuhuong );
              ---------------------
                            SELECT
                                COUNT(*)
                            INTO v_count_tp
                            FROM
                                tuphap_anphi tp
                            WHERE
                                    tp.vuviecid = item_tp.donid
                                AND tp.anphi_id = v_anphi_id
                                AND tp.maloaivuviec = v_maloaivuviec;

                            IF ( v_count_tp = 0 ) THEN
                                INSERT INTO tuphap_anphi (
                                    id,
                                    maloaivuviec,
                                    vuviecid,
                                    sobienlai,
                                    anphi,
                                    vbtongdatid,
                                    donvi_thutien_id,
                                    ngaytao,
                                    nguoitao,
                                    nguoitaoid,
                                    nguoithutien,
                                    nop_isnguyendon,
                                    nop_hoten,
                                    nop_gioitinh,
                                    nop_namsinh,
                                    nop_cmnd,
                                    nop_tel,
                                    nop_email,
                                    nop_diachi,
                                    anphi_id,
                                    duongsu_ids,
                                    dvcqg_tt_id
                                ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                           v_maloaivuviec,
                                           item_tp.donid,
                                           NULL,
                                           item_tp.tongtien,
                                           NULL,
                                           item_tp.donvitha_id,
                                           sysdate,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           v_anphi_id,
                                           item_tp.duongsu_ids,
                                           v_id );

                            END IF;

                        END IF;
                    END LOOP;

                ELSIF ( v_count_ds > 0 ) THEN
                    FOR item_tp IN (
                        SELECT
                            dx.id                        donxuly_id,
                            ai.id                        anphi_id,
                            ai.donid,
                            tha.id                       donvitha_id,
                            lh.ma                        maloaihinhthu,
                            to_char(do.mavuviec)         mavuviec,
                            tk.sotk_khobac               sotaikhoankb,
                            tk.ma_khobac                 makhobac,
                            tk.tentk_khobac              tenkhobac,
                            tha.ma_dinh_danh             machicuc,
                            tha.ma_ten                   tenchicuc,
                            ai.ngaythongbao,
                            ai.sothongbao,
                            tn.ma_ten                    tentoathongbao,
                            lh.ten                       tenloaihinhthu,
                            ap.tenduongsu                hotennguoinop,
                            NULL                         socmndnguoinop,
                            NULL                         diachinguoinop,
                            NULL                         huyennguoinop,
                            NULL                         tinhnguoinop,
                            replace(ai.tamunganphi, '.') tongtien,
                            ai.duongsu_id,
                            ai.duongsu_ids,
                            tk.ten_tk_thuhuong
                        FROM
                                 akt_anphi ai
                            INNER JOIN akt_don           do ON ai.donid = do.id
                            INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                            INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                            LEFT JOIN (
                                SELECT
                                    LISTAGG(hn.tenduongsu, ', ') WITHIN GROUP(
                                    ORDER BY
                                        hn.tenduongsu
                                    ) tenduongsu,
                                    du.anphi_id
                                FROM
                                    akt_anphi_duongsu du
                                    LEFT JOIN akt_don_duongsu   hn ON hn.id = du.duongsu_id
                                GROUP BY
                                    du.anphi_id
                            )                 ap ON ap.anphi_id = ai.id
                            LEFT JOIN akt_don_xuly      dx ON dx.donid = ai.donid
                                                         AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                            LEFT JOIN (
                                SELECT
                                    qd.donid
                                FROM
                                         akt_sotham_quyetdinh qd
                                    INNER JOIN (
                                        SELECT
                                            qda.*
                                        FROM
                                            dm_qd_quyetdinh qda
                                        WHERE
                                            qda.loaiid = 3
                                    ) dmqd ON dmqd.id = qd.quyetdinhid
                            )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                            LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                            LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                        WHERE
                                replace(ai.tamunganphi, '.') != 0
                            AND ai.id = v_anphi_id
                            AND ROWNUM = 1
                    ) LOOP
                        IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                            INSERT INTO dvcqg_thanh_toan (
                                id,
                                ma_thongbao,
                                donid,
                                tongdatid,
                                donxuly_id,
                                anphi_id,
                                maloaivuviec,
                                donvitha_id,
                                maloaihinhthu,
                                mavuviec,
                                sotaikhoankb,
                                makhobac,
                                tenkhobac,
                                machicuc,
                                tenchicuc,
                                ngaythongbao,
                                sothongbao,
                                tentoathongbao,
                                tenloaihinhthu,
                                hotennguoinop,
                                socmndnguoinop,
                                diachinguoinop,
                                huyennguoinop,
                                tinhnguoinop,
                                tongtien,
                                ngay_tao,
                                duongsu_id,
                                duongsu_ids,
                                ten_tk_thuhuong
                            ) VALUES ( v_id,
                                       v_ma_thongbao,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.donxuly_id,
                                       item_tp.anphi_id,
                                       v_maloaivuviec,
                                       item_tp.donvitha_id,
                                       item_tp.maloaihinhthu,
                                       item_tp.mavuviec,
                                       item_tp.sotaikhoankb,
                                       item_tp.makhobac,
                                       item_tp.tenkhobac,
                                       item_tp.machicuc,
                                       item_tp.tenchicuc,
                                       item_tp.ngaythongbao,
                                       item_tp.sothongbao,
                                       item_tp.tentoathongbao,
                                       item_tp.tenloaihinhthu,
                                       item_tp.hotennguoinop,
                                       item_tp.socmndnguoinop,
                                       item_tp.diachinguoinop,
                                       item_tp.huyennguoinop,
                                       item_tp.tinhnguoinop,
                                       item_tp.tongtien,
                                       sysdate,
                                       item_tp.duongsu_id,
                                       item_tp.duongsu_ids,
                                       item_tp.ten_tk_thuhuong );
                                --------------------
                            SELECT
                                COUNT(*)
                            INTO v_count_tp
                            FROM
                                tuphap_anphi tp
                            WHERE
                                    tp.vuviecid = item_tp.donid
                                AND tp.anphi_id = v_anphi_id
                                AND tp.maloaivuviec = v_maloaivuviec;

                            IF ( v_count_tp = 0 ) THEN
                                INSERT INTO tuphap_anphi (
                                    id,
                                    maloaivuviec,
                                    vuviecid,
                                    sobienlai,
                                    anphi,
                                    vbtongdatid,
                                    donvi_thutien_id,
                                    ngaytao,
                                    nguoitao,
                                    nguoitaoid,
                                    nguoithutien,
                                    nop_isnguyendon,
                                    nop_hoten,
                                    nop_gioitinh,
                                    nop_namsinh,
                                    nop_cmnd,
                                    nop_tel,
                                    nop_email,
                                    nop_diachi,
                                    anphi_id,
                                    duongsu_ids,
                                    dvcqg_tt_id
                                ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                           v_maloaivuviec,
                                           item_tp.donid,
                                           NULL,
                                           item_tp.tongtien,
                                           NULL,
                                           item_tp.donvitha_id,
                                           sysdate,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           v_anphi_id,
                                           item_tp.duongsu_ids,
                                           v_id );

                            END IF;

                        END IF;
                    END LOOP;
                END IF;
            ELSIF ( v_maloaivuviec = '5' ) THEN
               IF ( v_count_ds = 0 ) THEN
                    FOR item_tp IN (
                        SELECT
                            dx.id                        donxuly_id,
                            ai.id                        anphi_id,
                            ai.donid,
                            tha.id                       donvitha_id,
                            lh.ma                        maloaihinhthu,
                            to_char(do.mavuviec)         mavuviec,
                            tk.sotk_khobac               sotaikhoankb,
                            tk.ma_khobac                 makhobac,
                            tk.tentk_khobac              tenkhobac,
                            tha.ma_dinh_danh             machicuc,
                            tha.ma_ten                   tenchicuc,
                            ai.ngaythongbao,
                            ai.sothongbao,
                            tn.ma_ten                    tentoathongbao,
                            lh.ten                       tenloaihinhthu,
                            du.tenduongsu                hotennguoinop,
                            du.socmnd                    socmndnguoinop,
                            du.tamtruchitiet             diachinguoinop,
                            hc.ten                       huyennguoinop,
                            hc1.ten                      tinhnguoinop,
                            replace(ai.tamunganphi, '.') tongtien,
                            ai.duongsu_id,
                            ai.duongsu_ids,
                            tk.ten_tk_thuhuong
                        FROM
                                 ald_anphi ai
                            INNER JOIN ald_don           do ON ai.donid = do.id
                            INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                        --VNPT LE BA THO SUA DUONGSU
                            INNER JOIN ald_don_duongsu   du ON ai.duongsu_ids = du.id    --AI.DONID=DU.DONID cũ
                        --INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                            INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                            LEFT JOIN dm_hanhchinh      hc ON du.tamtruid = hc.id
                            LEFT JOIN dm_hanhchinh      hc1 ON du.tamtrutinhid = hc1.id
                            LEFT JOIN ald_don_xuly      dx ON dx.donid = ai.donid
                                                         AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
--                      LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
--                      LEFT JOIN AKT_FILE FL ON FL.DONID=AI.DONID AND FL.BIEUMAUID=67
                            LEFT JOIN (
                                SELECT
                                    qd.donid
                                FROM
                                         ald_sotham_quyetdinh qd
                                    INNER JOIN (
                                        SELECT
                                            qda.*
                                        FROM
                                            dm_qd_quyetdinh qda
                                        WHERE
                                            qda.loaiid = 3
                                    ) dmqd ON dmqd.id = qd.quyetdinhid
                            )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                            LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                            LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                        WHERE --DU.TUCACHTOTUNG_MA='NGUYENDON' --AND TD.BIEUMAUID=67--TD.BIEUMAUID=67 --Thông báo nộp tiền tạm ứng án phí
                        --AND DU.ISDAIDIEN = 1 --AND FL.TENFILE IS NOT NULL
                        --AND 
                                replace(ai.tamunganphi, '.') != 0
                            AND ai.id = v_anphi_id
                    ) LOOP
                        IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                            INSERT INTO dvcqg_thanh_toan (
                                id,
                                ma_thongbao,
                                donid,
                                tongdatid,
                                donxuly_id,
                                anphi_id,
                                maloaivuviec,
                                donvitha_id,
                                maloaihinhthu,
                                mavuviec,
                                sotaikhoankb,
                                makhobac,
                                tenkhobac,
                                machicuc,
                                tenchicuc,
                                ngaythongbao,
                                sothongbao,
                                tentoathongbao,
                                tenloaihinhthu,
                                hotennguoinop,
                                socmndnguoinop,
                                diachinguoinop,
                                huyennguoinop,
                                tinhnguoinop,
                                tongtien,
                                ngay_tao,
                                magiaidoan,
                                duongsu_id,
                                duongsu_ids,
                                ten_tk_thuhuong
                            ) VALUES ( v_id,
                                       v_ma_thongbao,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.donxuly_id,
                                       item_tp.anphi_id,
                                       v_maloaivuviec,
                                       item_tp.donvitha_id,
                                       item_tp.maloaihinhthu,
                                       item_tp.mavuviec,
                                       item_tp.sotaikhoankb,
                                       item_tp.makhobac,
                                       item_tp.tenkhobac,
                                       item_tp.machicuc,
                                       item_tp.tenchicuc,
                                       item_tp.ngaythongbao,
                                       item_tp.sothongbao,
                                       item_tp.tentoathongbao,
                                       item_tp.tenloaihinhthu,
                                       item_tp.hotennguoinop,
                                       item_tp.socmndnguoinop,
                                       item_tp.diachinguoinop,
                                       item_tp.huyennguoinop,
                                       item_tp.tinhnguoinop,
                                       item_tp.tongtien,
                                       sysdate,
                                       v_magiaidoan,
                                       item_tp.duongsu_id,
                                       item_tp.duongsu_ids,
                                       item_tp.ten_tk_thuhuong );
              ---------------------
                            SELECT
                                COUNT(*)
                            INTO v_count_tp
                            FROM
                                tuphap_anphi tp
                            WHERE
                                    tp.vuviecid = item_tp.donid
                                AND tp.anphi_id = v_anphi_id
                                AND tp.maloaivuviec = v_maloaivuviec;

                            IF ( v_count_tp = 0 ) THEN
                                INSERT INTO tuphap_anphi (
                                    id,
                                    maloaivuviec,
                                    vuviecid,
                                    sobienlai,
                                    anphi,
                                    vbtongdatid,
                                    donvi_thutien_id,
                                    ngaytao,
                                    nguoitao,
                                    nguoitaoid,
                                    nguoithutien,
                                    nop_isnguyendon,
                                    nop_hoten,
                                    nop_gioitinh,
                                    nop_namsinh,
                                    nop_cmnd,
                                    nop_tel,
                                    nop_email,
                                    nop_diachi,
                                    anphi_id,
                                    duongsu_ids,
                                    dvcqg_tt_id
                                ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                           v_maloaivuviec,
                                           item_tp.donid,
                                           NULL,
                                           item_tp.tongtien,
                                           NULL,
                                           item_tp.donvitha_id,
                                           sysdate,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           v_anphi_id,
                                           item_tp.duongsu_ids,
                                           v_id );

                            END IF;

                        END IF;
                    END LOOP;

                ELSIF ( v_count_ds > 0 ) THEN
                    FOR item_tp IN (
                        SELECT
                            dx.id                        donxuly_id,
                            ai.id                        anphi_id,
                            ai.donid,
                            tha.id                       donvitha_id,
                            lh.ma                        maloaihinhthu,
                            to_char(do.mavuviec)         mavuviec,
                            tk.sotk_khobac               sotaikhoankb,
                            tk.ma_khobac                 makhobac,
                            tk.tentk_khobac              tenkhobac,
                            tha.ma_dinh_danh             machicuc,
                            tha.ma_ten                   tenchicuc,
                            ai.ngaythongbao,
                            ai.sothongbao,
                            tn.ma_ten                    tentoathongbao,
                            lh.ten                       tenloaihinhthu,
                            ap.tenduongsu                hotennguoinop,
                            NULL                         socmndnguoinop,
                            NULL                         diachinguoinop,
                            NULL                         huyennguoinop,
                            NULL                         tinhnguoinop,
                            replace(ai.tamunganphi, '.') tongtien,
                            ai.duongsu_id,
                            ai.duongsu_ids,
                            tk.ten_tk_thuhuong
                        FROM
                                 ald_anphi ai
                            INNER JOIN ald_don           do ON ai.donid = do.id
                            INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                            INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                            LEFT JOIN (
                                SELECT
                                    LISTAGG(hn.tenduongsu, ', ') WITHIN GROUP(
                                    ORDER BY
                                        hn.tenduongsu
                                    ) tenduongsu,
                                    du.anphi_id
                                FROM
                                    ald_anphi_duongsu du
                                    LEFT JOIN ald_don_duongsu   hn ON hn.id = du.duongsu_id
                                GROUP BY
                                    du.anphi_id
                            )                 ap ON ap.anphi_id = ai.id
                            LEFT JOIN ald_don_xuly      dx ON dx.donid = ai.donid
                                                         AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                            LEFT JOIN (
                                SELECT
                                    qd.donid
                                FROM
                                         ald_sotham_quyetdinh qd
                                    INNER JOIN (
                                        SELECT
                                            qda.*
                                        FROM
                                            dm_qd_quyetdinh qda
                                        WHERE
                                            qda.loaiid = 3
                                    ) dmqd ON dmqd.id = qd.quyetdinhid
                            )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                            LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                            LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                        WHERE
                                replace(ai.tamunganphi, '.') != 0
                            AND ai.id = v_anphi_id
                            AND ROWNUM = 1
                    ) LOOP
                        IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                            INSERT INTO dvcqg_thanh_toan (
                                id,
                                ma_thongbao,
                                donid,
                                tongdatid,
                                donxuly_id,
                                anphi_id,
                                maloaivuviec,
                                donvitha_id,
                                maloaihinhthu,
                                mavuviec,
                                sotaikhoankb,
                                makhobac,
                                tenkhobac,
                                machicuc,
                                tenchicuc,
                                ngaythongbao,
                                sothongbao,
                                tentoathongbao,
                                tenloaihinhthu,
                                hotennguoinop,
                                socmndnguoinop,
                                diachinguoinop,
                                huyennguoinop,
                                tinhnguoinop,
                                tongtien,
                                ngay_tao,
                                duongsu_id,
                                duongsu_ids,
                                ten_tk_thuhuong
                            ) VALUES ( v_id,
                                       v_ma_thongbao,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.donxuly_id,
                                       item_tp.anphi_id,
                                       v_maloaivuviec,
                                       item_tp.donvitha_id,
                                       item_tp.maloaihinhthu,
                                       item_tp.mavuviec,
                                       item_tp.sotaikhoankb,
                                       item_tp.makhobac,
                                       item_tp.tenkhobac,
                                       item_tp.machicuc,
                                       item_tp.tenchicuc,
                                       item_tp.ngaythongbao,
                                       item_tp.sothongbao,
                                       item_tp.tentoathongbao,
                                       item_tp.tenloaihinhthu,
                                       item_tp.hotennguoinop,
                                       item_tp.socmndnguoinop,
                                       item_tp.diachinguoinop,
                                       item_tp.huyennguoinop,
                                       item_tp.tinhnguoinop,
                                       item_tp.tongtien,
                                       sysdate,
                                       item_tp.duongsu_id,
                                       item_tp.duongsu_ids,
                                       item_tp.ten_tk_thuhuong );
                                --------------------
                            SELECT
                                COUNT(*)
                            INTO v_count_tp
                            FROM
                                tuphap_anphi tp
                            WHERE
                                    tp.vuviecid = item_tp.donid
                                AND tp.anphi_id = v_anphi_id
                                AND tp.maloaivuviec = v_maloaivuviec;

                            IF ( v_count_tp = 0 ) THEN
                                INSERT INTO tuphap_anphi (
                                    id,
                                    maloaivuviec,
                                    vuviecid,
                                    sobienlai,
                                    anphi,
                                    vbtongdatid,
                                    donvi_thutien_id,
                                    ngaytao,
                                    nguoitao,
                                    nguoitaoid,
                                    nguoithutien,
                                    nop_isnguyendon,
                                    nop_hoten,
                                    nop_gioitinh,
                                    nop_namsinh,
                                    nop_cmnd,
                                    nop_tel,
                                    nop_email,
                                    nop_diachi,
                                    anphi_id,
                                    duongsu_ids,
                                    dvcqg_tt_id
                                ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                           v_maloaivuviec,
                                           item_tp.donid,
                                           NULL,
                                           item_tp.tongtien,
                                           NULL,
                                           item_tp.donvitha_id,
                                           sysdate,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           v_anphi_id,
                                           item_tp.duongsu_ids,
                                           v_id );

                            END IF;

                        END IF;
                    END LOOP;
                END IF;
            ELSIF ( v_maloaivuviec = '6' ) THEN
                IF ( v_count_ds = 0 ) THEN
                    FOR item_tp IN (
                        SELECT
                            dx.id                        donxuly_id,
                            ai.id                        anphi_id,
                            ai.donid,
                            tha.id                       donvitha_id,
                            lh.ma                        maloaihinhthu,
                            to_char(do.mavuviec)         mavuviec,
                            tk.sotk_khobac               sotaikhoankb,
                            tk.ma_khobac                 makhobac,
                            tk.tentk_khobac              tenkhobac,
                            tha.ma_dinh_danh             machicuc,
                            tha.ma_ten                   tenchicuc,
                            ai.ngaythongbao,
                            ai.sothongbao,
                            tn.ma_ten                    tentoathongbao,
                            lh.ten                       tenloaihinhthu,
                            du.tenduongsu                hotennguoinop,
                            du.socmnd                    socmndnguoinop,
                            du.tamtruchitiet             diachinguoinop,
                            hc.ten                       huyennguoinop,
                            hc1.ten                      tinhnguoinop,
                            replace(ai.tamunganphi, '.') tongtien,
                            ai.duongsu_id,
                            ai.duongsu_ids,
                            tk.ten_tk_thuhuong
                        FROM
                                 ahc_anphi ai
                            INNER JOIN ahc_don           do ON ai.donid = do.id
                            INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                            INNER JOIN ahc_don_duongsu   du ON ai.duongsu_ids = du.id--;  AI.DUONGSU_IDS like DU.ID || '%'   --AI.DONID=DU.DONID cũ
                                    --INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                            INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                            LEFT JOIN dm_hanhchinh      hc ON du.tamtruid = hc.id
                            LEFT JOIN dm_hanhchinh      hc1 ON du.tamtrutinhid = hc1.id
                            LEFT JOIN ahc_don_xuly      dx ON dx.donid = ai.donid
                                                         AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
            --                      LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
            --                      LEFT JOIN AHC_FILE FL ON FL.DONID=AI.DONID AND FL.BIEUMAUID=67
                            LEFT JOIN (
                                SELECT
                                    qd.donid
                                FROM
                                         ahc_sotham_quyetdinh qd
                                    INNER JOIN (
                                        SELECT
                                            qda.*
                                        FROM
                                            dm_qd_quyetdinh qda
                                        WHERE
                                            qda.loaiid = 3
                                    ) dmqd ON dmqd.id = qd.quyetdinhid
                            )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                            LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                            LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                        WHERE --DU.TUCACHTOTUNG_MA='NGUYENDON' --AND TD.BIEUMAUID=67--TD.BIEUMAUID=67 --Thông báo nộp tiền tạm ứng án phí
                                    --AND DU.ISDAIDIEN = 1 --AND FL.TENFILE IS NOT NULL
                                    --AND 
                                replace(ai.tamunganphi, '.') != 0
                            AND ai.id = v_anphi_id
                            AND ROWNUM = 1
                    ) LOOP
                        IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                            INSERT INTO dvcqg_thanh_toan (
                                id,
                                ma_thongbao,
                                donid,
                                tongdatid,
                                donxuly_id,
                                anphi_id,
                                maloaivuviec,
                                donvitha_id,
                                maloaihinhthu,
                                mavuviec,
                                sotaikhoankb,
                                makhobac,
                                tenkhobac,
                                machicuc,
                                tenchicuc,
                                ngaythongbao,
                                sothongbao,
                                tentoathongbao,
                                tenloaihinhthu,
                                hotennguoinop,
                                socmndnguoinop,
                                diachinguoinop,
                                huyennguoinop,
                                tinhnguoinop,
                                tongtien,
                                ngay_tao,
                                duongsu_id,
                                duongsu_ids,
                                ten_tk_thuhuong
                            ) VALUES ( v_id,
                                       v_ma_thongbao,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.donxuly_id,
                                       item_tp.anphi_id,
                                       v_maloaivuviec,
                                       item_tp.donvitha_id,
                                       item_tp.maloaihinhthu,
                                       item_tp.mavuviec,
                                       item_tp.sotaikhoankb,
                                       item_tp.makhobac,
                                       item_tp.tenkhobac,
                                       item_tp.machicuc,
                                       item_tp.tenchicuc,
                                       item_tp.ngaythongbao,
                                       item_tp.sothongbao,
                                       item_tp.tentoathongbao,
                                       item_tp.tenloaihinhthu,
                                       item_tp.hotennguoinop,
                                       item_tp.socmndnguoinop,
                                       item_tp.diachinguoinop,
                                       item_tp.huyennguoinop,
                                       item_tp.tinhnguoinop,
                                       item_tp.tongtien,
                                       sysdate,
                                       item_tp.duongsu_id,
                                       item_tp.duongsu_ids,
                                       item_tp.ten_tk_thuhuong );
                           ----------------
                            SELECT
                                COUNT(*)
                            INTO v_count_tp
                            FROM
                                tuphap_anphi tp
                            WHERE
                                    tp.vuviecid = item_tp.donid
                                AND tp.anphi_id = v_anphi_id
                                AND tp.maloaivuviec = v_maloaivuviec;

                            IF ( v_count_tp = 0 ) THEN
                                INSERT INTO tuphap_anphi (
                                    id,
                                    maloaivuviec,
                                    vuviecid,
                                    sobienlai,
                                    anphi,
                                    vbtongdatid,
                                    donvi_thutien_id,
                                    ngaytao,
                                    nguoitao,
                                    nguoitaoid,
                                    nguoithutien,
                                    nop_isnguyendon,
                                    nop_hoten,
                                    nop_gioitinh,
                                    nop_namsinh,
                                    nop_cmnd,
                                    nop_tel,
                                    nop_email,
                                    nop_diachi,
                                    anphi_id,
                                    duongsu_id,
                                    dvcqg_tt_id
                                ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                           v_maloaivuviec,
                                           item_tp.donid,
                                           NULL,
                                           item_tp.tongtien,
                                           NULL,
                                           item_tp.donvitha_id,
                                           sysdate,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           v_anphi_id,
                                           item_tp.duongsu_id,
                                           v_id );

                            END IF;

                        END IF;
                    END LOOP;

                ELSIF ( v_count_ds > 0 ) THEN
                    FOR item_tp IN (
                        SELECT
                            dx.id                        donxuly_id,
                            ai.id                        anphi_id,
                            ai.donid,
                            tha.id                       donvitha_id,
                            lh.ma                        maloaihinhthu,
                            to_char(do.mavuviec)         mavuviec,
                            tk.sotk_khobac               sotaikhoankb,
                            tk.ma_khobac                 makhobac,
                            tk.tentk_khobac              tenkhobac,
                            tha.ma_dinh_danh             machicuc,
                            tha.ma_ten                   tenchicuc,
                            ai.ngaythongbao,
                            ai.sothongbao,
                            tn.ma_ten                    tentoathongbao,
                            lh.ten                       tenloaihinhthu,
                            ap.tenduongsu                hotennguoinop,
                            NULL                         socmndnguoinop,
                            NULL                         diachinguoinop,
                            NULL                         huyennguoinop,
                            NULL                         tinhnguoinop,
                            replace(ai.tamunganphi, '.') tongtien,
                            ai.duongsu_id,
                            ai.duongsu_ids,
                            tk.ten_tk_thuhuong
                        FROM
                                 ahc_anphi ai
                            INNER JOIN ahc_don           do ON ai.donid = do.id
                            INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                            INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                            LEFT JOIN (
                                SELECT
                                    LISTAGG(hn.tenduongsu, ', ') WITHIN GROUP(
                                    ORDER BY
                                        hn.tenduongsu
                                    ) tenduongsu,
                                    du.anphi_id
                                FROM
                                    ahc_anphi_duongsu du
                                    LEFT JOIN ahc_don_duongsu   hn ON hn.id = du.duongsu_id
                                GROUP BY
                                    du.anphi_id
                            )                 ap ON ap.anphi_id = ai.id
                            LEFT JOIN ahc_don_xuly      dx ON dx.donid = ai.donid
                                                         AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
                            LEFT JOIN (
                                SELECT
                                    qd.donid
                                FROM
                                         ahc_sotham_quyetdinh qd
                                    INNER JOIN (
                                        SELECT
                                            qda.*
                                        FROM
                                            dm_qd_quyetdinh qda
                                        WHERE
                                            qda.loaiid = 3
                                    ) dmqd ON dmqd.id = qd.quyetdinhid
                            )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                            LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                            LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                        WHERE
                                replace(ai.tamunganphi, '.') != 0
                            AND ai.id = v_anphi_id
                            AND ROWNUM = 1
                    ) LOOP
                        IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                            INSERT INTO dvcqg_thanh_toan (
                                id,
                                ma_thongbao,
                                donid,
                                tongdatid,
                                donxuly_id,
                                anphi_id,
                                maloaivuviec,
                                donvitha_id,
                                maloaihinhthu,
                                mavuviec,
                                sotaikhoankb,
                                makhobac,
                                tenkhobac,
                                machicuc,
                                tenchicuc,
                                ngaythongbao,
                                sothongbao,
                                tentoathongbao,
                                tenloaihinhthu,
                                hotennguoinop,
                                socmndnguoinop,
                                diachinguoinop,
                                huyennguoinop,
                                tinhnguoinop,
                                tongtien,
                                ngay_tao,
                                duongsu_id,
                                duongsu_ids,
                                ten_tk_thuhuong
                            ) VALUES ( v_id,
                                       v_ma_thongbao,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.donxuly_id,
                                       item_tp.anphi_id,
                                       v_maloaivuviec,
                                       item_tp.donvitha_id,
                                       item_tp.maloaihinhthu,
                                       item_tp.mavuviec,
                                       item_tp.sotaikhoankb,
                                       item_tp.makhobac,
                                       item_tp.tenkhobac,
                                       item_tp.machicuc,
                                       item_tp.tenchicuc,
                                       item_tp.ngaythongbao,
                                       item_tp.sothongbao,
                                       item_tp.tentoathongbao,
                                       item_tp.tenloaihinhthu,
                                       item_tp.hotennguoinop,
                                       item_tp.socmndnguoinop,
                                       item_tp.diachinguoinop,
                                       item_tp.huyennguoinop,
                                       item_tp.tinhnguoinop,
                                       item_tp.tongtien,
                                       sysdate,
                                       item_tp.duongsu_id,
                                       item_tp.duongsu_ids,
                                       item_tp.ten_tk_thuhuong );
                                --------------------
                            SELECT
                                COUNT(*)
                            INTO v_count_tp
                            FROM
                                tuphap_anphi tp
                            WHERE
                                    tp.vuviecid = item_tp.donid
                                AND tp.anphi_id = v_anphi_id
                                AND tp.maloaivuviec = v_maloaivuviec;

                            IF ( v_count_tp = 0 ) THEN
                                INSERT INTO tuphap_anphi (
                                    id,
                                    maloaivuviec,
                                    vuviecid,
                                    sobienlai,
                                    anphi,
                                    vbtongdatid,
                                    donvi_thutien_id,
                                    ngaytao,
                                    nguoitao,
                                    nguoitaoid,
                                    nguoithutien,
                                    nop_isnguyendon,
                                    nop_hoten,
                                    nop_gioitinh,
                                    nop_namsinh,
                                    nop_cmnd,
                                    nop_tel,
                                    nop_email,
                                    nop_diachi,
                                    anphi_id,
                                    duongsu_ids,
                                    dvcqg_tt_id
                                ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                           v_maloaivuviec,
                                           item_tp.donid,
                                           NULL,
                                           item_tp.tongtien,
                                           NULL,
                                           item_tp.donvitha_id,
                                           sysdate,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           NULL,
                                           v_anphi_id,
                                           item_tp.duongsu_ids,
                                           v_id );

                            END IF;

                        END IF;
                    END LOOP;
                END IF;  
--        FOR item_tp IN 
--                    (
--                        SELECT DX.ID DONXULY_ID,AI.ID ANPHI_ID,AI.DONID,THA.ID DONVITHA_ID,LH.MA MALOAIHINHTHU,TO_CHAR(DO.MAVUVIEC)MAVUVIEC,TK.SOTK_KHOBAC SOTAIKHOANKB
--                        ,TK.MA_KHOBAC MAKHOBAC,TK.TENTK_KHOBAC TENKHOBAC,THA.MA_DINH_DANH MACHICUC,THA.MA_TEN TENCHICUC
--                        ,AI.NGAYTHONGBAO,AI.SOTHONGBAO,TN.MA_TEN TENTOATHONGBAO,LH.TEN TENLOAIHINHTHU,DU.TENDUONGSU HOTENNGUOINOP
--                        ,DU.SOCMND SOCMNDNGUOINOP,DU.TAMTRUCHITIET DIACHINGUOINOP,HC.TEN HUYENNGUOINOP,HC1.TEN TINHNGUOINOP
--                        , REPLACE(AI.TAMUNGANPHI,'.') TONGTIEN,AI.DUONGSU_ID,AI.DUONGSU_IDS,TK.TEN_TK_THUHUONG
--                        FROM AHC_ANPHI AI 
--                        INNER JOIN AHC_DON DO ON AI.DONID=DO.ID     
--                        INNER JOIN DM_TOAAN TN ON TN.ID=DO.TOAANID
--                        INNER JOIN AHC_DON_DUONGSU DU ON instr(','|| AI.DUONGSU_IDS||',',','|| DU.ID||',')>0   --AI.DONID=DU.DONID cũ
--                        --INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
--                        INNER JOIN DM_DONVITHIHANHAN THA ON THA.ARRTOAANID=TN.ID
--                        LEFT JOIN DM_HANHCHINH HC ON DU.TAMTRUID=HC.ID
--                        LEFT JOIN DM_HANHCHINH HC1 ON DU.TAMTRUTINHID=HC1.ID
--                        LEFT JOIN AHC_DON_XULY DX ON DX.DONID=AI.DONID AND DX.LOAIGIAIQUYET=5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
----                      LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
----                      LEFT JOIN AHC_FILE FL ON FL.DONID=AI.DONID AND FL.BIEUMAUID=67
--                        LEFT JOIN (SELECT QD.DONID FROM AHC_SOTHAM_QUYETDINH  QD 
--                                    INNER JOIN (SELECT QDA.* FROM DM_QD_QUYETDINH QDA WHERE QDA.LOAIID=3)DMQD ON DMQD.ID=QD.QUYETDINHID)DC ON DC.DONID=DO.ID --xac dinh xem co dinh chi nop an phi    
--                        LEFT JOIN DM_TK_THANHTOAN TK ON TK.THA_ID=THA.ID
--                        LEFT JOIN DM_LOAIHINH_THU LH ON LH.ID=TK.MA_LOAIHINHTHU
--                        WHERE --DU.TUCACHTOTUNG_MA='NGUYENDON' --AND TD.BIEUMAUID=67--TD.BIEUMAUID=67 --Thông báo nộp tiền tạm ứng án phí
--                        --AND DU.ISDAIDIEN = 1 --AND FL.TENFILE IS NOT NULL
--                        --AND 
--                        REPLACE(AI.TAMUNGANPHI,'.') !=0 
--                        AND AI.ID=V_ANPHI_ID AND ROWNUM = 1
--                   )
--            LOOP
--             IF(item_tp.SOTAIKHOANKB IS NOT NULL) THEN
--                    INSERT INTO DVCQG_THANH_TOAN
--                        (ID,MA_THONGBAO,DONID,TONGDATID,DONXULY_ID,ANPHI_ID,MALOAIVUVIEC,DONVITHA_ID,MALOAIHINHTHU,MAVUVIEC,SOTAIKHOANKB
--                        ,MAKHOBAC,TENKHOBAC,MACHICUC,TENCHICUC,NGAYTHONGBAO,SOTHONGBAO,TENTOATHONGBAO,TENLOAIHINHTHU
--                        ,HOTENNGUOINOP,SOCMNDNGUOINOP,DIACHINGUOINOP,HUYENNGUOINOP,TINHNGUOINOP,TONGTIEN,NGAY_TAO,DUONGSU_ID,DUONGSU_IDS,TEN_TK_THUHUONG)
--                        VALUES (DVCQG_THANH_TOAN_SEQ.NEXTVAL,V_MA_THONGBAO,item_tp.DONID,NULL,item_tp.DONXULY_ID,item_tp.ANPHI_ID,V_MALOAIVUVIEC,item_tp.DONVITHA_ID,item_tp.MALOAIHINHTHU,item_tp.MAVUVIEC
--                        ,item_tp.SOTAIKHOANKB,item_tp.MAKHOBAC,item_tp.TENKHOBAC,item_tp.MACHICUC,item_tp.TENCHICUC,item_tp.NGAYTHONGBAO,item_tp.SOTHONGBAO,item_tp.TENTOATHONGBAO,item_tp.TENLOAIHINHTHU
--                        ,item_tp.HOTENNGUOINOP,item_tp.SOCMNDNGUOINOP,item_tp.DIACHINGUOINOP,item_tp.HUYENNGUOINOP,item_tp.TINHNGUOINOP,item_tp.TONGTIEN,SYSDATE,item_tp.DUONGSU_ID,item_tp.DUONGSU_IDS,item_tp.TEN_TK_THUHUONG);
--             END IF;
--            END LOOP;
            ELSIF ( v_maloaivuviec = '7' ) THEN
                FOR item_tp IN (
                    SELECT
                        dx.id                        donxuly_id,
                        ai.id                        anphi_id,
                        ai.donid,
                        tha.id                       donvitha_id,
                        lh.ma                        maloaihinhthu,
                        to_char(do.mavuviec)         mavuviec,
                        tk.sotk_khobac               sotaikhoankb,
                        tk.ma_khobac                 makhobac,
                        tk.tentk_khobac              tenkhobac,
                        tha.ma_dinh_danh             machicuc,
                        tha.ma_ten                   tenchicuc,
                        ai.ngaythongbao,
                        ai.sothongbao,
                        tn.ma_ten                    tentoathongbao,
                        lh.ten                       tenloaihinhthu,
                        du.tenduongsu                hotennguoinop,
                        du.socmnd                    socmndnguoinop,
                        du.tamtruchitiet             diachinguoinop,
                        hc.ten                       huyennguoinop,
                        hc1.ten                      tinhnguoinop,
                        replace(ai.tamunganphi, '.') tongtien,
                        ai.duongsu_id,
                        tk.ten_tk_thuhuong
                    FROM
                             aps_anphi ai
                        INNER JOIN aps_don           do ON ai.donid = do.id
                        INNER JOIN dm_toaan          tn ON tn.id = do.toaanid
                        INNER JOIN aps_don_duongsu   du ON ai.duongsu_id = du.id    --AI.DONID=DU.DONID cũ
                        --INNER JOIN DM_BIEUMAU BM ON BM.ID=TD.BIEUMAUID
                        INNER JOIN dm_donvithihanhan tha ON tha.arrtoaanid = tn.id
                        LEFT JOIN dm_hanhchinh      hc ON du.tamtruid = hc.id
                        LEFT JOIN dm_hanhchinh      hc1 ON du.tamtrutinhid = hc1.id
                        LEFT JOIN aps_don_xuly      dx ON dx.donid = ai.donid
                                                     AND dx.loaigiaiquyet = 5 --DX.LOAIGIAIQUYET=5  Biện pháp GQ/YC-> thụ lý ->Thông báo nộp tiền tạm ứng án 
--                      LEFT JOIN TUPHAP_ANPHI TA ON TA.VUVIECID=TD.DONID
--                      LEFT JOIN APS_FILE FL ON FL.DONID=AI.DONID AND FL.BIEUMAUID=67
                        LEFT JOIN (
                            SELECT
                                qd.donid
                            FROM
                                     aps_sotham_quyetdinh qd
                                INNER JOIN (
                                    SELECT
                                        qda.*
                                    FROM
                                        dm_qd_quyetdinh qda
                                    WHERE
                                        qda.loaiid = 3
                                ) dmqd ON dmqd.id = qd.quyetdinhid
                        )                 dc ON dc.donid = do.id --xac dinh xem co dinh chi nop an phi    
                        LEFT JOIN dm_tk_thanhtoan   tk ON tk.tha_id = tha.id
                        LEFT JOIN dm_loaihinh_thu   lh ON lh.id = tk.ma_loaihinhthu
                    WHERE --DU.TUCACHTOTUNG_MA='NGUYENDON' --AND TD.BIEUMAUID=67--TD.BIEUMAUID=67 --Thông báo nộp tiền tạm ứng án phí
                        --AND DU.ISDAIDIEN = 1 --AND FL.TENFILE IS NOT NULL
                        --AND 
                            replace(ai.tamunganphi, '.') != 0
                        AND ai.id = v_anphi_id
                ) LOOP
                    IF ( item_tp.sotaikhoankb IS NOT NULL ) THEN
                        INSERT INTO dvcqg_thanh_toan (
                            id,
                            ma_thongbao,
                            donid,
                            tongdatid,
                            donxuly_id,
                            anphi_id,
                            maloaivuviec,
                            donvitha_id,
                            maloaihinhthu,
                            mavuviec,
                            sotaikhoankb,
                            makhobac,
                            tenkhobac,
                            machicuc,
                            tenchicuc,
                            ngaythongbao,
                            sothongbao,
                            tentoathongbao,
                            tenloaihinhthu,
                            hotennguoinop,
                            socmndnguoinop,
                            diachinguoinop,
                            huyennguoinop,
                            tinhnguoinop,
                            tongtien,
                            ngay_tao,
                            duongsu_id,
                            ten_tk_thuhuong
                        ) VALUES ( v_id,
                                   v_ma_thongbao,
                                   item_tp.donid,
                                   NULL,
                                   item_tp.donxuly_id,
                                   item_tp.anphi_id,
                                   v_maloaivuviec,
                                   item_tp.donvitha_id,
                                   item_tp.maloaihinhthu,
                                   item_tp.mavuviec,
                                   item_tp.sotaikhoankb,
                                   item_tp.makhobac,
                                   item_tp.tenkhobac,
                                   item_tp.machicuc,
                                   item_tp.tenchicuc,
                                   item_tp.ngaythongbao,
                                   item_tp.sothongbao,
                                   item_tp.tentoathongbao,
                                   item_tp.tenloaihinhthu,
                                   item_tp.hotennguoinop,
                                   item_tp.socmndnguoinop,
                                   item_tp.diachinguoinop,
                                   item_tp.huyennguoinop,
                                   item_tp.tinhnguoinop,
                                   item_tp.tongtien,
                                   sysdate,
                                   item_tp.duongsu_id,
                                   item_tp.ten_tk_thuhuong );
                     ----------------
                        SELECT
                            COUNT(*)
                        INTO v_count_tp
                        FROM
                            tuphap_anphi tp
                        WHERE
                                tp.vuviecid = item_tp.donid
                            AND tp.anphi_id = v_anphi_id
                            AND tp.maloaivuviec = v_maloaivuviec;

                        IF ( v_count_tp = 0 ) THEN
                            INSERT INTO tuphap_anphi (
                                id,
                                maloaivuviec,
                                vuviecid,
                                sobienlai,
                                anphi,
                                vbtongdatid,
                                donvi_thutien_id,
                                ngaytao,
                                nguoitao,
                                nguoitaoid,
                                nguoithutien,
                                nop_isnguyendon,
                                nop_hoten,
                                nop_gioitinh,
                                nop_namsinh,
                                nop_cmnd,
                                nop_tel,
                                nop_email,
                                nop_diachi,
                                anphi_id,
                                duongsu_id,
                                dvcqg_tt_id
                            ) VALUES ( tuphap_anphi_seq.NEXTVAL,
                                       v_maloaivuviec,
                                       item_tp.donid,
                                       NULL,
                                       item_tp.tongtien,
                                       NULL,
                                       item_tp.donvitha_id,
                                       sysdate,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       NULL,
                                       v_anphi_id,
                                       item_tp.duongsu_id,
                                       v_id );

                        END IF;

                    END IF;
                END LOOP;
            END IF;
     ------------  
        END IF;

    END thanh_toan_in_anphi;

    FUNCTION create_ma_tb_random (
        v_ma_thongbao OUT VARCHAR2
    ) RETURN VARCHAR2 AS
        v_counts_matb NUMBER;
        v_ma_tb       VARCHAR2(255) := NULL;
    BEGIN
        SELECT
            dbms_random.string('x', 10)
        INTO v_ma_tb
        FROM
            dual;

        SELECT
            CASE
                WHEN EXISTS (
                    SELECT
                        1
                    FROM
                        dvcqg_thanh_toan dvc
                    WHERE
                        dvc.ma_thongbao = v_ma_tb
                ) THEN
                    1
                ELSE
                    0
            END
        INTO v_counts_matb
        FROM
            dual;
          
    -----------
        IF ( v_counts_matb = 1 ) THEN
            v_ma_thongbao := pkg_dvcqg_app.create_ma_tb_random(v_ma_thongbao);
        ELSIF ( v_counts_matb = 0 ) THEN
            v_ma_thongbao := v_ma_tb;
        END IF;

        RETURN v_ma_thongbao;
    END create_ma_tb_random;

    PROCEDURE tt_remove_tongdat (
        v_tongdat_id   IN NUMBER,
        v_maloaivuviec IN VARCHAR2,
        v_value        OUT NUMBER
    ) IS
        v_counts NUMBER(20);
    BEGIN
        v_value := 0;
        SELECT
            COUNT(*)
        INTO v_counts
        FROM
            dvcqg_thanh_toan tt
        WHERE
                tt.tongdatid = v_tongdat_id
            AND maloaivuviec = v_maloaivuviec
            AND trangthaithanhtoan = 1;--AND EXISTS(SELECT 'X' FROM DVCQG_GIAODICH GD WHERE GD.THANH_TOAN_ID=TT.ID)
        IF ( v_counts = 0 ) THEN --update khi chưa phát sinh giao dịch
            UPDATE dvcqg_thanh_toan tt
            SET
                tongdatid = NULL
            WHERE
                    tt.tongdatid = v_tongdat_id
                AND maloaivuviec = v_maloaivuviec;

            v_value := 1;
        END IF;

    END tt_remove_tongdat;

    PROCEDURE thanh_toan_delete_xly (
        v_donxuly_id   IN NUMBER,
        v_maloaivuviec IN VARCHAR2,
        v_value        OUT NUMBER
    ) IS
        v_counts   NUMBER;
        v_id_tt    NUMBER;
        v_count_tt NUMBER;
        v_count_tp NUMBER;
    BEGIN
        v_value := 0;
     -------------
        SELECT
            COUNT(*)
        INTO v_count_tt
        FROM
            dvcqg_thanh_toan tt
        WHERE
                tt.donxuly_id = v_donxuly_id
            AND maloaivuviec = v_maloaivuviec
            AND trangthaithanhtoan = 0;
     ----------------
        IF ( v_count_tt = 1 ) THEN
            SELECT
                tt.id
            INTO v_id_tt
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.donxuly_id = v_donxuly_id
                AND maloaivuviec = v_maloaivuviec
                AND trangthaithanhtoan = 0;
         ---------
            DELETE dvcqg_giaodich tt
            WHERE
                tt.thanh_toan_id = v_id_tt;

        END IF;

        SELECT
            COUNT(*)
        INTO v_counts
        FROM
            dvcqg_thanh_toan tt
        WHERE
                tt.donxuly_id = v_donxuly_id
            AND maloaivuviec = v_maloaivuviec
            AND trangthaithanhtoan = 0
            AND EXISTS (
                SELECT
                    'X'
                FROM
                    dvcqg_giaodich gd
                WHERE
                    gd.thanh_toan_id = tt.id
            );

        IF ( v_counts = 0 ) THEN
            DELETE dvcqg_thanh_toan tt
            WHERE
                    tt.donxuly_id = v_donxuly_id
                AND maloaivuviec = v_maloaivuviec
                AND trangthaithanhtoan = 0;
         ---------
            SELECT
                COUNT(*)
            INTO v_count_tp
            FROM
                tuphap_anphi tp
            WHERE
                    tp.maloaivuviec = v_maloaivuviec
                AND tp.dvcqg_tt_id = v_id_tt;

            IF ( v_count_tp = 1 ) THEN
                DELETE tuphap_anphi tp
                WHERE
                        tp.maloaivuviec = v_maloaivuviec
                    AND tp.dvcqg_tt_id = v_id_tt;

            END IF;

            v_value := 1;
        END IF;

    END thanh_toan_delete_xly;

    PROCEDURE thanh_toan_delete_anphi (
        v_anphi_id     IN NUMBER,
        v_maloaivuviec IN VARCHAR2,
        v_value        OUT NUMBER
    ) IS
        v_counts     NUMBER;
        v_duongsuids VARCHAR2(250);
        v_id_tt      NUMBER;
        v_count_tt   NUMBER;
        v_count_tp   NUMBER;
    BEGIN
        v_value := 0;
        SELECT
            COUNT(*)
        INTO v_count_tt
        FROM
            dvcqg_thanh_toan tt
        WHERE
                tt.anphi_id = v_anphi_id
            AND maloaivuviec = v_maloaivuviec
            AND trangthaithanhtoan = 0;
     ---------------------
        IF ( v_count_tt = 1 ) THEN
            SELECT
                tt.id
            INTO v_id_tt
            FROM
                dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND maloaivuviec = v_maloaivuviec
                AND trangthaithanhtoan = 0;

            DELETE dvcqg_giaodich tt
            WHERE
                tt.thanh_toan_id = v_id_tt;

        END IF;

        SELECT
            COUNT(*)
        INTO v_counts
        FROM
            dvcqg_thanh_toan tt
        WHERE
                tt.anphi_id = v_anphi_id
            AND maloaivuviec = v_maloaivuviec
            AND trangthaithanhtoan = 0
            AND EXISTS (
                SELECT
                    'X'
                FROM
                    dvcqg_giaodich gd
                WHERE
                    gd.thanh_toan_id = tt.id
            );

        IF ( v_counts = 0 ) THEN
            DELETE dvcqg_thanh_toan tt
            WHERE
                    tt.anphi_id = v_anphi_id
                AND tt.maloaivuviec = v_maloaivuviec
                AND tt.trangthaithanhtoan = 0;

            SELECT
                COUNT(*)
            INTO v_count_tp
            FROM
                tuphap_anphi tp
            WHERE
                    tp.anphi_id = v_anphi_id
                AND tp.maloaivuviec = v_maloaivuviec
                AND tp.dvcqg_tt_id = v_id_tt;

            IF ( v_count_tp = 1 ) THEN
                DELETE tuphap_anphi tp
                WHERE
                        tp.anphi_id = v_anphi_id
                    AND tp.maloaivuviec = v_maloaivuviec
                    AND tp.dvcqg_tt_id = v_id_tt;

            END IF;

            v_value := 1;
        END IF;

    END thanh_toan_delete_anphi;
  ----------------------------
    PROCEDURE thanh_toan_up_tongdat (
        v_tongdat_id   IN NUMBER,
        v_duongsuid    IN NUMBER,
        v_maloaivuviec IN VARCHAR2
    ) AS
        v_donid     NUMBER;
        v_count     NUMBER;
        v_bieumauid NUMBER;
    BEGIN
        IF ( v_maloaivuviec = '2' ) THEN
            SELECT
                td.donid,
                td.bieumauid
            INTO
                v_donid,
                v_bieumauid
            FROM
                     ads_tongdat_doituong ot
                INNER JOIN ads_tongdat td ON td.id = ot.tongdatid
            WHERE
                    td.id = v_tongdat_id
                AND ot.duongsuid = v_duongsuid;         
            --------------------
            IF ( v_bieumauid = 67
            OR v_bieumauid = 381 ) THEN
                SELECT
                    COUNT(*)
                INTO v_count
                FROM
                    dvcqg_thanh_toan tt
                WHERE
                        tt.donid = v_donid
                    AND maloaivuviec = v_maloaivuviec
                    AND duongsu_id = v_duongsuid;

                IF ( v_count = 1 ) THEN
                    UPDATE dvcqg_thanh_toan
                    SET
                        tongdatid = v_tongdat_id
                    WHERE
                            donid = v_donid
                        AND maloaivuviec = v_maloaivuviec
                        AND duongsu_id = v_duongsuid;

                END IF;

            END IF;

        ELSIF ( v_maloaivuviec = '3' ) THEN
            SELECT
                td.donid,
                td.bieumauid
            INTO
                v_donid,
                v_bieumauid
            FROM
                     ahn_tongdat_doituong ot
                INNER JOIN ahn_tongdat td ON td.id = ot.tongdatid
            WHERE
                    td.id = v_tongdat_id
                AND ot.duongsuid = v_duongsuid;            
            ------------------
            IF ( v_bieumauid = 67
            OR v_bieumauid = 381 ) THEN
                SELECT
                    COUNT(*)
                INTO v_count
                FROM
                    dvcqg_thanh_toan tt
                WHERE
                        tt.donid = v_donid
                    AND maloaivuviec = v_maloaivuviec
                    AND instr(','
                              || duongsu_ids
                              || ',', ','
                                      || v_duongsuid
                                      || ',') > 0;

                IF ( v_count = 1 ) THEN
                    UPDATE dvcqg_thanh_toan
                    SET
                        tongdatid = v_tongdat_id
                    WHERE
                            donid = v_donid
                        AND maloaivuviec = v_maloaivuviec
                        AND instr(','
                                  || duongsu_ids
                                  || ',', ','
                                          || v_duongsuid
                                          || ',') > 0;

                END IF;

            END IF;

        ELSIF ( v_maloaivuviec = '4' ) THEN
            SELECT
                td.donid,
                td.bieumauid
            INTO
                v_donid,
                v_bieumauid
            FROM
                     akt_tongdat_doituong ot
                INNER JOIN akt_tongdat td ON td.id = ot.tongdatid
            WHERE
                    td.id = v_tongdat_id
                AND ot.duongsuid = v_duongsuid;
            ------------------
            IF ( v_bieumauid = 67
            OR v_bieumauid = 381 ) THEN
                SELECT
                    COUNT(*)
                INTO v_count
                FROM
                    dvcqg_thanh_toan tt
                WHERE
                        tt.donid = v_donid
                    AND maloaivuviec = v_maloaivuviec
                    AND duongsu_id = v_duongsuid;

                IF ( v_count = 1 ) THEN
                    UPDATE dvcqg_thanh_toan
                    SET
                        tongdatid = v_tongdat_id
                    WHERE
                            donid = v_donid
                        AND maloaivuviec = v_maloaivuviec
                        AND duongsu_id = v_duongsuid;

                END IF;

            END IF;

        ELSIF ( v_maloaivuviec = '5' ) THEN
            SELECT
                td.donid,
                td.bieumauid
            INTO
                v_donid,
                v_bieumauid
            FROM
                     ald_tongdat_doituong ot
                INNER JOIN ald_tongdat td ON td.id = ot.tongdatid
            WHERE
                    td.id = v_tongdat_id
                AND ot.duongsuid = v_duongsuid;
            --------------
            IF ( v_bieumauid = 67
            OR v_bieumauid = 381 ) THEN
                SELECT
                    COUNT(*)
                INTO v_count
                FROM
                    dvcqg_thanh_toan tt
                WHERE
                        tt.donid = v_donid
                    AND maloaivuviec = v_maloaivuviec
                    AND duongsu_id = v_duongsuid;

                IF ( v_count = 1 ) THEN
                    UPDATE dvcqg_thanh_toan
                    SET
                        tongdatid = v_tongdat_id
                    WHERE
                            donid = v_donid
                        AND maloaivuviec = v_maloaivuviec
                        AND duongsu_id = v_duongsuid;

                END IF;

            END IF;

        ELSIF ( v_maloaivuviec = '6' ) THEN
            SELECT
                td.donid,
                td.bieumauid
            INTO
                v_donid,
                v_bieumauid
            FROM
                     ahc_tongdat_doituong ot
                INNER JOIN ahc_tongdat td ON td.id = ot.tongdatid
            WHERE
                    td.id = v_tongdat_id
                AND ot.duongsuid = v_duongsuid;
            -----------------
            IF ( v_bieumauid = 121
            OR v_bieumauid = 381 ) THEN
                SELECT
                    COUNT(*)
                INTO v_count
                FROM
                    dvcqg_thanh_toan tt
                WHERE
                        tt.donid = v_donid
                    AND maloaivuviec = v_maloaivuviec
                    AND instr(','
                              || duongsu_ids
                              || ',', ','
                                      || v_duongsuid
                                      || ',') > 0;
                ---------------
                IF ( v_count = 1 ) THEN
                    UPDATE dvcqg_thanh_toan
                    SET
                        tongdatid = v_tongdat_id
                    WHERE
                            donid = v_donid
                        AND maloaivuviec = v_maloaivuviec
                        AND instr(','
                                  || duongsu_ids
                                  || ',', ','
                                          || v_duongsuid
                                          || ',') > 0;

                END IF;

            END IF;

        ELSIF ( v_maloaivuviec = '7' ) THEN
            SELECT
                td.donid,
                td.bieumauid
            INTO
                v_donid,
                v_bieumauid
            FROM
                     aps_tongdat_doituong ot
                INNER JOIN aps_tongdat td ON td.id = ot.tongdatid
            WHERE
                    td.id = v_tongdat_id
                AND ot.duongsuid = v_duongsuid;
            ----------------------------
            IF ( v_bieumauid = 121
            OR v_bieumauid = 381 ) THEN
                SELECT
                    COUNT(*)
                INTO v_count
                FROM
                    dvcqg_thanh_toan tt
                WHERE
                        tt.donid = v_donid
                    AND tt.maloaivuviec = v_maloaivuviec
                    AND tt.duongsu_id = v_duongsuid;

                IF ( v_count = 1 ) THEN
                    UPDATE dvcqg_thanh_toan
                    SET
                        tongdatid = v_tongdat_id
                    WHERE
                            donid = v_donid
                        AND maloaivuviec = v_maloaivuviec
                        AND duongsu_id = v_duongsuid;

                END IF;

            END IF;

        END IF;
    END thanh_toan_up_tongdat;

    PROCEDURE thanh_toan_up_tongdat_re (
        v_tongdat_id   IN VARCHAR2,
        v_donid        IN NUMBER,
        v_maloaivuviec IN VARCHAR2
    ) AS
        v_bieumauid NUMBER;
        v_count     NUMBER;
    BEGIN
        IF ( v_maloaivuviec = '3' ) THEN
            SELECT
                bieumauid
            INTO v_bieumauid
            FROM
                ahn_tongdat
            WHERE
                id = v_tongdat_id;

            IF ( v_bieumauid = 67
            OR v_bieumauid = 381 ) THEN
                FOR item IN (
                    SELECT
                        ot.*
                    FROM
                        ahn_tongdat_doituong ot
                    WHERE
                        ot.tongdatid = v_tongdat_id
                ) LOOP
                    SELECT
                        COUNT(*)
                    INTO v_count
                    FROM
                        dvcqg_thanh_toan tt
                    WHERE
                            instr(','
                                  || tt.duongsu_ids
                                  || ',', ','
                                          || item.duongsuid
                                          || ',') > 0
                        AND tt.donid = v_donid
                        AND tt.maloaivuviec = v_maloaivuviec;

                    IF ( v_count = 1 ) THEN
                        UPDATE dvcqg_thanh_toan
                        SET
                            tongdatid = v_tongdat_id
                        WHERE
                                donid = v_donid
                            AND maloaivuviec = v_maloaivuviec
                            AND tongdatid IS NULL
                            AND instr(','
                                      || duongsu_ids
                                      || ',', ','
                                              || item.duongsuid
                                              || ',') > 0;

                    END IF;

                END LOOP;

            END IF;

        END IF;
    END thanh_toan_up_tongdat_re;

    PROCEDURE reset_sequence_quto AS
    BEGIN
        EXECUTE IMMEDIATE 'ALTER SEQUENCE MA_THONGBAO_SEQ RESTART START WITH 1';
    END reset_sequence_quto;

END pkg_dvcqg_app;