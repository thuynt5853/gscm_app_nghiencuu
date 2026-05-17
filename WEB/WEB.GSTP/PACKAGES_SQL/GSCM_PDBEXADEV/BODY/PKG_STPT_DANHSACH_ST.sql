--------------------------------------------------------
--  DDL for Package Body PKG_STPT_DANHSACH_ST
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_DANHSACH_ST" AS

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
    V_TABLE_EXPORT_BAOCAO_HS   T_DANHSACH_AHS_DAXU_ST;

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

BEGIN   
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
        V_TABLE_EXPORT := T_TIMKIEM_BAOCAO_DANHSACHCHUNG();
        V_TABLE_EXPORT_BAOCAO := T_TYPE_OF_20_COLUMN_VARCHAR();
        V_TABLE_EXPORT_BAOCAO_HS := T_DANHSACH_AHS_DAXU_ST();

        V_TABLE_ID_ADS := T_ID();
        V_TABLE_ID_AHN := T_ID();
        V_TABLE_ID_AKT := T_ID();
        V_TABLE_ID_ALD := T_ID();
        V_TABLE_ID_AHC := T_ID();
        V_TABLE_ID_AHS := T_ID();

        IF(VV_TUNGAY IS NOT NULL) THEN
            IF(V_TUNGAY IS NOT NULL)  THEN  VV_TUNGAY  := TO_DATE(TRIM(V_TUNGAY) ||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  END IF;  
            IF(V_DENNGAY IS NOT NULL) THEN  VV_DENNGAY := TO_DATE(TRIM(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');  END IF;
        ELSE
            IF(V_NGAYTHULY_TU IS NOT NULL)  THEN  VV_TUNGAY  := TO_DATE(TRIM(V_NGAYTHULY_TU) ||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  END IF;  
            IF(V_NGAYTHULY_DEN IS NOT NULL) THEN  VV_DENNGAY := TO_DATE(TRIM(V_NGAYTHULY_DEN)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');  END IF;
        END IF;    

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
                             V_TUNGAY, V_DENNGAY, V_KETQUA, V_SO_QD, V_NGAY_QD, V_THAMPHAN_ID, V_VAITRO_THAMPHAN, V_THUKY_ID, V_THOIHAN_GQ, V_QD_TAMGIAM, V_UTTP,
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
                END IF;       
        END LOOP;


        IF(V_LOAIAN_ID ='1') THEN
                FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_ST.DON_SEARCH_ITEM_AHS(V_TABLE_ID_AHS) PA )
                LOOP
                    V_TABLE_EXPORT_BAOCAO_HS.EXTEND;   
                    V_TABLE_EXPORT_BAOCAO_HS(V_TABLE_EXPORT_BAOCAO_HS.count) := R_DANHSACH_AHS_DAXU_ST(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                      ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                      ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14);                                                                                             
                END LOOP;
            ELSE

                IF(INSTR(V_LOAIAN_ID,ADS) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_ST.DON_SEARCH_ITEM_ADS(V_TABLE_ID_ADS) PA )
                    LOOP
                        V_TABLE_EXPORT_BAOCAO.EXTEND; 
                        V_TABLE_EXPORT_BAOCAO(V_TABLE_EXPORT_BAOCAO.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                          ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                          ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14,ITEM.COLUMN_15,
                                                                                                          ITEM.COLUMN_16,ITEM.COLUMN_17,ITEM.COLUMN_18,ITEM.COLUMN_19,ITEM.COLUMN_20);                                                                                              
                    END LOOP; 
                END IF;

                IF(INSTR(V_LOAIAN_ID,AHN) > 0 OR V_LOAIAN_ID IS NULL) THEN                
                    FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_ST.DON_SEARCH_ITEM_AHN(V_TABLE_ID_AHN) PA )
                LOOP
                    V_TABLE_EXPORT_BAOCAO.EXTEND; 
                    V_TABLE_EXPORT_BAOCAO(V_TABLE_EXPORT_BAOCAO.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                      ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                      ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14,ITEM.COLUMN_15,
                                                                                                      ITEM.COLUMN_16,ITEM.COLUMN_17,ITEM.COLUMN_18,ITEM.COLUMN_19,ITEM.COLUMN_20); 
                END LOOP; 
                END IF;

                IF(INSTR(V_LOAIAN_ID,AKT) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_ST.DON_SEARCH_ITEM_AKT(V_TABLE_ID_AKT) PA )
                LOOP
                    V_TABLE_EXPORT_BAOCAO.EXTEND; 
                    V_TABLE_EXPORT_BAOCAO(V_TABLE_EXPORT_BAOCAO.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                      ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                      ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14,ITEM.COLUMN_15,
                                                                                                      ITEM.COLUMN_16,ITEM.COLUMN_17,ITEM.COLUMN_18,ITEM.COLUMN_19,ITEM.COLUMN_20); 
                END LOOP; 
                END IF;

                IF(INSTR(V_LOAIAN_ID,ALD) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_ST.DON_SEARCH_ITEM_ALD(V_TABLE_ID_ALD) PA )
                LOOP
                    V_TABLE_EXPORT_BAOCAO.EXTEND; 
                    V_TABLE_EXPORT_BAOCAO(V_TABLE_EXPORT_BAOCAO.count) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.COLUMN_1,ITEM.COLUMN_2,ITEM.COLUMN_3,ITEM.COLUMN_4,ITEM.COLUMN_5,
                                                                                                      ITEM.COLUMN_6,ITEM.COLUMN_7,ITEM.COLUMN_8,ITEM.COLUMN_9,ITEM.COLUMN_10,
                                                                                                      ITEM.COLUMN_11,ITEM.COLUMN_12,ITEM.COLUMN_13,ITEM.COLUMN_14,ITEM.COLUMN_15,
                                                                                                      ITEM.COLUMN_16,ITEM.COLUMN_17,ITEM.COLUMN_18,ITEM.COLUMN_19,ITEM.COLUMN_20); 
                END LOOP; 
                END IF;

                IF(INSTR(V_LOAIAN_ID,AHC) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (SELECT PA.* FROM PKG_STPT_DANHSACH_ST.DON_SEARCH_ITEM_AHC(V_TABLE_ID_AHC) PA )
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
                    <td colspan="13" style="text-align: center; vertical-align: top; font-size: 11pt;"><b>ÁN HÌNH SỰ '||V_TINHTRANGGIAQUYET||' TỪ NGÀY '||TO_CHAR(VV_TUNGAY,'dd/mm/rrrr')||' ĐẾN NGÀY '||TO_CHAR(VV_DENNGAY,'dd/mm/rrrr')||' </b></td>
                </tr>
                <tr style="height: 3px;">
                </tr>
                <tr align="center" style="text-align: center;">
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>STT</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Số/ngày thụ lý</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Họ và tên bị cáo</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Năm sinh</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Tội danh</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Thẩm phán</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Hội đồng</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Thư ký</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Số/Ngày BA/QD</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Kết quả XXST</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Kháng cáo/Kháng nghị</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Hình thức xét xử</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Ghi chú</b></td>
                </tr>');
        FOR item IN(SELECT ROW_NUMBER() OVER (ORDER BY PA.COLUMN_14) STT, PA.* 
                    FROM TABLE(V_TABLE_EXPORT_BAOCAO_HS) PA 
                    )
        LOOP
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;"> 
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.STT||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_2||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.COLUMN_3||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.COLUMN_4||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_5||'</td>                    
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_6||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_7||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_8||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_9||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_10||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_11||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_12||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_13||'</td>  
                </tr>');
        END LOOP;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr style="height: 0px;">
                <td style="width: 34px"></td>
                <td style="width: 93px"></td>
                <td style="width: 205px"></td>
                <td style="width: 81px"></td>
                <td style="width: 200px"></td>
                <td style="width: 132px"></td>
                <td style="width: 132px"></td>
                <td style="width: 132px"></td>
                <td style="width: 98PX"></td>
                <td style="width: 152px"></td>
                <td style="width: 149px"></td>
                <td style="width: 124px"></td> 
                <td style="width: 182px"></td> 
            </tr>
        </table>');
    ELSE
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
        <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">
            <tr align="center" style="text-align: center;">
                <td colspan="13" style="text-align: center; vertical-align: top; font-size: 11pt;"><b>ÁN '||TEN_LOAI_AN_DA_XU||' '||V_TINHTRANGGIAQUYET||' TỪ NGÀY '||TO_CHAR(VV_TUNGAY,'dd/mm/rrrr')||' ĐẾN NGÀY '||TO_CHAR(VV_DENNGAY,'dd/mm/rrrr')||' </b></td>
            </tr>
            <tr style="height: 3px;">
            </tr>
            <tr align="center" style="text-align: center;"> 
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>STT</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Loại án</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Số/ngày thụ lý</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Nguyên đơn/NKK</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Bị đơn/NBK</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Quan hệ pháp luật</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Thẩm phán</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Hội đồng</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Thư ký</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Số/Ngày BA/QD</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Kháng cáo/Kháng nghị</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Hình thức xét xử</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Ghi chú</b></td>
            </tr>');
    FOR item IN(SELECT ROW_NUMBER() OVER (ORDER BY TO_DATE(PA.COLUMN_14,'DD/MM/YYYY')) STT, PA.* 
                FROM TABLE(V_TABLE_EXPORT_BAOCAO) PA
               )
    LOOP



        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;">                     
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.STT||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_2||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_3||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.COLUMN_4||'</td>
                    <td colspan="1" style="text-align: left; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black; mso-number-format:\@;">'||ITEM.COLUMN_5||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_6||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_7||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_8||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_9||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_10||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_11||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_12||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.COLUMN_13||'</td>
                </tr>');
    END LOOP;
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr style="height: 0px;">
                    <td style="width: 45px"></td>
                    <td style="width: 73px"></td
                    <td style="width: 109px"></td>
                    <td style="width: 168px"></td>
                    <td style="width: 168px"></td>
                    <td style="width: 171px"></td>
                    <td style="width: 161px"></td>
                    <td style="width: 161px"></td>
                    <td style="width: 161px"></td>
                    <td style="width: 125px"></td>
                    <td style="width: 176px"></td>
                    <td style="width: 125px"></td>
                    <td style="width: 189px"></td>
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
    V_NOIDUNGKHANGNGHI CLOB DEFAULT '';     
    V_NGUYENDON CLOB DEFAULT '';       
    V_BIDON CLOB DEFAULT '';
BEGIN

     V_TABLE_EXPORT := T_TYPE_OF_20_COLUMN_VARCHAR();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

     FOR ITEM IN (SELECT ROW_NUMBER() OVER (ORDER BY A.ID) STT, A.ID AS DONID,
                         TL.THULY THULY,
                         NVL(BANANST.QHPL,NVL(TL.QHPL,NVL(A.QUANHEPHAPLUAT_NAME,DMDON.TEN))) AS QHPL,
                         NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA,
                         TENTHUKY.HOTENTHUKY VTHUKY,
                         TENTPHDXX.HOTEN VTHANHVIEN,
                         DECODE(BANANST.SONGAYBANAN, NULL, QDVAST.SONGAYQD,BANANST.SONGAYBANAN) SONGAYBAQD,
                         HTXX.HTXX,
                         GHICHU.GHICHU,
                         TL.NGAYTHULY

              FROM ADS_DON A
                    INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                    --------------------------Số thụ lý---------------------------------------------------------
                    LEFT JOIN (SELECT TL.DONID,
                                      LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULY,
                                      LISTAGG(NVL(TL.QUANHEPHAPLUAT_NAME, DMPTTL.TEN),',') WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS QHPL,
                                      TL.NGAYTHULY
                               FROM ADS_SOTHAM_THULY TL 
                                   left join DM_DATAITEM DMPTTL on TL.QUANHEPHAPLUATID=DMPTTL.ID
                               GROUP BY TL.DONID, TL.NGAYTHULY
                               )TL ON A.ID=TL.DONID 

                    --------------------------Nguyên đơn--------------------------------------------------------
                    --------------------------Bị đơn------------------------------------------------------------

                    --------------------------QHPL--------------------------------------------------------------
                    LEFT JOIN DM_DATAITEM DMDON on DMDON.ID = A.QUANHEPHAPLUATID                              

                    --------------------------Chủ tọa-----------------------------------------------------------
                    LEFT JOIN (SELECT D.DONID, 
                                      LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) AS HOTEN  
                               FROM ADS_SOTHAM_HDXX D
                                   LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                               WHERE D.MAVAITRO LIKE 'THAMPHAN'
                               GROUP BY D.DONID) TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                    LEFT JOIN (SELECT GG.DONID,
                                      LISTAGG(NNPC.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY GG.NGAYNHANPHANCONG, GG.NGAYTAO) AS HOTEN
                               FROM ADS_DON_THAMPHAN GG
                                   LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                               WHERE GG.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GG.NGAYPHANCONG IS NOT NULL AND GG.NGAYNHANPHANCONG IS NOT NULL AND GG.NGUOIPHANCONGID IS NOT NULL
                               GROUP BY GG.DONID )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                    --------------------------Thành viên---------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTEN 
                              FROM ADS_SOTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                              GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                     

                    --------------------------Thư ký-------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTENTHUKY 
                              FROM ADS_SOTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THUKY'
                              GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID

                    --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------   
                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOQD || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYQD,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYQD) AS SONGAYQD
                               FROM ADS_SOTHAM_QUYETDINH
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               GROUP BY DONID ) QDVAST ON QDVAST.DONID = A.ID

                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOBANAN || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYTUYENAN,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYTUYENAN) AS SONGAYBANAN,
                                      NVL(QUANHEPHAPLUAT_NAME, DMPTBA.TEN) AS QHPL
                               FROM ADS_SOTHAM_BANAN D
                                   LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) DMPTBA on D.QUANHEPHAPLUATID = DMPTBA.ID
                               GROUP BY DONID, QUANHEPHAPLUAT_NAME, DMPTBA.TEN
                               ) BANANST ON BANANST.DONID = A.ID                               

                    --------------------------Kháng cáo/Kháng nghị-------------------------------------------------------                           

                    --------------------------Hình thức xét xử-------------------------------------------------------
                    LEFT JOIN ( SELECT * 
                                FROM (SELECT QD.DONID, 
                                              CASE WHEN QD.HINHTHUCXETXU = 1 THEN 'Xử/Họp kín trực tuyến'
                                                   WHEN QD.HINHTHUCXETXU = 2 THEN 'Xử/Họp kín trực tiếp'
                                                   WHEN QD.HINHTHUCXETXU = 3 THEN 'Xử/Họp công khai trực tuyến'
                                                   WHEN QD.HINHTHUCXETXU = 4 THEN 'Xử/Họp công khai trực tiếp'
                                              END AS HTXX,
                                              ROW_NUMBER() OVER (PARTITION BY QD.DONID ORDER BY QD.NGAYQD DESC) AS  R
                                      FROM ADS_SOTHAM_QUYETDINH QD
                                          INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.LOAIID = 5
                                  )
                                  WHERE R = 1) HTXX ON HTXX.DONID = A.ID

                    --------------------------Ghi chú----------------------------------------------------------------                              
                    LEFT JOIN (SELECT QD.DONID, 
                                      LISTAGG('- QĐ ' || DMQD.MAHIENTHI || ' : số ' || QD.SOQD || ' ngày ' || TO_CHAR(QD.NGAYQD,'DD/MM/YYYY'), '<br style="mso-data-placement:same-cell;" />' ) WITHIN GROUP (ORDER BY QD.NGAYQD) GHICHU
                               FROM ADS_SOTHAM_QUYETDINH QD
                                   INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID
                                   INNER JOIN DM_QD_LOAI DMQDL ON DMQDL.ID = DMQD.LOAIID AND DMQDL.MA IN ('TDC','HPT')
                               GROUP BY QD.DONID) GHICHU ON GHICHU.DONID = A.ID
        )
        LOOP

              V_NGUYENDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         TENDUONGSU TENNGUYENDON 
                                  FROM ADS_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'NGUYENDON' AND DONID = ITEM.DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_NGUYENDON := V_NGUYENDON || '- ' || ITEM_DS.TENNGUYENDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

              V_BIDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         TENDUONGSU TENBIDON 
                                  FROM ADS_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'BIDON' AND DONID = ITEM.DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_BIDON := V_BIDON || '- ' || ITEM_DS.TENBIDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

            V_NOIDUNGKHANGNGHI := '';
            FOR ITEM_KNKC IN (SELECT KC.DONID,
                                     DS.HOTEN || NTGTT.HOTEN AS KNKC
                              FROM ADS_SOTHAM_KHANGCAO KC
                                  LEFT JOIN (SELECT ID, DONID, 
                                                    CASE WHEN NVL(LENGTH(DS.TENDUONGSU),0) > 0 THEN '- ' || DS.TENDUONGSU || DECODE(TUCACHTOTUNG_MA, 'BIDON' , ' - Bị đơn', 'QUYENNVLQ' , ' - NLQ', 'NGUYENDON', ' - NĐ', '')
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM ADS_DON_DUONGSU DS) DS ON DS.ID = KC.DUONGSUID AND KC.DONID = DS.DONID
                                  LEFT JOIN (SELECT TGTT.ID, DONID,
                                                    CASE WHEN NVL(LENGTH(TGTT.HOTEN),0) > 0 THEN '- ' || TGTT.HOTEN || ' - ' || DM.TEN
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM ADS_DON_THAMGIATOTUNG TGTT
                                                LEFT JOIN DM_DATAITEM DM ON DM.MA = TGTT.TUCACHTGTTID) NTGTT ON NTGTT.ID = KC.DUONGSUID AND KC.DONID = NTGTT.DONID
                              WHERE KC.DONID = ITEM.DONID

                              UNION

                              SELECT KN.DONID,
                                     CASE WHEN KN.DONVIKN = 0 AND KN.CAPKN = 0 THEN '- Chánh án ' || DMTA.TEN || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 0 THEN '- Viện trưởng ' || REPLACE(DMTA.TEN,'Tòa án','VKS') || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 1 THEN '- Viện trưởng ' || REPLACE(DMTACAPTREN.TEN,'Tòa án','VKS') || ' kháng nghị '
                                     END AS KNKC
                              FROM ADS_SOTHAM_KHANGNGHI KN
                                  LEFT JOIN DM_TOAAN DMTA ON DMTA.ID = KN.TOAAN_VKS_KN
                                  LEFT JOIN DM_TOAAN DMTACAPTREN ON DMTACAPTREN.ID = DMTA.CAPCHAID
                              WHERE KN.DONID = ITEM.DONID)
            LOOP
                V_NOIDUNGKHANGNGHI := V_NOIDUNGKHANGNGHI || ITEM_KNKC.KNKC || '<br style="mso-data-placement:same-cell;" />';
            END LOOP;

                V_TABLE_EXPORT.EXTEND;
                V_TABLE_EXPORT(V_TABLE_EXPORT.COUNT) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.STT, 'Dân sự', ITEM.THULY,
                                                                                    V_NGUYENDON, V_BIDON, ITEM.QHPL,
                                                                                    ITEM.VCHUTOA, ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                                                                    ITEM.SONGAYBAQD, V_NOIDUNGKHANGNGHI,-- ITEM.VKCKN,
                                                                                    ITEM.HTXX,
                                                                                    ITEM.GHICHU, ITEM.NGAYTHULY,'15','16','17','18','19','20');
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
    V_NOIDUNGKHANGNGHI CLOB DEFAULT '';     
    V_NGUYENDON CLOB DEFAULT '';       
    V_BIDON CLOB DEFAULT '';
