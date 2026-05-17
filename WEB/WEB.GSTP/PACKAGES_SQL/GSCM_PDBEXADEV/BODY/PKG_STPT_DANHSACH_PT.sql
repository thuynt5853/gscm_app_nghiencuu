--------------------------------------------------------
--  DDL for Package Body PKG_STPT_DANHSACH_PT
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_DANHSACH_PT" AS

PROCEDURE DANHSACH_AN_DANSUMORONG
(
    V_CAP_XET_XU_LOGIN      IN VARCHAR2,
    V_TEN_VU_AN             IN VARCHAR2, 
    V_TOIDANH               IN VARCHAR2, 
    V_MA_VU_AN              IN VARCHAR2, 
    V_BI_CAN                IN VARCHAR2,
    V_CAPXX                 IN VARCHAR2,
    V_TOAAN_ID              IN VARCHAR2, 
    V_TINHTRANG_THULY       IN VARCHAR2,
    V_NGAYTHULY_TU          IN VARCHAR2,
    V_NGAYTHULY_DEN         IN VARCHAR2,
    V_SOTHULY               IN VARCHAR2,
    V_TINHTRANG_GIAIQUYET   IN VARCHAR2,
    V_TUNGAY                IN VARCHAR2,
    V_DENNGAY               IN VARCHAR2,
    V_KETQUA                IN VARCHAR2,
    V_SO_QD                 IN VARCHAR2,
    V_NGAY_QD               IN VARCHAR2,
    V_THAMPHAN_ID           IN VARCHAR2, 
    V_VAITRO_THAMPHAN       IN VARCHAR2, 
    V_THUKY_ID              IN VARCHAR2, 
    V_THOIHAN_GQ            IN VARCHAR2, 
    V_QD_TAMGIAM            IN VARCHAR2,
    V_UTTP                  IN VARCHAR2,
    V_LOAIAN_ID             IN VARCHAR2,
    V_AN_KET_THUC           IN NUMBER,
    PAGE_INDEX              IN INT,
    PAGE_SIZE	            IN INT,
    CURRETURN               OUT SYS_REFCURSOR
)
AS
    CURSOR_RETURN           SYS_REFCURSOR;

    V_TABLE_EXPORT          T_TIMKIEM_BAOCAO_DANHSACHCHUNG;
    V_TABLE_EXPORT_BAOCAO   T_TYPE_OF_20_COLUMN_VARCHAR;
    V_TABLE_EXPORT_BAOCAO_HS   T_DANHSACH_AHS_DAXU_PT;

    V_EXPORT_TEXT           CLOB;

    V_TABLE_ID_ADS              T_ID;
    V_TABLE_ID_AHN              T_ID;
    V_TABLE_ID_AKT              T_ID;
    V_TABLE_ID_ALD              T_ID;
    V_TABLE_ID_AHC              T_ID;
    V_TABLE_ID_AHS              T_ID;

    TEN_LOAI_AN_DA_XU       VARCHAR2(250);
    V_TINHTRANGGIAQUYET     VARCHAR2(250) DEFAULT '';
    VV_TUNGAY               date;
    VV_DENNGAY              date;

    COLUMN_1                VARCHAR2(4000) DEFAULT '';
    COLUMN_2                VARCHAR2(4000) DEFAULT '';
    COLUMN_3                VARCHAR2(4000) DEFAULT '';
    COLUMN_4                VARCHAR2(4000) DEFAULT '';
    COLUMN_5                VARCHAR2(4000) DEFAULT '';
    COLUMN_6                VARCHAR2(4000) DEFAULT '';
    COLUMN_7                VARCHAR2(4000) DEFAULT '';
    COLUMN_8                VARCHAR2(4000) DEFAULT '';
    COLUMN_9                VARCHAR2(4000) DEFAULT '';
    COLUMN_10               VARCHAR2(4000) DEFAULT '';
    COLUMN_11               VARCHAR2(4000) DEFAULT '';
    COLUMN_12               VARCHAR2(4000) DEFAULT '';
    COLUMN_13               VARCHAR2(4000) DEFAULT '';
    COLUMN_14               VARCHAR2(4000) DEFAULT '';
    COLUMN_15               VARCHAR2(4000) DEFAULT '';
    COLUMN_16               VARCHAR2(4000) DEFAULT '';
    COLUMN_17               VARCHAR2(4000) DEFAULT '';
    COLUMN_18               VARCHAR2(4000) DEFAULT '';
    COLUMN_19               VARCHAR2(4000) DEFAULT '';
    COLUMN_20               VARCHAR2(4000) DEFAULT '';
    COLUMN_21               VARCHAR2(4000) DEFAULT '';
    COLUMN_22               VARCHAR2(4000) DEFAULT '';
    COLUMN_23               VARCHAR2(4000) DEFAULT '';
    COLUMN_24               VARCHAR2(4000) DEFAULT '';
    COLUMN_25               VARCHAR2(4000) DEFAULT '';
    COLUMN_26               VARCHAR2(4000) DEFAULT '';
    COLUMN_27               VARCHAR2(4000) DEFAULT '';
    COLUMN_28               VARCHAR2(4000) DEFAULT '';

    AHS                     VARCHAR(1) DEFAULT '1';
    ADS                     VARCHAR(1) DEFAULT '2';
    AHN                     VARCHAR(1) DEFAULT '3';
    AKT                     VARCHAR(1) DEFAULT '4';
    ALD                     VARCHAR(1) DEFAULT '5';
    AHC                     VARCHAR(1) DEFAULT '6';
    APS                     VARCHAR(1) DEFAULT '7';
    XLHC                    VARCHAR(1) DEFAULT '8';

    V_CHECK_ID                   CLOB DEFAULT ',';
