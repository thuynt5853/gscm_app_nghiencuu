create or replace NONEDITIONABLE PACKAGE BODY PKG_DASHBOARD AS


FUNCTION BAOCAO_TK_TP_GET
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
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'<table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">');
    
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
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chánh án kháng nghị</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Viện trưởng kháng nghị</td>
                    </tr> 
                   <tr style="font-style: italic; color: #adabab; font-size: 10pt; text-align: center;">
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">1</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">2</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">3</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">4</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">5</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">6</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">7</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">8</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">9</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">10</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">11</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">12</td>
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
                    
                    --if(item.stt > 1 and item.COUNTALL != item.stt) then
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <span style=''font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
                            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                            mso-fareast-language:EN-US;mso-bidi-language:AR-SA''><br clear=all
                            style=''mso-special-character:line-break;page-break-before:always''>
                            </span>
                    
                            <p class=MsoNormal><o:p>&nbsp;</o:p></p>');
                         --   End if;
                END IF;
                
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
          
            IF(V_TABLE_TIMKIEM.COUNT > 0 /*OR VTHAMPHANID > 0*/) THEN

                    IF(ITEM.ID = 0) THEN
                            V_HOTEN:='THỐNG KÊ CÁC VỤ ÁN CÓ Ý KIẾN CỦA QUỐC HỘI, ĐOÀN ĐẠI BIỂU QUỐC HỘI';
                        ELSIF(ITEM.HOTEN LIKE '%PCA') THEN
                            V_HOTEN:='THỐNG KÊ CÁC VỤ ÁN CÓ Ý KIẾN CỦA QUỐC HỘI, ĐOÀN ĐẠI BIỂU QUỐC HỘI CỦA '||UPPER(ITEM.FULL_HOTEN);
                        ELSE 
                            V_HOTEN:='THỐNG KÊ CÁC VỤ ÁN CÓ Ý KIẾN CỦA QUỐC HỘI, ĐOÀN ĐẠI BIỂU QUỐC HỘI CỦA THẨM PHÁN '||UPPER(ITEM.FULL_HOTEN);
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
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chánh án kháng nghị</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Viện trưởng kháng nghị</td>
                    </tr> 
                   <tr style="font-style: italic; color: #adabab; font-size: 10pt; text-align: center;">
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">1</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">2</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">3</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">4</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">5</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">6</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">7</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">8</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">9</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">10</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">11</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">12</td>
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
                    
                    --if(item.stt > 1 and item.COUNTALL != item.stt) then
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <span style=''font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
                            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                            mso-fareast-language:EN-US;mso-bidi-language:AR-SA''><br clear=all
                            style=''mso-special-character:line-break;page-break-before:always''>
                            </span>
                    
                            <p class=MsoNormal><o:p>&nbsp;</o:p></p>');
                         --   End if;
                END IF;                
                
                
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
          
            IF(V_TABLE_TIMKIEM.COUNT > 0 /*OR VTHAMPHANID > 0*/) THEN

                    IF(ITEM.ID = 0) THEN
                            V_HOTEN:='THỐNG KÊ VỤ ÁN CÓ THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG';
                        ELSIF(ITEM.HOTEN LIKE '%PCA') THEN
                            V_HOTEN:='THỐNG KÊ VỤ ÁN CÓ THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG CỦA '||UPPER(ITEM.FULL_HOTEN);
                        ELSE 
                            V_HOTEN:='THỐNG KÊ VỤ ÁN CÓ THỜI HIỆU GIẢI QUYẾT DƯỚI 3 THÁNG CỦA THẨM PHÁN '||UPPER(ITEM.FULL_HOTEN);
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
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chánh án kháng nghị</td>
                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Viện trưởng kháng nghị</td>
                    </tr> 
                   <tr style="font-style: italic; color: #adabab; font-size: 10pt; text-align: center;">
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">1</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">2</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">3</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">4</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">5</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">6</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">7</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">8</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">9</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">10</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">11</td>
                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">12</td>
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
                    
                    --if(item.stt > 1 and item.COUNTALL != item.stt) then
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <span style=''font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
                            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
                            mso-fareast-language:EN-US;mso-bidi-language:AR-SA''><br clear=all
                            style=''mso-special-character:line-break;page-break-before:always''>
                            </span>
                    
                            <p class=MsoNormal><o:p>&nbsp;</o:p></p>');
                         --   End if;
                END IF;     
                
        END LOOP;
                
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
           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
            style="mso-special-character:line-break;page-break-before:always">
            </span>
            <p class=MsoNormal><o:p></o:p></p>               
        ');
        
        OPEN V_CURSOR FOR SELECT V_EXPORT_TEXT TEXT_REPORT FROM DUAL;          
        DBMS_LOB.FREETEMPORARY(V_EXPORT_TEXT);        
        RETURN V_CURSOR;  
        
END BAOCAO_TK_TP_GET;

--FUNCTION BAOCAO_TK_TAND_GET
--(
--  VTOAANID IN NUMBER,
--  VTUNGAY IN DATE,
--  VDENNGAY IN DATE
--)
--RETURN SYS_REFCURSOR
--IS 
--    V_CURSOR sys_refcursor;
--    V_CURSOR_TD sys_refcursor;
--    V_EXPORT_TEXT CLOB; 
--    
--    V_HOTEN VARCHAR(500);
--    V_THOIGIANLAYBAOCAO VARCHAR(500);
--    V_TABLE_TIMKIEM             T_TYPE_OF_15_COLUMN_VARCHAR;
--    
--    FETCH_COLUMN_1     VARCHAR2(10 CHAR);
--    FETCH_COLUMN_2     VARCHAR2(10 CHAR);
--    FETCH_COLUMN_3     VARCHAR2(10 CHAR); 
--    FETCH_COLUMN_4     VARCHAR2(10 CHAR);
--    FETCH_COLUMN_5     VARCHAR2(10 CHAR);
--    
--BEGIN	
--        V_TABLE_TIMKIEM := T_TYPE_OF_15_COLUMN_VARCHAR();
--        
--        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,TRUE);
--        
--        --Insert số trang
--        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
--            <div style="mso-element: footer" id="f1">
--                <w:sdt sdtdocpart="t"
--                docparttype="Page Numbers (Bottom of Page)" docpartunique="t" id="644013658">
--                <p class=MsoFooter align=right style="text-align:right"><!--[if supportFields]><span
--                style="mso-element:field-begin"></span><span
--                style="mso-spacerun:yes"> </span>PAGE<span style="mso-spacerun:yes">  
--                </span>\* MERGEFORMAT <span style="mso-element:field-separator"></span><![endif]--><span
--                style="mso-no-proof:yes;display:none">2</span><!--[if supportFields]><span
--                style="mso-no-proof:yes"><span style="mso-element:field-end"></span></span><![endif]--><w:sdtPr></w:sdtPr></p>
--                </w:sdt>
--                <p class="MsoFooter" align="right" style="text-align: right;"><o:p></o:p> </p>
--            </div>');
--        DBMS_LOB.APPEND(V_EXPORT_TEXT,'<table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">');
--    
--
--            PKG_DASHBOARD.DASHBOARD_STPT_EXP(VTOAANID, VTUNGAY, VDENNGAY, V_CURSOR_TD);            
--            LOOP
--                FETCH V_CURSOR_TD
--                INTO    FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3, FETCH_COLUMN_4, FETCH_COLUMN_5
--                EXIT WHEN V_CURSOR_TD%NOTFOUND;
--
--                V_TABLE_TIMKIEM.EXTEND;
--                V_TABLE_TIMKIEM(V_TABLE_TIMKIEM.COUNT) := R_TYPE_OF_15_COLUMN_VARCHAR(FETCH_COLUMN_1, FETCH_COLUMN_2, FETCH_COLUMN_3, FETCH_COLUMN_4, FETCH_COLUMN_5,
--                                                                                        '', '', '', 
--                                                                                        '', '', '', '',
--                                                                                        '','','');
--            END LOOP;  
--          
--                    V_HOTEN := 'TÌNH HÌNH GIẢI QUYẾT ÁN SƠ THẨM, PHÚC THẨM';
--                    V_THOIGIANLAYBAOCAO := ' (TỪ NGÀY '|| TO_CHAR(VTUNGAY,'DD/MM/YYYY') || ' ĐẾN NGÀY '|| TO_CHAR(VDENNGAY,'DD/MM/YYYY') || ')';
--
--                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
--                    <tr style="margin-top: 0px;">
--                            <th style="text-align: center; vertical-align: middle; height: 45px; font-size: 14pt;" colspan="12">'||V_HOTEN || V_THOIGIANLAYBAOCAO ||'</th>
--                    </tr>                        
--                    <tr style="">
--                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng số</td>
--                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Trả lời đơn</td>
--                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Kháng nghị</td>
--                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Xếp đơn</td>
--                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Tổng</td>
--                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Chánh án kháng nghị</td>
--                            <td style="text-align: center; vertical-align: middle; border: 1pt solid Black;">Viện trưởng kháng nghị</td>
--                    </tr> 
--                   <tr style="font-style: italic; color: #adabab; font-size: 10pt; text-align: center;">
--                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">1</td>
--                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">2</td>
--                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">3</td>
--                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">4</td>
--                            <td style="text-align: center;vertical-align: middle;font-style: italic; border: 1pt solid Black;">5</td>
--                        </tr>
--                    ');
--                 
--                 
--               
--                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
--                            <tr>
--                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle; padding: 5px;">'||ITEMS.COLUMN_1||'</td>
--                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_2||'</td>            
--                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_3||'</td>
--                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_4||'</td>            
--                            <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||ITEMS.COLUMN_5||'</td>
--                            </tr>
--                        ');
--                    
--                    --if(item.stt > 1 and item.COUNTALL != item.stt) then
--                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
--                    <span style=''font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
--                            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
--                            mso-fareast-language:EN-US;mso-bidi-language:AR-SA''><br clear=all
--                            style=''mso-special-character:line-break;page-break-before:always''>
--                            </span>
--                    
--                            <p class=MsoNormal><o:p>&nbsp;</o:p></p>');
--              
--                
--                DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
--                      <tr style="height: 0px;">
--                        <td style="width: 47px"></td>
--                        <td style="width: 47px"></td>
--                        <td style="width: 47px"></td>
--                        <td style="width: 47px"></td>
--                        <td style="width: 47px"></td>
--                    </tr>
--               </table>
--           <span style="font-size:12.0pt;font-family:"Times New Roman",serif;mso-fareast-font-family:
--            "Times New Roman";mso-fareast-theme-font:minor-fareast;mso-ansi-language:EN-US;
--            mso-fareast-language:EN-US;mso-bidi-language:AR-SA"><br clear=all
--            style="mso-special-character:line-break;page-break-before:always">
--            </span>
--            <p class=MsoNormal><o:p></o:p></p>               
--        ');
--        
--        OPEN V_CURSOR FOR SELECT V_EXPORT_TEXT TEXT_REPORT FROM DUAL;          
--        DBMS_LOB.FREETEMPORARY(V_EXPORT_TEXT);        
--        RETURN V_CURSOR;  
--        
--END BAOCAO_TK_TAND_GET;