BEGIN

     V_TABLE_EXPORT := T_TYPE_OF_20_COLUMN_VARCHAR();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

     FOR ITEM IN (SELECT ROW_NUMBER() OVER (ORDER BY A.ID) STT, A.ID AS DONID,
                         TL.THULY THULY,
                         NVL(BANANST.QHPL,NVL(TL.QHPL,NVL(A.QUANHEPHAPLUAT_NAME,DMDON.TEN))) AS QHPL,
                         NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA,
                         TENTHUKY.HOTENTHUKY VTHUKY,
                         TENTPHDXX.HOTEN VTHANHVIEN,
                         DECODE(BANANST.SONGAYBANAN, NULL, QDVAST.SONGAYQD,BANANST.SONGAYBANAN) SONGAYBAQD,
                         HTXX.HTXX,
                         GHICHU.GHICHU,
                         TL.NGAYTHULY

              FROM AHN_DON A
                    INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                    --------------------------Số thụ lý---------------------------------------------------------
                    LEFT JOIN (SELECT TL.DONID,
                                      LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULY,
                                      LISTAGG(NVL(TL.QUANHEPHAPLUAT_NAME, DMPTTL.TEN),',') WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS QHPL,
                                      TL.NGAYTHULY
                               FROM AHN_SOTHAM_THULY TL 
                                   left join DM_DATAITEM DMPTTL on TL.QUANHEPHAPLUATID=DMPTTL.ID
                               GROUP BY TL.DONID, TL.NGAYTHULY
                               )TL ON A.ID=TL.DONID 

                    --------------------------Nguyên đơn--------------------------------------------------------
                    --------------------------Bị đơn------------------------------------------------------------

                    --------------------------QHPL--------------------------------------------------------------
                    LEFT JOIN DM_DATAITEM DMDON on DMDON.ID = A.QUANHEPHAPLUATID                              

                    --------------------------Chủ tọa-----------------------------------------------------------
                    LEFT JOIN (SELECT D.DONID, 
                                      LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) AS HOTEN  
                               FROM AHN_SOTHAM_HDXX D
                                   LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                               WHERE D.MAVAITRO LIKE 'THAMPHAN'
                               GROUP BY D.DONID) TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                    LEFT JOIN (SELECT GG.DONID,
                                      LISTAGG(NNPC.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY GG.NGAYNHANPHANCONG, GG.NGAYTAO) AS HOTEN
                               FROM AHN_DON_THAMPHAN GG
                                   LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                               WHERE GG.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GG.NGAYPHANCONG IS NOT NULL AND GG.NGAYNHANPHANCONG IS NOT NULL AND GG.NGUOIPHANCONGID IS NOT NULL
                               GROUP BY GG.DONID )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                    --------------------------Thành viên---------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTEN 
                              FROM AHN_SOTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                              GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                     

                    --------------------------Thư ký-------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTENTHUKY 
                              FROM AHN_SOTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THUKY'
                              GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID

                    --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------   
                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOQD || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYQD,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYQD) AS SONGAYQD
                               FROM AHN_SOTHAM_QUYETDINH
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               GROUP BY DONID ) QDVAST ON QDVAST.DONID = A.ID

                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOBANAN || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYTUYENAN,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYTUYENAN) AS SONGAYBANAN,
                                      NVL(QUANHEPHAPLUAT_NAME, DMPTBA.TEN) AS QHPL
                               FROM AHN_SOTHAM_BANAN D
                                   LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) DMPTBA on D.QUANHEPHAPLUATID = DMPTBA.ID
                               GROUP BY DONID, QUANHEPHAPLUAT_NAME, DMPTBA.TEN
                               ) BANANST ON BANANST.DONID = A.ID                               

                    --------------------------Kháng cáo/Kháng nghị-------------------------------------------------------                      

                    --------------------------Hình thức xét xử-------------------------------------------------------
                    LEFT JOIN ( SELECT * 
                                FROM (SELECT QD.DONID, 
                                              CASE WHEN QD.HINHTHUCXETXU = 1 THEN 'Xử/Họp kín trực tuyến'
                                                   WHEN QD.HINHTHUCXETXU = 2 THEN 'Xử/Họp kín trực tiếp'
                                                   WHEN QD.HINHTHUCXETXU = 3 THEN 'Xử/Họp công khai trực tuyến'
                                                   WHEN QD.HINHTHUCXETXU = 4 THEN 'Xử/Họp công khai trực tiếp'
                                              END AS HTXX,
                                              ROW_NUMBER() OVER (PARTITION BY QD.DONID ORDER BY QD.NGAYQD DESC) AS  R
                                      FROM AHN_SOTHAM_QUYETDINH QD
                                          INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.LOAIID = 5
                                  )
                                  WHERE R = 1) HTXX ON HTXX.DONID = A.ID

                    --------------------------Ghi chú----------------------------------------------------------------                              
                    LEFT JOIN (SELECT QD.DONID, 
                                      LISTAGG('- QĐ ' || DMQD.MAHIENTHI || ' : số ' || QD.SOQD || ' ngày ' || TO_CHAR(QD.NGAYQD,'DD/MM/YYYY'), '<br style="mso-data-placement:same-cell;" />' ) WITHIN GROUP (ORDER BY QD.NGAYQD) GHICHU
                               FROM AHN_SOTHAM_QUYETDINH QD
                                   INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID
                                   INNER JOIN DM_QD_LOAI DMQDL ON DMQDL.ID = DMQD.LOAIID AND DMQDL.MA IN ('TDC','HPT')
                               GROUP BY QD.DONID) GHICHU ON GHICHU.DONID = A.ID
        )
        LOOP

              V_NGUYENDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         TENDUONGSU TENNGUYENDON 
                                  FROM AHN_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'NGUYENDON' AND DONID = ITEM.DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_NGUYENDON := V_NGUYENDON || '- ' || ITEM_DS.TENNGUYENDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

              V_BIDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         TENDUONGSU TENBIDON 
                                  FROM AHN_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'BIDON' AND DONID = ITEM.DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_BIDON := V_BIDON || '- ' || ITEM_DS.TENBIDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

            V_NOIDUNGKHANGNGHI := '';
            FOR ITEM_KNKC IN (SELECT KC.DONID,
                                     DS.HOTEN || NTGTT.HOTEN AS KNKC
                              FROM AHN_SOTHAM_KHANGCAO KC
                                  LEFT JOIN (SELECT ID, DONID, 
                                                    CASE WHEN NVL(LENGTH(DS.TENDUONGSU),0) > 0 THEN '- ' || DS.TENDUONGSU || DECODE(TUCACHTOTUNG_MA, 'BIDON' , ' - Bị đơn', 'QUYENNVLQ' , ' - NLQ', 'NGUYENDON', ' - NĐ', '')
                                                    ELSE u'' 
                                                         END AS HOTEN
                                             FROM AHN_DON_DUONGSU DS) DS ON DS.ID = KC.DUONGSUID AND KC.DONID = DS.DONID
                                  LEFT JOIN (SELECT TGTT.ID, DONID,
                                                    CASE WHEN NVL(LENGTH(TGTT.HOTEN),0) > 0 THEN '- ' || TGTT.HOTEN || ' - ' || DM.TEN
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM AHN_DON_THAMGIATOTUNG TGTT
                                                LEFT JOIN DM_DATAITEM DM ON DM.MA = TGTT.TUCACHTGTTID) NTGTT ON NTGTT.ID = KC.DUONGSUID AND KC.DONID = NTGTT.DONID
                              WHERE KC.DONID = ITEM.DONID

                              UNION

                              SELECT KN.DONID,
                                     CASE WHEN KN.DONVIKN = 0 AND KN.CAPKN = 0 THEN '- Chánh án ' || DMTA.TEN || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 0 THEN '- Viện trưởng ' || REPLACE(DMTA.TEN,'Tòa án','VKS') || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 1 THEN '- Viện trưởng ' || REPLACE(DMTACAPTREN.TEN,'Tòa án','VKS') || ' kháng nghị '
                                     END AS KNKC
                              FROM AHN_SOTHAM_KHANGNGHI KN
                                  LEFT JOIN DM_TOAAN DMTA ON DMTA.ID = KN.TOAAN_VKS_KN
                                  LEFT JOIN DM_TOAAN DMTACAPTREN ON DMTACAPTREN.ID = DMTA.CAPCHAID
                              WHERE KN.DONID = ITEM.DONID)
            LOOP
                V_NOIDUNGKHANGNGHI := V_NOIDUNGKHANGNGHI || ITEM_KNKC.KNKC || '<br style="mso-data-placement:same-cell;" />';
            END LOOP;

                V_TABLE_EXPORT.EXTEND;
                V_TABLE_EXPORT(V_TABLE_EXPORT.COUNT) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.STT, 'HNGD', ITEM.THULY,
                                                                                    V_NGUYENDON, V_BIDON, ITEM.QHPL,
                                                                                    ITEM.VCHUTOA, ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                                                                    ITEM.SONGAYBAQD, V_NOIDUNGKHANGNGHI,-- ITEM.VKCKN,
                                                                                    ITEM.HTXX,
                                                                                    ITEM.GHICHU, ITEM.NGAYTHULY,'15','16','17','18','19','20');
        END LOOP;

        RETURN V_TABLE_EXPORT;