BEGIN   
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
        V_TABLE_EXPORT := T_TIMKIEM_BAOCAO_DANHSACHCHUNG();
        V_TABLE_EXPORT_BAOCAO := T_TYPE_OF_20_COLUMN_VARCHAR();
        V_TABLE_EXPORT_BAOCAO_HS := T_DANHSACH_AHS_DAXU_PT();

        V_TABLE_ID_ADS := T_ID();
        V_TABLE_ID_AHN := T_ID();
        V_TABLE_ID_AKT := T_ID();
        V_TABLE_ID_ALD := T_ID();
        V_TABLE_ID_AHC := T_ID();
        V_TABLE_ID_AHS := T_ID();

        IF(V_TUNGAY IS NOT NULL)  THEN  VV_TUNGAY  := TO_DATE(TRIM(V_TUNGAY) ||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  END IF;  
        IF(V_DENNGAY IS NOT NULL) THEN  VV_DENNGAY := TO_DATE(TRIM(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');  END IF;  

        IF( v_TINHTRANG_GIAIQUYET = '1') THEN V_TINHTRANGGIAQUYET := 'CHƯA GIẢI QUYẾT XONG';
           ELSIF( v_TINHTRANG_GIAIQUYET = '2') THEN V_TINHTRANGGIAQUYET := 'CHƯA PHÂN CÔNG THẨM PHÁN';
           ELSIF( v_TINHTRANG_GIAIQUYET = '3') THEN V_TINHTRANGGIAQUYET := 'ĐÃ PHÂN CÔNG THẨM PHÁN';
           ELSIF( v_TINHTRANG_GIAIQUYET = '4') THEN V_TINHTRANGGIAQUYET := 'ĐÃ LÊN LỊCH XÉT XỬ';
           ELSIF( v_TINHTRANG_GIAIQUYET = '5') THEN V_TINHTRANGGIAQUYET := 'ĐÃ HOÃN';
           ELSIF( v_TINHTRANG_GIAIQUYET = '6') THEN V_TINHTRANGGIAQUYET := 'ĐANG TẠM ĐÌNH CHỈ';
           ELSIF( v_TINHTRANG_GIAIQUYET = '7') THEN V_TINHTRANGGIAQUYET := 'ĐÃ GIẢI QUYẾT XONG';
           ELSIF( v_TINHTRANG_GIAIQUYET = '8') THEN V_TINHTRANGGIAQUYET := 'ĐÃ XÉT XỬ';
           ELSIF( v_TINHTRANG_GIAIQUYET = '9') THEN V_TINHTRANGGIAQUYET := 'ĐÌNH CHỈ';
           ELSIF( v_TINHTRANG_GIAIQUYET = '10') THEN V_TINHTRANGGIAQUYET := 'CHUYỂN VỤ ÁN';
        END IF;

        IF(V_LOAIAN_ID='2,3,4,5,6') THEN -- DS
                TEN_LOAI_AN_DA_XU := 'DÂN SỰ CÁC LOẠI';
            ELSE
                SELECT UPPER(A.LOAI_AN_TEN) INTO TEN_LOAI_AN_DA_XU
                FROM DM_LOAIAN A
                WHERE ID = TO_NUMBER(V_LOAIAN_ID);
            END IF;

        --Lấy dữ liệu như Tìm kiếm báo cáo
        HS_DS_EXT_SEARCH_ALL(V_CAP_XET_XU_LOGIN, V_TEN_VU_AN, V_TOIDANH, V_MA_VU_AN, V_BI_CAN, V_CAPXX,
                             V_TOAAN_ID, V_TINHTRANG_THULY, V_NGAYTHULY_TU, V_NGAYTHULY_DEN, V_SOTHULY, V_TINHTRANG_GIAIQUYET,
                             V_TUNGAY, V_DENNGAY, V_KETQUA, V_SO_QD, V_NGAY_QD, V_THAMPHAN_ID, V_VAITRO_THAMPHAN ,
                             V_THUKY_ID, V_THOIHAN_GQ, V_QD_TAMGIAM, V_UTTP,
                             V_LOAIAN_ID, V_AN_KET_THUC, 0, 0,
                             CURSOR_RETURN);
        LOOP

            FETCH CURSOR_RETURN
            INTO    COLUMN_1, COLUMN_2, COLUMN_3, COLUMN_4,COLUMN_5, COLUMN_6, COLUMN_7,
                    COLUMN_8, COLUMN_9, COLUMN_10, COLUMN_11, COLUMN_12, COLUMN_13,
                    COLUMN_14, COLUMN_15, COLUMN_16, COLUMN_17,
                    COLUMN_18, COLUMN_19, COLUMN_20, COLUMN_21, COLUMN_22, COLUMN_23,
                    COLUMN_24, COLUMN_25, COLUMN_26, COLUMN_27, COLUMN_28;
            EXIT WHEN CURSOR_RETURN%NOTFOUND;

            V_TABLE_EXPORT.EXTEND;
            V_TABLE_EXPORT(V_TABLE_EXPORT.COUNT) := R_TIMKIEM_BAOCAO_DANHSACHCHUNG
                                                               (COLUMN_1, COLUMN_2, COLUMN_3, COLUMN_4, COLUMN_5, COLUMN_6, COLUMN_7,
                                                                COLUMN_8, COLUMN_9, COLUMN_10,COLUMN_11, COLUMN_12, COLUMN_13,
                                                                /*COLUMN_14,*/ COLUMN_15, COLUMN_16, COLUMN_17,
                                                                COLUMN_18, COLUMN_19, COLUMN_20, COLUMN_21, COLUMN_22, COLUMN_23,
                                                                COLUMN_24, COLUMN_25, COLUMN_26, COLUMN_27, COLUMN_28);

        END LOOP;
        CLOSE CURSOR_RETURN;

        --Nối chuỗi các ID theo từng loại án;
        FOR ITEM IN (SELECT VA.ID, VA.LOAIAN_ID FROM TABLE(V_TABLE_EXPORT) VA)
        LOOP
            IF(ITEM.LOAIAN_ID = '1') THEN
                    V_TABLE_ID_AHS.EXTEND;
                    V_TABLE_ID_AHS(V_TABLE_ID_AHS.COUNT) := R_ID(TO_NUMBER(ITEM.ID));
                ELSIF(ITEM.LOAIAN_ID = '2') THEN
                    V_TABLE_ID_ADS.EXTEND;
                    V_TABLE_ID_ADS(V_TABLE_ID_ADS.COUNT) := R_ID(TO_NUMBER(ITEM.ID));
                ELSIF(ITEM.LOAIAN_ID = '3') THEN
                    V_TABLE_ID_AHN.EXTEND;
                    V_TABLE_ID_AHN(V_TABLE_ID_AHN.COUNT) := R_ID(TO_NUMBER(ITEM.ID));
                ELSIF(ITEM.LOAIAN_ID = '4') THEN
                    V_TABLE_ID_AKT.EXTEND;
                    V_TABLE_ID_AKT(V_TABLE_ID_AKT.COUNT) := R_ID(TO_NUMBER(ITEM.ID));
                ELSIF(ITEM.LOAIAN_ID = '5') THEN
                    V_TABLE_ID_ALD.EXTEND;
                    V_TABLE_ID_ALD(V_TABLE_ID_ALD.COUNT) := R_ID(TO_NUMBER(ITEM.ID));
                ELSIF(ITEM.LOAIAN_ID = '6') THEN
                    V_TABLE_ID_AHC.EXTEND;
                    V_TABLE_ID_AHC(V_TABLE_ID_AHC.COUNT) := R_ID(TO_NUMBER(ITEM.ID));
                    V_CHECK_ID := V_CHECK_ID || ',' || ITEM.ID;
                END IF;       
        END LOOP;


      --DBMS_OUTPUT.PUT_LINE(V_TABLE_ID_AHS);

        IF(V_LOAIAN_ID = AHS) THEN
                FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_PT.DON_SEARCH_ITEM_AHS(V_TABLE_ID_AHS) PA )
                LOOP
                    V_TABLE_EXPORT_BAOCAO_HS.EXTEND;    
                    V_TABLE_EXPORT_BAOCAO_HS(V_TABLE_EXPORT_BAOCAO_HS.count) := R_DANHSACH_AHS_DAXU_PT(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                      ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                      ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14,ITEM.COLUMN_15);                                                                                            
                END LOOP;
            ELSE
                IF(INSTR(V_LOAIAN_ID,ADS) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_PT.DON_SEARCH_ITEM_ADS(V_TABLE_ID_ADS) PA )
                    LOOP
                        V_TABLE_EXPORT_BAOCAO.EXTEND; 
                        V_TABLE_EXPORT_BAOCAO(V_TABLE_EXPORT_BAOCAO.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                          ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                          ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14,ITEM.COLUMN_15,
                                                                                                          ITEM.COLUMN_16,ITEM.COLUMN_17,ITEM.COLUMN_18,ITEM.COLUMN_19,ITEM.COLUMN_20);                                                                                              
                    END LOOP; 
                END IF;

                IF(INSTR(V_LOAIAN_ID,AHN) > 0 OR V_LOAIAN_ID IS NULL) THEN                
                    FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_PT.DON_SEARCH_ITEM_AHN(V_TABLE_ID_AHN) PA )
                LOOP
                    V_TABLE_EXPORT_BAOCAO.EXTEND; 
                    V_TABLE_EXPORT_BAOCAO(V_TABLE_EXPORT_BAOCAO.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                      ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                      ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14,ITEM.COLUMN_15,
                                                                                                      ITEM.COLUMN_16,ITEM.COLUMN_17,ITEM.COLUMN_18,ITEM.COLUMN_19,ITEM.COLUMN_20); 
                END LOOP; 
                END IF;

                IF(INSTR(V_LOAIAN_ID,AKT) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_PT.DON_SEARCH_ITEM_AKT(V_TABLE_ID_AKT) PA )
                LOOP
                    V_TABLE_EXPORT_BAOCAO.EXTEND; 
                    V_TABLE_EXPORT_BAOCAO(V_TABLE_EXPORT_BAOCAO.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                      ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                      ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14,ITEM.COLUMN_15,
                                                                                                      ITEM.COLUMN_16,ITEM.COLUMN_17,ITEM.COLUMN_18,ITEM.COLUMN_19,ITEM.COLUMN_20); 
                END LOOP; 
                END IF;

                IF(INSTR(V_LOAIAN_ID,ALD) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_PT.DON_SEARCH_ITEM_ALD(V_TABLE_ID_ALD) PA )
                LOOP
                    V_TABLE_EXPORT_BAOCAO.EXTEND; 
                    V_TABLE_EXPORT_BAOCAO(V_TABLE_EXPORT_BAOCAO.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                      ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                      ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14,ITEM.COLUMN_15,
                                                                                                      ITEM.COLUMN_16,ITEM.COLUMN_17,ITEM.COLUMN_18,ITEM.COLUMN_19,ITEM.COLUMN_20); 
                END LOOP; 
                END IF;

                IF(INSTR(V_LOAIAN_ID,AHC) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_PT.DON_SEARCH_ITEM_AHC(V_TABLE_ID_AHC) PA )
                    LOOP
                        V_TABLE_EXPORT_BAOCAO.EXTEND; 
                        V_TABLE_EXPORT_BAOCAO(V_TABLE_EXPORT_BAOCAO.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                          ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                          ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14,ITEM.COLUMN_15,
                                                                                                          ITEM.COLUMN_16,ITEM.COLUMN_17,ITEM.COLUMN_18,ITEM.COLUMN_19,ITEM.COLUMN_20); 
                    END LOOP;
                END IF;

            END IF;


    IF(V_LOAIAN_ID = AHS) THEN
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
                <tr align="center" style="text-align: center;">
                    <td colspan="13" style="text-align: center; vertical-align: top; font-size: 12pt"><b>ÁN HÌNH SỰ '||V_TINHTRANGGIAQUYET||' TỪ NGÀY '||TO_CHAR(VV_TUNGAY,'dd/mm/rrrr')||' ĐẾN NGÀY '||TO_CHAR(VV_DENNGAY,'dd/mm/rrrr')||' </b></td>
                </tr>
                <tr style="height: 3px;">
                </tr>
                <tr align="center" style="text-align: center;"> 
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Chủ toạ</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Thành viên</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Thư ký</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Số BA/QĐ PT</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Ngày BA/QĐ PT</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Số/Ngày TL</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Họ và tên</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Số BC</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">KC/KN</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Tội danh</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Mức án ST</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Số BA/QĐ ST</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Ngày BA/QĐ ST</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Tỉnh/TP</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">Kết quả XXPT</td>
                </tr>');
        FOR item IN(SELECT PA.* 
                    FROM TABLE(V_TABLE_EXPORT_BAOCAO_HS) PA
                    ORDER BY PA.COLUMN_5 ASC)
        LOOP
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;"> 
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||UPPER(ITEM.COLUMN_1)||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_2||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_3||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_4||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||TO_CHAR(ITEM.COLUMN_5,'DD/MM/YYYY')||'</td>                    
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_6||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_7||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_8||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_9||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_10||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_11||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_12||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||TO_CHAR(ITEM.COLUMN_13,'DD/MM/YYYY')||'</td>  
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_14||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 8pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_15||'</td>
                </tr>');
        END LOOP;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr style="height: 0px;">
                <td style="width: 66px"></td>
                <td style="width: 66px"></td>
                <td style="width: 66px"></td>
                <td style="width: 42px"></td>
                <td style="width: 62px"></td>
                <td style="width: 62px"></td>
                <td style="width: 100px"></td>
                <td style="width: 50px"></td>
                <td style="width: 50px"></td>
                <td style="width: 105px"></td>
                <td style="width: 105px"></td>
                <td style="width: 42px"></td> 
                <td style="width: 62px"></td> 
                <td style="width: 80px"></td>
                <td style="width: 105px"></td>
            </tr>
        </table>');
    ELSE
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
            <tr align="center" style="text-align: center;">
                <td colspan="13" style="text-align: center; vertical-align: top; font-size: 12pt">ÁN '||TEN_LOAI_AN_DA_XU||' '||V_TINHTRANGGIAQUYET||' TỪ NGÀY '||TO_CHAR(VV_TUNGAY,'dd/mm/rrrr')||' ĐẾN NGÀY '||TO_CHAR(VV_DENNGAY,'dd/mm/rrrr')||' </td>
            </tr>
            <tr style="height: 3px;">
            </tr>
            <tr align="center" style="text-align: center;"> 
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Chủ toạ</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Thành viên</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Thư ký</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Loại án</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Số án</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Ngày xử</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Số/Ngày TL</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Nguyên đơn</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Bị đơn</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Vụ việc</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Số BA/QĐ ST</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Ngày BA/QĐ ST</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Tỉnh/TP</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">KC/KN</td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">Kết quả XXPT</td>
            </tr>');
    FOR item IN(SELECT PA.* FROM 
                TABLE(V_TABLE_EXPORT_BAOCAO) PA 
                ORDER BY PA.COLUMN_6 ASC)
    LOOP
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;"> 
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_1||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_2||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_3||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_4||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_5||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_6||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_7||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_8||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_9||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_10||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_11||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_12||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_13||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_14||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 10pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_15||'</td>
                </tr>');
    END LOOP;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr style="height: 0px;">
                    <td style="width: 75px"></td>
                    <td style="width: 75px"></td>
                    <td style="width: 75px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 65px"></td>
                    <td style="width: 65px"></td>
                    <td style="width: 75px"></td>
                    <td style="width: 75px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 65px"></td>
                    <td style="width: 85px"></td>
                    <td style="width: 50px"></td>
                    <td style="width: 100px"></td>
                </tr>
            </table>');
    END IF;

    OPEN curReturn FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
            dbms_lob.freetemporary(V_EXPORT_TEXT);
END DANHSACH_AN_DANSUMORONG;


FUNCTION DON_SEARCH_ITEM_ADS
(   
    V_DONID T_ID
)
RETURN T_TYPE_OF_20_COLUMN_VARCHAR
IS 
    V_TABLE_EXPORT  T_TYPE_OF_20_COLUMN_VARCHAR;
    V_TABLE_ID T_ID;
    V_NGUYENDON CLOB DEFAULT '';
BEGIN

     V_TABLE_EXPORT := T_TYPE_OF_20_COLUMN_VARCHAR();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

     FOR ITEM IN 
     (        SELECT A.ID AS DONID,
                     NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA, TENTHUKY.HOTENTHUKY VTHUKY,TENTPHDXX.HOTEN VTHANHVIEN,
                     TLPT.THULYPT THULYPT,
                     NVL(TTBA.QHPL,NVL(TLPT.QHPL,NVL(A.QUANHEPHAPLUAT_NAME,DMDON.TEN))) AS QHPL,
                     REPLACE(TENTA.TEN,'Tòa án nhân dân t', 'T') VDIACHI,
                     --DS_ND.TENNGUYENDON VNGUYENDON,
                     DS_BD.TENBIDON VBIDON,NDBDS.NOIDUNGKHANGCAO ||NDKNS.NOIDUNGKN VKCKN,
                     --SOTHAM
                     QDVAST.SOQD || ' ' || BANANST.SOBANAN  SOBAQDST, QDVAST.NGAYQD || ' ' || BANANST.NGAYTUYENAN NGAYBAQDST,
                     --PHUCTHAM
                     QDVA.TEN || ' ' || TTBA.KQPT AS KETQUAXXPT,
                     QDVA.SOQD || ' ' || TTBA.SOBANAN AS SOKQXXPT, TO_CHAR(QDVA.NGAYQD,'DD/MM/YYYY') || ' ' || TO_CHAR(TTBA.NGAYTUYENAN,'DD/MM/YYYY') AS NGAYKQXXPT
--                     --SOTHAM
--                     QDVAST.SOQD || ' ' || BANANST.SOBANAN  SOBAQDST, TO_CHAR(QDVAST.NGAYQD,'DD/MM/YYYY') || ' ' || TO_CHAR(BANANST.NGAYTUYENAN,'DD/MM/YYYY') NGAYBAQDST,
--                     --PHUCTHAM
--                     QDVA.TEN || ' ' || TTBA.KQPT AS KETQUAXXPT,
--                     QDVA.SOQD || ' ' || TTBA.SOBANAN AS SOKQXXPT, TO_CHAR(QDVA.NGAYQD,'DD/MM/YYYY') || ' ' || TO_CHAR(TTBA.NGAYTUYENAN,'DD/MM/YYYY') AS NGAYKQXXPT

              FROM ADS_DON A
                    INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                    --------------------------Chủ tọa-----------------------------------------------------------
                    LEFT JOIN (SELECT D.DONID, 
                                      LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) AS HOTEN  
                               FROM ADS_PHUCTHAM_HDXX D
                                   LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                               WHERE D.MAVAITRO LIKE 'THAMPHAN'
                               GROUP BY D.DONID) TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                    LEFT JOIN (SELECT GG.DONID,
                                      LISTAGG(NNPC.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY GG.NGAYNHANPHANCONG, GG.NGAYTAO) AS HOTEN
                               FROM ADS_DON_THAMPHAN GG
                                   LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                               WHERE GG.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GG.NGAYPHANCONG IS NOT NULL AND GG.NGAYNHANPHANCONG IS NOT NULL AND GG.NGUOIPHANCONGID IS NOT NULL
                               GROUP BY GG.DONID )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                    --------------------------Thành viên---------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTEN 
                              FROM ADS_PHUCTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                              GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                     

                    --------------------------Thư ký-------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTENTHUKY 
                              FROM ADS_PHUCTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THUKY'
                              GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID                    

                    --------------------------Bản án/Quyết định gây kết thúc Phúc thẩm---------------------------
                    ----------------------KẾT QUẢ PHÚC THẨM, SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ, QHPL BA
                    LEFT JOIN(SELECT DONID, DMKQPT.TEN AS KQPT, SOBANAN, NGAYTUYENAN, NVL(QUANHEPHAPLUAT_NAME,DMPTBA.TEN) AS QHPL
                              FROM ADS_PHUCTHAM_BANAN D
                                  LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = D.KETQUAPHUCTHAMID
                                  LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) DMPTBA on D.QUANHEPHAPLUATID = DMPTBA.ID
                              ) TTBA ON TTBA.DONID = A.ID 

                    LEFT JOIN (SELECT PTQD.DONID, PTQD.SOQD, PTQD.NGAYQD,  
                                         CASE WHEN (DMQD.TEN LIKE '%Quyết định đình chỉ%') THEN u'Q\0110 \0111\00ecnh ch\1ec9'
                                              WHEN (DMQD.TEN LIKE '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN DMKQPT.TEN
                                              ELSE DECODE(instr(DMQD.TEN,'. '), 0, DMQD.TEN, SUBSTR(DMQD.TEN, instr(DMQD.TEN,'. ')+2))
                                         END AS TEN 
                               FROM ADS_PHUCTHAM_QUYETDINH PTQD
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                                   LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = PTQD.KETQUAID
                               ) QDVA ON QDVA.DONID = A.ID

                    --------------------------Số thụ lý------------------------------------------------------------
                    LEFT JOIN (SELECT TL.DONID,
                                      LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULYPT,
                                      LISTAGG(NVL(TL.QUANHEPHAPLUAT_NAME, DMPTTL.TEN),',') WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS QHPL
                               FROM ADS_PHUCTHAM_THULY TL 
                                   left join DM_DATAITEM DMPTTL on TL.QUANHEPHAPLUATID=DMPTTL.ID
                               GROUP BY TL.DONID
                               )TLPT ON A.ID=TLPT.DONID

                    --------------------------Nguyên đơn------------------------------------------------------------
--                    LEFT JOIN(SELECT DONID,
--                                     LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENNGUYENDON 
--                              FROM ADS_DON_DUONGSU
--                              WHERE TUCACHTOTUNG_MA = 'NGUYENDON'
--                              GROUP BY DONID ) DS_ND ON DS_ND.DONID = A.ID  

                    --------------------------Bị đơn-----------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENBIDON 
                              FROM ADS_DON_DUONGSU
                              WHERE TUCACHTOTUNG_MA = 'BIDON'
                              GROUP BY DONID ) DS_BD ON DS_BD.DONID = A.ID 

                    --------------------------Vụ việc----------------------------------------------------------------- 
                    LEFT JOIN DM_DATAITEM DMDON on DMDON.ID = A.QUANHEPHAPLUATID

                    --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------   
                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOQD,',') WITHIN GROUP (ORDER BY NGAYQD) AS SOQD,
                                      LISTAGG(TO_CHAR(NGAYQD,'DD/MM/YYYY'),',') WITHIN GROUP (ORDER BY NGAYQD) AS NGAYQD
                               FROM ADS_SOTHAM_QUYETDINH
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               GROUP BY DONID ) QDVAST ON QDVAST.DONID = A.ID

                    LEFT JOIN (SELECT DONID, SOBANAN, TO_CHAR(NGAYTUYENAN,'DD/MM/YYYY') NGAYTUYENAN FROM ADS_SOTHAM_BANAN) BANANST ON BANANST.DONID = A.ID 

                    --------------------------

                    --TEN TOA AN SO THAM 
                    LEFT JOIN DM_TOAAN TENTA ON A.TOAANID = TENTA.ID
                    --------------------------Kháng cáo/Kháng nghị-------------------------------------------------------
                    LEFT JOIN (SELECT NDBD.DONID,
                                      LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NGAYKHANGCAO) NOIDUNGKHANGCAO
                                FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO, NGAYKHANGCAO
                                        FROM (   
                                              SELECT F.DON_ND, NGAYKHANGCAO FROM (
                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND, NGAYKHANGCAO
                                                    from ADS_SOTHAM_KHANGCAO kc 
                                                    LEFT JOIN ADS_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA, NGAYKHANGCAO
                                                   )F
                                              GROUP BY F.DON_ND, NGAYKHANGCAO
                                          )FF
                                 )NDBD  GROUP BY NDBD.DONID
                                )NDBDS ON NDBDS.DONID=A.ID
                    LEFT JOIN (SELECT NDKN.DONID,
                                      LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NGAYKN)NOIDUNGKN
                               FROM (SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN, NGAYKN
                                     FROM ADS_SOTHAM_KHANGNGHI KC )NDKN  
                               GROUP BY NDKN.DONID
                              )NDKNS ON NDKNS.DONID=A.ID  
        )
        LOOP
              V_NGUYENDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         --LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC)
                                         TENDUONGSU TENNGUYENDON 
                                  FROM ADS_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'NGUYENDON' AND DONID = ITEM.DONID
                                  --GROUP BY DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_NGUYENDON := V_NGUYENDON || ITEM_DS.TENNGUYENDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

                V_TABLE_EXPORT.EXTEND; 
                V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.VCHUTOA,ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                            'Dân sự',ITEM.SOKQXXPT,ITEM.NGAYKQXXPT,ITEM.THULYPT,
                                            V_NGUYENDON,ITEM.VBIDON,ITEM.QHPL,ITEM.SOBAQDST,ITEM.NGAYBAQDST,
                                            ITEM.VDIACHI,ITEM.VKCKN,ITEM.KETQUAXXPT,'16','17','18','19','20');
        END LOOP;

        RETURN V_TABLE_EXPORT;