PROCEDURE  GET_THAMPHAN_TOICAO
(
  vToaAnID in VARCHAR2,
  vThamphan_id IN NUMBER,
  CurReturn OUT sys_refcursor 
) AS 


BEGIN

   open CurReturn for
        SELECT * FROM (   
            SELECT 0 ID, TRANSLATE ('--- Tất cả Thẩm phám ---' USING NCHAR_CS) AS HOTEN, TRANSLATE ('--- Tất cả Thẩm phám ---' USING NCHAR_CS) AS  FULL_HOTEN
            FROM DUAL
            
            UNION ALL
            
            SELECT D.ID, D.HOTEN || DECODE(CV.ID, 45, ' - CA', 74, ' - PCA', 446, ' - PCA', 1938, ' - PCA', '') AS HOTEN, DECODE(CV.TEN, NULL, '', CV.TEN || ' ') || D.HOTEN  AS FULL_HOTEN
            FROM DM_CANBO D
                LEFT JOIN DM_DATAITEM CV ON CV.ID = D.CHUCVUID AND CV.MA NOT LIKE 'CA'
                LEFT JOIN DM_DATAITEM CD ON CD.ID = D.CHUCDANHID
            WHERE D.TOAANID = vToaAnID AND D.HIEULUC = 1 
                AND (vThamphan_id = 0 OR vThamphan_id = D.ID)
                AND CD.MA LIKE 'TPTATC' -- Chỉ lấy TP TANDTC
                AND NOT EXISTS(SELECT DT.ID, DT.TEN FROM DM_DATAITEM DT WHERE DT.MA IN ('CA') AND DT.ID=D.CHUCVUID) -- Loại Chánh án ra khỏi danh sách
        )
        ORDER BY 
            CASE 
                WHEN ID = 0 THEN 1  -- Đưa ID = 0 lên đầu
                WHEN FULL_HOTEN LIKE '%Thường trực%' THEN 2
                WHEN HOTEN LIKE '%PCA' THEN 3  -- Đưa Phó Chánh án (PCA) sau ID = 0
                ELSE 4  -- Các nhân vật còn lại
            END,
            HOTEN;
    
END GET_THAMPHAN_TOICAO;



PROCEDURE DASHBOARD_GDT_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    V_TABLE T_GDTTT_DASHBOARD;
    V_TABLE_ALL T_GDTTT_DASHBOARD;
    vvToaAnID NUMBER;
    vCursur sys_refcursor;
    
    vCheck number;
    vTongCOLUMN_2 NUMBER:=0;vTongCOLUMN_3 NUMBER:=0;vTongCOLUMN_4 NUMBER:=0;vTongCOLUMN_5 NUMBER:=0;
    vTongCOLUMN_6 NUMBER:=0;vTongCOLUMN_7 NUMBER:=0;vTongCOLUMN_8 NUMBER:=0;vTongCOLUMN_9 NUMBER:=0;vTongCOLUMN_10 NUMBER:=0;
    vTongCOLUMN_11 NUMBER:=0;vTongCOLUMN_12 NUMBER:=0; vTongCOLUMN_13 NUMBER:=0;

    vTongALLCOLUMN_2 NUMBER:=0;vTongALLCOLUMN_3 NUMBER:=0;vTongALLCOLUMN_4 NUMBER:=0;vTongALLCOLUMN_5 NUMBER:=0;
    vTongALLCOLUMN_6 NUMBER:=0;vTongALLCOLUMN_7 NUMBER:=0;vTongALLCOLUMN_8 NUMBER:=0;vTongALLCOLUMN_9 NUMBER:=0;vTongALLCOLUMN_10 NUMBER:=0;
    vTongALLCOLUMN_11 NUMBER:=0;vTongALLCOLUMN_12 NUMBER:=0;vTongALLCOLUMN_13 NUMBER:=0;
   
   
   
    vViewhuyen varchar2(50);
BEGIN
    v_table := T_GDTTT_DASHBOARD();
    V_TABLE_ALL := T_GDTTT_DASHBOARD();

    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
    
