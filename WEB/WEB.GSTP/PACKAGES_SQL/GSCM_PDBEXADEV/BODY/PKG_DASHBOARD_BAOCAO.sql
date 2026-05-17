--------------------------------------------------------
--  DDL for Package Body PKG_DASHBOARD_BAOCAO
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_DASHBOARD_BAOCAO" AS

FUNCTION DASHBOARD_M1_TATC_BAOCAO
(
  VTOAANID IN NUMBER,
  VTHAMPHANID  IN NUMBER,
  VTUNGAY IN DATE,
  VDENNGAY IN DATE
)
RETURN SYS_REFCURSOR
IS 
    V_CURSOR sys_refcursor;
    V_CURSOR_TD sys_refcursor;
    V_EXPORT_TEXT CLOB; 
    
    V_HOTEN VARCHAR2(250);
    V_THOIGIANLAYBAOCAO VARCHAR2(250);
    V_MA_CHUCVU varchar2(50); 
    
    V_TABLE_TIMKIEM             T_TYPE_OF_15_COLUMN_VARCHAR;
    
    FETCH_LOAIAN       VARCHAR2(25 CHAR);
    FETCH_COLUMN_1     VARCHAR2(10 CHAR);
    FETCH_COLUMN_2     VARCHAR2(10 CHAR);
    FETCH_COLUMN_3     VARCHAR2(10 CHAR); 
    FETCH_COLUMN_4     VARCHAR2(10 CHAR);
    FETCH_COLUMN_5     VARCHAR2(10 CHAR);
    FETCH_COLUMN_6     VARCHAR2(10 CHAR);  
    FETCH_COLUMN_7     VARCHAR2(10 CHAR);
    FETCH_COLUMN_8     VARCHAR2(10 CHAR);
    FETCH_COLUMN_9     VARCHAR2(10 CHAR);
    FETCH_COLUMN_10    VARCHAR2(10 CHAR);
    FETCH_COLUMN_11    VARCHAR2(10 CHAR);
    
BEGIN	
        V_TABLE_TIMKIEM := T_TYPE_OF_15_COLUMN_VARCHAR();
        
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,TRUE);
        
        --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <div style="mso-element: footer" id="f1">
                <w:sdt sdtdocpart="t"
                docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
                <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
                style="mso-element:field-begin"></span><span
                style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
                </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
                style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
                style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
                </w:sdt>
                <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
            </div>');
        --DBMS_LOB.APPEND(V_EXPORT_TEXT,'<table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">');
    
        BEGIN
            SELECT nvl(B.MA,'') INTO V_MA_CHUCVU
            FROM DM_CANBO A LEFT JOIN DM_DATAITEM B ON A.CHUCVUID = B.ID 
            WHERE A.ID = VTHAMPHANID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_MA_CHUCVU := '';
        END;    
        
        FOR ITEM IN (
                     SELECT LS.*, ROW_NUMBER() OVER (ORDER BY 'X') STT, COUNT(*) OVER () AS COUNTALL
                     FROM
                        (   
                            SELECT 0 ID, TRANSLATE ('--- Tất cả Thẩm phám ---' USING NCHAR_CS) AS HOTEN, TRANSLATE ('--- Tất cả Thẩm phám ---' USING NCHAR_CS) AS  FULL_HOTEN
                            FROM DUAL
                            WHERE VTHAMPHANID = 0
                            
                            UNION ALL
                            
                            SELECT D.ID, D.HOTEN || DECODE(CV.ID, 45, ' - CA', 74, ' - PCA', 446, ' - PCA', 1938, ' - PCA', '') AS HOTEN, DECODE(CV.TEN, NULL, '', CV.TEN || ' ') || D.HOTEN  AS FULL_HOTEN
                            FROM DM_CANBO D
                                LEFT JOIN DM_DATAITEM CV ON CV.ID = D.CHUCVUID AND CV.MA NOT LIKE 'CA'
                                LEFT JOIN DM_DATAITEM CD ON CD.ID = D.CHUCDANHID
                            WHERE D.TOAANID = VTOAANID AND D.HIEULUC = 1 
                                AND (/*VTHAMPHANID = 0 OR*/VTHAMPHANID = D.ID)
                                AND CD.MA LIKE 'TPTATC' -- Chỉ lấy TP TANDTC
                                AND NOT EXISTS(SELECT DT.ID, DT.TEN FROM DM_DATAITEM DT WHERE DT.MA IN ('CA') AND DT.ID=D.CHUCVUID) -- Loại Chánh án ra khỏi danh sách
                        ) LS
                        ORDER BY 
                            CASE 
                                WHEN LS.ID = 0 THEN 1  -- Đưa ID = 0 lên đầu
                                WHEN LS.FULL_HOTEN LIKE '%Thường trực%' THEN 2
                                WHEN LS.HOTEN LIKE '%PCA' THEN 3  -- Đưa Phó Chánh án (PCA) sau ID = 0
                                ELSE 4  -- Các nhân vật còn lại
                            END,
                            LS.HOTEN
                    )
        LOOP 
  
            --TÌNH HÌNH GIẢI QUYẾT ĐƠN, XÉT XỬ GDT,TT TÒA ÁN NHÂN DÂN TỐI CAO
            V_TABLE_TIMKIEM.DELETE;
            V_TABLE_TIMKIEM.TRIM(0);
            
            PKG_DASHBOARD.DASHBOARD_GDT_EXP(VTOAANID, ITEM.ID, VTUNGAY, VDENNGAY, V_CURSOR_TD);            
            LOOP
                FETCH V_CURSOR_TD
                INTO    FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                        FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                        FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11;
                EXIT WHEN V_CURSOR_TD%NOTFOUND;

                V_TABLE_TIMKIEM.EXTEND;
                V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                                                                                        FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                                                                                        FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11,
                                                                                        '13','14','15');
            END LOOP;
            