END DON_SEARCH_ITEM_AHN;

FUNCTION DON_SEARCH_ITEM_AKT
(   
    V_DONID T_ID
)
RETURN T_TYPE_OF_20_COLUMN_VARCHAR
IS 
    V_TABLE_EXPORT  T_TYPE_OF_20_COLUMN_VARCHAR;
    V_TABLE_ID T_ID;
    V_NOIDUNGKHANGNGHI CLOB DEFAULT '';     
    V_NGUYENDON CLOB DEFAULT '';       
    V_BIDON CLOB DEFAULT '';
BEGIN

     V_TABLE_EXPORT := T_TYPE_OF_20_COLUMN_VARCHAR();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

     FOR ITEM IN (SELECT ROW_NUMBER() OVER (ORDER BY A.ID) STT, A.ID AS DONID,
                         TL.THULY THULY,
                         NVL(BANANST.QHPL,NVL(TL.QHPL,NVL(A.QUANHEPHAPLUAT_NAME,DMDON.TEN))) AS QHPL,
                         NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA,
                         TENTHUKY.HOTENTHUKY VTHUKY,
                         TENTPHDXX.HOTEN VTHANHVIEN,
                         DECODE(BANANST.SONGAYBANAN, NULL, QDVAST.SONGAYQD,BANANST.SONGAYBANAN) SONGAYBAQD,
                         HTXX.HTXX,
                         GHICHU.GHICHU,
                         TL.NGAYTHULY

              FROM AKT_DON A
                    INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                    --------------------------Số thụ lý------------------------------------------------------------
                    LEFT JOIN (SELECT TL.DONID,
                                      LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULY,
                                      LISTAGG(NVL(TL.QUANHEPHAPLUAT_NAME, DMPTTL.TEN),',') WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS QHPL,
                                      TL.NGAYTHULY
                               FROM AKT_SOTHAM_THULY TL 
                                   left join DM_DATAITEM DMPTTL on TL.QUANHEPHAPLUATID=DMPTTL.ID
                               GROUP BY TL.DONID, TL.NGAYTHULY
                               )TL ON A.ID=TL.DONID 

                    --------------------------Nguyên đơn------------------------------------------------------------
                    --------------------------Bị đơn-----------------------------------------------------------------

                    --------------------------QHPL--------------------------------------------------------------
                    LEFT JOIN DM_DATAITEM DMDON on DMDON.ID = A.QUANHEPHAPLUATID                              

                    --------------------------Chủ tọa-----------------------------------------------------------
                    LEFT JOIN (SELECT D.DONID, 
                                      LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) AS HOTEN  
                               FROM AKT_SOTHAM_HDXX D
                                   LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                               WHERE D.MAVAITRO LIKE 'THAMPHAN'
                               GROUP BY D.DONID) TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                    LEFT JOIN (SELECT GG.DONID,
                                      LISTAGG(NNPC.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY GG.NGAYNHANPHANCONG, GG.NGAYTAO) AS HOTEN
                               FROM AKT_DON_THAMPHAN GG
                                   LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                               WHERE GG.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GG.NGAYPHANCONG IS NOT NULL AND GG.NGAYNHANPHANCONG IS NOT NULL AND GG.NGUOIPHANCONGID IS NOT NULL
                               GROUP BY GG.DONID )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                    --------------------------Thành viên---------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTEN 
                              FROM AKT_SOTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                              GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                     

                    --------------------------Thư ký-------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTENTHUKY 
                              FROM AKT_SOTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THUKY'
                              GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID

                    --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------   
                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOQD || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYQD,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYQD) AS SONGAYQD
                               FROM AKT_SOTHAM_QUYETDINH
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               GROUP BY DONID ) QDVAST ON QDVAST.DONID = A.ID

                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOBANAN || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYTUYENAN,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYTUYENAN) AS SONGAYBANAN,
                                      NVL(QUANHEPHAPLUAT_NAME, DMPTBA.TEN) AS QHPL
                               FROM AKT_SOTHAM_BANAN D
                                   LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) DMPTBA on D.QUANHEPHAPLUATID = DMPTBA.ID
                               GROUP BY DONID, QUANHEPHAPLUAT_NAME, DMPTBA.TEN
                               ) BANANST ON BANANST.DONID = A.ID                               

                    --------------------------Kháng cáo/Kháng nghị-------------------------------------------------------                             

                    --------------------------Hình thức xét xử-------------------------------------------------------
                    LEFT JOIN ( SELECT * 
                                FROM (SELECT QD.DONID, 
                                              CASE WHEN QD.HINHTHUCXETXU = 1 THEN 'Xử/Họp kín trực tuyến'
                                                   WHEN QD.HINHTHUCXETXU = 2 THEN 'Xử/Họp kín trực tiếp'
                                                   WHEN QD.HINHTHUCXETXU = 3 THEN 'Xử/Họp công khai trực tuyến'
                                                   WHEN QD.HINHTHUCXETXU = 4 THEN 'Xử/Họp công khai trực tiếp'
                                              END AS HTXX,
                                              ROW_NUMBER() OVER (PARTITION BY QD.DONID ORDER BY QD.NGAYQD DESC) AS  R
                                      FROM AKT_SOTHAM_QUYETDINH QD
                                          INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.LOAIID = 5
                                  )
                                  WHERE R = 1) HTXX ON HTXX.DONID = A.ID

                    --------------------------Ghi chú----------------------------------------------------------------                              
                    LEFT JOIN (SELECT QD.DONID, 
                                      LISTAGG('- QĐ ' || DMQD.MAHIENTHI || ' : số ' || QD.SOQD || ' ngày ' || TO_CHAR(QD.NGAYQD,'DD/MM/YYYY'), '<br style="mso-data-placement:same-cell;" />' ) WITHIN GROUP (ORDER BY QD.NGAYQD) GHICHU
                               FROM AKT_SOTHAM_QUYETDINH QD
                                   INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID
                                   INNER JOIN DM_QD_LOAI DMQDL ON DMQDL.ID = DMQD.LOAIID AND DMQDL.MA IN ('TDC','HPT')
                               GROUP BY QD.DONID) GHICHU ON GHICHU.DONID = A.ID
        )
        LOOP

              V_NGUYENDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         TENDUONGSU TENNGUYENDON 
                                  FROM AKT_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'NGUYENDON' AND DONID = ITEM.DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_NGUYENDON := V_NGUYENDON || '- ' || ITEM_DS.TENNGUYENDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

              V_BIDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         TENDUONGSU TENBIDON 
                                  FROM AKT_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'BIDON' AND DONID = ITEM.DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_BIDON := V_BIDON || '- ' || ITEM_DS.TENBIDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

            V_NOIDUNGKHANGNGHI := '';
            FOR ITEM_KNKC IN (SELECT KC.DONID,
                                     DS.HOTEN || NTGTT.HOTEN AS KNKC
                              FROM AKT_SOTHAM_KHANGCAO KC
                                  LEFT JOIN (SELECT ID, DONID, 
                                                    CASE WHEN NVL(LENGTH(DS.TENDUONGSU),0) > 0 THEN '- ' || DS.TENDUONGSU || DECODE(TUCACHTOTUNG_MA, 'BIDON' , ' - Bị đơn', 'QUYENNVLQ' , ' - NLQ', 'NGUYENDON', ' - NĐ', '')
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM AKT_DON_DUONGSU DS) DS ON DS.ID = KC.DUONGSUID AND KC.DONID = DS.DONID
                                  LEFT JOIN (SELECT TGTT.ID, DONID,
                                                    CASE WHEN NVL(LENGTH(TGTT.HOTEN),0) > 0 THEN '- ' || TGTT.HOTEN || ' - ' || DM.TEN
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM AKT_DON_THAMGIATOTUNG TGTT
                                                LEFT JOIN DM_DATAITEM DM ON DM.MA = TGTT.TUCACHTGTTID) NTGTT ON NTGTT.ID = KC.DUONGSUID AND KC.DONID = NTGTT.DONID
                              WHERE KC.DONID = ITEM.DONID

                              UNION

                              SELECT KN.DONID,
                                     CASE WHEN KN.DONVIKN = 0 AND KN.CAPKN = 0 THEN '- Chánh án ' || DMTA.TEN || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 0 THEN '- Viện trưởng ' || REPLACE(DMTA.TEN,'Tòa án','VKS') || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 1 THEN '- Viện trưởng ' || REPLACE(DMTACAPTREN.TEN,'Tòa án','VKS') || ' kháng nghị '
                                     END AS KNKC
                              FROM AKT_SOTHAM_KHANGNGHI KN
                                  LEFT JOIN DM_TOAAN DMTA ON DMTA.ID = KN.TOAAN_VKS_KN
                                  LEFT JOIN DM_TOAAN DMTACAPTREN ON DMTACAPTREN.ID = DMTA.CAPCHAID
                              WHERE KN.DONID = ITEM.DONID)
            LOOP
                V_NOIDUNGKHANGNGHI := V_NOIDUNGKHANGNGHI || ITEM_KNKC.KNKC || '<br style="mso-data-placement:same-cell;" />';
            END LOOP;

                V_TABLE_EXPORT.EXTEND;
                V_TABLE_EXPORT(V_TABLE_EXPORT.COUNT) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.STT, 'KDTM', ITEM.THULY,
                                                                                    V_NGUYENDON, V_BIDON, ITEM.QHPL,
                                                                                    ITEM.VCHUTOA, ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                                                                    ITEM.SONGAYBAQD, V_NOIDUNGKHANGNGHI,-- ITEM.VKCKN,
                                                                                    ITEM.HTXX,
                                                                                    ITEM.GHICHU, ITEM.NGAYTHULY,'15','16','17','18','19','20');
        END LOOP;

        RETURN V_TABLE_EXPORT;