--DBMS_OUTPUT.PUT_LINE(v_TIME_FROM );
--DBMS_OUTPUT.PUT_LINE(v_TIME_TO );

               ----COLUMN_2-------Phải giải quyết----------
               FOR item IN (

                SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_2
                         FROM (
                                SELECT d.BAQD_LOAIAN,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao> to_Date('01/01/2020','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1  
                                          AND d.ngaytao> to_Date('01/01/2020','dd/MM/yyyy')
                                          AND d.TL_NGAY between v_TIME_FROM and v_TIME_TO
                                UNION 
                                 SELECT d.BAQD_LOAIAN,d.ID 
                                          FROM GDTTT_DON d 
                                          where 
                                          NVL(d.LOAIDON,0) NOT IN(4)
                                          AND d.ngaytao> to_Date('01/01/2020','dd/MM/yyyy')
                                          AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                          AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                          AND D.ISTHULY = 1 
                                          AND  d.TL_NGAY < v_TIME_FROM                            
                                                 and ((d.BAQD_LOAIAN != 1 AND  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                                    WHERE DKQ.DONID = D.ID
                                                                            AND DKQ.TRANGTHAI = 1
                                                                            AND KQ.GQD_NGAYPHATHANHCV >= v_TIME_FROM))
                                                        or (d.BAQD_LOAIAN != 1 AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ  
                                                                                                        WHERE DKQ.DONID = D.ID 
                                                                                                        AND DKQ.TRANGTHAI = 1))            
                                                         or (d.BAQD_LOAIAN = 1  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4))  )  
                                                         OR (d.BAQD_LOAIAN = 1  AND EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                               WHERE v.ID = D.vuviecid and v.gqd_loaiketqua in (0,1,2,3,4)
                                                                                                        and v.GQD_NGAYPHATHANHCV >= v_TIME_FROM)  )                      
                                                                    )
                                        
                                    )C
                                    
                                GROUP BY  C.BAQD_LOAIAN

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        item.colnum_2,0,0,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;
                

                ------COLUMN_3 Đã giải quyết xong
                FOR item IN ( SELECT d.toaanid
                                  ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_3
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao > to_Date('01/01/2020','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                  AND( (d.BAQD_LOAIAN != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON DKQ   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE DKQ.DONID = D.ID 
                                                                AND DKQ.TRANGTHAI = 1
                                                                AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO))
                                                            
                                  OR (d.BAQD_LOAIAN  = 1 and ( EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                                                        WHERE v.ID = D.vuviecid 
                                                                                                            and v.gqd_loaiketqua in (2,3,4) 
                                                                                                            and v.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                                               OR  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                                        WHERE kqd.DONID = D.ID 
                                                                                                            and kqd.TYPETB in (3,4)
                                                                                                            and kqd.NGAYPHATHANH between v_TIME_FROM and v_TIME_TO 
                                                                                                            )    --TLD;KN                    
                                                                                )                                                                                            
                                                    )                                                                      
                                  )
                                  
                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,item.colnum_3,0,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;

--                
--                ----COLUMN_4---------tra loi don--------
                FOR item IN ( SELECT d.toaanid
                                   ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_4
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2020','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID 
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA = 0
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                   OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                        WHERE kqd.DONID = D.ID 
                                                                                            and kqd.TYPETB in (3)
                                                                                            and kqd.NGAYPHATHANH between v_TIME_FROM and v_TIME_TO 
                                                                                            )    --TLD                   
                                                            )                                                                                                              
                                                    )                                                                      
                                                            
                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,item.colnum_4,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;
--                 ----COLUMN_5---kn--------------
               FOR item IN ( SELECT d.toaanid
                                 ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_5
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2020','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                  AND( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA = 1
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                       OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_DON_TRALOI kqd 
                                                                                            WHERE kqd.DONID = D.ID 
                                                                                                and kqd.TYPETB in (4)
                                                                                                and kqd.NGAYPHATHANH between v_TIME_FROM and v_TIME_TO 
                                                                                                )    --KN                   
                                                               )                                                                                                               
                                                    )                                                    
                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,item.colnum_5,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;
--                 ----COLUMN_6----Xep don-------------
               FOR item IN ( SELECT d.toaanid
                                  ,d.BAQD_LOAIAN TENLOAIAN,count(D.id) colnum_6
                                  FROM GDTTT_DON d 
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2020','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                  AND ( (d.BAQD_LOAIAN  != 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA_DON KQD   
                                                            LEFT JOIN GDTTT_VUAN_KETQUA KQ ON KQD.VUAN_KETQUA_ID = KQ.ID
                                                            WHERE KQD.DONID = D.ID 
                                                            AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                            AND KQ.GQD_LOAIKETQUA IN (2,3,4)
                                                            AND KQD.TRANGTHAI = 1
                                                            )
                                                        )
                                          OR (d.BAQD_LOAIAN  = 1 and  EXISTS(SELECT 'X' FROM GDTTT_VUAN v 
                                                                            WHERE v.ID = D.vuviecid 
                                                                                and v.gqd_loaiketqua in (2,3,4) 
                                                                                and v.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO) ---XEP DON
                                                               )
                                            )
                                  GROUP BY  d.toaanid,d.BAQD_LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,item.colnum_6,0,0,0,0,
                        0,0
                        );   
                END LOOP;
               
                -- ----COLUMN_7-----------------
               FOR item IN (
                    SELECT C.BAQD_LOAIAN TENLOAIAN,count(C.id) colnum_7
                              FROM(
                                SELECT d.BAQD_LOAIAN,d.ID
                                  FROM GDTTT_DON d 
                                    LEFT JOIN GDTTT_VUAN_KETQUA_DON DKQ ON DKQ.DONID = D.ID AND DKQ.TRANGTHAI = 1
                                    LEFT JOIN GDTTT_VUAN_KETQUA KQ ON DKQ.VUAN_KETQUA_ID = KQ.ID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2020','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  AND d.BAQD_LOAIAN != 1 
                                  and (KQ.GQD_NGAYPHATHANHCV IS NULL OR KQ.GQD_NGAYPHATHANHCV > v_TIME_TO)
                                 UNION
                                SELECT d.BAQD_LOAIAN,d.ID
                                  FROM GDTTT_DON d 
                                  LEFT JOIN GDTTT_VUAN V ON V.ID = D.VUVIECID
                                  where 
                                  NVL(d.LOAIDON,0) NOT IN(4)
                                  AND d.ngaytao> to_Date('01/01/2020','dd/MM/yyyy')
                                  AND d.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)
                                  AND D.ISTHULY = 1
                                  AND d.TL_NGAY <= v_TIME_TO 
                                  AND d.BAQD_LOAIAN = 1              
                                  and ( v.gqd_loaiketqua IS NULL 
                                        OR  v.GQD_NGAYPHATHANHCV > v_TIME_TO
                                        )   
                                 )C
                                 
                                  GROUP BY C.BAQD_LOAIAN   
                                  
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,item.colnum_7,0,0,0,
                        0,0
                        );   
                END LOOP;
              
--   ----COLUMN_8-----------------Tong phải xet xu
              FOR item IN (select c.TENLOAIAN, count(c.id) colnum_8 
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)                                      
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is null )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND d.THAMQUYENXXGDT = 1
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,item.colnum_8,0,0
                        ,0,0
                        );   
                END LOOP;
 --            ----COLUMN_9----------------- Tong so kháng nghị CA
                FOR item IN ( select c.TENLOAIAN, count(c.id) colnum_9
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)                                      
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is null )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND NVL(d.TRUONGHOPTHULY,0) != 1
                                      AND d.THAMQUYENXXGDT = 1
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN   
                                    
                                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,item.colnum_9,0,
                        0,0
                        );   
                END LOOP;
 --            ----COLUMN_10----------------- Tong so kháng nghị VKS
                FOR item IN (
                       select c.TENLOAIAN, count(c.id) colnum_10
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)                                      
                                      AND (d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is null )
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and d.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND NVL(d.TRUONGHOPTHULY,0) = 1
                                      AND d.THAMQUYENXXGDT = 1
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN   
                           )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,item.colnum_10,
                        0,0
                        );   
                END LOOP;  