END DON_SEARCH_ITEM_ADS;

FUNCTION DON_SEARCH_ITEM_AHN
(   
    V_DONID T_ID
)
RETURN T_TYPE_OF_20_COLUMN_VARCHAR
IS 
    V_TABLE_EXPORT  T_TYPE_OF_20_COLUMN_VARCHAR;
    V_TABLE_ID T_ID;
    V_NGUYENDON CLOB DEFAULT '';
BEGIN

     V_TABLE_EXPORT := T_TYPE_OF_20_COLUMN_VARCHAR();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

     FOR ITEM IN 
     (      SELECT A.ID AS DONID,
                     NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA, TENTHUKY.HOTENTHUKY VTHUKY,TENTPHDXX.HOTEN VTHANHVIEN,
                     TLPT.THULYPT THULYPT,
                     NVL(TTBA.QHPL,NVL(TLPT.QHPL,NVL(A.QUANHEPHAPLUAT_NAME,DMDON.TEN))) AS QHPL,
                     REPLACE(TENTA.TEN,'Tòa án nhân dân t', 'T') VDIACHI,
                     --DS_ND.TENNGUYENDON VNGUYENDON,
                     DS_BD.TENBIDON VBIDON,NDBDS.NOIDUNGKHANGCAO ||NDKNS.NOIDUNGKN VKCKN,
                     --SOTHAM
                     QDVAST.SOQD || ' ' || BANANST.SOBANAN  SOBAQDST, QDVAST.NGAYQD || ' ' || BANANST.NGAYTUYENAN NGAYBAQDST,
                     --PHUCTHAM
                     QDVA.TEN || ' ' || TTBA.KQPT AS KETQUAXXPT,
                     QDVA.SOQD || ' ' || TTBA.SOBANAN AS SOKQXXPT, TO_CHAR(QDVA.NGAYQD,'DD/MM/YYYY') || ' ' || TO_CHAR(TTBA.NGAYTUYENAN,'DD/MM/YYYY') AS NGAYKQXXPT

              FROM AHN_DON A
                    INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                    --------------------------Chủ tọa-----------------------------------------------------------
                    LEFT JOIN (SELECT D.DONID, 
                                      LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) AS HOTEN  
                               FROM AHN_PHUCTHAM_HDXX D
                                   LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                               WHERE D.MAVAITRO LIKE 'THAMPHAN'
                               GROUP BY D.DONID) TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                    LEFT JOIN (SELECT GG.DONID,
                                      LISTAGG(NNPC.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY GG.NGAYNHANPHANCONG, GG.NGAYTAO) AS HOTEN
                               FROM AHN_DON_THAMPHAN GG
                                   LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                               WHERE GG.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GG.NGAYPHANCONG IS NOT NULL AND GG.NGAYNHANPHANCONG IS NOT NULL AND GG.NGUOIPHANCONGID IS NOT NULL
                               GROUP BY GG.DONID )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                    --------------------------Thành viên---------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTEN 
                              FROM AHN_PHUCTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                              GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                     

                    --------------------------Thư ký-------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTENTHUKY 
                              FROM AHN_PHUCTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THUKY'
                              GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID                    

                    --------------------------Bản án/Quyết định gây kết thúc Phúc thẩm---------------------------
                    ----------------------KẾT QUẢ PHÚC THẨM, SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ, QHPL BA
                    LEFT JOIN(SELECT DONID, DMKQPT.TEN AS KQPT, SOBANAN, NGAYTUYENAN, NVL(QUANHEPHAPLUAT_NAME,DMPTBA.TEN) AS QHPL
                              FROM AHN_PHUCTHAM_BANAN D
                                  LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = D.KETQUAPHUCTHAMID
                                  LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) DMPTBA on D.QUANHEPHAPLUATID = DMPTBA.ID
                              ) TTBA ON TTBA.DONID = A.ID 

                    LEFT JOIN (SELECT PTQD.DONID, PTQD.SOQD, PTQD.NGAYQD,  
                                         CASE WHEN (DMQD.TEN LIKE '%Quyết định đình chỉ%') THEN u'Q\0110 \0111\00ecnh ch\1ec9'
                                              WHEN (DMQD.TEN LIKE '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN DMKQPT.TEN
                                              ELSE DECODE(instr(DMQD.TEN,'. '), 0, DMQD.TEN, SUBSTR(DMQD.TEN, instr(DMQD.TEN,'. ')+2))
                                         END AS TEN 
                               FROM AHN_PHUCTHAM_QUYETDINH PTQD
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                                   LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = PTQD.KETQUAID
                               ) QDVA ON QDVA.DONID = A.ID

                    --------------------------Số thụ lý------------------------------------------------------------
                    LEFT JOIN (SELECT TL.DONID,
                                      LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULYPT,
                                      LISTAGG(NVL(TL.QUANHEPHAPLUAT_NAME, DMPTTL.TEN),',') WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS QHPL
                               FROM AHN_PHUCTHAM_THULY TL 
                                   left join DM_DATAITEM DMPTTL on TL.QUANHEPHAPLUATID=DMPTTL.ID
                               GROUP BY TL.DONID
                               )TLPT ON A.ID=TLPT.DONID

                    --------------------------Nguyên đơn------------------------------------------------------------
--                    LEFT JOIN(SELECT DONID,
--                                     LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENNGUYENDON 
--                              FROM AHN_DON_DUONGSU
--                              WHERE TUCACHTOTUNG_MA = 'NGUYENDON'
--                              GROUP BY DONID ) DS_ND ON DS_ND.DONID = A.ID  

                    --------------------------Bị đơn-----------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENBIDON 
                              FROM AHN_DON_DUONGSU
                              WHERE TUCACHTOTUNG_MA = 'BIDON'
                              GROUP BY DONID ) DS_BD ON DS_BD.DONID = A.ID 

                    --------------------------Vụ việc----------------------------------------------------------------- 
                    LEFT JOIN DM_DATAITEM DMDON on DMDON.ID = A.QUANHEPHAPLUATID

                    --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------   
                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOQD,',') WITHIN GROUP (ORDER BY NGAYQD) AS SOQD,
                                      LISTAGG(TO_CHAR(NGAYQD,'DD/MM/YYYY'),',') WITHIN GROUP (ORDER BY NGAYQD) AS NGAYQD
                               FROM AHN_SOTHAM_QUYETDINH
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               GROUP BY DONID ) QDVAST ON QDVAST.DONID = A.ID

                    LEFT JOIN (SELECT DONID, SOBANAN, TO_CHAR(NGAYTUYENAN,'DD/MM/YYYY') NGAYTUYENAN FROM AHN_SOTHAM_BANAN) BANANST ON BANANST.DONID = A.ID 

                    --------------------------

                    --TEN TOA AN SO THAM 
                    LEFT JOIN DM_TOAAN TENTA ON A.TOAANID = TENTA.ID
                    --------------------------Kháng cáo/Kháng nghị-------------------------------------------------------
                    LEFT JOIN (SELECT NDBD.DONID,
                                      LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NGAYKHANGCAO) NOIDUNGKHANGCAO
                                FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO, NGAYKHANGCAO
                                        FROM (   
                                              SELECT F.DON_ND, NGAYKHANGCAO FROM (
                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND, NGAYKHANGCAO
                                                    from AHN_SOTHAM_KHANGCAO kc 
                                                    LEFT JOIN AHN_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA, NGAYKHANGCAO
                                                   )F
                                              GROUP BY F.DON_ND, NGAYKHANGCAO
                                          )FF
                                 )NDBD  GROUP BY NDBD.DONID
                                )NDBDS ON NDBDS.DONID=A.ID
                    LEFT JOIN (SELECT NDKN.DONID,
                                      LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NGAYKN)NOIDUNGKN
                               FROM (SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN, NGAYKN
                                     FROM AHN_SOTHAM_KHANGNGHI KC )NDKN  
                               GROUP BY NDKN.DONID
                              )NDKNS ON NDKNS.DONID=A.ID  
        )
        LOOP
              V_NGUYENDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         --LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC)
                                         TENDUONGSU TENNGUYENDON 
                                  FROM AHN_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'NGUYENDON' AND DONID = ITEM.DONID
                                  --GROUP BY DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_NGUYENDON := V_NGUYENDON || ITEM_DS.TENNGUYENDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

                V_TABLE_EXPORT.EXTEND; 
                V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.VCHUTOA,ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                            'Hôn nhân gia đình',ITEM.SOKQXXPT,ITEM.NGAYKQXXPT,ITEM.THULYPT,
                                            V_NGUYENDON,ITEM.VBIDON,ITEM.QHPL,ITEM.SOBAQDST,ITEM.NGAYBAQDST,
                                            ITEM.VDIACHI,ITEM.VKCKN,ITEM.KETQUAXXPT,'16','17','18','19','20');
        END LOOP;

        RETURN V_TABLE_EXPORT;