END DON_SEARCH_ITEM_AKT;

FUNCTION DON_SEARCH_ITEM_ALD
(   
    V_DONID T_ID
)
RETURN T_TYPE_OF_20_COLUMN_VARCHAR
IS 
    V_TABLE_EXPORT  T_TYPE_OF_20_COLUMN_VARCHAR;
    V_TABLE_ID T_ID;
    V_NOIDUNGKHANGNGHI CLOB DEFAULT '';     
    V_NGUYENDON CLOB DEFAULT '';       
    V_BIDON CLOB DEFAULT '';
BEGIN

     V_TABLE_EXPORT := T_TYPE_OF_20_COLUMN_VARCHAR();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

     FOR ITEM IN (SELECT ROW_NUMBER() OVER (ORDER BY A.ID) STT, A.ID AS DONID,
                         TL.THULY THULY,
                         NVL(BANANST.QHPL,NVL(TL.QHPL,NVL(A.QUANHEPHAPLUAT_NAME,DMDON.TEN))) AS QHPL,
                         NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA,
                         TENTHUKY.HOTENTHUKY VTHUKY,
                         TENTPHDXX.HOTEN VTHANHVIEN,
                         DECODE(BANANST.SONGAYBANAN, NULL, QDVAST.SONGAYQD,BANANST.SONGAYBANAN) SONGAYBAQD,
                         HTXX.HTXX,
                         GHICHU.GHICHU,
                         TL.NGAYTHULY

              FROM ALD_DON A
                    INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                    --------------------------Số thụ lý------------------------------------------------------------
                    LEFT JOIN (SELECT TL.DONID,
                                      LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULY,
                                      LISTAGG(NVL(TL.QUANHEPHAPLUAT_NAME, DMPTTL.TEN),',') WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS QHPL,
                                      TL.NGAYTHULY
                               FROM ALD_SOTHAM_THULY TL 
                                   left join DM_DATAITEM DMPTTL on TL.QUANHEPHAPLUATID=DMPTTL.ID
                               GROUP BY TL.DONID, TL.NGAYTHULY
                               )TL ON A.ID=TL.DONID 

                    --------------------------Nguyên đơn--------------------------------------------------------
                    --------------------------Bị đơn------------------------------------------------------------

                    --------------------------QHPL--------------------------------------------------------------
                    LEFT JOIN DM_DATAITEM DMDON on DMDON.ID = A.QUANHEPHAPLUATID                              

                    --------------------------Chủ tọa-----------------------------------------------------------
                    LEFT JOIN (SELECT D.DONID, 
                                      LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) AS HOTEN  
                               FROM ALD_SOTHAM_HDXX D
                                   LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                               WHERE D.MAVAITRO LIKE 'THAMPHAN'
                               GROUP BY D.DONID) TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                    LEFT JOIN (SELECT GG.DONID,
                                      LISTAGG(NNPC.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY GG.NGAYNHANPHANCONG, GG.NGAYTAO) AS HOTEN
                               FROM ALD_DON_THAMPHAN GG
                                   LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                               WHERE GG.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GG.NGAYPHANCONG IS NOT NULL AND GG.NGAYNHANPHANCONG IS NOT NULL AND GG.NGUOIPHANCONGID IS NOT NULL
                               GROUP BY GG.DONID )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                    --------------------------Thành viên---------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTEN 
                              FROM ALD_SOTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                              GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                     

                    --------------------------Thư ký-------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTENTHUKY 
                              FROM ALD_SOTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THUKY'
                              GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID

                    --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------   
                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOQD || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYQD,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYQD) AS SONGAYQD
                               FROM ALD_SOTHAM_QUYETDINH
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               GROUP BY DONID ) QDVAST ON QDVAST.DONID = A.ID

                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOBANAN || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYTUYENAN,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYTUYENAN) AS SONGAYBANAN,
                                      NVL(QUANHEPHAPLUAT_NAME, DMPTBA.TEN) AS QHPL
                               FROM ALD_SOTHAM_BANAN D
                                   LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) DMPTBA on D.QUANHEPHAPLUATID = DMPTBA.ID
                               GROUP BY DONID, QUANHEPHAPLUAT_NAME, DMPTBA.TEN
                               ) BANANST ON BANANST.DONID = A.ID                               

                    --------------------------Kháng cáo/Kháng nghị-------------------------------------------------------                             

                    --------------------------Hình thức xét xử-------------------------------------------------------
                    LEFT JOIN ( SELECT * 
                                FROM (SELECT QD.DONID, 
                                              CASE WHEN QD.HINHTHUCXETXU = 1 THEN 'Xử/Họp kín trực tuyến'
                                                   WHEN QD.HINHTHUCXETXU = 2 THEN 'Xử/Họp kín trực tiếp'
                                                   WHEN QD.HINHTHUCXETXU = 3 THEN 'Xử/Họp công khai trực tuyến'
                                                   WHEN QD.HINHTHUCXETXU = 4 THEN 'Xử/Họp công khai trực tiếp'
                                              END AS HTXX,
                                              ROW_NUMBER() OVER (PARTITION BY QD.DONID ORDER BY QD.NGAYQD DESC) AS  R
                                      FROM ALD_SOTHAM_QUYETDINH QD
                                          INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.LOAIID = 5
                                  )
                                  WHERE R = 1) HTXX ON HTXX.DONID = A.ID

                    --------------------------Ghi chú----------------------------------------------------------------                              
                    LEFT JOIN (SELECT QD.DONID, 
                                      LISTAGG('- QĐ ' || DMQD.MAHIENTHI || ' : số ' || QD.SOQD || ' ngày ' || TO_CHAR(QD.NGAYQD,'DD/MM/YYYY'), '<br style="mso-data-placement:same-cell;" />' ) WITHIN GROUP (ORDER BY QD.NGAYQD) GHICHU
                               FROM ALD_SOTHAM_QUYETDINH QD
                                   INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID
                                   INNER JOIN DM_QD_LOAI DMQDL ON DMQDL.ID = DMQD.LOAIID AND DMQDL.MA IN ('TDC','HPT')
                               GROUP BY QD.DONID) GHICHU ON GHICHU.DONID = A.ID
        )
        LOOP

              V_NGUYENDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         TENDUONGSU TENNGUYENDON 
                                  FROM ALD_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'NGUYENDON' AND DONID = ITEM.DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_NGUYENDON := V_NGUYENDON || '- ' || ITEM_DS.TENNGUYENDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

              V_BIDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         TENDUONGSU TENBIDON 
                                  FROM ALD_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'BIDON' AND DONID = ITEM.DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_BIDON := V_BIDON || '- ' || ITEM_DS.TENBIDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

            V_NOIDUNGKHANGNGHI := '';
            FOR ITEM_KNKC IN (SELECT KC.DONID,
                                     DS.HOTEN || NTGTT.HOTEN AS KNKC
                              FROM ALD_SOTHAM_KHANGCAO KC
                                  LEFT JOIN (SELECT ID, DONID, 
                                                    CASE WHEN NVL(LENGTH(DS.TENDUONGSU),0) > 0 THEN '- ' || DS.TENDUONGSU || DECODE(TUCACHTOTUNG_MA, 'BIDON' , ' - Bị đơn', 'QUYENNVLQ' , ' - NLQ', 'NGUYENDON', ' - NĐ', '')
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM ALD_DON_DUONGSU DS) DS ON DS.ID = KC.DUONGSUID AND KC.DONID = DS.DONID
                                  LEFT JOIN (SELECT TGTT.ID, DONID,
                                                    CASE WHEN NVL(LENGTH(TGTT.HOTEN),0) > 0 THEN '- ' || TGTT.HOTEN || ' - ' || DM.TEN
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM ALD_DON_THAMGIATOTUNG TGTT
                                                LEFT JOIN DM_DATAITEM DM ON DM.MA = TGTT.TUCACHTGTTID) NTGTT ON NTGTT.ID = KC.DUONGSUID AND KC.DONID = NTGTT.DONID
                              WHERE KC.DONID = ITEM.DONID

                              UNION

                              SELECT KN.DONID,
                                     CASE WHEN KN.DONVIKN = 0 AND KN.CAPKN = 0 THEN '- Chánh án ' || DMTA.TEN || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 0 THEN '- Viện trưởng ' || REPLACE(DMTA.TEN,'Tòa án','VKS') || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 1 THEN '- Viện trưởng ' || REPLACE(DMTACAPTREN.TEN,'Tòa án','VKS') || ' kháng nghị '
                                     END AS KNKC
                              FROM ALD_SOTHAM_KHANGNGHI KN
                                  LEFT JOIN DM_TOAAN DMTA ON DMTA.ID = KN.TOAAN_VKS_KN
                                  LEFT JOIN DM_TOAAN DMTACAPTREN ON DMTACAPTREN.ID = DMTA.CAPCHAID
                              WHERE KN.DONID = ITEM.DONID)
            LOOP
                V_NOIDUNGKHANGNGHI := V_NOIDUNGKHANGNGHI || ITEM_KNKC.KNKC || '<br style="mso-data-placement:same-cell;" />';
            END LOOP;

                V_TABLE_EXPORT.EXTEND;
                V_TABLE_EXPORT(V_TABLE_EXPORT.COUNT) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.STT, 'Lao động', ITEM.THULY,
                                                                                    V_NGUYENDON, V_BIDON, ITEM.QHPL,
                                                                                    ITEM.VCHUTOA, ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                                                                    ITEM.SONGAYBAQD, V_NOIDUNGKHANGNGHI,-- ITEM.VKCKN,
                                                                                    ITEM.HTXX,
                                                                                    ITEM.GHICHU, ITEM.NGAYTHULY,'15','16','17','18','19','20');
        END LOOP;

        RETURN V_TABLE_EXPORT;