--                ----COLUMN_11-----------------Đã  xét xử gdtt
              FOR item IN (                                     
                      select c.TENLOAIAN, count(c.id) colnum_11
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)  
                                      AND  EXISTS(select 'X' from gdttt_vuan_xetxugdttt kq where d.ID = kq.VUANID and NVL(kq.ishoan,0) = 0 and kq.NGAYMOPT between v_TIME_FROM and v_TIME_TO )
                                      --AND  d.XXGDTTT_NGAYQD between v_TIME_FROM and v_TIME_TO 
                                      AND d.THAMQUYENXXGDT = 1
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN       
                                    
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,
                        item.colnum_11,0
                        );   
                END LOOP;                
 --                ----COLUMN_12-----------------Chua xét xử gdtt
              FOR item IN (     
                         select c.TENLOAIAN, count(c.id) colnum_12
                                from(
                                    SELECT d.toaanid,d.id
                                           ,d.LOAIAN TENLOAIAN
                                             FROM GDTTT_VUAN d  
                                      where 
                                      d.toaanid = vToaAnID --sau se truyen don vi vao
                                       AND (vThamphanid = 0 or d.THAMPHANID = vThamphanid)                                      
                                      AND ((d.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO  and (d.XXGDTTT_NGAYQD is null  OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and (d.XXGDTTT_NGAYQD is null OR to_char(d.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (d.NGAYTHULYXXGDT < v_TIME_FROM and d.XXGDTTT_NGAYQD is not null and d.XXGDTTT_NGAYQD > v_TIME_TO))     
                                      AND d.THAMQUYENXXGDT = 1
                                      GROUP BY  d.toaanid,d.id,d.LOAIAN)C
                                    group by c.TENLOAIAN               
                                    
                                    
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0
                        ,0,item.colnum_12
                        );   
                END LOOP;               

    
                vTongALLCOLUMN_2 :=0;vTongALLCOLUMN_3 :=0;vTongALLCOLUMN_4 :=0;vTongALLCOLUMN_5 :=0;vTongALLCOLUMN_6 :=0;
                vTongALLCOLUMN_7 :=0;vTongALLCOLUMN_8 :=0;vTongALLCOLUMN_9 :=0;vTongALLCOLUMN_10 :=0;vTongALLCOLUMN_11 :=0;
                vTongALLCOLUMN_12 :=0;
                FOR itemdv IN (SELECT LA.THUTU,TK.TENLOAIAN,la.loai_an_ten LOAIAN,
                                        sum(tk.COLUMN_1) COLUMN_1,sum(tk.COLUMN_2) COLUMN_2,
                                        sum(tk.COLUMN_3) COLUMN_3,sum(tk.COLUMN_4) COLUMN_4,
                                        sum(tk.COLUMN_5) COLUMN_5,sum(tk.COLUMN_6) COLUMN_6,
                                        sum(tk.COLUMN_7) COLUMN_7,sum(tk.COLUMN_8) COLUMN_8,
                                        sum(tk.COLUMN_9) COLUMN_9,sum(tk.COLUMN_10) COLUMN_10,
                                        sum(tk.COLUMN_11) COLUMN_11     
                                                  FROM table(v_table) tk 
                                                   LEFT JOIN DM_LOAIAN LA ON LA.ID=tk.TENLOAIAN                                                    
                                                        group by LA.THUTU,tk.TENLOAIAN,la.loai_an_ten ORDER BY LA.THUTU
                                    )
                                    
                LOOP
                  
                        V_TABLE_ALL.extend;
                        V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_DASHBOARD(
                            itemdv.LOAIAN,itemdv.COLUMN_1,itemdv.COLUMN_2,itemdv.COLUMN_3,itemdv.COLUMN_4,itemdv.COLUMN_5,itemdv.COLUMN_6,
                            itemdv.COLUMN_7,itemdv.COLUMN_8,itemdv.COLUMN_9,itemdv.COLUMN_10,itemdv.COLUMN_11
                            ); 
                       
                            
                            
                END LOOP;  
       

   --------------------------
   OPEN curReturn FOR 
        select * from table(V_TABLE_ALL);


END;

PROCEDURE DASHBOARD_GDT_QH_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    V_TABLE T_GDTTT_DASHBOARD;
    V_TABLE_ALL T_GDTTT_DASHBOARD;
    vvToaAnID NUMBER;
    vCursur sys_refcursor;
    
    vCheck number;
    vTongCOLUMN_2 NUMBER:=0;vTongCOLUMN_3 NUMBER:=0;vTongCOLUMN_4 NUMBER:=0;vTongCOLUMN_5 NUMBER:=0;
    vTongCOLUMN_6 NUMBER:=0;vTongCOLUMN_7 NUMBER:=0;vTongCOLUMN_8 NUMBER:=0;vTongCOLUMN_9 NUMBER:=0;vTongCOLUMN_10 NUMBER:=0;
    vTongCOLUMN_11 NUMBER:=0;vTongCOLUMN_12 NUMBER:=0; vTongCOLUMN_13 NUMBER:=0;

    vTongALLCOLUMN_2 NUMBER:=0;vTongALLCOLUMN_3 NUMBER:=0;vTongALLCOLUMN_4 NUMBER:=0;vTongALLCOLUMN_5 NUMBER:=0;
    vTongALLCOLUMN_6 NUMBER:=0;vTongALLCOLUMN_7 NUMBER:=0;vTongALLCOLUMN_8 NUMBER:=0;vTongALLCOLUMN_9 NUMBER:=0;vTongALLCOLUMN_10 NUMBER:=0;
    vTongALLCOLUMN_11 NUMBER:=0;vTongALLCOLUMN_12 NUMBER:=0;vTongALLCOLUMN_13 NUMBER:=0;
   
   
   
    vViewhuyen varchar2(50);
BEGIN
    v_table := T_GDTTT_DASHBOARD();
    V_TABLE_ALL := T_GDTTT_DASHBOARD();

    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
    
--DBMS_OUTPUT.PUT_LINE(v_TIME_FROM );
--DBMS_OUTPUT.PUT_LINE(v_TIME_TO );

               ----COLUMN_2-------Phải giải quyết----------
               FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_2
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)
                                  AND (v.NGAYTAO between v_TIME_FROM and v_TIME_TO
                                        OR (v.NGAYTAO < v_TIME_FROM 
                                                and  (v.LOAIAN != 1 and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID)) 
                                                and  (v.LOAIAN = 1 and  v.gqd_loaiketqua not in (0,1,2,3,4))
                                                )  
                                        OR (v.NGAYTAO < v_TIME_FROM
                                                and ( v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID AND KQ.GQD_NGAYPHATHANHCV >= v_TIME_FROM))
                                                and  (v.LOAIAN = 1 and  v.gqd_loaiketqua  in (0,1,2,3,4) and v.GQD_NGAYPHATHANHCV >= v_TIME_FROM)
                                                )
                                  )
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                  GROUP BY  v.LOAIAN

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        item.colnum_2,0,0,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;


                ------COLUMN_3 Đã giải quyết xong
                FOR item IN (SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_3
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                  AND (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO))
                                  AND (v.LOAIAN = 1  and v.gqd_loaiketqua  in (0,1,2,3,4) and v.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO)                     
                                  GROUP BY  v.LOAIAN
                                  
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,item.colnum_3,0,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;

--                
--                ----COLUMN_4---------tra loi don--------
                FOR item IN (SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_4
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                   AND (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                                            AND KQ.GQD_LOAIKETQUA = 0
                                                                            ))
                                  AND (v.LOAIAN = 1 and v.gqd_loaiketqua  in (0) and v.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO)                                           
                                                        
                                  GROUP BY  v.LOAIAN                                  
                                  
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,item.colnum_4,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;
--                 ----COLUMN_5---kn--------------
               FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_5
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                   AND (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                                            AND KQ.GQD_LOAIKETQUA = 1 --KN
                                                                            ))
                                  AND (v.LOAIAN = 1 and v.gqd_loaiketqua  in (1) and v.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO)         
                                                        
                                  GROUP BY  v.LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,item.colnum_5,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;
--                 ----COLUMN_6----Xep don-------------
               FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_6
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                   AND (v.LOAIAN != 1 and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                                        WHERE KQ.VUANID = v.ID 
                                                                            AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                                            AND KQ.GQD_LOAIKETQUA in (2,3,4)
                                                                            ))
                                   AND (v.LOAIAN = 1 and v.gqd_loaiketqua  in (2,3,4) and v.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO)       
                                                        
                                  GROUP BY  v.LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,item.colnum_6,0,0,0,0,
                        0,0
                        );   
                END LOOP;
                
                -- ----COLUMN_7-------chua co ket qua----------
               FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_7
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)
                                  AND v.NGAYTAO <= v_TIME_TO
                                  
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                 and  (v.LOAIAN != 1 and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID)) 
                                 and  (v.LOAIAN = 1 and  v.gqd_loaiketqua not in (0,1,2,3,4))                          
                                                            
                                  GROUP BY  v.LOAIAN
                                  
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,item.colnum_7,0,0,0,
                        0,0
                        );   
                END LOOP;