DBMS_LOB.APPEND(V_EXPORT_TEXT,'<table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">');          
          
            IF(V_TABLE_TIMKIEM.COUNT > 0 /*OR VTHAMPHANID > 0*/) THEN

                    IF(ITEM.ID = 0) THEN
                            V_HOTEN:='TÌNH HÌNH GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GĐTTT TÒA ÁN NHÂN DÂN TỐI CAO';
                        ELSIF(ITEM.HOTEN LIKE '%PCA') THEN
                            V_HOTEN:='TÌNH HÌNH GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GĐTTT CỦA '||UPPER(ITEM.FULL_HOTEN);
                        ELSE 
                            V_HOTEN:='TÌNH HÌNH GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GĐTTT CỦA THẨM PHÁN '||UPPER(ITEM.FULL_HOTEN);
                    END IF;
                    
                    V_THOIGIANLAYBAOCAO := ' (TỪ NGÀY '|| TO_CHAR(VTUNGAY,'DD/MM/YYYY') || ' ĐẾN NGÀY '|| TO_CHAR(VDENNGAY,'DD/MM/YYYY') || ')';

                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr style="margin-top: 0px;">
                            <th style="text-align: center; vertical-align: middle; height: 45px; font-size: 14pt;" colspan="12">'||V_HOTEN || V_THOIGIANLAYBAOCAO ||'</th>
                    </tr>
                    <tr style="">
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">LOẠI ÁN </td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="6">GIẢI QUYẾT ĐƠN</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="5">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                    </tr>
                    <tr style="">
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tổng số đơn</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="4">Đã giải quyết xong</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Chưa giải quyết xong</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="3">Số vụ án xét xử GĐT, TT</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Đã xét xử</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Chưa xét xử</td>
                    </tr>                            
                    <tr style="">
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Trả lời đơn</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Kháng nghị</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Xếp đơn</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chánh án Kháng nghị</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Viện trưởng Kháng nghị</td>
                    </tr> 
                    ');
                 
                 
                    FOR ITEMS IN (
                        SELECT  TT.*
                        FROM TABLE(V_TABLE_TIMKIEM)  TT
                    )
                    LOOP
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <tr>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding: 5px;">'||ITEMS.COLUMN_1||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_2||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_3||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_4||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_5||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_6||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_7||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_8||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_9||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_10||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_11||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_12||'</td>
                            </tr>
                        ');
                    END LOOP;
                    
             
                END IF;
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                      <tr style="height: 0px;">
                        <td style="width: 25px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                    </tr>
               </table>             
        ');               
                
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>  ');
            
                
            --THỐNG KÊ CÁC VỤ ÁN CÓ Ý KIẾN CỦA QUỐC HỘI, ĐOÀN ĐẠI BIỂU QUỐC HỘI
            V_TABLE_TIMKIEM.DELETE;
            V_TABLE_TIMKIEM.TRIM(0);
            
            PKG_DASHBOARD.DASHBOARD_GDT_QH_EXP(VTOAANID, ITEM.ID, VTUNGAY, VDENNGAY, V_CURSOR_TD);            
            LOOP
                FETCH V_CURSOR_TD
                INTO    FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                        FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                        FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11;
                EXIT WHEN V_CURSOR_TD%NOTFOUND;

                V_TABLE_TIMKIEM.EXTEND;
                V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                                                                                        FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                                                                                        FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11,
                                                                                        '13','14','15');
            END LOOP;  
            