END DON_SEARCH_ITEM_ALD;

FUNCTION DON_SEARCH_ITEM_AHC
(   
    V_DONID T_ID
)
RETURN T_TYPE_OF_20_COLUMN_VARCHAR
IS 
    V_TABLE_EXPORT  T_TYPE_OF_20_COLUMN_VARCHAR;
    V_TABLE_ID T_ID;

    V_NOIDUNGKHANGNGHI CLOB DEFAULT '';     
    V_NGUYENDON CLOB DEFAULT '';       
    V_BIDON CLOB DEFAULT '';  
BEGIN

     V_TABLE_EXPORT := T_TYPE_OF_20_COLUMN_VARCHAR();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

     FOR ITEM IN (SELECT ROW_NUMBER() OVER (ORDER BY A.ID) STT, A.ID AS DONID,
                         TL.THULY THULY,
                         NVL(BANANST.QHPL,NVL(TL.QHPL,NVL(A.QUANHEPHAPLUAT_NAME,DMDON.TEN))) AS QHPL,
                         NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA,
                         TENTHUKY.HOTENTHUKY VTHUKY,
                         TENTPHDXX.HOTEN VTHANHVIEN,
                         DECODE(BANANST.SONGAYBANAN, NULL, QDVAST.SONGAYQD,BANANST.SONGAYBANAN) SONGAYBAQD,
                         HTXX.HTXX,
                         GHICHU.GHICHU,
                         TL.NGAYTHULY

              FROM AHC_DON A
                    INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                    --------------------------Số thụ lý------------------------------------------------------------
                    LEFT JOIN (SELECT TL.DONID,
                                      LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULY,
                                      LISTAGG(NVL(TL.QUANHEPHAPLUAT_NAME, DMPTTL.TEN),',') WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS QHPL,
                                      TL.NGAYTHULY
                               FROM AHC_SOTHAM_THULY TL 
                                   left join DM_DATAITEM DMPTTL on TL.QUANHEPHAPLUATID=DMPTTL.ID
                               GROUP BY TL.DONID, TL.NGAYTHULY
                               )TL ON A.ID=TL.DONID 

                    --------------------------Nguyên đơn------------------------------------------------------------
                    --------------------------Bị đơn-----------------------------------------------------------------

                    --------------------------QHPL--------------------------------------------------------------
                    LEFT JOIN DM_DATAITEM DMDON on DMDON.ID = A.QUANHEPHAPLUATID                              

                    --------------------------Chủ tọa-----------------------------------------------------------
                    LEFT JOIN (SELECT D.DONID, 
                                      LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) AS HOTEN  
                               FROM AHC_SOTHAM_HDXX D
                                   LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                               WHERE D.MAVAITRO LIKE 'THAMPHAN'
                               GROUP BY D.DONID) TENCHUTOA ON TENCHUTOA.DONID = A.ID 

                    LEFT JOIN (SELECT GG.DONID,
                                      LISTAGG(NNPC.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY GG.NGAYNHANPHANCONG, GG.NGAYTAO) AS HOTEN
                               FROM AHC_DON_THAMPHAN GG
                                   LEFT JOIN DM_CANBO NNPC ON NNPC.ID=GG.CANBOID
                               WHERE GG.MAVAITRO='VTTP_GIAIQUYETSOTHAM' AND GG.NGAYPHANCONG IS NOT NULL AND GG.NGAYNHANPHANCONG IS NOT NULL AND GG.NGUOIPHANCONGID IS NOT NULL
                               GROUP BY GG.DONID )PCTP_GQ ON PCTP_GQ.DONID=A.ID

                    --------------------------Thành viên---------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTEN 
                              FROM AHC_SOTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                              GROUP BY DONID) TENTPHDXX ON TENTPHDXX.DONID = A.ID                     

                    --------------------------Thư ký-------------------------------------------------------------
                    LEFT JOIN(SELECT DONID,
                                     LISTAGG(DMCANBO.HOTEN,'<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY D.NGAYNHANPHANCONG, D.NGAYTAO) HOTENTHUKY 
                              FROM AHC_SOTHAM_HDXX D
                                  LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                              WHERE D.MAVAITRO LIKE 'THUKY'
                              GROUP BY DONID) TENTHUKY ON TENTHUKY.DONID = A.ID

                    --------------------------Bản án/Quyết định sơ thẩm-----------------------------------------------   
                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOQD || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYQD,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYQD) AS SONGAYQD
                               FROM AHC_SOTHAM_QUYETDINH
                                   inner join (select id, TEN from dm_qd_quyetdinh where KET_THUC = 1 AND ISSOTHAM = 1) dmqd on dmqd.id = QUYETDINHID
                               GROUP BY DONID ) QDVAST ON QDVAST.DONID = A.ID

                    LEFT JOIN (SELECT DONID,
                                      LISTAGG(SOBANAN || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYTUYENAN,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYTUYENAN) AS SONGAYBANAN,
                                      NVL(QUANHEPHAPLUAT_NAME, DMPTBA.TEN) AS QHPL
                               FROM AHC_SOTHAM_BANAN D
                                   LEFT JOIN (SELECT ID, TEN FROM DM_DATAITEM) DMPTBA on D.QUANHEPHAPLUATID = DMPTBA.ID
                               GROUP BY DONID, QUANHEPHAPLUAT_NAME, DMPTBA.TEN
                               ) BANANST ON BANANST.DONID = A.ID                               

                    --------------------------Kháng cáo/Kháng nghị-------------------------------------------------------                              

                    --------------------------Hình thức xét xử-------------------------------------------------------
                    LEFT JOIN ( SELECT * 
                                FROM (SELECT QD.DONID, 
                                              CASE WHEN QD.HINHTHUCXETXU = 1 THEN 'Xử/Họp kín trực tuyến'
                                                   WHEN QD.HINHTHUCXETXU = 2 THEN 'Xử/Họp kín trực tiếp'
                                                   WHEN QD.HINHTHUCXETXU = 3 THEN 'Xử/Họp công khai trực tuyến'
                                                   WHEN QD.HINHTHUCXETXU = 4 THEN 'Xử/Họp công khai trực tiếp'
                                              END AS HTXX,
                                              ROW_NUMBER() OVER (PARTITION BY QD.DONID ORDER BY QD.NGAYQD DESC) AS  R
                                      FROM AHC_SOTHAM_QUYETDINH QD
                                          INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.LOAIID = 5
                                  )
                                  WHERE R = 1) HTXX ON HTXX.DONID = A.ID

                    --------------------------Ghi chú----------------------------------------------------------------                              
                    LEFT JOIN (SELECT QD.DONID, 
                                      LISTAGG('- QĐ ' || DMQD.MAHIENTHI || ' : số ' || QD.SOQD || ' ngày ' || TO_CHAR(QD.NGAYQD,'DD/MM/YYYY'), '<br style="mso-data-placement:same-cell;" />' ) WITHIN GROUP (ORDER BY QD.NGAYQD) GHICHU
                               FROM AHC_SOTHAM_QUYETDINH QD
                                   INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID
                                   INNER JOIN DM_QD_LOAI DMQDL ON DMQDL.ID = DMQD.LOAIID AND DMQDL.MA IN ('TDC','HPT')
                               GROUP BY QD.DONID) GHICHU ON GHICHU.DONID = A.ID
        )
        LOOP

              V_NGUYENDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         TENDUONGSU TENNGUYENDON 
                                  FROM AHC_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'NGUYENDON' AND DONID = ITEM.DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_NGUYENDON := V_NGUYENDON || '- ' || ITEM_DS.TENNGUYENDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

              V_BIDON := '';
              FOR ITEM_DS IN (SELECT DONID,
                                         TENDUONGSU TENBIDON 
                                  FROM AHC_DON_DUONGSU
                                  WHERE TUCACHTOTUNG_MA = 'BIDON' AND DONID = ITEM.DONID
                                  ORDER BY ID ASC)
              LOOP
                  V_BIDON := V_BIDON || '- ' || ITEM_DS.TENBIDON || '<br style="mso-data-placement:same-cell;" />';
              END LOOP;

            V_NOIDUNGKHANGNGHI := '';
            FOR ITEM_KNKC IN (SELECT KC.DONID,
                                     DS.HOTEN || NTGTT.HOTEN AS KNKC
                              FROM AHC_SOTHAM_KHANGCAO KC
                                  LEFT JOIN (SELECT ID, DONID, 
                                                    CASE WHEN NVL(LENGTH(DS.TENDUONGSU),0) > 0 THEN '- ' || DS.TENDUONGSU || DECODE(TUCACHTOTUNG_MA, 'BIDON' , ' - Bị đơn', 'QUYENNVLQ' , ' - NLQ', 'NGUYENDON', ' - NĐ', '')
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM AHC_DON_DUONGSU DS) DS ON DS.ID = KC.DUONGSUID AND KC.DONID = DS.DONID
                                  LEFT JOIN (SELECT TGTT.ID, DONID,
                                                    CASE WHEN NVL(LENGTH(TGTT.HOTEN),0) > 0 THEN '- ' || TGTT.HOTEN || ' - ' || DM.TEN
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM AHC_DON_THAMGIATOTUNG TGTT
                                                LEFT JOIN DM_DATAITEM DM ON DM.MA = TGTT.TUCACHTGTTID) NTGTT ON NTGTT.ID = KC.DUONGSUID AND KC.DONID = NTGTT.DONID
                              WHERE KC.DONID = ITEM.DONID

                              UNION

                              SELECT KN.DONID,
                                     CASE WHEN KN.DONVIKN = 0 AND KN.CAPKN = 0 THEN '- Chánh án ' || DMTA.TEN || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 0 THEN '- Viện trưởng ' || REPLACE(DMTA.TEN,'Tòa án','VKS') || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 1 THEN '- Viện trưởng ' || REPLACE(DMTACAPTREN.TEN,'Tòa án','VKS') || ' kháng nghị '
                                     END AS KNKC
                              FROM AHC_SOTHAM_KHANGNGHI KN
                                  LEFT JOIN DM_TOAAN DMTA ON DMTA.ID = KN.TOAAN_VKS_KN
                                  LEFT JOIN DM_TOAAN DMTACAPTREN ON DMTACAPTREN.ID = DMTA.CAPCHAID
                              WHERE KN.DONID = ITEM.DONID)
            LOOP
                V_NOIDUNGKHANGNGHI := V_NOIDUNGKHANGNGHI || ITEM_KNKC.KNKC || '<br style="mso-data-placement:same-cell;" />';
            END LOOP;

                V_TABLE_EXPORT.EXTEND;
                V_TABLE_EXPORT(V_TABLE_EXPORT.COUNT) := R_TYPE_OF_20_COLUMN_VARCHAR(ITEM.STT, 'Hành chính', ITEM.THULY,
                                                                                    V_NGUYENDON, V_BIDON, ITEM.QHPL,
                                                                                    ITEM.VCHUTOA, ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                                                                    ITEM.SONGAYBAQD, V_NOIDUNGKHANGNGHI,-- ITEM.VKCKN,
                                                                                    ITEM.HTXX,
                                                                                    ITEM.GHICHU, ITEM.NGAYTHULY,'15','16','17','18','19','20');
        END LOOP;

        RETURN V_TABLE_EXPORT;