--   ----COLUMN_8-----------------Tong phải xet xu
              FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_8
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  AND (v.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is null )
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is not null and v.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND v.THAMQUYENXXGDT = 1
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                                            
                                  GROUP BY  v.LOAIAN         
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,item.colnum_8,0,0
                        ,0,0
                        );   
                END LOOP;
 --            ----COLUMN_9----------------- Tong so kháng nghị CA
                FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_9
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  AND (v.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is null )
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is not null and v.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND v.THAMQUYENXXGDT = 1
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                  AND NVL(V.TRUONGHOPTHULY,0) != 1
                                                            
                                  GROUP BY  v.LOAIAN   
                                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,item.colnum_9,0,
                        0,0
                        );   
                END LOOP;
 --            ----COLUMN_10----------------- Tong so kháng nghị VKS
                FOR item IN (SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_10
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  AND (v.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is null )
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is not null and v.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND v.THAMQUYENXXGDT = 1
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                  AND NVL(V.TRUONGHOPTHULY,0) = 1
                                  GROUP BY  v.LOAIAN   
                           )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,item.colnum_10,
                        0,0
                        );   
                END LOOP;  
--                ----COLUMN_11-----------------Đã  xét xử gdtt
              FOR item IN (SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_11
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  AND  EXISTS(select 'X' from gdttt_vuan_xetxugdttt kq where v.ID = kq.VUANID and NVL(kq.ishoan,0) = 0 and kq.NGAYMOPT between v_TIME_FROM and v_TIME_TO )     
                                  AND v.THAMQUYENXXGDT = 1
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                  GROUP BY  v.LOAIAN     
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,
                        item.colnum_11,0
                        );   
                END LOOP;                
 --                ----COLUMN_12-----------------Chua xét xử gdtt
              FOR item IN (SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_12
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                   AND ((v.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO  and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and (v.XXGDTTT_NGAYQD is null OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is not null and v.XXGDTTT_NGAYQD > v_TIME_TO))
                                  AND v.THAMQUYENXXGDT = 1
                                  And EXISTS(select 'X' from GDTTT_DON d 
                                                        where d.LOAICONGVAN in(Select TEM.ID from DM_DATAITEM TEM 
                                                                        where  TEM.ma like 'CV9.3%' OR TEM.ma like 'CV8.1%')
                                                            AND d.VuViecID = v.ID)
                                  GROUP BY  v.LOAIAN     
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0
                        ,0,item.colnum_12
                        );   
                END LOOP;               

    
                vTongALLCOLUMN_2 :=0;vTongALLCOLUMN_3 :=0;vTongALLCOLUMN_4 :=0;vTongALLCOLUMN_5 :=0;vTongALLCOLUMN_6 :=0;
                vTongALLCOLUMN_7 :=0;vTongALLCOLUMN_8 :=0;vTongALLCOLUMN_9 :=0;vTongALLCOLUMN_10 :=0;vTongALLCOLUMN_11 :=0;
                vTongALLCOLUMN_12 :=0;
                FOR itemdv IN (SELECT LA.THUTU,TK.TENLOAIAN,la.loai_an_ten LOAIAN,
                                        sum(tk.COLUMN_1) COLUMN_1,sum(tk.COLUMN_2) COLUMN_2,
                                        sum(tk.COLUMN_3) COLUMN_3,sum(tk.COLUMN_4) COLUMN_4,
                                        sum(tk.COLUMN_5) COLUMN_5,sum(tk.COLUMN_6) COLUMN_6,
                                        sum(tk.COLUMN_7) COLUMN_7,sum(tk.COLUMN_8) COLUMN_8,
                                        sum(tk.COLUMN_9) COLUMN_9,sum(tk.COLUMN_10) COLUMN_10,
                                        sum(tk.COLUMN_11) COLUMN_11     
                                                  FROM table(v_table) tk 
                                                   LEFT JOIN DM_LOAIAN LA ON LA.ID=tk.TENLOAIAN                                                    
                                                        group by LA.THUTU,tk.TENLOAIAN,la.loai_an_ten ORDER BY LA.THUTU
                                    )
                                    
                LOOP
                  
                        V_TABLE_ALL.extend;
                        V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_DASHBOARD(
                            itemdv.LOAIAN,itemdv.COLUMN_1,itemdv.COLUMN_2,itemdv.COLUMN_3,itemdv.COLUMN_4,itemdv.COLUMN_5,itemdv.COLUMN_6,
                            itemdv.COLUMN_7,itemdv.COLUMN_8,itemdv.COLUMN_9,itemdv.COLUMN_10,itemdv.COLUMN_11
                            ); 
                       
                            
                            
                END LOOP;  
       

   --------------------------
   OPEN curReturn FOR 
        select * from table(V_TABLE_ALL);


END;


PROCEDURE DASHBOARD_GDT_THOIHIEU_EXP
(  
    vToaAnID	in	VARCHAR2,
    vThamphanid in number,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    V_TABLE T_GDTTT_DASHBOARD;
    V_TABLE_ALL T_GDTTT_DASHBOARD;
    vvToaAnID NUMBER;
    vCursur sys_refcursor;
    
    vCheck number;
    vTongCOLUMN_2 NUMBER:=0;vTongCOLUMN_3 NUMBER:=0;vTongCOLUMN_4 NUMBER:=0;vTongCOLUMN_5 NUMBER:=0;
    vTongCOLUMN_6 NUMBER:=0;vTongCOLUMN_7 NUMBER:=0;vTongCOLUMN_8 NUMBER:=0;vTongCOLUMN_9 NUMBER:=0;vTongCOLUMN_10 NUMBER:=0;
    vTongCOLUMN_11 NUMBER:=0;vTongCOLUMN_12 NUMBER:=0; vTongCOLUMN_13 NUMBER:=0;

    vTongALLCOLUMN_2 NUMBER:=0;vTongALLCOLUMN_3 NUMBER:=0;vTongALLCOLUMN_4 NUMBER:=0;vTongALLCOLUMN_5 NUMBER:=0;
    vTongALLCOLUMN_6 NUMBER:=0;vTongALLCOLUMN_7 NUMBER:=0;vTongALLCOLUMN_8 NUMBER:=0;vTongALLCOLUMN_9 NUMBER:=0;vTongALLCOLUMN_10 NUMBER:=0;
    vTongALLCOLUMN_11 NUMBER:=0;vTongALLCOLUMN_12 NUMBER:=0;vTongALLCOLUMN_13 NUMBER:=0;
   
   
   
    vViewhuyen varchar2(50);
BEGIN
    v_table := T_GDTTT_DASHBOARD();
    V_TABLE_ALL := T_GDTTT_DASHBOARD();

    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
    
--DBMS_OUTPUT.PUT_LINE(v_TIME_FROM );
--DBMS_OUTPUT.PUT_LINE(v_TIME_TO );

               ----COLUMN_2-------Phải giải quyết----------
               FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_2
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)
                                  AND (v.NGAYTAO between v_TIME_FROM and v_TIME_TO
                                        OR (v.NGAYTAO < v_TIME_FROM and NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID))
                                        OR (v.NGAYTAO < v_TIME_FROM and EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID AND KQ.GQD_NGAYPHATHANHCV >= v_TIME_FROM))
                                  )
                                  AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90                                                            
                                  GROUP BY  v.LOAIAN

                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        item.colnum_2,0,0,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;


                ------COLUMN_3 Đã giải quyết xong
                FOR item IN (SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_3
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid) 
                                  AND  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO)
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90                      
                                  GROUP BY  v.LOAIAN
                                  
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,item.colnum_3,0,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;

--                
--                ----COLUMN_4---------tra loi don--------
                FOR item IN (SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_4
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid) 
                                --- Co ket qua la tra loi don va khong co ket qua nao la khang nghi
                                  AND  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                    WHERE KQ.VUANID = v.ID 
                                                        AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                        AND KQ.GQD_LOAIKETQUA = 0)
                                  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                    WHERE KQ.VUANID = v.ID 
                                                        AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                        AND KQ.GQD_LOAIKETQUA = 1)
                                  AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90                       
                                  GROUP BY  v.LOAIAN                                  
                                  
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,item.colnum_4,0,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;
--                 ----COLUMN_5---kn--------------
               FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_5
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                 
                                  AND  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                    WHERE KQ.VUANID = v.ID 
                                                        AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                        AND KQ.GQD_LOAIKETQUA = 1)
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                                                        
                                  GROUP BY  v.LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,item.colnum_5,0,0,0,0,0,
                        0,0
                        );   
                END LOOP;