DBMS_LOB.APPEND(V_EXPORT_TEXT,'<table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">');         
       
            IF(V_TABLE_TIMKIEM.COUNT > 0 /*OR VTHAMPHANID > 0*/) THEN

                    IF(ITEM.ID = 0) THEN
                            V_HOTEN:='SỐ VỤ ÁN CÓ ĐƠN, VĂN BẢN ĐỀ NGHỊ GĐT,TT THUỘC TRƯỜNG HỢP CÓ Ý KIẾN CỦA QUỐC HỘI, ĐOÀN ĐẠI BIỂU QUỐC HỘI';
                        ELSIF(ITEM.HOTEN LIKE '%PCA') THEN
                            V_HOTEN:='SỐ VỤ ÁN CÓ ĐƠN, VĂN BẢN ĐỀ NGHỊ GĐT,TT THUỘC TRƯỜNG HỢP CÓ Ý KIẾN CỦA QUỐC HỘI, ĐOÀN ĐẠI BIỂU QUỐC HỘI CỦA '||UPPER(ITEM.FULL_HOTEN);
                        ELSE 
                            V_HOTEN:='SỐ VỤ ÁN CÓ ĐƠN, VĂN BẢN ĐỀ NGHỊ GĐT,TT THUỘC TRƯỜNG HỢP CÓ Ý KIẾN CỦA QUỐC HỘI, ĐOÀN ĐẠI BIỂU QUỐC HỘI CỦA THẨM PHÁN '||UPPER(ITEM.FULL_HOTEN);
                    END IF;
                    
                    V_THOIGIANLAYBAOCAO := ' (TỪ NGÀY '|| TO_CHAR(VTUNGAY,'DD/MM/YYYY') || ' ĐẾN NGÀY '|| TO_CHAR(VDENNGAY,'DD/MM/YYYY') || ')';

                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr style="margin-top: 0px;">
                            <th style="text-align: center; vertical-align: middle; height: 45px; font-size: 14pt;" colspan="12">'||V_HOTEN || V_THOIGIANLAYBAOCAO ||'</th>
                    </tr>
                    <tr style="">
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">LOẠI ÁN </td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="6">SỐ VỤ PHẢI GIẢI QUYẾT TRONG GIAI ĐOẠN GIẢI QUYẾT ĐƠN</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="5">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                    </tr>
                    <tr style="">
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tổng số vụ án phải giải quyết</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="4">Đã giải quyết xong</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Chưa giải quyết xong</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="3">Số vụ án xét xử GĐT, TT</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Đã xét xử</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Chưa xét xử</td>
                    </tr>                            
                    <tr style="">
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Số vụ Trả lời đơn</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Số vụ Kháng nghị</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Số vụ Xếp đơn</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chánh án Kháng nghị</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Viện trưởng Kháng nghị</td>
                    </tr> 
                    ');
                 
                 
                    FOR ITEMS IN (
                        SELECT  TT.*
                        FROM TABLE(V_TABLE_TIMKIEM)  TT
                    )
                    LOOP
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <tr>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding: 5px;">'||ITEMS.COLUMN_1||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_2||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_3||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_4||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_5||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_6||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_7||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_8||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_9||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_10||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_11||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_12||'</td>
                            </tr>
                        ');
                    END LOOP;
                    
                END IF;                
                
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                      <tr style="height: 0px;">
                        <td style="width: 25px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                    </tr>
               </table>             
        ');                
            
               DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>  ');
                
            --THỐNG KÊ VỤ ÁN CÓ THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG
            V_TABLE_TIMKIEM.DELETE;
            V_TABLE_TIMKIEM.TRIM(0);
            
            PKG_DASHBOARD.DASHBOARD_GDT_THOIHIEU_EXP(VTOAANID, ITEM.ID, VTUNGAY, VDENNGAY, V_CURSOR_TD);            
            LOOP
                FETCH V_CURSOR_TD
                INTO    FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                        FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                        FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11;
                EXIT WHEN V_CURSOR_TD%NOTFOUND;

                V_TABLE_TIMKIEM.EXTEND;
                V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(FETCH_LOAIAN, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                                                                                        FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7,
                                                                                        FETCH_COLUMN_8, FETCH_COLUMN_9, FETCH_COLUMN_10, FETCH_COLUMN_11,
                                                                                        '13','14','15');
            END LOOP;  