END DON_SEARCH_ITEM_AHN;

FUNCTION DON_SEARCH_ITEM_ALD
(   
    V_DONID T_ID
)
RETURN T_TYPE_OF_20_COLUMN_VARCHAR
IS 
    V_TABLE_EXPORT  T_TYPE_OF_20_COLUMN_VARCHAR;
    V_TABLE_ID T_ID;
    V_NGUYENDON CLOB DEFAULT '';
BEGIN

     V_TABLE_EXPORT := T_TYPE_OF_20_COLUMN_VARCHAR();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

     FOR ITEM IN 
     (      SELECT A.ID AS DONID,
                     NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA, TENTHUKY.HOTENTHUKY VTHUKY,TENTPHDXX.HOTEN VTHANHVIEN,
                     TLPT.THULYPT THULYPT,
                     NVL(TTBA.QHPL,NVL(TLPT.QHPL,NVL(A.QUANHEPHAPLUAT_NAME,DMDON.TEN))) AS QHPL,
                     REPLACE(TENTA.TEN,'Tòa án nhân dân t', 'T') VDIACHI,
                     --DS_ND.TENNGUYENDON VNGUYENDON,
                     DS_BD.TENBIDON VBIDON,NDBDS.NOIDUNGKHANGCAO ||NDKNS.NOIDUNGKN VKCKN,
                     --SOTHAM
                     QDVAST.SOQD || ' ' || BANANST.SOBANAN  SOBAQDST, QDVAST.NGAYQD || ' ' || BANANST.NGAYTUYENAN NGAYBAQDST,
                     --PHUCTHAM
                     QDVA.TEN || ' ' || TTBA.KQPT AS KETQUAXXPT,
                     QDVA.SOQD || ' ' || TTBA.SOBANAN AS SOKQXXPT, TO_CHAR(QDVA.NGAYQD,'DD/MM/YYYY') || ' ' || TO_CHAR(TTBA.NGAYTUYENAN,'DD/MM/YYYY') AS NGAYKQXXPT

              FROM ALD_DON A
                    INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                    --------------------------Chủ tọa-----------------------------------------------------------
                    LEFT JOIN (SELECT D.DONID, 
                                      LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) AS HOTEN  
                               FROM ALD_PHUCTHAM_HDXX D
                                   LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                               WHERE D.MAVAITRO LIKE 'THAMPHAN'
                               GROUP BY D.DONID) TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                    LEFT JOIN (SELECT GG.DONID,
                                      LISTAGG(NNPC.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY GG.NGAYNHANPHANCONG, GG.NGAYTAO) AS HOTEN
                               FROM ALD_DON_THAMPHAN GG
                                   LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                               WHERE GG.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GG.NGAYPHANCONG IS NOT NULL AND GG.NGAYNHANPHANCONG IS NOT NULL AND GG.NGUOIPHANCONGID IS NOT NULL
                               GROUP BY GG.DONID )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                    --------------------------Thành viên---------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTEN 
                              FROM ALD_PHUCTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                              GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                     

                    --------------------------Thư ký-------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTENTHUKY 
                              FROM ALD_PHUCTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THUKY'
                              GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID                    

                    --------------------------Bản án/Quyết định gây kết thúc Phúc thẩm---------------------------
                    ----------------------KẾT QUẢ PHÚC THẨM, SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ, QHPL BA
                    LEFT JOIN(SELECT DONID, DMKQPT.TEN AS KQPT, SOBANAN, NGAYTUYENAN, NVL(QUANHEPHAPLUAT_NAME,DMPTBA.TEN) AS QHPL
                              FROM ALD_PHUCTHAM_BANAN D
                                  LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = D.KETQUAPHUCTHAMID
                                  LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) DMPTBA on D.QUANHEPHAPLUATID = DMPTBA.ID
                              ) TTBA ON TTBA.DONID = A.ID 

                    LEFT JOIN (SELECT PTQD.DONID, PTQD.SOQD, PTQD.NGAYQD,  
                                         CASE WHEN (DMQD.TEN LIKE '%Quyết định đình chỉ%') THEN u'Q\0110 \0111\00ecnh ch\1ec9'
                                              WHEN (DMQD.TEN LIKE '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN DMKQPT.TEN
                                              ELSE DECODE(instr(DMQD.TEN,'. '), 0, DMQD.TEN, SUBSTR(DMQD.TEN, instr(DMQD.TEN,'. ')+2))
                                         END AS TEN 
                               FROM ALD_PHUCTHAM_QUYETDINH PTQD
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                                   LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = PTQD.KETQUAID
                               ) QDVA ON QDVA.DONID = A.ID

                    --------------------------Số thụ lý------------------------------------------------------------
                    LEFT JOIN (SELECT TL.DONID,
                                      LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULYPT,
                                      LISTAGG(NVL(TL.QUANHEPHAPLUAT_NAME, DMPTTL.TEN),',') WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS QHPL
                               FROM ALD_PHUCTHAM_THULY TL 
                                   left join DM_DATAITEM DMPTTL on TL.QUANHEPHAPLUATID=DMPTTL.ID
                               GROUP BY TL.DONID
                               )TLPT ON A.ID=TLPT.DONID

                    --------------------------Nguyên đơn------------------------------------------------------------
--                    LEFT JOIN(SELECT DONID,
--                                     LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENNGUYENDON 
--                              FROM ALD_DON_DUONGSU
--                              WHERE TUCACHTOTUNG_MA = 'NGUYENDON'
--                              GROUP BY DONID ) DS_ND ON DS_ND.DONID = A.ID  

                    --------------------------Bị đơn-----------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENBIDON 
                              FROM ALD_DON_DUONGSU
                              WHERE TUCACHTOTUNG_MA = 'BIDON'
                              GROUP BY DONID ) DS_BD ON DS_BD.DONID = A.ID 

                    --------------------------Vụ việc----------------------------------------------------------------- 
                    LEFT JOIN DM_DATAITEM DMDON on DMDON.ID = A.QUANHEPHAPLUATID

                    --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------   
                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOQD,',') WITHIN GROUP (ORDER BY NGAYQD) AS SOQD,
                                      LISTAGG(TO_CHAR(NGAYQD,'DD/MM/YYYY'),',') WITHIN GROUP (ORDER BY NGAYQD) AS NGAYQD
                               FROM ALD_SOTHAM_QUYETDINH
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               GROUP BY DONID ) QDVAST ON QDVAST.DONID = A.ID

                    LEFT JOIN (SELECT DONID, SOBANAN, TO_CHAR(NGAYTUYENAN,'DD/MM/YYYY') NGAYTUYENAN FROM ALD_SOTHAM_BANAN) BANANST ON BANANST.DONID = A.ID 

                    --------------------------

                    --TEN TOA AN SO THAM 
                    LEFT JOIN DM_TOAAN TENTA ON A.TOAANID = TENTA.ID
                    --------------------------Kháng cáo/Kháng nghị-------------------------------------------------------
                    LEFT JOIN (SELECT NDBD.DONID,
                                      LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NGAYKHANGCAO) NOIDUNGKHANGCAO
                                FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO, NGAYKHANGCAO
                                        FROM (   
                                              SELECT F.DON_ND, NGAYKHANGCAO FROM (
                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND, NGAYKHANGCAO
                                                    from ALD_SOTHAM_KHANGCAO kc 
                                                    LEFT JOIN ALD_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA, NGAYKHANGCAO
                                                   )F
                                              GROUP BY F.DON_ND, NGAYKHANGCAO
                                          )FF
                                 )NDBD  GROUP BY NDBD.DONID
                                )NDBDS ON NDBDS.DONID=A.ID
                    LEFT JOIN (SELECT NDKN.DONID,
                                      LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NGAYKN)NOIDUNGKN
                               FROM (SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN, NGAYKN
                                     FROM ALD_SOTHAM_KHANGNGHI KC )NDKN  
                               GROUP BY NDKN.DONID
                              )NDKNS ON NDKNS.DONID=A.ID  
        )
        LOOP
              V_NGUYENDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         --LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC)
                                         TENDUONGSU TENNGUYENDON 
                                  FROM ALD_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'NGUYENDON' AND DONID = ITEM.DONID
                                  --GROUP BY DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_NGUYENDON := V_NGUYENDON || ITEM_DS.TENNGUYENDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

                V_TABLE_EXPORT.EXTEND; 
                V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.VCHUTOA,ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                            'Lao động',ITEM.SOKQXXPT,ITEM.NGAYKQXXPT,ITEM.THULYPT,
                                            V_NGUYENDON,ITEM.VBIDON,ITEM.QHPL,ITEM.SOBAQDST,ITEM.NGAYBAQDST,
                                            ITEM.VDIACHI,ITEM.VKCKN,ITEM.KETQUAXXPT,'16','17','18','19','20');
        END LOOP;

        RETURN V_TABLE_EXPORT;