--                 ----COLUMN_6----Xep don-------------
               FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_6
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                 
                                 
                                  ---Co ket qua la xu ly khac, xep don, vks dang gq va khong co kq nao là tld va kn                          
                                  AND  EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                    WHERE KQ.VUANID = v.ID 
                                                        AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                        AND KQ.GQD_LOAIKETQUA in (2,3,4))
                                  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ 
                                                    WHERE KQ.VUANID = v.ID 
                                                        AND KQ.GQD_NGAYPHATHANHCV between v_TIME_FROM and v_TIME_TO
                                                        AND KQ.GQD_LOAIKETQUA in (0,1))
                                              
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                                                        
                                  GROUP BY  v.LOAIAN
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,item.colnum_6,0,0,0,0,
                        0,0
                        );   
                END LOOP;
                
                -- ----COLUMN_7-------chua co ket qua----------
               FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_7
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)
                                  AND v.NGAYTAO <= v_TIME_TO
                                  AND NOT EXISTS(SELECT 'X' FROM GDTTT_VUAN_KETQUA KQ WHERE KQ.VUANID = v.ID)
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                                 
                                  GROUP BY  v.LOAIAN
                                  
                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,item.colnum_7,0,0,0,
                        0,0
                        );   
                END LOOP;
--   ----COLUMN_8-----------------Tong phải xet xu
              FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_8
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  AND (v.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is null )
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is not null and v.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                   AND v.THAMQUYENXXGDT = 1
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                                                            
                                  GROUP BY  v.LOAIAN         
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,item.colnum_8,0,0
                        ,0,0
                        );   
                END LOOP;
 --            ----COLUMN_9----------------- Tong so kháng nghị CA
                FOR item IN ( SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_9
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  AND (v.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is null )
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is not null and v.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND v.THAMQUYENXXGDT = 1
                                  AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                                                        
                                  AND NVL(V.TRUONGHOPTHULY,0) != 1
                                                            
                                  GROUP BY  v.LOAIAN   
                                                  )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,item.colnum_9,0,
                        0,0
                        );   
                END LOOP;
 --            ----COLUMN_10----------------- Tong so kháng nghị VKS
                FOR item IN (SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_10
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  AND (v.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is null )
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is not null and v.XXGDTTT_NGAYQD >= v_TIME_FROM))     
                                      AND v.THAMQUYENXXGDT = 1
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                                  AND NVL(V.TRUONGHOPTHULY,0) = 1
                                  GROUP BY  v.LOAIAN   
                           )
                LOOP
                        v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,item.colnum_10,
                        0,0
                        );   
                END LOOP;  
--                ----COLUMN_11-----------------Đã  xét xử gdtt
              FOR item IN (SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_11
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                  AND  EXISTS(select 'X' from gdttt_vuan_xetxugdttt kq where v.ID = kq.VUANID and NVL(kq.ishoan,0) = 0 and kq.NGAYMOPT between v_TIME_FROM and v_TIME_TO )     
                                  AND v.THAMQUYENXXGDT = 1
                                   AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                                  GROUP BY  v.LOAIAN     
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0,
                        item.colnum_11,0
                        );   
                END LOOP;                
 --                ----COLUMN_12-----------------Chua xét xử gdtt
              FOR item IN (SELECT v.LOAIAN TENLOAIAN,count(v.id) colnum_12
                                  FROM GDTTT_VUAN V 
                                  where 
                                   v.toaanid = vToaAnID --sau se truyen don vi vao
                                  AND (vThamphanid = 0 or v.THAMPHANID = vThamphanid)                                  
                                   AND ((v.NGAYTHULYXXGDT between v_TIME_FROM and v_TIME_TO  and (v.XXGDTTT_NGAYQD is null  OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and (v.XXGDTTT_NGAYQD is null OR to_char(v.XXGDTTT_NGAYQD,'dd/MM/yyyy') = '01/01/0001' ))
                                           OR  (v.NGAYTHULYXXGDT < v_TIME_FROM and v.XXGDTTT_NGAYQD is not null and v.XXGDTTT_NGAYQD > v_TIME_TO))
                                  AND v.THAMQUYENXXGDT = 1
                                  AND PKG_GDTTT_BAOCAO_APP.CHECK_ANTHOIHIEU(NVL(v.LoaiAn,0), 
                                                        DECODE(v.BAQD_CAPXETXU,4,v.NGAYQD,2,v.NGAYXUSOTHAM,v.NGAYXUPHUCTHAM),
                                                        v.NGAYXUSOTHAM, NVL(v.ThuLyLai_VuAnId, 0),v.NGAYTHULYDON)<90
                                  GROUP BY  v.LOAIAN     
                                  )
                LOOP
                         v_table.extend;
                        v_table(v_table.count) := R_GDTTT_DASHBOARD(
                        item.TENLOAIAN,
                        0,0,0,0,0,0,0,0,0
                        ,0,item.colnum_12
                        );   
                END LOOP;               

    
                vTongALLCOLUMN_2 :=0;vTongALLCOLUMN_3 :=0;vTongALLCOLUMN_4 :=0;vTongALLCOLUMN_5 :=0;vTongALLCOLUMN_6 :=0;
                vTongALLCOLUMN_7 :=0;vTongALLCOLUMN_8 :=0;vTongALLCOLUMN_9 :=0;vTongALLCOLUMN_10 :=0;vTongALLCOLUMN_11 :=0;
                vTongALLCOLUMN_12 :=0;
                FOR itemdv IN (SELECT LA.THUTU,TK.TENLOAIAN,la.loai_an_ten LOAIAN,
                                        sum(tk.COLUMN_1) COLUMN_1,sum(tk.COLUMN_2) COLUMN_2,
                                        sum(tk.COLUMN_3) COLUMN_3,sum(tk.COLUMN_4) COLUMN_4,
                                        sum(tk.COLUMN_5) COLUMN_5,sum(tk.COLUMN_6) COLUMN_6,
                                        sum(tk.COLUMN_7) COLUMN_7,sum(tk.COLUMN_8) COLUMN_8,
                                        sum(tk.COLUMN_9) COLUMN_9,sum(tk.COLUMN_10) COLUMN_10,
                                        sum(tk.COLUMN_11) COLUMN_11     
                                                  FROM table(v_table) tk 
                                                   LEFT JOIN DM_LOAIAN LA ON LA.ID=tk.TENLOAIAN                                                    
                                                        group by LA.THUTU,tk.TENLOAIAN,la.loai_an_ten ORDER BY LA.THUTU
                                    )
                                    
                LOOP
                  
                        V_TABLE_ALL.extend;
                        V_TABLE_ALL(V_TABLE_ALL.count) := R_GDTTT_DASHBOARD(
                            itemdv.LOAIAN,itemdv.COLUMN_1,itemdv.COLUMN_2,itemdv.COLUMN_3,itemdv.COLUMN_4,itemdv.COLUMN_5,itemdv.COLUMN_6,
                            itemdv.COLUMN_7,itemdv.COLUMN_8,itemdv.COLUMN_9,itemdv.COLUMN_10,itemdv.COLUMN_11
                            ); 
                       
                            
                            
                END LOOP;  
       

   --------------------------
   OPEN curReturn FOR 
        select * from table(V_TABLE_ALL);


END;

PROCEDURE DASHBOARD_STPT_EXP
(  
    vToaAnID	in	VARCHAR2,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2,
    vTuNgayTruoc	in VARCHAR2,
    vDenNgayTruoc	in VARCHAR2,
    curReturn OUT sys_refcursor 
)
AS
    v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);  
    v_from_truoc date;v_to_truoc date;
    V_TABLE T_GDTTT_DASHBOARD;
    V_TABLE_ALL T_GDTTT_DASHBOARD;
    v_table_qlta  T_GDTTT_DASHBOARD;
    v_table_ds T_TYLEGQ_CA;
    
    
     
    vvToaAnID NUMBER;
    vCursur sys_refcursor;
    vTren50  NUMBER;vDuoi50  NUMBER;
    vCheck number;
    vTongCOLUMN_2 NUMBER:=0;vTongCOLUMN_3 NUMBER:=0;vTongCOLUMN_4 NUMBER:=0;vTongCOLUMN_5 NUMBER:=0;
    vTongCOLUMN_6 NUMBER:=0;vTongCOLUMN_7 NUMBER:=0;vTongCOLUMN_8 NUMBER:=0;

    vTongALLCOLUMN_2 NUMBER:=0;vTongALLCOLUMN_3 NUMBER:=0;vTongALLCOLUMN_4 NUMBER:=0;vTongALLCOLUMN_5 NUMBER:=0;
    vTongALLCOLUMN_6 NUMBER:=0;vTongALLCOLUMN_7 NUMBER:=0;vTongALLCOLUMN_8 NUMBER:=0;
   
    vViewhuyen varchar2(50);
    vTongThuLy number; vTongGiaiQuyet number; vTongTren50 number; vTyLeLech number;
    vTongThuLy_truoc number; vTongGiaiQuyet_truoc number;
    vTyleTruoc number; vTyle number;
    vTangGiam varchar2(10);
    vTongSoDonvi number; 