END DON_SEARCH_ITEM_AHC;

FUNCTION DON_SEARCH_ITEM_AHS
(   
    V_DONID T_ID
)
RETURN T_DANHSACH_AHS_DAXU_ST
AS
    V_TABLE_EXPORT  T_DANHSACH_AHS_DAXU_ST;
    V_TABLE_ID      T_ID;

    V_CURSOR        sys_refcursor;

    V_KQXXST        CLOB DEFAULT '';
    V_HOTEN         CLOB DEFAULT '';
    V_NAMSINH       CLOB DEFAULT '';
    V_TENTOIDANH    CLOB DEFAULT '';
    V_KQXXST_TEMP   CLOB DEFAULT '';
    V_NOIDUNGKHANGNGHI   CLOB DEFAULT '';
BEGIN   

     V_TABLE_EXPORT := T_DANHSACH_AHS_DAXU_ST();
     V_TABLE_ID := T_ID();

     SELECT R_ID(TTS.V_ID)
     BULK COLLECT INTO V_TABLE_ID
     FROM TABLE(V_DONID) TTS;

        FOR ITEM IN(
            SELECT   
                     A.ID VUANID,
                     ROW_NUMBER() OVER (ORDER BY A.ID) STT,
                     TL.THULY THULY,
                     NVL(TENCHUTOA.HOTEN,PCTP_GQ.HOTEN) VCHUTOA,
                     TENTHUKY.HOTENTHUKY VTHUKY,
                     TENTPHDXX.HOTEN VTHANHVIEN,
                     DECODE(BAST.SONGAYBANAN, NULL, QDVAST.SONGAYQD,BAST.SONGAYBANAN) SONGAYBAQD,
                     HTXX.HTXX,
                     GHICHU.GHICHU,
                     TL.NGAYTHULY
                     ,QDVAST.TENQD
            FROM AHS_VUAN A

                INNER JOIN (SELECT v_ID AS ID FROM TABLE(V_TABLE_ID)) TABLE_ID ON TABLE_ID.ID = A.ID

                --------------------------Số/Ngày thụ lý----------------------------------------------------
                LEFT JOIN ( SELECT TL.VUANID,
                                          LISTAGG(TL.SOTHULY || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(TL.NGAYTHULY,'DD/MM/YYYY')) WITHIN GROUP (ORDER BY TL.NGAYTHULY) AS THULY,
                                          TL.NGAYTHULY
                                   FROM AHS_SOTHAM_THULY TL 
                                   GROUP BY TL.VUANID,TL.NGAYTHULY
                           )TL ON A.ID=TL.VUANID

                --------------------------Họ và tên bị cáo--------------------------------------------------
                --------------------------Năm sinh----------------------------------------------------------
                --------------------------Tội danh----------------------------------------------------------
                --------------------------Chủ tọa-----------------------------------------------------------
                LEFT JOIN (SELECT * 
                           FROM (SELECT VUANID, DMCANBO.HOTEN,
                                        ROW_NUMBER() OVER (PARTITION BY D.VUANID ORDER BY D.NGAYPHANCONG DESC) AS  R
                                 FROM AHS_SOTHAM_HDXX D
                                     LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                                 WHERE D.MAVAITRO LIKE 'THAMPHAN')
                            WHERE R = 1) TENCHUTOA ON TENCHUTOA.VUANID = A.ID 

                LEFT JOIN (SELECT * 
                           FROM (SELECT VUANID, DMCANBO.HOTEN,
                                        ROW_NUMBER() OVER (PARTITION BY D.VUANID ORDER BY D.NGAYPHANCONG DESC) AS  R
                                 FROM AHS_THAMPHANGIAIQUYET D
                                     LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                                 WHERE D.MAVAITRO LIKE 'VTTP_GIAIQUYETSOTHAM')
                            WHERE R = 1) PCTP_GQ ON PCTP_GQ.VUANID = A.ID

                --------------------------Hội đồng----------------------------------------------------------
                LEFT JOIN(SELECT VUANID,
                                 LISTAGG(DMCANBO.HOTEN,',<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTEN 
                          FROM AHS_SOTHAM_HDXX D
                              LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                          WHERE D.MAVAITRO LIKE 'THAMPHANHDXX'
                          GROUP BY VUANID) TENTPHDXX ON TENTPHDXX.VUANID = A.ID  
                --------------------------Thư ký------------------------------------------------------------
                LEFT JOIN(SELECT VUANID,
                                 LISTAGG(DMCANBO.HOTEN,',<br style="mso-data-placement:same-cell;" />') WITHIN GROUP (ORDER BY DMCANBO.ID desc) HOTENTHUKY 
                          FROM AHS_SOTHAM_HDXX D
                                LEFT JOIN (SELECT ID,HOTEN FROM DM_CANBO) DMCANBO ON DMCANBO.ID = D.CANBOID
                          WHERE D.MAVAITRO LIKE 'THUKY'
                          GROUP BY VUANID) TENTHUKY ON TENTHUKY.VUANID = A.ID
                --------------------------Số/Ngày BAQD------------------------------------------------------
                LEFT JOIN (SELECT VUANID,
                                  LISTAGG(SOQUYETDINH || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYQD,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYQD) AS SONGAYQD
                                  ,TENQD
                           FROM (SELECT STQD.VUANID, STQD.SOQUYETDINH, STQD.NGAYQD,
                                        ROW_NUMBER() OVER (PARTITION BY STQD.VUANID ORDER BY STQD.NGAYQD DESC) AS  R
                                        ,DECODE(instr(DMQD.TEN,'. '), 0, DMQD.TEN, SUBSTR(DMQD.TEN, instr(DMQD.TEN,'. ')+2)) AS TENQD
                                 FROM AHS_SOTHAM_QUYETDINH_VUAN STQD
                                    inner join dm_qd_quyetdinh dmqd on dmqd.id = QUYETDINHID AND dmqd.KET_THUC = 1 AND dmqd.ISSOTHAM = 1)
                           WHERE R = 1
                           GROUP BY VUANID,TENQD) QDVAST ON QDVAST.VUANID = A.ID

                LEFT JOIN(SELECT VUANID,
                                 LISTAGG(SOBANAN || '<br style="mso-data-placement:same-cell;" />' || TO_CHAR(NGAYBANAN,'DD/MM/YYYY') ,',') WITHIN GROUP (ORDER BY NGAYBANAN) AS SONGAYBANAN
                          FROM AHS_SOTHAM_BANAN D
                          GROUP BY VUANID) BAST ON BAST.VUANID = A.ID                              
                --------------------------Kết quả XXST------------------------------------------------------              
                --------------------------Kháng cáo/Kháng nghị----------------------------------------------

                --------------------------Hình thức xét xử--------------------------------------------------
                LEFT JOIN ( SELECT * 
                            FROM (SELECT QD.VUANID, 
                                          CASE WHEN QD.HINHTHUCXETXU = 1 THEN 'Xử/Họp kín trực tuyến'
                                               WHEN QD.HINHTHUCXETXU = 2 THEN 'Xử/Họp kín trực tiếp'
                                               WHEN QD.HINHTHUCXETXU = 3 THEN 'Xử/Họp công khai trực tuyến'
                                               WHEN QD.HINHTHUCXETXU = 4 THEN 'Xử/Họp công khai trực tiếp'
                                          END AS HTXX,
                                          ROW_NUMBER() OVER (PARTITION BY QD.VUANID ORDER BY QD.NGAYQD DESC) AS  R
                                  FROM AHS_SOTHAM_QUYETDINH_VUAN QD
                                      INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID AND DMQD.LOAIID = 5
                              )
                              WHERE R = 1) HTXX ON HTXX.VUANID = A.ID
                --------------------------Ghi chú-----------------------------------------------------------               
                LEFT JOIN (SELECT QD.VUANID, 
                                  LISTAGG('- QĐ ' || DMQD.MAHIENTHI || ' : số ' || QD.SOQUYETDINH || ' ngày ' || TO_CHAR(QD.NGAYQD,'DD/MM/YYYY'), '<br style="mso-data-placement:same-cell;" />' ) WITHIN GROUP (ORDER BY QD.NGAYQD) GHICHU
                           FROM AHS_SOTHAM_QUYETDINH_VUAN QD
                               INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = QD.QUYETDINHID
                               INNER JOIN DM_QD_LOAI DMQDL ON DMQDL.ID = DMQD.LOAIID AND DMQDL.MA IN ('TDC','HPT')
                           GROUP BY QD.VUANID) GHICHU ON GHICHU.VUANID = A.ID
        )
        LOOP

            V_NAMSINH := '';
            V_HOTEN := '';
            V_TENTOIDANH := '';
            V_KQXXST := '';
            V_KQXXST_TEMP := '';
            V_NOIDUNGKHANGNGHI := '';

            FOR ITEM_BICAO IN (SELECT BC.ID,
                                      BC.VUANID,
                                      ('- ' || BC.HOTEN || DECODE(BC.BICANDAUVU, 1, ' (Đầu vụ)', '') ) AS HOTEN,
                                       '- ' || BC.NAMSINH/*to_char(EXTRACT(YEAR FROM  NGAYSINH))*/ AS NAMSINH,
                                       '- ' || TD.TENTOIDANH AS TENTOIDANH
                               FROM AHS_BICANBICAO BC
                                   INNER JOIN (SELECT BICANID, DL.TENTOIDANH 
                                             FROM AHS_SOTHAM_CAOTRANG_DIEULUAT DL 
                                                INNER JOIN (SELECT ID FROM DM_BOLUAT_TOIDANH BL WHERE DIEM IS NULL AND KHOAN IS NULL) DMBL ON DMBL.ID = DL.TOIDANHID
                                             WHERE ISMAIN = 1 )TD ON TD.BICANID = BC.ID
                               WHERE BC.VUANID = ITEM.VUANID
                               ORDER BY BICANDAUVU DESC, ID)
            LOOP
                IF(NVL(LENGTH(ITEM_BICAO.HOTEN),0) > 0 ) THEN V_HOTEN := V_HOTEN || ITEM_BICAO.HOTEN || '<br style="mso-data-placement:same-cell;" />'; END IF; 
                IF(NVL(LENGTH(ITEM_BICAO.NAMSINH),0) > 0 ) THEN V_NAMSINH := V_NAMSINH || ITEM_BICAO.NAMSINH || '<br style="mso-data-placement:same-cell;" />'; END IF; 
                IF(NVL(LENGTH(ITEM_BICAO.TENTOIDANH),0) > 0 ) THEN V_TENTOIDANH := V_TENTOIDANH || ITEM_BICAO.TENTOIDANH || '<br style="mso-data-placement:same-cell;" />'; END IF; 

                PKG_STPT_AHS_TONGHOPHINHPHAT.AHS_TONGHOPHINHPHAT_ST(ITEM_BICAO.VUANID,ITEM_BICAO.ID,V_CURSOR);
                LOOP 
                FETCH V_CURSOR 
                    INTO      V_KQXXST_TEMP;
                    EXIT WHEN V_CURSOR%NOTFOUND;
                END LOOP;    
                CLOSE V_CURSOR;
                IF(NVL(LENGTH(V_KQXXST_TEMP),0) > 0 ) THEN
                        V_KQXXST := V_KQXXST || '- ' || V_KQXXST_TEMP || '<br style="mso-data-placement:same-cell;" />' ;
                    END IF;
            END LOOP;

            IF (NVL(length(V_KQXXST),0) = 0) THEN
                    V_KQXXST := ITEM.TENQD;
                END IF;

            FOR ITEM_KNKC IN (SELECT KC.VUANID,
                                     BC.HOTEN || NTGTT.HOTEN AS KNKC
                              FROM AHS_SOTHAM_KHANGCAO KC
                                  LEFT JOIN (SELECT ID, 
                                                    CASE WHEN NVL(LENGTH(BC.HOTEN),0) > 0 THEN '- ' || BC.HOTEN || CASE WHEN NVL(LENGTH(ITEM.SONGAYBAQD),0) = 0 THEN ' - Bị can' ELSE ' - Bị cáo' END
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM AHS_BICANBICAO BC) BC ON BC.ID = KC.NGUOIKCID AND KC.NGUOIKCLOAI = 0
                                  LEFT JOIN (SELECT TGTT.ID,
                                                    CASE WHEN NVL(LENGTH(TGTT.HOTEN),0) > 0 THEN '- ' || TGTT.HOTEN || ' - ' || DM.TEN 
                                                         ELSE u'' 
                                                         END AS HOTEN
                                             FROM AHS_NGUOITHAMGIATOTUNG TGTT
                                                LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID = TGTT.ID
                                                LEFT JOIN DM_DATAITEM DM ON DM.ID = TC.TUCACHID) NTGTT ON NTGTT.ID = KC.NGUOIKCID AND KC.NGUOIKCLOAI = 1
                              WHERE KC.VUANID = ITEM.VUANID

                              UNION

                              SELECT KN.VUANID,
                                     CASE WHEN KN.DONVIKN = 0 AND KN.CAPKN = 0 THEN '- Chánh án ' || DMTA.TEN || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 0 THEN '- Viện trưởng ' || REPLACE(DMTA.TEN,'Tòa án','VKS') || ' kháng nghị '
                                          WHEN KN.DONVIKN = 1 AND KN.CAPKN = 1 THEN '- Viện trưởng ' || REPLACE(DMTACAPTREN.TEN,'Tòa án','VKS') || ' kháng nghị '
                                     END AS KNKC
                              FROM AHS_SOTHAM_KHANGNGHI KN
                                  LEFT JOIN DM_TOAAN DMTA ON DMTA.ID = KN.TOAAN_VKS_KN
                                  LEFT JOIN DM_TOAAN DMTACAPTREN ON DMTACAPTREN.ID = DMTA.CAPCHAID
                              WHERE KN.VUANID = ITEM.VUANID)
            LOOP
                V_NOIDUNGKHANGNGHI := V_NOIDUNGKHANGNGHI || ITEM_KNKC.KNKC || '<br style="mso-data-placement:same-cell;" />';
            END LOOP;

            V_TABLE_EXPORT.EXTEND;
            V_TABLE_EXPORT(V_TABLE_EXPORT.count) := R_DANHSACH_AHS_DAXU_ST( ITEM.STT,ITEM.THULY,V_HOTEN, V_NAMSINH, V_TENTOIDANH,
                                                                            ITEM.VCHUTOA,ITEM.VTHANHVIEN,ITEM.VTHUKY,
                                                                            ITEM.SONGAYBAQD,V_KQXXST,
                                                                            V_NOIDUNGKHANGNGHI,--ITEM.KCKN,
                                                                            ITEM.HTXX,
                                                                            ITEM.GHICHU,
                                                                            ITEM.NGAYTHULY);

        END LOOP;

   RETURN V_TABLE_EXPORT;

END DON_SEARCH_ITEM_AHS;

END PKG_STPT_DANHSACH_ST;

/