END DON_SEARCH_ITEM_ALD;

FUNCTION DON_SEARCH_ITEM_AKT
(   
    V_DONID T_ID
)
RETURN T_TYPE_OF_20_COLUMN_VARCHAR
IS 
    V_TABLE_EXPORT  T_TYPE_OF_20_COLUMN_VARCHAR;
    V_TABLE_ID T_ID;
    V_NGUYENDON CLOB DEFAULT '';
BEGIN

     V_TABLE_EXPORT := T_TYPE_OF_20_COLUMN_VARCHAR();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

     FOR ITEM IN 
     (      SELECT A.ID AS DONID,
                     NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA, TENTHUKY.HOTENTHUKY VTHUKY,TENTPHDXX.HOTEN VTHANHVIEN,
                     TLPT.THULYPT THULYPT,
                     NVL(TTBA.QHPL,NVL(TLPT.QHPL,NVL(A.QUANHEPHAPLUAT_NAME,DMDON.TEN))) AS QHPL,
                     REPLACE(TENTA.TEN,'Tòa án nhân dân t', 'T') VDIACHI,
                     --DS_ND.TENNGUYENDON VNGUYENDON,
                     DS_BD.TENBIDON VBIDON,NDBDS.NOIDUNGKHANGCAO ||NDKNS.NOIDUNGKN VKCKN,
                     --SOTHAM
                     QDVAST.SOQD || ' ' || BANANST.SOBANAN  SOBAQDST, QDVAST.NGAYQD || ' ' || BANANST.NGAYTUYENAN NGAYBAQDST,
                     --PHUCTHAM
                     QDVA.TEN || ' ' || TTBA.KQPT AS KETQUAXXPT,
                     QDVA.SOQD || ' ' || TTBA.SOBANAN AS SOKQXXPT, TO_CHAR(QDVA.NGAYQD,'DD/MM/YYYY') || ' ' || TO_CHAR(TTBA.NGAYTUYENAN,'DD/MM/YYYY') AS NGAYKQXXPT

              FROM AKT_DON A
                    INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                    --------------------------Chủ tọa-----------------------------------------------------------
                    LEFT JOIN (SELECT D.DONID, 
                                      LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) AS HOTEN  
                               FROM AKT_PHUCTHAM_HDXX D
                                   LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                               WHERE D.MAVAITRO LIKE 'THAMPHAN'
                               GROUP BY D.DONID) TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                    LEFT JOIN (SELECT GG.DONID,
                                      LISTAGG(NNPC.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY GG.NGAYNHANPHANCONG, GG.NGAYTAO) AS HOTEN
                               FROM AKT_DON_THAMPHAN GG
                                   LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                               WHERE GG.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GG.NGAYPHANCONG IS NOT NULL AND GG.NGAYNHANPHANCONG IS NOT NULL AND GG.NGUOIPHANCONGID IS NOT NULL
                               GROUP BY GG.DONID )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                    --------------------------Thành viên---------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTEN 
                              FROM AKT_PHUCTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                              GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                     

                    --------------------------Thư ký-------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTENTHUKY 
                              FROM AKT_PHUCTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THUKY'
                              GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID                    

                    --------------------------Bản án/Quyết định gây kết thúc Phúc thẩm---------------------------
                    ----------------------KẾT QUẢ PHÚC THẨM, SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ, QHPL BA
                    LEFT JOIN(SELECT DONID, DMKQPT.TEN AS KQPT, SOBANAN, NGAYTUYENAN, NVL(QUANHEPHAPLUAT_NAME,DMPTBA.TEN) AS QHPL
                              FROM AKT_PHUCTHAM_BANAN D
                                  LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = D.KETQUAPHUCTHAMID
                                  LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) DMPTBA on D.QUANHEPHAPLUATID = DMPTBA.ID
                              ) TTBA ON TTBA.DONID = A.ID 

                    LEFT JOIN (SELECT PTQD.DONID, PTQD.SOQD, PTQD.NGAYQD,  
                                         CASE WHEN (DMQD.TEN LIKE '%Quyết định đình chỉ%') THEN u'Q\0110 \0111\00ecnh ch\1ec9'
                                              WHEN (DMQD.TEN LIKE '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN DMKQPT.TEN
                                              ELSE DECODE(instr(DMQD.TEN,'. '), 0, DMQD.TEN, SUBSTR(DMQD.TEN, instr(DMQD.TEN,'. ')+2))
                                         END AS TEN 
                               FROM AKT_PHUCTHAM_QUYETDINH PTQD
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                                   LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = PTQD.KETQUAID
                               ) QDVA ON QDVA.DONID = A.ID

                    --------------------------Số thụ lý------------------------------------------------------------
                    LEFT JOIN (SELECT TL.DONID,
                                      LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULYPT,
                                      LISTAGG(NVL(TL.QUANHEPHAPLUAT_NAME, DMPTTL.TEN),',') WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS QHPL
                               FROM AKT_PHUCTHAM_THULY TL 
                                   left join DM_DATAITEM DMPTTL on TL.QUANHEPHAPLUATID=DMPTTL.ID
                               GROUP BY TL.DONID
                               )TLPT ON A.ID=TLPT.DONID

                    --------------------------Nguyên đơn------------------------------------------------------------
--                    LEFT JOIN(SELECT DONID,
--                                     LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENNGUYENDON 
--                              FROM AKT_DON_DUONGSU
--                              WHERE TUCACHTOTUNG_MA = 'NGUYENDON'
--                              GROUP BY DONID ) DS_ND ON DS_ND.DONID = A.ID  

                    --------------------------Bị đơn-----------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENBIDON 
                              FROM AKT_DON_DUONGSU
                              WHERE TUCACHTOTUNG_MA = 'BIDON'
                              GROUP BY DONID ) DS_BD ON DS_BD.DONID = A.ID 

                    --------------------------Vụ việc----------------------------------------------------------------- 
                    LEFT JOIN DM_DATAITEM DMDON on DMDON.ID = A.QUANHEPHAPLUATID

                    --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------   
                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOQD,',') WITHIN GROUP (ORDER BY NGAYQD) AS SOQD,
                                      LISTAGG(TO_CHAR(NGAYQD,'DD/MM/YYYY'),',') WITHIN GROUP (ORDER BY NGAYQD) AS NGAYQD
                               FROM AKT_SOTHAM_QUYETDINH
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               GROUP BY DONID ) QDVAST ON QDVAST.DONID = A.ID

                    LEFT JOIN (SELECT DONID, SOBANAN, TO_CHAR(NGAYTUYENAN,'DD/MM/YYYY') NGAYTUYENAN FROM AKT_SOTHAM_BANAN) BANANST ON BANANST.DONID = A.ID 

                    --------------------------

                    --TEN TOA AN SO THAM 
                    LEFT JOIN DM_TOAAN TENTA ON A.TOAANID = TENTA.ID
                    --------------------------Kháng cáo/Kháng nghị-------------------------------------------------------
                    LEFT JOIN (SELECT NDBD.DONID,
                                      LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NGAYKHANGCAO) NOIDUNGKHANGCAO
                                FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO, NGAYKHANGCAO
                                        FROM (   
                                              SELECT F.DON_ND, NGAYKHANGCAO FROM (
                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND, NGAYKHANGCAO
                                                    from AKT_SOTHAM_KHANGCAO kc 
                                                    LEFT JOIN AKT_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA, NGAYKHANGCAO
                                                   )F
                                              GROUP BY F.DON_ND, NGAYKHANGCAO
                                          )FF
                                 )NDBD  GROUP BY NDBD.DONID
                                )NDBDS ON NDBDS.DONID=A.ID
                    LEFT JOIN (SELECT NDKN.DONID,
                                      LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NGAYKN)NOIDUNGKN
                               FROM (SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN, NGAYKN
                                     FROM AKT_SOTHAM_KHANGNGHI KC )NDKN  
                               GROUP BY NDKN.DONID
                              )NDKNS ON NDKNS.DONID=A.ID
        )
        LOOP
              V_NGUYENDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         --LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC)
                                         TENDUONGSU TENNGUYENDON 
                                  FROM AKT_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'NGUYENDON' AND DONID = ITEM.DONID
                                  --GROUP BY DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_NGUYENDON := V_NGUYENDON || ITEM_DS.TENNGUYENDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

                V_TABLE_EXPORT.EXTEND; 
                V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.VCHUTOA,ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                            'Kinh doanh, thương mại',ITEM.SOKQXXPT,ITEM.NGAYKQXXPT,ITEM.THULYPT,
                                            V_NGUYENDON,ITEM.VBIDON,ITEM.QHPL,ITEM.SOBAQDST,ITEM.NGAYBAQDST,
                                            ITEM.VDIACHI,ITEM.VKCKN,ITEM.KETQUAXXPT,'16','17','18','19','20');
        END LOOP;

        RETURN V_TABLE_EXPORT;