DBMS_LOB.APPEND(V_EXPORT_TEXT,'<table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">');          
          
            IF(V_TABLE_TIMKIEM.COUNT > 0 /*OR VTHAMPHANID > 0*/) THEN

                    IF(ITEM.ID = 0) THEN
                            V_HOTEN:='SỐ VỤ ÁN CÓ ĐƠN, VĂN BẢN ĐỀ NGHỊ GĐT,TT CÒN THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG';
                        ELSIF(ITEM.HOTEN LIKE '%PCA') THEN
                            V_HOTEN:='SỐ VỤ ÁN CÓ ĐƠN, VĂN BẢN ĐỀ NGHỊ GĐT,TT CÒN THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG CỦA '||UPPER(ITEM.FULL_HOTEN);
                        ELSE 
                            V_HOTEN:='SỐ VỤ ÁN CÓ ĐƠN, VĂN BẢN ĐỀ NGHỊ GĐT,TT CÒN THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG CỦA THẨM PHÁN '||UPPER(ITEM.FULL_HOTEN);
                    END IF;
                    
                    V_THOIGIANLAYBAOCAO := ' (TỪ NGÀY '|| TO_CHAR(VTUNGAY,'DD/MM/YYYY') || ' ĐẾN NGÀY '|| TO_CHAR(VDENNGAY,'DD/MM/YYYY') || ')';

                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr style="margin-top: 0px;">
                            <th style="text-align: center; vertical-align: middle; height: 45px; font-size: 14pt;" colspan="12">'||V_HOTEN || V_THOIGIANLAYBAOCAO ||'</th>
                    </tr>
                    <tr style="">
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="3">LOẠI ÁN </td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="6">SỐ VỤ PHẢI GIẢI QUYẾT TRONG GIAI ĐOẠN GIẢI QUYẾT ĐƠN</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="5">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                    </tr>
                    <tr style="">
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Tổng số vụ án phải giải quyết</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="4">Đã giải quyết xong</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Chưa giải quyết xong</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="3">Số vụ án xét xử GĐT, TT</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Đã xét xử</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" rowspan="2">Chưa xét xử</td>
                    </tr>                            
                    <tr style="">
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Số vụ Trả lời đơn</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Số vụ Kháng nghị	</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Số vụ Xếp đơn	</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chánh án Kháng nghị</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Viện trưởng Kháng nghị</td>
                    </tr>
                    ');
                 
                 
                    FOR ITEMS IN (
                        SELECT  TT.*
                        FROM TABLE(V_TABLE_TIMKIEM)  TT
                    )
                    LOOP
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <tr>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding: 5px;">'||ITEMS.COLUMN_1||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_2||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_3||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_4||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_5||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_6||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_7||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_8||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_9||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_10||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_11||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_12||'</td>
                            </tr>
                        ');
                    END LOOP;
                    
                END IF;     
                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                      <tr style="height: 0px;">
                        <td style="width: 25px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                        <td style="width: 47px"></td>
                    </tr>
               </table>             
        ');          
        
        END LOOP;
                
        OPEN V_CURSOR FOR SELECT V_EXPORT_TEXT TEXT_REPORT FROM DUAL;          
        DBMS_LOB.FREETEMPORARY(V_EXPORT_TEXT);        
        RETURN V_CURSOR;  
        
