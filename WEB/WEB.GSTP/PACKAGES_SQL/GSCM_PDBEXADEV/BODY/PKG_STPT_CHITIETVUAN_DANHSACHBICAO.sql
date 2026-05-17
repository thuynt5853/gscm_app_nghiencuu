--------------------------------------------------------
--  DDL for Package Body PKG_STPT_CHITIETVUAN_DANHSACHBICAO
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_CHITIETVUAN_DANHSACHBICAO" AS

    PROCEDURE AHS_STPT_CHITIETVUAN_DANHSACHBICAO
    ( 
        VCAPXETXU     IN  NUMBER, -- Sơ thẩm - 2, Phúc thẩm - 3
        VVUANID       IN  NUMBER,
        PAGEINDEX	  IN  INT,
        PAGESIZE	  IN  INT,
        CURRETURN     OUT SYS_REFCURSOR
    )
    IS 
        V_ARRAY         T_TYPE_OF_15_COLUMN_VARCHAR;
        V_CURSOR        SYS_REFCURSOR; 

        V_THONGTINBICAO         VARCHAR2(200)   DEFAULT '';
        V_TOIDANH       VARCHAR(500)    DEFAULT '';
        V_HINHPHAT      VARCHAR(500)    DEFAULT '';
        V_KHANGCAO      VARCHAR2(10)    DEFAULT '';

        V_KCKN          VARCHAR(2000)   DEFAULT '';

        V_CHECKCOUNT    NUMBER          DEFAULT 0;

        TotalItem       NUMBER DEFAULT 0;
        STT             NUMBER DEFAULT 0;
        MinIndex	    NUMBER;
        MaxIndex	    NUMBER;

    BEGIN

        V_ARRAY := T_TYPE_OF_15_COLUMN_VARCHAR();

        MinIndex := PageSize*(PageIndex - 1) + 1;
        MaxIndex := PageIndex*PageSize ;

        --SƠ THẨM
        IF(VCAPXETXU LIKE '2') THEN

                FOR ITEM IN (SELECT BC.HOTEN || DECODE(BC.BICANDAUVU, 1, ' - đầu vụ', '')  AS THONGTINBICAO
                                  , BC.NAMSINH AS NAMSINH
                                  , BC.NGAYSINH AS NGAYSINH
                --|| DECODE( TO_CHAR(BC.NGAYSINH,'DD/MM/YYYY'), '01-JAN-01', NVL(BC.NAMSINH,'0'), EXTRACT( YEAR FROM TO_DATE(TO_CHAR(BC.NGAYSINH,'DD/MM/YYYY') ,'DD/MM/YYYY') ) ) AS THONGTINBICAO
                                  , BC.NGAYTHAMGIA AS NGAYTHAMGIA
                                  , 'Địa chỉ: ' || BC.TAMTRUCHITIET || DECODE(BC.TAMTRUCHITIET,'','',', ') || T7.TEN || DECODE(T7.TEN,'','',', ' ) || T8.TEN || DECODE(T8.TEN,'','', ', ' ) AS DIACHITAMTRU
                                  , DECODE(BC.GIOITINH, 1, 'Nam', 2, 'Nữ', '') AS GIOITINH
                                  , BC.ID AS BCID
                             FROM AHS_BICANBICAO BC
                                    LEFT JOIN DM_HANHCHINH T7 ON T7.ID = BC.TAMTRU_HUYEN -- Huyện
                                    LEFT JOIN DM_HANHCHINH T8 ON T8.ID = BC.TAMTRU -- Tỉnh
                             WHERE BC.VUANID = VVUANID)
                LOOP  
                        V_THONGTINBICAO := '';
                        IF(ITEM.NGAYSINH LIKE '01-JAN-01') THEN                
                            V_THONGTINBICAO := ITEM.THONGTINBICAO || '<br>' || '(' || ITEM.NAMSINH || ')';
                        ELSE
                            V_THONGTINBICAO := ITEM.THONGTINBICAO || '<br>' || '(' || TO_CHAR(ITEM.NGAYSINH,'DD/MM/YYYY') || ')';
                        END IF;

                        -- Tổng hợp hình phạt sơ thẩm của bị cáo
                        V_HINHPHAT := '';
                        PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_TONGHOPHINHPHAT_ST(VVUANID, ITEM.BCID, V_CURSOR);
                        LOOP 
                        FETCH V_CURSOR 
                            INTO      V_HINHPHAT;
                            EXIT WHEN V_CURSOR%NOTFOUND;
                        END LOOP;    
                        CLOSE V_CURSOR;

                        V_TOIDANH := '';
                        SELECT LISTAGG(BL.TENTOIDANH, ', ') WITHIN GROUP (ORDER BY CT.TOIDANHID) INTO V_TOIDANH
                        FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CT
                            INNER JOIN DM_BOLUAT_TOIDANH BL ON BL.ID = CT.TOIDANHID
                        WHERE CT.BICANID = ITEM.BCID AND CT.ISMAIN = 1;

                        SELECT COUNT('X') INTO V_CHECKCOUNT
                        FROM AHS_SOTHAM_KHANGCAO KC
                        WHERE KC.NGUOIKCID = ITEM.BCID;

                        V_KHANGCAO := '';
                        IF(V_CHECKCOUNT > 0) THEN V_KHANGCAO := 'X'; ELSE V_KHANGCAO := ''; END IF;

                        STT := STT + 1;
                        V_ARRAY.EXTEND;
                        V_ARRAY(V_ARRAY.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(V_THONGTINBICAO, TO_CHAR(ITEM.NGAYTHAMGIA,'DD/MM/YYYY'), ITEM.DIACHITAMTRU, ITEM.GIOITINH, V_TOIDANH, V_HINHPHAT, V_KHANGCAO,
                                                                                  '8','','','','','','',STT);

                        TotalItem := TotalItem + 1;
                END LOOP;

            --PHÚC THẨM
            ELSIF(VCAPXETXU LIKE '3') THEN

                FOR ITEM IN (SELECT BC.HOTEN AS THONGTINBICAO
                                  , BC.NAMSINH AS NAMSINH
                                  , BC.NGAYSINH AS NGAYSINH
                --|| DECODE( TO_CHAR(BC.NGAYSINH,'DD/MM/YYYY'), '01-JAN-01', NVL(BC.NAMSINH,'0'), EXTRACT( YEAR FROM TO_DATE(TO_CHAR(BC.NGAYSINH,'DD/MM/YYYY') ,'DD/MM/YYYY') ) ) AS THONGTINBICAO
                                  , BC.NGAYTHAMGIA AS NGAYTHAMGIA
                                  , 'HKTT: ' || BC.TAMTRUCHITIET || DECODE(BC.TAMTRUCHITIET,'','',', ') || T7.TEN || DECODE(T7.TEN,'','',', ' ) || T8.TEN || DECODE(T8.TEN,'','', ', ' ) AS DIACHITAMTRU
                                  , DECODE(BC.GIOITINH, 1, 'Nam', 2, 'Nữ', '') AS GIOITINH
                                  , BC.ID AS BCID
                             FROM AHS_BICANBICAO BC
                                    LEFT JOIN DM_HANHCHINH T7 ON T7.ID = BC.TAMTRU_HUYEN -- Huyện
                                    LEFT JOIN DM_HANHCHINH T8 ON T8.ID = BC.TAMTRU -- Tỉnh
                             WHERE BC.VUANID = VVUANID)
                LOOP  
                        V_THONGTINBICAO := '';
                        IF(ITEM.NGAYSINH LIKE '01-JAN-01') THEN                
                            V_THONGTINBICAO := ITEM.THONGTINBICAO || '<br>' || '(' || ITEM.NAMSINH || ')';
                        ELSE
                            V_THONGTINBICAO := ITEM.THONGTINBICAO || '<br>' || '(' || TO_CHAR(ITEM.NGAYSINH,'DD/MM/YYYY') || ')';
                        END IF;

                        -- Tổng hợp hình phạt phúc thẩm của bị cáo
                        V_HINHPHAT := '';
                        PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_TONGHOPHINHPHAT_SOSANH(VVUANID, ITEM.BCID, V_CURSOR);
                        LOOP 
                        FETCH V_CURSOR 
                            INTO      V_HINHPHAT;
                            EXIT WHEN V_CURSOR%NOTFOUND;
                        END LOOP;    
                        CLOSE V_CURSOR;

                        V_TOIDANH := '';
                        SELECT LISTAGG(BL.TENTOIDANH, ', ') WITHIN GROUP (ORDER BY CT.TOIDANHID) INTO V_TOIDANH
                        FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CT
                            INNER JOIN DM_BOLUAT_TOIDANH BL ON BL.ID = CT.TOIDANHID
                        WHERE CT.BICANID = ITEM.BCID AND CT.ISMAIN = 1;

                        SELECT COUNT('X') INTO V_CHECKCOUNT
                        FROM AHS_SOTHAM_KHANGCAO KC
                        WHERE KC.NGUOIKCID = ITEM.BCID;

                        --lấy danh sách các ID của bị cáo được kc/kn, bị kc/kn
                        SELECT NGUOIBIKNID.DSNGUOIBIKN || ',' || NGUOIBIKCID.DSNGUOIBIKC || ',' || NGUOIKCID.NGUOIKCID INTO V_KCKN
                        FROM DUAL
                            LEFT JOIN (SELECT LISTAGG(NGUOIKCID.NGUOIKCID, ', ') WITHIN GROUP (ORDER BY NGUOIKCID.ID) NGUOIKCID, NGUOIKCID.VUANID  
                                       FROM AHS_SOTHAM_KHANGCAO NGUOIKCID
                                       GROUP BY NGUOIKCID.VUANID) NGUOIKCID ON NGUOIKCID.VUANID = VVUANID
                            LEFT JOIN (SELECT LISTAGG(NGUOIBIKCID.DSNGUOIBIKC, ', ') WITHIN GROUP (ORDER BY NGUOIBIKCID.ID) DSNGUOIBIKC, NGUOIBIKCID.VUANID  
                                       FROM AHS_SOTHAM_KHANGCAO NGUOIBIKCID
                                       GROUP BY NGUOIBIKCID.VUANID) NGUOIBIKCID ON NGUOIBIKCID.VUANID = VVUANID
                            LEFT JOIN (SELECT LISTAGG(NGUOIBIKNID.DSNGUOIBIKN, ', ') WITHIN GROUP (ORDER BY NGUOIBIKNID.ID) DSNGUOIBIKN, NGUOIBIKNID.VUANID  
                                       FROM AHS_SOTHAM_KHANGNGHI NGUOIBIKNID
                                       GROUP BY NGUOIBIKNID.VUANID) NGUOIBIKNID ON NGUOIBIKNID.VUANID = VVUANID;

                        V_KHANGCAO := '';
                        IF(V_CHECKCOUNT > 0) THEN V_KHANGCAO := 'X'; ELSE V_KHANGCAO := ''; END IF;

                        -- chỉ lấy các bị cáo được kc/kn, bị kc/kn
                        IF(V_KCKN LIKE '%' || ITEM.BCID || '%') THEN

                            STT := STT + 1;
                            V_ARRAY.EXTEND;
                            V_ARRAY(V_ARRAY.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(V_THONGTINBICAO, TO_CHAR(ITEM.NGAYTHAMGIA,'DD/MM/YYYY'), ITEM.DIACHITAMTRU, ITEM.GIOITINH, V_TOIDANH, V_HINHPHAT, V_KHANGCAO,
                                                                                  '8','','','','','','',STT);    
                            TotalItem := TotalItem + 1;

                        END IF;
                END LOOP;

        END IF;

        --COLUMN_15 -- Là số thứ tự
        OPEN curReturn FOR SELECT A.*, TotalItem AS CountAll
                           FROM (SELECT * FROM TABLE(V_ARRAY) T1) A 
                           where A.COLUMN_15 >= MinIndex and a.COLUMN_15<=MaxIndex;

    END AHS_STPT_CHITIETVUAN_DANHSACHBICAO;

    PROCEDURE AHS_STPT_CHITIETVUAN_DANHSACHKHANGCAO
    ( 
        VCAPXETXU     IN  NUMBER, -- Sơ thẩm - 2, Phúc thẩm - 3
        VVUANID       IN  NUMBER,
        PAGEINDEX	  IN  INT,
        PAGESIZE	  IN  INT,
        CURRETURN     OUT SYS_REFCURSOR
    )
    IS 
        V_ARRAY         T_TYPE_OF_15_COLUMN_VARCHAR;
        V_CURSOR        SYS_REFCURSOR; 

        V_NOIDUNGKHANGCAO CLOB;

        TotalItem       NUMBER DEFAULT 0;
        STT             NUMBER DEFAULT 0;
        MinIndex	    NUMBER;
        MaxIndex	    NUMBER;

    BEGIN

        V_ARRAY := T_TYPE_OF_15_COLUMN_VARCHAR();

        MinIndex := PageSize*(PageIndex - 1) + 1;
        MaxIndex := PageIndex*PageSize ;

        FOR ITEM IN (SELECT DECODE(T2.NGUOIKCLOAI, 0, BC.HOTEN , 1, TGTT.HOTENTUCACHTOTUNG, '') AS NGUOIKHANGCAO,
                            DECODE(T2.LOAIKHANGCAO, 0, 'Bản án', 1, 'Quyết định', 2, 'Quyết định', 3, 'Quyết định', '') AS LOAIKHANGCAO,
                            TO_CHAR(T2.NGAYKHANGCAO,'DD/MM/YYYY') AS NGAYKHANGCAO,
                            DECODE(T2.LOAIKHANGCAO, 0, BA.SOBANAN, 1, QDVA.SOQUYETDINH, 2, QDVA.SOQUYETDINH, 3, QDBC.SOQUYETDINH, '') AS SOBAQD,
                            DECODE(T2.LOAIKHANGCAO, 0, TO_CHAR(BA.NGAYBANAN,'DD/MM/YYYY'), 1, TO_CHAR(QDVA.NGAYQD,'DD/MM/YYYY'), 2, TO_CHAR(QDVA.NGAYQD,'DD/MM/YYYY'), 3, TO_CHAR(QDBC.NGAYQD,'DD/MM/YYYY'), '') AS NGAYBAQD,
                            DECODE(T2.ISQUAHAN, 0, '', 1, 'X', '') AS QUAHAN,
                            T2.ID KCID

                     FROM AHS_SOTHAM_KHANGCAO T2

                        LEFT JOIN (SELECT BC.ID, DECODE(BC.BICANDAUVU, 1, BC.HOTEN || ' - Bị cáo đầu vụ', BC.HOTEN || ' - Bị cáo') HOTEN FROM AHS_BICANBICAO BC) BC ON BC.ID = T2.NGUOIKCID
                        LEFT JOIN (SELECT TGTT.ID, TGTT.HOTEN || ' - ' || TCTGTT.TEN HOTENTUCACHTOTUNG 
                                   FROM AHS_NGUOITHAMGIATOTUNG TGTT
                                        LEFT JOIN (SELECT DMDT.TEN, TCTGTT.NGUOIID
                                                   FROM AHS_NGUOITHAMGIATOTUNG_TUCACH TCTGTT
                                                       LEFT JOIN DM_DATAITEM DMDT ON DMDT.ID = TCTGTT.TUCACHID
                                                   ) TCTGTT ON TCTGTT.NGUOIID = TGTT.ID
                                   ) TGTT ON TGTT.ID = T2.NGUOIKCID

                        LEFT JOIN (SELECT * FROM AHS_SOTHAM_BANAN) BA ON BA.ID = T2.SOQDBA
                        LEFT JOIN (SELECT * FROM AHS_SOTHAM_QUYETDINH_VUAN) QDVA ON QDVA.ID = T2.SOQDBA
                        LEFT JOIN (SELECT * FROM AHS_SOTHAM_QUYETDINH_BICAN) QDBC ON QDBC.ID = T2.SOQDBA

                     WHERE T2.VUANID = VVUANID)
        LOOP  
                V_NOIDUNGKHANGCAO := '';
                FOR NOIDUNGYEUCAU IN (SELECT DM.TEN || ';<br>' TEN
                                      FROM AHS_SOTHAM_KHANGCAO_YEUCAU YC
                                        LEFT JOIN DM_DATAITEM DM ON DM.ID = YC.YEUCAUID
                                      WHERE KHANGCAOID = ITEM.KCID)
                LOOP

                    V_NOIDUNGKHANGCAO := V_NOIDUNGKHANGCAO || NOIDUNGYEUCAU.TEN;

                END LOOP;

                STT := STT + 1;
                V_ARRAY.EXTEND;
                V_ARRAY(V_ARRAY.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(ITEM.NGUOIKHANGCAO, ITEM.LOAIKHANGCAO, ITEM.NGAYKHANGCAO, ITEM.SOBAQD, ITEM.NGAYBAQD, V_NOIDUNGKHANGCAO, ITEM.QUAHAN,
                                                                          '8','','','','','','',STT);

                TotalItem := TotalItem + 1;
        END LOOP;


        --COLUMN_15 -- Là số thứ tự
        OPEN curReturn FOR SELECT A.*, TotalItem AS CountAll
                           FROM (SELECT * FROM TABLE(V_ARRAY) T1) A 
                           where A.COLUMN_15 >= MinIndex and a.COLUMN_15<=MaxIndex;

    END AHS_STPT_CHITIETVUAN_DANHSACHKHANGCAO;

    PROCEDURE AHS_STPT_CHITIETVUAN_DANHSACHKHANGNGHI
    ( 
        VCAPXETXU     IN  NUMBER, -- Sơ thẩm - 2, Phúc thẩm - 3
        VVUANID       IN  NUMBER,
        PAGEINDEX	  IN  INT,
        PAGESIZE	  IN  INT,
        CURRETURN     OUT SYS_REFCURSOR
    )
    IS 
        V_ARRAY         T_TYPE_OF_15_COLUMN_VARCHAR;
        V_CURSOR        SYS_REFCURSOR; 

        V_NOIDUNGKHANGNGHI CLOB;

        TotalItem       NUMBER DEFAULT 0;
        STT             NUMBER DEFAULT 0;
        MinIndex	    NUMBER;
        MaxIndex	    NUMBER;

    BEGIN

        V_ARRAY := T_TYPE_OF_15_COLUMN_VARCHAR();

        MinIndex := PageSize*(PageIndex - 1) + 1;
        MaxIndex := PageIndex*PageSize ;

        FOR ITEM IN (SELECT DECODE(T2.DONVIKN, 0, 'Tòa án', 1, 'Viện kiểm sát', '') || DECODE(T2.CAPKN, 0, ' cùng cấp', 1, ' cấp trên', '') AS DONVIKN,
                            DECODE(T2.LOAIKN, 0, 'Bản án', 1, 'Quyết định', 2, 'Quyết định', '') AS LOAIKN,
                            TO_CHAR(T2.NGAYKN,'DD/MM/YYYY') AS NGAYKN,
                            SOKN,
                            TO_CHAR(T2.NGAYBANAN,'DD/MM/YYYY') AS NGAYBANAN,
                            T2.ID KNID

                     FROM AHS_SOTHAM_KHANGNGHI T2
                     WHERE T2.VUANID = VVUANID)
                LOOP  

                        V_NOIDUNGKHANGNGHI := '';
                        FOR NOIDUNGYEUCAU IN (SELECT DM.TEN || ';<br>' TEN
                                              FROM AHS_SOTHAM_KHANGNGHI_YEUCAU YC
                                                LEFT JOIN DM_DATAITEM DM ON DM.ID = YC.YEUCAUID
                                              WHERE KHANGNGHIID = ITEM.KNID)
                        LOOP

                            V_NOIDUNGKHANGNGHI := V_NOIDUNGKHANGNGHI || NOIDUNGYEUCAU.TEN;

                        END LOOP;


                        STT := STT + 1;
                        V_ARRAY.EXTEND;
                        V_ARRAY(V_ARRAY.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(ITEM.DONVIKN, ITEM.LOAIKN, ITEM.NGAYKN, ITEM.SOKN, ITEM.NGAYBANAN, V_NOIDUNGKHANGNGHI, '',
                                                                                  '8','','','','','','',STT);

                        TotalItem := TotalItem + 1;
                END LOOP;


        --COLUMN_15 -- Là số thứ tự
        OPEN curReturn FOR SELECT A.*, TotalItem AS CountAll
                           FROM (SELECT * FROM TABLE(V_ARRAY) T1) A 
                           where A.COLUMN_15 >= MinIndex and a.COLUMN_15<=MaxIndex;

    END AHS_STPT_CHITIETVUAN_DANHSACHKHANGNGHI;


END PKG_STPT_CHITIETVUAN_DANHSACHBICAO;

/