END DON_SEARCH_ITEM_AKT;

FUNCTION DON_SEARCH_ITEM_AHC
(   
    V_DONID T_ID
)
RETURN T_TYPE_OF_20_COLUMN_VARCHAR
IS 
    V_TABLE_EXPORT  T_TYPE_OF_20_COLUMN_VARCHAR;
    V_TABLE_ID T_ID;
    V_NGUYENDON CLOB DEFAULT '';
BEGIN

     V_TABLE_EXPORT := T_TYPE_OF_20_COLUMN_VARCHAR();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

     FOR ITEM IN 
     (      SELECT A.ID AS DONID,
                     NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA, TENTHUKY.HOTENTHUKY VTHUKY,TENTPHDXX.HOTEN VTHANHVIEN,
                     TLPT.THULYPT THULYPT,
                     NVL(TTBA.QHPL,NVL(TLPT.QHPL,NVL(A.QUANHEPHAPLUAT_NAME,DMDON.TEN))) AS QHPL,
                     REPLACE(TENTA.TEN,'Tòa án nhân dân t', 'T') VDIACHI,
                     --DS_ND.TENNGUYENDON VNGUYENDON,
                     DS_BD.TENBIDON VBIDON,NDBDS.NOIDUNGKHANGCAO ||NDKNS.NOIDUNGKN VKCKN,
                     --SOTHAM
                     QDVAST.SOQD || ' ' || BANANST.SOBANAN  SOBAQDST, QDVAST.NGAYQD || ' ' || BANANST.NGAYTUYENAN NGAYBAQDST,
                     --PHUCTHAM
                     QDVA.TEN || ' ' || TTBA.KQPT AS KETQUAXXPT,
                     QDVA.SOQD || ' ' || TTBA.SOBANAN AS SOKQXXPT, TO_CHAR(QDVA.NGAYQD,'DD/MM/YYYY') || ' ' || TO_CHAR(TTBA.NGAYTUYENAN,'DD/MM/YYYY') AS NGAYKQXXPT

              FROM AHC_DON A
                    INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                    --------------------------Chủ tọa-----------------------------------------------------------
                    LEFT JOIN (SELECT D.DONID, 
                                      LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) AS HOTEN  
                               FROM AHC_PHUCTHAM_HDXX D
                                   LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                               WHERE D.MAVAITRO LIKE 'THAMPHAN'
                               GROUP BY D.DONID) TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                    LEFT JOIN (SELECT GG.DONID,
                                      LISTAGG(NNPC.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY GG.NGAYNHANPHANCONG, GG.NGAYTAO) AS HOTEN
                               FROM AHC_DON_THAMPHAN GG
                                   LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                               WHERE GG.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' AND GG.NGAYPHANCONG IS NOT NULL AND GG.NGAYNHANPHANCONG IS NOT NULL AND GG.NGUOIPHANCONGID IS NOT NULL
                               GROUP BY GG.DONID )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                    --------------------------Thành viên---------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTEN 
                              FROM AHC_PHUCTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                              GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                     

                    --------------------------Thư ký-------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTENTHUKY 
                              FROM AHC_PHUCTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THUKY'
                              GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID                    

                    --------------------------Bản án/Quyết định gây kết thúc Phúc thẩm---------------------------
                    ----------------------KẾT QUẢ PHÚC THẨM, SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ, QHPL BA
                    LEFT JOIN(SELECT DONID, DMKQPT.TEN AS KQPT, SOBANAN, NGAYTUYENAN, NVL(QUANHEPHAPLUAT_NAME,DMPTBA.TEN) AS QHPL
                              FROM AHC_PHUCTHAM_BANAN D
                                  LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = D.KETQUAPHUCTHAMID
                                  LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) DMPTBA on D.QUANHEPHAPLUATID = DMPTBA.ID
                              ) TTBA ON TTBA.DONID = A.ID 

                    LEFT JOIN (SELECT PTQD.DONID, PTQD.SOQD, PTQD.NGAYQD,  
                                         CASE WHEN (DMQD.TEN LIKE '%Quyết định đình chỉ%') THEN u'Q\0110 \0111\00ecnh ch\1ec9'
                                              WHEN (DMQD.TEN LIKE '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN DMKQPT.TEN
                                              ELSE DECODE(instr(DMQD.TEN,'. '), 0, DMQD.TEN, SUBSTR(DMQD.TEN, instr(DMQD.TEN,'. ')+2))
                                         END AS TEN 
                               FROM AHC_PHUCTHAM_QUYETDINH PTQD
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                                   LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = PTQD.KETQUAID
                               ) QDVA ON QDVA.DONID = A.ID

                    --------------------------Số thụ lý------------------------------------------------------------
                    LEFT JOIN (SELECT TL.DONID,
                                      LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULYPT,
                                      LISTAGG(NVL(TL.QUANHEPHAPLUAT_NAME, DMPTTL.TEN),',') WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS QHPL
                               FROM AHC_PHUCTHAM_THULY TL 
                                   left join DM_DATAITEM DMPTTL on TL.QUANHEPHAPLUATID=DMPTTL.ID
                               GROUP BY TL.DONID
                               )TLPT ON A.ID=TLPT.DONID

                    --------------------------Nguyên đơn------------------------------------------------------------
--                    LEFT JOIN(SELECT DONID,
--                                     --LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC)
--                                     '' TENNGUYENDON 
--                              FROM AHC_DON_DUONGSU
--                              WHERE TUCACHTOTUNG_MA = 'NGUYENDON'
--                              GROUP BY DONID ) DS_ND ON DS_ND.DONID = A.ID  

                    --------------------------Bị đơn-----------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC) TENBIDON 
                              FROM AHC_DON_DUONGSU
                              WHERE TUCACHTOTUNG_MA = 'BIDON'
                              GROUP BY DONID ) DS_BD ON DS_BD.DONID = A.ID 

                    --------------------------Vụ việc----------------------------------------------------------------- 
                    LEFT JOIN DM_DATAITEM DMDON on DMDON.ID = A.QUANHEPHAPLUATID

                    --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------   
                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOQD,',') WITHIN GROUP (ORDER BY NGAYQD) AS SOQD,
                                      LISTAGG(TO_CHAR(NGAYQD,'DD/MM/YYYY'),',') WITHIN GROUP (ORDER BY NGAYQD) AS NGAYQD
                               FROM AHC_SOTHAM_QUYETDINH
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               GROUP BY DONID ) QDVAST ON QDVAST.DONID = A.ID

                    LEFT JOIN (SELECT DONID, SOBANAN, TO_CHAR(NGAYTUYENAN,'DD/MM/YYYY') NGAYTUYENAN FROM AHC_SOTHAM_BANAN) BANANST ON BANANST.DONID = A.ID 

                    --------------------------

                    --TEN TOA AN SO THAM 
                    LEFT JOIN DM_TOAAN TENTA ON A.TOAANID = TENTA.ID
                    --------------------------Kháng cáo/Kháng nghị-------------------------------------------------------
                    LEFT JOIN (SELECT NDBD.DONID,
                                      LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NGAYKHANGCAO) NOIDUNGKHANGCAO
                                FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO, NGAYKHANGCAO
                                        FROM (   
                                              SELECT F.DON_ND, NGAYKHANGCAO FROM (
                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND, NGAYKHANGCAO
                                                    from AHC_SOTHAM_KHANGCAO kc 
                                                    LEFT JOIN AHC_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA, NGAYKHANGCAO
                                                   )F
                                              GROUP BY F.DON_ND, NGAYKHANGCAO
                                          )FF
                                 )NDBD  GROUP BY NDBD.DONID
                                )NDBDS ON NDBDS.DONID=A.ID
                    LEFT JOIN (SELECT NDKN.DONID,
                                      LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NGAYKN)NOIDUNGKN
                               FROM (SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN, NGAYKN
                                     FROM AHC_SOTHAM_KHANGNGHI KC )NDKN  
                               GROUP BY NDKN.DONID
                              )NDKNS ON NDKNS.DONID=A.ID  
        )
        LOOP
              V_NGUYENDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         --LISTAGG(TENDUONGSU,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY ID ASC)
                                         TENDUONGSU TENNGUYENDON 
                                  FROM AHC_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'NGUYENDON' AND DONID = ITEM.DONID
                                  --GROUP BY DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_NGUYENDON := V_NGUYENDON || ITEM_DS.TENNGUYENDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;


                V_TABLE_EXPORT.EXTEND; 
                V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.VCHUTOA,ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                            'Hành chính',ITEM.SOKQXXPT,ITEM.NGAYKQXXPT,ITEM.THULYPT,
                                            V_NGUYENDON,ITEM.VBIDON,ITEM.QHPL,ITEM.SOBAQDST,ITEM.NGAYBAQDST,
                                            ITEM.VDIACHI,ITEM.VKCKN,ITEM.KETQUAXXPT,'16','17','18','19','20');
        END LOOP;

        RETURN V_TABLE_EXPORT;