BEGIN
    v_table := T_GDTTT_DASHBOARD();
    V_TABLE_ALL := T_GDTTT_DASHBOARD();
    v_table_qlta := T_GDTTT_DASHBOARD(); 
    v_table_ds := T_TYLEGQ_CA(); 
    
    v_TIME_FROM:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    v_TIME_TO:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
    
    v_from_truoc:=TO_DATE(vTuNgayTruoc ||'00:00:00', 'dd/MM/yyyy hh24:mi:ss');
    v_to_truoc:=TO_DATE(vDenNgayTruoc||'23:59:59', 'dd/MM/yyyy  hh24:mi:ss');      



               ----COLUMN_2-------Tổng số vụ án thụ lý sơ thẩm và phuc thẩm----------
             SELECT count(v.toaanid) into vTongThuLy
                                  FROM DASHBOARD_STPT v 
                                  where 
                                   (vToaAnID = 0 or v.toaanid = vToaAnID)
                                  AND (v.NGAYTHULY between v_TIME_FROM and v_TIME_TO
                                        OR (v.NGAYTHULY < v_TIME_FROM and v.KQLOAI is null)
                                        OR (v.NGAYTHULY < v_TIME_FROM and v.KQLOAI is not null and v.KQNGAY>= v_TIME_FROM)
                                  );
                                  
            SELECT count(v.toaanid) into vTongThuLy_truoc
                                  FROM DASHBOARD_STPT v 
                                  where 
                                   (vToaAnID = 0 or v.toaanid = vToaAnID)
                                  AND (v.NGAYTHULY between v_from_truoc and v_to_truoc
                                        OR (v.NGAYTHULY < v_from_truoc and v.KQLOAI is null)
                                        OR (v.NGAYTHULY < v_from_truoc and v.KQLOAI is not null and v.KQNGAY>= v_from_truoc)
                                  );
              
                ------COLUMN_3 Tổng số giải quyết	
              SELECT count(v.toaanid) into vTongGiaiQuyet
                                  FROM DASHBOARD_STPT v 
                                  where 
                                    (vToaAnID = 0 or v.toaanid = vToaAnID)
                                    AND (v.KQNGAY between v_TIME_FROM and v_TIME_TO)
                                    AND v.KQLOAI is not null
                             ;
                             
              SELECT count(v.toaanid) into vTongGiaiQuyet_truoc
                                  FROM DASHBOARD_STPT v 
                                  where 
                                    (vToaAnID = 0 or v.toaanid = vToaAnID)
                                    AND (v.KQNGAY between v_from_truoc and v_to_truoc)
                                    AND v.KQLOAI is not null
                             ;
                             
                     if (vTongThuLy > 0) then     
                        vTyle :=   ROUND((vTongGiaiQuyet/vTongThuLy)*100,1);  
                     else
                        vTyle :=   0;  
                     end if;
                     
                     if (vTongThuLy_truoc > 0) then
                        vTyleTruoc:=ROUND((vTongGiaiQuyet_truoc/vTongThuLy_truoc)*100,1) ;   
                     else
                        vTyleTruoc:=0 ;   
                     end if;
                     
                     vTyLeLech := vTyle - vTyleTruoc;
                     if (vTyle > vTyleTruoc ) then
                        vTangGiam := 'Tăng';
                     else
                        vTangGiam := 'Giảm';
                     end if;

--    tren50,( 765 - v_count_ta) as duoi50
             ----01.Tong so phai giai quyet trong ky-COLUMN_1---------
                 FOR item_sum IN 
                        ( SELECT C.COURT_ID, count(C.COURT_ID) COLUMN_1 FROM(
                            select hs.TOAANID COURT_ID from GSCM.DASHBOARD_STPT hs 
                                            LEFT JOIN GSCM.dm_toaan TA on ta.id=hs.toaanid
                                                where
                                                  (vToaAnID = 0 or hs.TOAANID = vToaAnID)
                                                  AND( hs.ngaythuly BETWEEN v_TIME_FROM and v_TIME_TO
                                                         OR (hs.ngaythuly < v_TIME_FROM and hs.KQLOAI is null)
                                                         OR (hs.ngaythuly < v_TIME_FROM and hs.KQLOAI is not null and  hs.KQNGAY >= v_TIME_FROM))
                                                  AND ta.BAOCAO=1               
            
                                    ) C
                                  GROUP BY C.COURT_ID               
                            )
                    LOOP 
                            v_table_qlta.extend;
                            v_table_qlta(v_table_qlta.count) := R_GDTTT_DASHBOARD(
                                    item_sum.COURT_ID,
                                    item_sum.COLUMN_1,0,0,0,0,0,0,0,0,
                                    0,0
                                    );   
            
                    END LOOP;
                 
                 ----02.Tong so đã giai quyet trong ky-COLUMN_1---------2
                     FOR item_sum IN 
                        ( SELECT C.COURT_ID, count(C.COURT_ID) COLUMN_2 FROM(
                            select hs.TOAANID COURT_ID from GSCM.DASHBOARD_STPT hs 
                                            LEFT JOIN GSCM.dm_toaan TA on ta.id=hs.toaanid
                                                where
                                                  (vToaAnID = 0 or hs.TOAANID = vToaAnID)
                                                  AND hs.KQNGAY BETWEEN v_TIME_FROM and v_TIME_TO
                                                  AND ta.BAOCAO=1               
            
                                    ) C
            
                                  GROUP BY C.COURT_ID               
                            )
                    LOOP 
                            v_table_qlta.extend;
                            v_table_qlta(v_table_qlta.count) := R_GDTTT_DASHBOARD(
                                    item_sum.COURT_ID,
                                    0,item_sum.COLUMN_2,0,0,0,0,0,0,0,
                                    0,0
                                    );   
            
                    END LOOP;  
                    
                --- 03. Tông giai quyet cua ky truoc
                  FOR item_sum IN 
                        ( SELECT C.COURT_ID, count(*) COLUMN_3 FROM(
                            select hs.TOAANID COURT_ID from GSCM.DASHBOARD_STPT hs 
                                            LEFT JOIN GSCM.dm_toaan TA on ta.id=hs.toaanid
                                                where
                                                  (vToaAnID = 0 or hs.TOAANID = vToaAnID)
                                                  AND( hs.ngaythuly BETWEEN v_from_truoc and v_to_truoc
                                                         OR (hs.ngaythuly < v_from_truoc and hs.KQLOAI is null)
                                                         OR (hs.ngaythuly < v_from_truoc and hs.KQLOAI is not null and  hs.KQNGAY >= v_from_truoc))
                                                  AND ta.BAOCAO=1       
                                    ) C
            
                                  GROUP BY C.COURT_ID               
                            )
                    LOOP 
                            v_table_qlta.extend;
                            v_table_qlta(v_table_qlta.count) := R_GDTTT_DASHBOARD(
                                    item_sum.COURT_ID,
                                    0,0,item_sum.COLUMN_3,0,0,0,0,0,0,
                                    0,0
                                    );   
            
                    END LOOP; 
                    
                  ---- Tinh ty le tang hoac giam   
                  
                    
                   
            ----04.Tong so phai giai quyet trong ky truoc-COLUMN_4---------
                     FOR item_sum IN 
                        ( SELECT C.COURT_ID, count(C.COURT_ID) COLUMN_4 FROM(
                            select hs.TOAANID COURT_ID from GSCM.DASHBOARD_STPT hs 
                                            LEFT JOIN GSCM.dm_toaan TA on ta.id=hs.toaanid
                                                where
                                                  (vToaAnID = 0 or hs.TOAANID = vToaAnID)
                                                  AND hs.KQNGAY BETWEEN v_from_truoc and v_to_truoc
                                                  AND ta.BAOCAO=1     
                                    ) C
            
                                  GROUP BY C.COURT_ID               
                            )
                    LOOP 
                            v_table_qlta.extend;
                            v_table_qlta(v_table_qlta.count) := R_GDTTT_DASHBOARD(
                                    item_sum.COURT_ID,
                                    0,0,0,item_sum.COLUMN_4,0,0,0,0,0,
                                    0,0
                                    );   
            
                    END LOOP;
                  -----Dem don vi Giai quyet tren 50% va duo 50%  
                   vTongTren50 := 0;
                    FOR item in (  SELECT JM.TENLOAIAN,TA.MA_TEN,
                                            SUM(JM.COLUMN_1)COLUMN_1,SUM(JM.COLUMN_2)COLUMN_2,                           
                                            DECODE(SUM(JM.COLUMN_1),0,0
                                                    ,ROUND((SUM(JM.COLUMN_2)/SUM(JM.COLUMN_1))*100,1)
                                                    ) TYLE,
                                            DECODE(SUM(JM.COLUMN_3),0,0
                                                    ,ROUND((SUM(JM.COLUMN_4)/SUM(JM.COLUMN_3))*100,1)
                                                    ) TYLE_TRUOC
                                                    
                                            FROM TABLE(v_table_qlta) JM
                                            inner JOIN GSCM.dm_toaan TA ON TA.id=JM.TENLOAIAN and TA.hieuluc = 1 and TA.baocao = 1 
                                      GROUP BY JM.TENLOAIAN,TA.MA_TEN)
                    LOOP
                         if(item.TYLE >= 50) then
                            v_table_ds.extend;
                            v_table_ds(v_table_ds.count) := R_TYLEGQ_CA(item.TENLOAIAN,'TREN50',item.TYLE,item.TYLE_TRUOC,0,0,0);
                            vTongTren50 := vTongTren50 + 1;
                         end if;
                
                    END LOOP;  
                    
 select count(*) into vTongSoDonvi from dm_toaan where baocao = 1 and hieuluc = 1;
   --------------------------
   OPEN curReturn FOR 


        select a.COLUMN_1, a.COLUMN_2, a.COLUMN_3, a.COLUMN_4, a.COLUMN_5, a.COLUMN_6, a.COLUMN_7
        
        
            ,