END DASHBOARD_M1_TATC_BAOCAO;


FUNCTION DASHBOARD_M1_TPTATC_BAOCAO
(
  VTOAANID IN NUMBER,
  VTHAMPHANID  IN NUMBER,
  VTUNGAY IN DATE,
  VDENNGAY IN DATE
)
RETURN SYS_REFCURSOR
IS 
    V_CURSOR sys_refcursor;
    V_CURSOR_TD sys_refcursor;
    V_EXPORT_TEXT CLOB; 

    V_HOTEN VARCHAR2(250);
    V_THOIGIANLAYBAOCAO VARCHAR2(250);
    V_MA_CHUCVU varchar2(50); 

    V_TABLE_TIMKIEM             T_DASHBOARD_THAMPHAN;

    FETCH_THAMPHAN_HOTEN    VARCHAR2(25 CHAR); 
    FETCH_THAMPHANID        VARCHAR2(10 CHAR);
    FETCH_COLUMN_1          VARCHAR2(10 CHAR);
    FETCH_COLUMN_2          VARCHAR2(10 CHAR);
    FETCH_COLUMN_3          VARCHAR2(10 CHAR); 
    FETCH_COLUMN_4          VARCHAR2(10 CHAR);
    FETCH_COLUMN_5          VARCHAR2(10 CHAR);
    FETCH_COLUMN_6          VARCHAR2(10 CHAR); 
    FETCH_COLUMN_7          VARCHAR2(10 CHAR);
    FETCH_COLUMN_8          VARCHAR2(10 CHAR);
    FETCH_COLUMN_9          VARCHAR2(10 CHAR);
    FETCH_COLUMN_10         VARCHAR2(10 CHAR);