END DON_SEARCH_ITEM_AHC;

FUNCTION DON_SEARCH_ITEM_AHS
(   
    V_DONID T_ID
)
RETURN T_DANHSACH_AHS_DAXU_PT
AS
    V_TABLE_EXPORT  T_DANHSACH_AHS_DAXU_PT;
    V_TABLE_ID      T_ID;

    V_CURSOR        sys_refcursor;

    V_KQXXPT        CLOB;
    V_KQXXST        CLOB;
    V_HOTEN         CLOB DEFAULT '';
    V_TENTOIDANH    CLOB DEFAULT '';
    V_SOBCKC        NUMBER DEFAULT 0;
BEGIN   

     V_TABLE_EXPORT := T_DANHSACH_AHS_DAXU_PT();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

        FOR ITEM IN(
            SELECT   A.ID VUANID,
                     NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA,
                     TENTHUKY.HOTENTHUKY VTHUKY, TENTPHDXX.HOTEN VTHANHVIEN,
                     TLPT.THULYPT THULYPT,
                     BC_KC.BCKC||', '||STKN.NOIDUNGKN KNKC,
                     TENTA.TEN VDIACHI,
                     DECODE(BAST.SOBANAN, NULL, QDVAST.SOQUYETDINH, BAST.SOBANAN)  SOBAQDST, DECODE(BAST.NGAYBANAN, NULL, QDVAST.NGAYQD, BAST.NGAYBANAN) NGAYBAQDST,
                     DECODE(TTBA.SOBANAN, NULL, QDVA.SOQUYETDINH, TTBA.SOBANAN)  SOKQXXPT, DECODE(TTBA.NGAYBANAN, NULL, QDVA.NGAYQD, TTBA.NGAYBANAN) NGAYKQXXPT,
                     QDVA.TEN KETQUAXXPT
            FROM AHS_VUAN A

                INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                --------------------------Chủ tọa-----------------------------------------------------------
                LEFT JOIN (SELECT * 
                           FROM (SELECT VUANID, DMCANBO.HOTEN,
                                        ROW_NUMBER() OVER (PARTITION BY D.VUANID ORDER BY D.NGAYPHANCONG DESC) AS  R
                                 FROM AHS_PHUCTHAM_HDXX D
                                     LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                                 WHERE D.MAVAITRO LIKE 'THAMPHAN')
                            WHERE R = 1) TENCHUTOA ON TENCHUTOA.VUANID = A.ID 

                LEFT JOIN (SELECT * 
                           FROM (SELECT VUANID, DMCANBO.HOTEN,
                                        ROW_NUMBER() OVER (PARTITION BY D.VUANID ORDER BY D.NGAYPHANCONG DESC) AS  R
                                 FROM AHS_THAMPHANGIAIQUYET D
                                     LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                                 WHERE D.MAVAITRO LIKE 'VTTP_GIAIQUYETPHUCTHAM')
                            WHERE R = 1) PCTP_GQ ON PCTP_GQ.VUANID = A.ID

                --------------------------Thành viên----------------------------------------------------------                  
                LEFT JOIN(SELECT VUANID,
                                 LISTAGG(DMCANBO.HOTEN,',<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTEN 
                          FROM AHS_PHUCTHAM_HDXX D
                              LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                          WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                          GROUP BY VUANID) TENTPHDXX ON TENTPHDXX.VUANID = A.ID  
                --------------------------Thư ký---------------------------------------------------------------
                LEFT JOIN(SELECT VUANID,
                                 LISTAGG(DMCANBO.HOTEN,',<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTENTHUKY 
                          FROM AHS_PHUCTHAM_HDXX D
                                LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                          WHERE D.MAVAITRO LIKE 'THUKY'
                          GROUP BY VUANID) TENTHUKY ON TENTHUKY.VUANID = A.ID

                --------------------------Bản án/Quyết định gây kết thúc Phúc thẩm-----------------------------
                ----------------------KẾT QUẢ PHÚC THẨM, SỐ BẢN ÁN NGÀY BẢN ÁN SỐ THỤ LÝ NGÀY THỤ LÝ, QHPL BA
                LEFT JOIN(SELECT VUANID, SOBANAN, NGAYBANAN
                          FROM AHS_PHUCTHAM_BANAN D
                          ) TTBA ON TTBA.VUANID = A.ID 

                LEFT JOIN (SELECT PTQD.VUANID, PTQD.SOQUYETDINH, PTQD.NGAYQD,  
                                     CASE WHEN (DMQD.TEN LIKE '%Quyết định đình chỉ%') THEN u'Q\0110 \0111\00ecnh ch\1ec9'
                                          WHEN (DMQD.TEN LIKE '%Quyết định giải quyết việc kháng cáo, kháng nghị đối với quyết định tạm đình chỉ%') THEN DMKQPT.TEN
                                          ELSE DECODE(instr(DMQD.TEN,'. '), 0, DMQD.TEN, SUBSTR(DMQD.TEN, instr(DMQD.TEN,'. ')+2))
                                     END AS TEN 
                           FROM AHS_PHUCTHAM_QUYETDINH_VUAN PTQD
                               inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISPHUCTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               LEFT JOIN (SELECT ID, TEN FROM DM_KETQUA_PHUCTHAM) DMKQPT ON DMKQPT.ID = PTQD.KETQUAID
                           ) QDVA ON QDVA.VUANID = A.ID

                --------------------------Số thụ lý---------------------------------------------------------------
                LEFT JOIN (SELECT TL.VUANID,
                                  LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULYPT
                           FROM AHS_PHUCTHAM_THULY TL 
                           GROUP BY TL.VUANID
                           )TLPT ON A.ID=TLPT.VUANID                
                --------------------------Họ và tên---------------------------------------------------------------
                --------------------------Số BC-------------------------------------------------------------------
                --------------------------Kháng cáo/Kháng nghị---------------------------------------------------- 
                LEFT JOIN( SELECT NDBD.VUANID,LISTAGG(NDBD.NOIDUNGKHANGCAO, ', ')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) BCKC
                               FROM (
                                        SELECT  TO_NUMBER(SUBSTR(FF.VUAN_ND,0,INSTR(FF.VUAN_ND,';')-1))VUANID,
                                                SUBSTR(FF.VUAN_ND,INSTR(FF.VUAN_ND,';')+1, LENGTH(FF.VUAN_ND))NOIDUNGKHANGCAO
                                        FROM (   
                                                        SELECT F.VUAN_ND FROM (
                                                             SELECT KC.VUANID||';'||count(*)||' '
                                                                    ||DECODE(KC.NGUOIKCLOAI,0,'BC',1,I.TEN)||' k/c'
                                                                     VUAN_ND 
                                                            FROM AHS_SOTHAM_KHANGCAO KC
                                                            LEFT JOIN AHS_NGUOITHAMGIATOTUNG TT ON KC.NGUOIKCID=TT.ID
                                                            LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID=TT.ID
                                                            LEFT JOIN DM_DataItem I ON I.ID=TC.TUCACHID
                                                            GROUP BY KC.VUANID,KC.NGUOIKCLOAI,I.TEN
                                                        )F
                                                        GROUP BY F.VUAN_ND
                                        )FF
                                     )NDBD  GROUP BY NDBD.VUANID )BC_KC ON BC_KC.VUANID=A.ID

                LEFT JOIN (SELECT NDKN.VUANID,LISTAGG(NDKN.NOIDUNGKN, ', ')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                                FROM (
                                        SELECT KC.VUANID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN
                                        FROM AHS_SOTHAM_KHANGNGHI KC
                                        LEFT JOIN AHS_SOTHAM_KHANGCAO_YEUCAU T5 ON T5.KHANGCAOID=KC.ID
                                 )NDKN  GROUP BY NDKN.VUANID)STKN ON STKN.VUANID=A.ID                               


                --------------------------Tội danh---------------------------------------------------------------- 
                --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------
                LEFT JOIN (SELECT * 
                           FROM (SELECT STQD.VUANID, STQD.SOQUYETDINH, STQD.NGAYQD,
                                        ROW_NUMBER() OVER (PARTITION BY STQD.VUANID ORDER BY STQD.NGAYQD DESC) AS  R
                                 FROM AHS_SOTHAM_QUYETDINH_VUAN STQD
                                    inner join dm_qd_quyetdinh dmqd on dmqd.id = QUYETDINHID AND dmqd.KET_THUC = 1 AND dmqd.ISPHUCTHAM = 1)
                           WHERE R = 1) QDVAST ON QDVAST.VUANID = A.ID

                LEFT JOIN(SELECT VUANID, SOBANAN, NGAYBANAN
                          FROM AHS_SOTHAM_BANAN D) BAST ON BAST.VUANID = A.ID            

                --------------------------Tòa án xét xử sơ thẩm---------------------------------------------------
                LEFT JOIN (SELECT ID, REPLACE(TEN,'Tòa án nhân dân t', 'T') TEN FROM DM_TOAAN) TENTA ON A.TOAANID = TENTA.ID
        )
        LOOP
            V_KQXXST := '';
            V_KQXXPT := '';
            V_HOTEN := '';
            V_TENTOIDANH := '';
            V_SOBCKC := 0;

            PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_RETURN_ALL_HINHPHAT_BICAN(ITEM.VUANID,V_CURSOR);
            LOOP 
            FETCH V_CURSOR 
                INTO      V_KQXXST,V_KQXXPT,V_HOTEN,V_TENTOIDANH,V_SOBCKC;
                EXIT WHEN V_CURSOR%NOTFOUND;
            END LOOP;    
            CLOSE V_CURSOR; 

            IF(V_KQXXPT IS NULL) THEN
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_AHS_DAXU_PT(ITEM.VCHUTOA,ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                                                                        ITEM.SOKQXXPT,ITEM.NGAYKQXXPT,ITEM.THULYPT,
                                                                                        V_HOTEN,TO_CHAR(V_SOBCKC),ITEM.KNKC,V_TENTOIDANH,V_KQXXST,
                                                                                        ITEM.SOBAQDST,ITEM.NGAYBAQDST,
                                                                                        ITEM.VDIACHI,ITEM.KETQUAXXPT);
                ELSE                  
                    V_TABLE_EXPORT.EXTEND; 
                    V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_AHS_DAXU_PT(ITEM.VCHUTOA,ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                                                                        ITEM.SOKQXXPT,ITEM.NGAYKQXXPT,ITEM.THULYPT,
                                                                                        V_HOTEN,TO_CHAR(V_SOBCKC),ITEM.KNKC,V_TENTOIDANH,V_KQXXST,
                                                                                        ITEM.SOBAQDST,ITEM.NGAYBAQDST,
                                                                                        ITEM.VDIACHI,V_KQXXPT);
                END IF;
        END LOOP;

   RETURN V_TABLE_EXPORT;

END DON_SEARCH_ITEM_AHS;

END PKG_STPT_DANHSACH_PT;

/