--            A.COLUMN_7 || ': ' 
--                || DECODE(A.TYLE_TANGGIAM,'.0' || ' %', '0 %','0.' || ' %', '0 %',A.TYLE_TANGGIAM)  
--                || ' </br> <i>( Kỳ trước: ' || DECODE(A.COLUMN_6,'.0' || ' %', '0 %','0.' || ' %', '0 %',A.COLUMN_6) || ')</i>' AS COLUMN_8
            
            DECODE(A.COLUMN_7, 'Tăng', '<p style="color: green; font-size:14px;">' || A.COLUMN_7 || ': ' || DECODE(A.TYLE_TANGGIAM,'.0' || ' %', '0 %','0.' || ' %', '0 %',A.TYLE_TANGGIAM)  || '</p>',
            'Giảm', '<p style="color: red;font-size:14px;">' || A.COLUMN_7 || ': ' || DECODE(A.TYLE_TANGGIAM,'.0' || ' %', '0 %','0.' || ' %', '0 %',A.TYLE_TANGGIAM)  || '</p>',
            A.COLUMN_7 || ': ' || DECODE(A.TYLE_TANGGIAM,'.0' || ' %', '0 %','0.' || ' %', '0 %',A.TYLE_TANGGIAM)  )
            || ' <i>( Kỳ trước: ' || DECODE(A.COLUMN_6,'.0' || ' %', '0 %','0.' || ' %', '0 %',A.COLUMN_6) || ')</i>' AS COLUMN_8
            
            
            
            , DECODE(A.COLUMN_9,'.0' || ' %', '0%','0.' || ' %', '0 %',A.COLUMN_9) COLUMN_9
        From (
        select rtrim(to_char(vTongThuLy, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') COLUMN_1,
               rtrim(to_char(vTongGiaiQuyet, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') COLUMN_2,
                vTongTren50 COLUMN_3,(vTongSoDonvi - vTongTren50) as COLUMN_4,
                vTyLe COLUMN_5,
                --vTyleTruoc COLUMN_6 ,  
                vTangGiam  COLUMN_7, -- (tăng or giảm)
                
                
                       CASE WHEN ABS(vTyLe - vTyleTruoc) < 1 THEN TO_CHAR(ABS(vTyLe - vTyleTruoc), 'FM0.9')|| ' %'
                                ELSE TO_CHAR(ABS(vTyLe - vTyleTruoc), 'FM999.0') || ' %'
                                END AS TYLE_TANGGIAM , -- Tỷ lệ tăng giảm                 
                
                
--                vTangGiam || ': ' || TO_CHAR(ABS(vTyLe - vTyleTruoc), 'FM0.0') || ' %'
--                || ' </br> <i>( Kỳ trước: ' || TO_CHAR(vTyleTruoc, 'FM0.0') || ' % )</i>'AS COLUMN_8,
   
                CASE WHEN vTyleTruoc < 1 THEN TO_CHAR(vTyleTruoc, 'FM0.9')|| ' %'
                ELSE TO_CHAR(vTyleTruoc, 'FM999.0') || ' %'
                END AS COLUMN_6, -- Tỷ lệ giải quyết 
                
                CASE WHEN vTyLe < 1 THEN TO_CHAR(vTyLe, 'FM0.9')|| ' %'
                ELSE TO_CHAR(vTyLe, 'FM999.0') || ' %'
                END AS COLUMN_9 -- Tỷ lệ giải quyết 
            
                from dual) a;
        
--        
--        select a.COLUMN_1, a.COLUMN_2, a.COLUMN_3, a.COLUMN_4, a.COLUMN_5, a.COLUMN_6, a.COLUMN_7
--        From (
--        select rtrim(to_char(vTongThuLy, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') COLUMN_1,
--               rtrim(to_char(vTongGiaiQuyet, 'FM9G999G999D999', 'NLS_NUMERIC_CHARACTERS='',.'''),',') COLUMN_2,
--                vTongTren50 COLUMN_3,(vTongSoDonvi - vTongTren50) as COLUMN_4,
--                vTyLe COLUMN_5,
--                vTyleTruoc COLUMN_6 ,  
--                vTangGiam  COLUMN_7, -- (tăng or giảm)
--                
--                
--                       CASE WHEN ABS(A.COLUMN_3 - A.COLUMN_4) < 1 THEN TO_CHAR(ABS(A.COLUMN_3 - A.COLUMN_4), 'FM0.9')|| ' %'
--                                ELSE TO_CHAR(ABS(A.COLUMN_3 - A.COLUMN_4), 'FM999.0') || ' %'
--                                END AS TYLE_TANGGIAM , -- Tỷ lệ tăng giảm                 
--                
--                
--                vTangGiam || ': ' || TO_CHAR(ABS(vTyLe - vTyleTruoc), 'FM0.0') || ' %'
--                || ' </br> <i>( Kỳ trước: ' || TO_CHAR(vTyleTruoc, 'FM0.0') || ' % )</i>'AS COLUMN_8,
--                TO_CHAR(vTyLe, 'FM0.0') || ' %'  AS COLUMN_9
--                
--                
--                from dual) a
--                
--                
--                ;
                
END;



END PKG_DASHBOARD;