BEGIN	
        V_TABLE_TIMKIEM := T_DASHBOARD_THAMPHAN();

        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,TRUE);

        --Insert số trang
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <div style="mso-element: footer" id="f1">
                <w:sdt sdtdocpart="t"
                docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
                <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
                style="mso-element:field-begin"></span><span
                style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
                </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
                style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
                style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
                </w:sdt>
                <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
            </div>');
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'<table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">');

            --TÌNH HÌNH GIẢI QUYẾT ĐƠN, XÉT XỬ GDT,TT TÒA ÁN NHÂN DÂN TỐI CAO
            V_TABLE_TIMKIEM.DELETE;
            V_TABLE_TIMKIEM.TRIM(0);

            PKG_DASHBOARD.DASHBOARD_M1_TPTATC(VTOAANID, 0, VTUNGAY, VDENNGAY, V_CURSOR_TD);            
            LOOP
                FETCH V_CURSOR_TD
                INTO    FETCH_THAMPHAN_HOTEN, FETCH_THAMPHANID, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                        FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6, FETCH_COLUMN_7, FETCH_COLUMN_8, FETCH_COLUMN_9,
                        FETCH_COLUMN_10;
                EXIT WHEN V_CURSOR_TD%NOTFOUND;

                V_TABLE_TIMKIEM.EXTEND;
                V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_DASHBOARD_THAMPHAN(FETCH_THAMPHAN_HOTEN, FETCH_THAMPHANID, FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3,
                                                                                        FETCH_COLUMN_4, FETCH_COLUMN_5, FETCH_COLUMN_6,
                                                                                        0,0,0,0);
            END LOOP;  

            IF(V_TABLE_TIMKIEM.COUNT > 0 /*OR VTHAMPHANID > 0*/) THEN

                    V_HOTEN:='TỔNG HỢP SỐ LIỆU THEO THẨM PHÁN TANDTC';
                    V_THOIGIANLAYBAOCAO := ' (TỪ NGÀY '|| TO_CHAR(VTUNGAY,'DD/MM/YYYY') || ' ĐẾN NGÀY '|| TO_CHAR(VDENNGAY,'DD/MM/YYYY') || ')';

                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr style="margin-top: 0px;">
                            <th style="text-align: center; vertical-align: middle; height: 45px; font-size: 14pt;" colspan="16">'||V_HOTEN || V_THOIGIANLAYBAOCAO ||'</th>
                    </tr>
                    <tr >
                        <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 60px;" colspan="2" rowspan="2">STT</td>
                        <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2" rowspan="2">THẨM PHÁN TANDTC</td>
                        <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 30px;" colspan="6" rowspan="1">GIẢI QUYẾT ĐƠN</td>
                        <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="6" rowspan="1">XÉT XỬ GIÁM ĐỐC THẨM, TÁI THẨM</td>
                    </tr>
                    <tr>
                        <td style="text-align: center; vertical-align: middle; border: 1pt solid Black; height: 30px;" colspan="2">Tổng số đơn</td>
                        <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">Đã giải quyết xong</td>
                        <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">Chưa giải quyết xong</td>
                        <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">Tổng số vụ án</td>
                        <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">Đã xét xử</td>
                        <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;" colspan="2">Chưa xét xử</td>
                    </tr>      
                    ');


                    FOR ITEMS IN (
                        SELECT  ROW_NUMBER() OVER (ORDER BY 'X' DESC) STT,TT.*
                        FROM TABLE(V_TABLE_TIMKIEM)  TT
                    )
                    LOOP
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                            <tr>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding: 5px;" colspan="2">'||ITEMS.STT||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"colspan="2">'||ITEMS.THAMPHAN_HOTEN||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"colspan="2">'||ITEMS.COLUMN_1||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"colspan="2">'||ITEMS.COLUMN_2||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"colspan="2">'||ITEMS.COLUMN_3||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"colspan="2">'||ITEMS.COLUMN_4||'</td>
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"colspan="2">'||ITEMS.COLUMN_5||'</td>            
                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;"colspan="2">'||ITEMS.COLUMN_6||'</td>
                            </tr>
                        ');
                    END LOOP;



                END IF;



                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                      <tr style="height: 0px;">
                        <td style="width: 19px;"></td>
                        <td style="width: 19px"></td>

                        <td style="width: 94px"></td>
                        <td style="width: 94px"></td>

                        <td style="width: 70px; "></td>
                        <td style="width: 70px; "></td>

                        <td style="width: 70px; "></td>
                        <td style="width: 70px; "></td>

                        <td style="width: 70px; "></td>
                        <td style="width: 70px; "></td>

                        <td style="width: 50px; "></td>
                        <td style="width: 50px; "></td>

                        <td style="width: 50px; "></td>
                        <td style="width: 50px; "></td>

                        <td style="width: 50px; "></td>
                        <td style="width: 50px; "></td>
                    </tr>
               </table>

        ');

        OPEN V_CURSOR FOR SELECT V_EXPORT_TEXT TEXT_REPORT FROM DUAL;          
        DBMS_LOB.FREETEMPORARY(V_EXPORT_TEXT);        
        RETURN V_CURSOR;  

END DASHBOARD_M1_TPTATC_BAOCAO;

END PKG_DASHBOARD_BAOCAO;

/
