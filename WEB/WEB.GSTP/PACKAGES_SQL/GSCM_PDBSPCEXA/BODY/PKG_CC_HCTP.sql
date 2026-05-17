--------------------------------------------------------
--  DDL for Package Body PKG_CC_HCTP
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_CC_HCTP" AS
FUNCTION TK_HCTP_EXPORT
(
    VTOAANID in number,
    VstrUsername  in VARCHAR2,
    VstrNhomID  in VARCHAR2,
    VTUNGAY in VARCHAR2,
    VDENNGAY in VARCHAR2
)
 RETURN SYS_REFCURSOR
   IS 
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB; v_table T_THONGKE_HCTP_CC;v_table_nsd T_NGUOIDUNG_HCTP;
       --------------
        LoaiAn number;TenLoaiAn varchar2(250);
        v_TT number;COLUMN_1 number;COLUMN_2 number;COLUMN_3 number;COLUMN_4 number;COLUMN_5 number;COLUMN_6 number;COLUMN_7 number;COLUMN_8 number;
        COLUMN_9 number;COLUMN_10 number;COLUMN_11 number;COLUMN_12 number;COLUMN_13 number;COLUMN_14 number;COLUMN_15 number;COLUMN_16 number;COLUMN_17 number;COLUMN_18 number;
        COLUMN_19 number;COLUMN_20 number;COLUMN_21 number;COLUMN_22 number;COLUMN_23 number;COLUMN_24 number;COLUMN_25 number;
       ------------------------
       USERNAME_ID number;USERNAME varchar2(250); HOTEN varchar2(250);HOTEN_USERNAME varchar2(500);USERNAME_LIST  varchar2(1000);
  BEGIN	
    --------------
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
                ----------------------
                 v_table := T_THONGKE_HCTP_CC();
                 PKG_CC_HCTP.TK_HCTP_CREATE_DATA(VTOAANID,VstrUsername,VstrNhomID,VTUNGAY,VDENNGAY,V_CURSOR);
                -----------------------
               LOOP 
                FETCH V_CURSOR --chạy từng dòng dữ liệu gán vào các biến
                  INTO  v_TT,LoaiAn,TenLoaiAn,
                        COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                        COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,COLUMN_13,COLUMN_14,COLUMN_15,COLUMN_16,
                        COLUMN_17,COLUMN_18,COLUMN_19,COLUMN_20,COLUMN_21,COLUMN_22,COLUMN_23,COLUMN_24,COLUMN_25;
                EXIT WHEN V_CURSOR%NOTFOUND;
               -------------
                  IF(LoaiAn is not null) THEN--không lấy dòng tổng
                     v_table.extend;--chuyen vao bang dinh nghia - tiện cho việc truy vấn,
                     --trường hợp này có thể không cần dùng v_table, có thể add giao diện trực tiếp tại đây
                     v_table(v_table.count) := R_THONGKE_HCTP_CC(
                                LoaiAn,TenLoaiAn,
                                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4,COLUMN_5,COLUMN_6,COLUMN_7,COLUMN_8,
                                COLUMN_9,COLUMN_10,COLUMN_11,COLUMN_12,COLUMN_13,COLUMN_14,COLUMN_15,COLUMN_16,
                                COLUMN_17,COLUMN_18,COLUMN_19,COLUMN_20,COLUMN_21,COLUMN_22,COLUMN_23,COLUMN_24,COLUMN_25
                             );
                  END IF;
              END LOOP;
              CLOSE V_CURSOR;
              ---------------
               v_table_nsd := T_NGUOIDUNG_HCTP();
                PKG_GDTTT_HCTP.TK_NGUOIDUNG_CREATE_DATA(VTOAANID,VstrUsername,VstrNhomID,VTUNGAY,VDENNGAY,V_CURSOR);
                LOOP 
                FETCH V_CURSOR --chạy từng dòng dữ liệu gán vào các biến
                  INTO  v_TT,HOTEN_USERNAME,HOTEN,USERNAME_ID,USERNAME,USERNAME_LIST,
                        COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4;
                EXIT WHEN V_CURSOR%NOTFOUND;
               -------------
                  IF(HOTEN is not null) THEN--không lấy dòng tổng
                     v_table_nsd.extend;--chuyen vao bang dinh nghia - tiện cho việc truy vấn,
                     --trường hợp này có thể không cần dùng v_table, có thể add giao diện trực tiếp tại đây
                     v_table_nsd(v_table_nsd.count) := R_NGUOIDUNG_HCTP(
                                USERNAME_ID,USERNAME,HOTEN,HOTEN_USERNAME,
                                COLUMN_1,COLUMN_2,COLUMN_3,COLUMN_4
                             );
                  END IF;
              END LOOP;
              CLOSE V_CURSOR;
              --------------
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
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
              <tr>
                <td colspan="19" style="line-height: 100%; font-size: 14pt"><b>PHÒNG HÀNH CHÍNH TƯ PHÁP</b>
                    <br />
                    <i style="font-size: 12pt;">(Số liệu tính từ ngày '||VTUNGAY||'  đến ngày '||VDENNGAY||')</i>
                </td>
            </tr>
            <tr> <td colspan="19" style="height: 15pt;"></td></tr>
            <tr style="font-weight: bold;">
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">LOẠI ÁN</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng số đơn đã xử lý HCTP</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Trả lại đơn</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đơn không thuộc thẩm quyền</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đơn chưa đủ điều kiện</td>
                <td colspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 40pt;">Đơn đủ điều kiện chuyển P. GĐKT 1</td>
                <td colspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đơn đủ điều kiện chuyển P. GĐKT 2</td>
                <td colspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đơn đủ điều kiện chuyển P. GĐKT 3</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đơn chuyển TATC</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đơn chuyển Tòa án khác </td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đơn chuyển các đơn vị ngoài Tòa án</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Xếp đơn</td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 70pt;">Đơn trùng</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đơn thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 70pt;">Đơn trùng</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đơn thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 70pt;">Đơn trùng</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đơn thụ lý mới</td>
            </tr>
            <tr style="font-style: italic; color: #adabab; font-size: 10pt; text-align: center;">
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black; height: 25px"></td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">1</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">2</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">3</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">4</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">5</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">6</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">7</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">8</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">9</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">10</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">14</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">16</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">17</td>
                <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">18</td>
            </tr>
                       ');
                 -----------item
                    FOR item IN (
                          SELECT PA.LoaiAn,PA.TenLoaiAn,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
                          ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
                          ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
                          ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17,SUM(PA.COLUMN_18)COLUMN_18
                          ,SUM(PA.COLUMN_19)COLUMN_19,SUM(PA.COLUMN_20)COLUMN_20,SUM(PA.COLUMN_21)COLUMN_21,SUM(PA.COLUMN_22)COLUMN_22,SUM(PA.COLUMN_23)COLUMN_23,SUM(PA.COLUMN_24)COLUMN_24
                          FROM TABLE(v_table) PA  
                          GROUP BY PA.LoaiAn,PA.TenLoaiAn ORDER BY PA.LoaiAn
                           )
                    LOOP
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                       <tr>
                        <td style="border: 1pt solid Black; text-align: left; vertical-align: middle; padding: 5px;">'||item.TenLoaiAn||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_1||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_2||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_3||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_4||'</td>
                        '); 
                       if(item.COLUMN_19>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_5||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_19||'</td>
                         '); 
                        ELSif(item.COLUMN_19=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_5||'</td>
                         '); 
                        END IF;
                        if(item.COLUMN_20>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_6||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_20||'</td>
                         '); 
                        ELSif(item.COLUMN_20=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_6||'</td>
                         '); 
                        END IF;
                        if(item.COLUMN_21>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_7||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_21||'</td>
                         '); 
                        ELSif(item.COLUMN_21=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_7||'</td>
                         '); 
                        END IF;
                         if(item.COLUMN_22>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_8||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_22||'</td>
                         '); 
                        ELSif(item.COLUMN_22=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_8||'</td>
                         '); 
                        END IF;
                        if(item.COLUMN_23>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_9||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_23||'</td>
                         '); 
                        ELSif(item.COLUMN_23=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_9||'</td>
                         '); 
                        END IF;
                         if(item.COLUMN_24>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_10||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_24||'</td>
                         '); 
                        ELSif(item.COLUMN_24=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_10||'</td>
                         '); 
                        END IF;
                          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_14||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_16||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_17||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_18||'</td>
                    </tr>
                   ');
                    END LOOP;
                    -----tong
                    FOR item IN (
                       SELECT SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
                      ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
                      ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
                      ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17,SUM(PA.COLUMN_18)COLUMN_18
                      ,SUM(PA.COLUMN_19)COLUMN_19,SUM(PA.COLUMN_20)COLUMN_20,SUM(PA.COLUMN_21)COLUMN_21,SUM(PA.COLUMN_22)COLUMN_22,SUM(PA.COLUMN_23)COLUMN_23,SUM(PA.COLUMN_24)COLUMN_24
                      FROM TABLE(v_table) PA
                    )
                    LOOP
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                       <tr style="font-weight:bold;">
                        <td style="border: 1pt solid Black; text-align: left; vertical-align: middle; padding: 5px;">TỔNG CỘNG</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_1||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_2||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_3||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_4||'</td>
                      '); 
                       if(item.COLUMN_19>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_5||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_19||'</td>
                         '); 
                        ELSif(item.COLUMN_19=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_5||'</td>
                         '); 
                        END IF;
                        if(item.COLUMN_20>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_6||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_20||'</td>
                         '); 
                        ELSif(item.COLUMN_20=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_6||'</td>
                         '); 
                        END IF;
                        if(item.COLUMN_21>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_7||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_21||'</td>
                         '); 
                        ELSif(item.COLUMN_21=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_7||'</td>
                         '); 
                        END IF;
                         if(item.COLUMN_22>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_8||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_22||'</td>
                         '); 
                        ELSif(item.COLUMN_22=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_8||'</td>
                         '); 
                        END IF;
                        if(item.COLUMN_23>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_9||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_23||'</td>
                         '); 
                        ELSif(item.COLUMN_23=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_9||'</td>
                         '); 
                        END IF;
                         if(item.COLUMN_24>0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_10||' <br /><span style=color:#a2c2a8;font:12px>---------</span><br/>CĐ:'||item.COLUMN_24||'</td>
                         '); 
                        ELSif(item.COLUMN_24=0)THEN
                         DBMS_LOB.APPEND(V_EXPORT_TEXT,'<td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_10||'</td>
                         '); 
                        END IF;
                          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_14||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_16||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_17||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_18||'</td>
                    </tr>
                   ');
                END LOOP;
                 -----------
           DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <tr style="height: 1pt;">
                <td style="width: 250px"></td>
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
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                <td style="width: 47px"></td>
                </tr>
               </table>
                ');
        --------------------------------
        --------------danh sách người dùng nhập vào hệ thống--------
        -------------------------------
                 DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                 <table cellpadding="1" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
                    <tr>
                        <td colspan="4" style="height: 20pt;"></td>
                    </tr>
                    <tr style="font-weight: bold;">
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 40pt;">Họ tên</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng số đơn xử lý trong ngày</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng số đơn xử lý trong tháng</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng số đơn xử lý trong kỳ</td>
                    </tr>
                    <tr style="font-style: italic; color: #adabab; font-size: 10pt; text-align: center;">
                        <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black; height: 25px"></td>
                        <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">1</td>
                        <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">2</td>
                        <td style="text-align: center; vertical-align: middle; font-style: italic; border: 1pt solid Black;">3</td>
                    </tr>
                       ');
                 -----------item
                    FOR item IN (
                          SELECT PA.HOTEN_USERNAME,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3
                          FROM TABLE(v_table_nsd) PA
                          GROUP BY PA.HOTEN_USERNAME,PA.HOTEN
                          ORDER BY SUBSTR(PA.HOTEN,INSTR(PA.HOTEN,' ',-1)+ 1)
                           )
                    LOOP
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                       <tr>
                        <td style="border: 1pt solid Black; text-align: left; vertical-align: middle; padding: 5px;">'||item.HOTEN_USERNAME||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_1||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_2||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_3||'</td>      
                    </tr>
                   ');
                    END LOOP; 
                 -----tong
                    FOR item IN (
                        SELECT SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3
                      FROM TABLE(v_table_nsd) PA 
                    )
                    LOOP
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                       <tr style="font-weight:bold;">
                        <td style="border: 1pt solid Black; text-align: left; vertical-align: middle; padding: 5px;">TỔNG CỘNG</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_1||'</td>            
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_2||'</td>
                        <td style="border: 1pt solid Black; text-align: center; vertical-align: middle;">'||item.COLUMN_3||'</td>          
                    </tr>
                   ');
                END LOOP;  
             -----------
           DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
               <tr style="height: 1pt;">
                    <td style="width: 350px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 100px"></td>
                </tr>
               </table>
                ');     
        OPEN V_CURSOR FOR
--      SELECT JM.* FROM TABLE(v_table) JM;
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;   
END TK_HCTP_EXPORT;
PROCEDURE TK_HCTP_CREATE_DATA
    (
        VTOAANID in number,
        VstrUsername  in VARCHAR2,
        VstrNhomID  in VARCHAR2,
        VTUNGAY in VARCHAR2,
        VDENNGAY in VARCHAR2,
        curReturn OUT SYS_REFCURSOR
    ) AS    
       V_CURSOR sys_refcursor; 
       ------------------------
       v_table T_THONGKE_HCTP_CC;
       ------------------------
        vvTuNgay date;vvDenNgay date;v_Tongso number:=0;V_XEM_ALL number;
  BEGIN    
    v_table := T_THONGKE_HCTP_CC();
    ----------------------------
    SELECT QH.XEM_ALL INTO V_XEM_ALL FROM QT_NHOMNGUOIDUNG_HOME QH where NHOMID=VstrNhomID AND CHUONGTRINHID=44;
    -----------------------
    vvTuNgay:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');vvDenNgay:=to_date(trim(vDenNgay)||' 23:59:59','dd/MM/yyyy HH24:MI:SS');
  --vvTuNgay:=to_date(trim(vTuNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');vvDenNgay:=to_date(trim(vDenNgay)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');
    for item in  (
                    select v.BAQD_LOAIAN,DECODE(V.BAQD_LOAIAN,1,'HÌNH SỰ',2,'DÂN SỰ',3,'HÔN NHÂN VÀ GIA ĐÌNH',4,'KINH DOANH, THƯƠNG MẠI',5,'LAO ĐỘNG',6,'HÀNH CHÍNH',7,'PHÁ SẢN',55,'CHƯA XÁC ĐỊNH')LOAIAN_TEN
                    From (select nvl(d.BAQD_LOAIAN,55)BAQD_LOAIAN from GDTTT_DON d) v 
                    where V.BAQD_LOAIAN IS NOT NULL 
                    group by V.BAQD_LOAIAN,DECODE(V.BAQD_LOAIAN,1,'HÌNH SỰ',2,'DÂN SỰ',3,'HÔN NHÂN VÀ GIA ĐÌNH',4,'KINH DOANH, THƯƠNG MẠI',5,'LAO ĐỘNG',6,'HÀNH CHÍNH',7,'PHÁ SẢN',55,'CHƯA XÁC ĐỊNH')
                 )
    LOOP
             -----Tổng số đơn đã xử lý HCTP
             SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
             LEFT JOIN VT_CHUYEN_NHAN CN ON CN.GDTTT_DON_ID=D.ID
              Where d.TOAANID=vToaAnID 
              AND  NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3)
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
              AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND(
                  (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
                   --Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         v_Tongso,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );
            --Trả lại đơn d.CD_LOAI=3
            SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
             AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=3
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
               Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              )
              ;
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,v_Tongso,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );   
         -- Đơn không thuộc thẩm quyền TATC              
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI IN (1,2)--Tòa khác + Ngoài tòa án
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
               Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              )
              ;
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,v_Tongso,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );    
         -- Đơn chưa đủ điều kiện            
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=1--d.CD_LOAI=0 Nội bộ
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
               Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              )
              ;
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,v_Tongso,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );            
          -- Đơn trùng-Đơn đủ điều kiện chuyển Vụ GĐKT 1           
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=2 
                AND ((vToaAnID = 6 AND d.CD_TA_DONVIID= 14) -- Toa an CCHCM thì phòng GDKT1 = 14
                    OR (vToaAnID = 5 AND d.CD_TA_DONVIID= 10)  -- Toa an CCDN thì phòng GDKT1 = 10
                    OR (vToaAnID = 4 AND d.CD_TA_DONVIID= 6)  -- Toa an CCHN thì phòng GDKT1 = 6
                    ) 
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
               Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,v_Tongso,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );                 
          -- Đơn thụ lý mới-Đơn đủ điều kiện chuyển P. GĐKT 1          
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=1 
               AND ((vToaAnID = 6 AND d.CD_TA_DONVIID= 14) -- Toa an CCHCM thì phòng GDKT1 = 14
                    OR (vToaAnID = 5 AND d.CD_TA_DONVIID= 10)  -- Toa an CCDN thì phòng GDKT1 = 10
                    OR (vToaAnID = 4 AND d.CD_TA_DONVIID= 6)  -- Toa an CCHN thì phòng GDKT1 = 6
                    ) 
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
                Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,v_Tongso,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );          
          -- Đơn trùng-Đơn đủ điều kiện chuyển P. GĐKT 2          
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=2 
               AND ((vToaAnID = 6 AND d.CD_TA_DONVIID= 15) -- Toa an CCHCM thì phòng GDKT2 = 15
                    OR (vToaAnID = 5 AND d.CD_TA_DONVIID= 11)  -- Toa an CCDN thì phòng GDKT2 = 11
                    OR (vToaAnID = 4 AND d.CD_TA_DONVIID= 7)  -- Toa an CCHN thì phòng GDKT2 = 7
                    ) 
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
               Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         v_Tongso,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );  
           -- Đơn thụ lý mới-Đơn đủ điều kiện chuyển P. GĐKT 2            
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=1 
               AND ((vToaAnID = 6 AND d.CD_TA_DONVIID= 15) -- Toa an CCHCM thì phòng GDKT2 = 15
                    OR (vToaAnID = 5 AND d.CD_TA_DONVIID= 11)  -- Toa an CCDN thì phòng GDKT2 = 11
                    OR (vToaAnID = 4 AND d.CD_TA_DONVIID= 7)  -- Toa an CCHN thì phòng GDKT2 = 7
                    ) 
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
                Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,v_Tongso,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );           
         -- Đơn trùng-Đơn đủ điều kiện chuyển P. GĐKT 3           
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=2 
               AND ((vToaAnID = 6 AND d.CD_TA_DONVIID= 16) -- Toa an CCHCM thì phòng GDKT3 = 16
                    OR (vToaAnID = 4 AND d.CD_TA_DONVIID= 8)  -- Toa an CCHN thì phòng GDKT3 = 8
                    ) 
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,v_Tongso,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        ); 
           -- Đơn thụ lý mới-Đơn đủ điều kiện chuyển P. GĐKT 3 ;CD_TA_DONVIID đơn vị nội bộ          
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=1 
               AND ((vToaAnID = 6 AND d.CD_TA_DONVIID= 16) -- Toa an CCHCM thì phòng GDKT3 = 16
                    OR (vToaAnID = 4 AND d.CD_TA_DONVIID= 8)  -- Toa an CCHN thì phòng GDKT3 = 8
                    ) 
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
               Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,v_Tongso,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );   
           -- TAND CC tại Hà Nội-TAND CC tại Hà Nội    
--         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
--              Where d.TOAANID=vToaAnID 
--              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
--               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
--              AND d.CD_LOAI=1 and d.CD_TK_DONVIID=4 --d.CD_LOAI=1 Tòa khác;d.CD_TK_DONVIID Tòa khác
--              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
----              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
--              );
--              -----
--              v_table.extend;
--              v_table(v_table.count) := R_THONGKE_HCTP_CC(
--                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
--                         0,0,0,0,0,0,
--                         0,0,0,0,v_Tongso,0,
--                         0,0,0,0,0,0,
--                         0,0,0,0,0,0
--                        );     
       -- TAND CC tại Đà Nẵng-TAND CC tại Hà Nội    
--         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
--              Where d.TOAANID=vToaAnID 
--              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
--               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
--              AND d.CD_LOAI=1 and d.CD_TK_DONVIID=5
--              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
----              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
--              );
--              -----
--              v_table.extend;
--              v_table(v_table.count) := R_THONGKE_HCTP_CC(
--                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
--                         0,0,0,0,0,0,
--                         0,0,0,0,0,v_Tongso,
--                         0,0,0,0,0,0,
--                         0,0,0,0,0,0
--                        );            
         -- TAND CC tại TP.Hồ Chí Minh-TAND CC tại Hà Nội    
--         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
--              Where d.TOAANID=vToaAnID 
--              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
--               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
--              AND d.CD_LOAI=1 and d.CD_TK_DONVIID=6
--              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
----              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
--              );
--              -----
--              v_table.extend;
--              v_table(v_table.count) := R_THONGKE_HCTP_CC(
--                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
--                         0,0,0,0,0,0,
--                         0,0,0,0,0,0,
--                         v_Tongso,0,0,0,0,0,
--                         0,0,0,0,0,0
--                        );  
         -- Chuyển Vụ Tổ chức cán bộ ->cấp cao là đơn chuyển Đơn chuyển TATC  
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
              And nvl(d.BAQD_LOAIAN,55)=item.BAQD_LOAIAN
              AND d.CD_LOAI=1 and d.CD_TK_DONVIID=1
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,v_Tongso,0,0,0,0,
                         0,0,0,0,0,0,
                         0
                        ); 
         -- Chuyển Ban Thanh tra
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
              And nvl(d.BAQD_LOAIAN,55)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 and d.CD_TA_DONVIID=22
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
               Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,v_Tongso,0,0,0,
                         0,0,0,0,0,0,
                         0
                        );   
          --Đơn chuyển Tòa án khác và không có TAND tối cao  CD_TK_DONVIID           
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
              And nvl(d.BAQD_LOAIAN,55)=item.BAQD_LOAIAN
              AND d.CD_LOAI=1 AND d.CD_TK_DONVIID!=1
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,v_Tongso,0,0,
                         0,0,0,0,0,0,
                         0
                        );  
          --Đơn chuyển các đơn vị ngoài Tòa án           
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
              And nvl(d.BAQD_LOAIAN,55)=item.BAQD_LOAIAN
              AND d.CD_LOAI=2
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
               Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,v_Tongso,0,
                         0,0,0,0,0,0,
                         0
                        );   
             --Xếp đơn       
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=4
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
               Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              );
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,v_Tongso,
                         0,0,0,0,0,0,
                         0
                        );      
               ----------------------------------------------------------
               --AND d.CD_TRANGTHAI=1 đã chuyển     
               --chuyển đơn,Đơn trùng-Đơn đủ điều kiện chuyển Vụ GĐKT 1;
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=2 and d.CD_TA_DONVIID=2
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay) 
              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              )
              AND d.CD_TRANGTHAI in (1,2) AND (d.CD_NGAYXULY>=vvTuNgay AND d.CD_NGAYXULY<=vvDenNgay)
                ;
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         v_Tongso,0,0,0,0,0,
                         0
                        );                 
          -- chuyển đơn,Đơn thụ lý mới-Đơn đủ điều kiện chuyển Vụ GĐKT 1           
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=1 and d.CD_TA_DONVIID=2
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              )
              AND d.CD_TRANGTHAI in (1,2) AND (d.CD_NGAYXULY>=vvTuNgay AND d.CD_NGAYXULY<=vvDenNgay)
              ;
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,v_Tongso,0,0,0,0,
                         0
                        );          
          -- chuyển đơn,Đơn trùng-Đơn đủ điều kiện chuyển Vụ GĐKT 2           
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=2 and d.CD_TA_DONVIID=3
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)  
              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              )
              AND d.CD_TRANGTHAI in (1,2) AND (d.CD_NGAYXULY>=vvTuNgay AND d.CD_NGAYXULY<=vvDenNgay)
              ;
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,v_Tongso,0,0,0,
                         0
                        );  
           -- chuyển đơn,Đơn thụ lý mới-Đơn đủ điều kiện chuyển Vụ GĐKT 2           
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=1 and d.CD_TA_DONVIID=3
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)  
              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              )
              AND d.CD_TRANGTHAI in (1,2) AND (d.CD_NGAYXULY>=vvTuNgay AND d.CD_NGAYXULY<=vvDenNgay)
              ;
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,v_Tongso,0,0,
                         0
                        );           
         -- chuyển đơn,Đơn trùng-Đơn đủ điều kiện chuyển Vụ GĐKT 3           
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=2 and d.CD_TA_DONVIID=4
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay) 
              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <=vvDenNgay )
              )
              AND d.CD_TRANGTHAI in (1,2) AND (d.CD_NGAYXULY>=vvTuNgay AND d.CD_NGAYXULY<=vvDenNgay)
              ;
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,v_Tongso,0,
                         0
                        ); 
           --chuyển đơn, Đơn thụ lý mới-Đơn đủ điều kiện chuyển Vụ GĐKT 3 ;CD_TA_DONVIID đơn vị nội bộ          
         SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
              Where d.TOAANID=vToaAnID 
              AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
               AND decode(d.BAQD_LOAIAN,0,55,null,55,d.BAQD_LOAIAN)=item.BAQD_LOAIAN
              AND d.CD_LOAI=0 AND d.CD_TA_TRANGTHAI=0 AND d.ISTHULY=1 and d.CD_TA_DONVIID=4
              AND( (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
              Or  ( d.TL_NGAY>=vvTuNgay and d.TL_NGAY <= vvDenNgay )
              )
              AND d.CD_TRANGTHAI in (1,2) AND (d.CD_NGAYXULY>=vvTuNgay AND d.CD_NGAYXULY<=vvDenNgay)
              ;
              -----
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,v_Tongso,
                         0
                        );   
            -----Văn thư đến
               SELECT COUNT(*) INTO v_Tongso FROM VT_VANBANDEN vt WHERE vt.LOAI_VB !=5
                AND VT.TOAANID =  vToaAnID
               AND  decode(VT.LOAI_AN_DON,0,55,null,55,VT.LOAI_AN_DON)=item.BAQD_LOAIAN 
               AND EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN CN WHERE CN.VANBANDEN_ID=VT.ID)
               AND (vt.NGAY_TAO>=vvTuNgay AND vt.NGAY_TAO<=vvDenNgay);
               --------
              v_table.extend;
              v_table(v_table.count) := R_THONGKE_HCTP_CC(
                        item.BAQD_LOAIAN,item.LOAIAN_TEN,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         0,0,0,0,0,0,
                         v_Tongso
                        );             
    END LOOP;
OPEN curReturn FOR 
           SELECT PP.v_TT,PP.LoaiAn,PP.TenLoaiAn,PP.COLUMN_1,PP.COLUMN_2,PP.COLUMN_3,PP.COLUMN_4,
           PP.COLUMN_5,PP.COLUMN_6,PP.COLUMN_7,PP.COLUMN_8,PP.COLUMN_9,PP.COLUMN_10,
           PP.COLUMN_11,PP.COLUMN_12,PP.COLUMN_13,PP.COLUMN_14,PP.COLUMN_15,PP.COLUMN_16,PP.COLUMN_17,
           PP.COLUMN_18,PP.COLUMN_19,PP.COLUMN_20,PP.COLUMN_21,PP.COLUMN_22,PP.COLUMN_23,PP.COLUMN_24,PP.COLUMN_25
           FROM 
           (
              SELECT NULL v_TT,PA.LoaiAn,PA.TenLoaiAn,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
              ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
              ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
              ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17,SUM(PA.COLUMN_18)COLUMN_18
               ,SUM(PA.COLUMN_19)COLUMN_19,SUM(PA.COLUMN_20)COLUMN_20,SUM(PA.COLUMN_21)COLUMN_21,SUM(PA.COLUMN_22)COLUMN_22,SUM(PA.COLUMN_23)COLUMN_23,SUM(PA.COLUMN_24)COLUMN_24,SUM(PA.COLUMN_25)COLUMN_25
              ,SUM(PA.COLUMN_1+PA.COLUMN_2+PA.COLUMN_3+PA.COLUMN_4+PA.COLUMN_5+PA.COLUMN_6+PA.COLUMN_7+PA.COLUMN_8+PA.COLUMN_9+PA.COLUMN_10+PA.COLUMN_11+PA.COLUMN_12+PA.COLUMN_13+PA.COLUMN_14+PA.COLUMN_15+PA.COLUMN_16+PA.COLUMN_17+PA.COLUMN_18+PA.COLUMN_19+PA.COLUMN_20+PA.COLUMN_21+PA.COLUMN_22+PA.COLUMN_23+PA.COLUMN_24+PA.COLUMN_25)COLUMN_26
              FROM TABLE(v_table) PA
              GROUP BY PA.LoaiAn,PA.TenLoaiAn,NULL ORDER BY PA.LoaiAn
          )PP WHERE PP.COLUMN_26!=0 and PP.LoaiAn !=55
          -- PP.COLUMN_26!=0 loại bỏ như những loại án nào có tất cả các cột đều trống
          -- PP.LoaiAn !=0 bỏ những loại án chưa xác định
          UNION ALL
          --and PP.LoaiAn=0 lấy những loại án chưa xác định
           SELECT PP.v_TT,PP.LoaiAn,PP.TenLoaiAn,PP.COLUMN_1,PP.COLUMN_2,PP.COLUMN_3,PP.COLUMN_4,
           PP.COLUMN_5,PP.COLUMN_6,PP.COLUMN_7,PP.COLUMN_8,PP.COLUMN_9,PP.COLUMN_10,
           PP.COLUMN_11,PP.COLUMN_12,PP.COLUMN_13,PP.COLUMN_14,PP.COLUMN_15,PP.COLUMN_16,PP.COLUMN_17,
           PP.COLUMN_18,PP.COLUMN_19,PP.COLUMN_20,PP.COLUMN_21,PP.COLUMN_22,PP.COLUMN_23,PP.COLUMN_24,PP.COLUMN_25 FROM 
           (
              SELECT NULL v_TT,PA.LoaiAn,PA.TenLoaiAn,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
              ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
              ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
              ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17,SUM(PA.COLUMN_18)COLUMN_18
              ,SUM(PA.COLUMN_19)COLUMN_19,SUM(PA.COLUMN_20)COLUMN_20,SUM(PA.COLUMN_21)COLUMN_21,SUM(PA.COLUMN_22)COLUMN_22,SUM(PA.COLUMN_23)COLUMN_23,SUM(PA.COLUMN_24)COLUMN_24,SUM(PA.COLUMN_25)COLUMN_25
              ,SUM(PA.COLUMN_1+PA.COLUMN_2+PA.COLUMN_3+PA.COLUMN_4+PA.COLUMN_5+PA.COLUMN_6+PA.COLUMN_7+PA.COLUMN_8+PA.COLUMN_9+PA.COLUMN_10+PA.COLUMN_11+PA.COLUMN_12+PA.COLUMN_13+PA.COLUMN_14+PA.COLUMN_15+PA.COLUMN_16+PA.COLUMN_17+PA.COLUMN_18+PA.COLUMN_19+PA.COLUMN_20+PA.COLUMN_21+PA.COLUMN_22+PA.COLUMN_23+PA.COLUMN_24+PA.COLUMN_25)COLUMN_26
              FROM TABLE(v_table) PA
              GROUP BY PA.LoaiAn,PA.TenLoaiAn,NULL ORDER BY PA.LoaiAn
          )PP WHERE PP.COLUMN_26!=0 and PP.LoaiAn =55-- PP.COLUMN_26!=0 loại bỏ như những loại án nào có tất cả các cột đều trống
          UNION ALL
          SELECT NULL v_TT,NULL LoaiAn,'<span class="tong_cong_tp">TỔNG CỘNG</span>' TenLoaiAn,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
          ,SUM(PA.COLUMN_5)COLUMN_5,SUM(PA.COLUMN_6)COLUMN_6,SUM(PA.COLUMN_7)COLUMN_7,SUM(PA.COLUMN_8)COLUMN_8,SUM(PA.COLUMN_9)COLUMN_9
          ,SUM(PA.COLUMN_10)COLUMN_10,SUM(PA.COLUMN_11)COLUMN_11,SUM(PA.COLUMN_12)COLUMN_12,SUM(PA.COLUMN_13)COLUMN_13,SUM(PA.COLUMN_14)COLUMN_14
          ,SUM(PA.COLUMN_15)COLUMN_15,SUM(PA.COLUMN_16)COLUMN_16,SUM(PA.COLUMN_17)COLUMN_17,SUM(PA.COLUMN_18)COLUMN_18
          ,SUM(PA.COLUMN_19)COLUMN_19,SUM(PA.COLUMN_20)COLUMN_20,SUM(PA.COLUMN_21)COLUMN_21,SUM(PA.COLUMN_22)COLUMN_22,SUM(PA.COLUMN_23)COLUMN_23,SUM(PA.COLUMN_24)COLUMN_24,SUM(PA.COLUMN_25)COLUMN_25
          FROM TABLE(v_table) PA GROUP BY NULL,'<span class="tong_cong_tp">TỔNG CỘNG</span>';
     -----------------------------------
END TK_HCTP_CREATE_DATA;   
PROCEDURE TK_NGUOIDUNG_CREATE_DATA
    (
        VTOAANID in number,
        VstrUsername  in VARCHAR2,
        VstrNhomID  in VARCHAR2,
        VTUNGAY in VARCHAR2,
        VDENNGAY in VARCHAR2,
        curReturn OUT SYS_REFCURSOR
    ) AS    
       V_CURSOR sys_refcursor; 
       ------------------------
       v_table T_NGUOIDUNG_HCTP;
       ------------------------
        vvTuNgay date;vvDenNgay date;v_Tongso number;V_XEM_ALL number;v_TONG_NGAY number;V_TRUNG_B NUMBER;
        TYPE ARRAY_T IS VARRAY(3) OF NUMBER;  array array_t := array_t(0,1,2);USERNAME_LIST VARCHAR2(1000);
  BEGIN    
    v_table := T_NGUOIDUNG_HCTP();
    ----------------------------
    SELECT QH.XEM_ALL INTO V_XEM_ALL FROM QT_NHOMNGUOIDUNG_HOME QH where NHOMID=VstrNhomID AND CHUONGTRINHID=44;
--    select ROUND(sysdate-to_date('01/'||to_char(sysdate,'MM/yyyy'),'dd/MM/yyyy'),0) INTO v_TONG_NGAY from dual;
    ----------------------------
    SELECT COUNT(*) INTO v_TONG_NGAY FROM
          (SELECT  TO_CHAR(trunc(sysdate,'MM') + LEVEL-1,'dd/MM/yyyy')NGAY
               , TO_CHAR(trunc(sysdate,'MM') + LEVEL-1, 'DY')THU   -- day of week
           FROM dual 
           CONNECT BY LEVEL <= (to_date(VDENNGAY,'dd/MM/yyyy') -to_date(VTUNGAY,'dd/MM/yyyy'))+1 --TO_CHAR(SYSDATE, 'DD')--(sysdate - (trunc(sysdate,'MM')-1) ) -- end_date - start_date 
          )TT
      WHERE TT.THU NOT IN ('SAT', 'SUN') 
      AND TT.NGAY NOT IN ('01/01/'||TO_CHAR(sysdate, 'YYYY'),'30/04/'||TO_CHAR(sysdate, 'YYYY')
      ,'01/05/'||TO_CHAR(sysdate, 'YYYY'),'02/09/'||TO_CHAR(sysdate, 'YYYY') );
     --trunc(sysdate,'MM') lấy ngày đầu tiên của tháng
     --TO_CHAR(SYSDATE, 'DD') đến ngày hôm nay
     --TT.THU NOT IN ('sat','sun') bỏ ngày thứ 7 và chủ nhật
-- SELECT Count(*) BusDaysBtwn
--     FROM
--     (
--     SELECT TO_DATE('2013-02-18', 'YYYY-MM-DD') + LEVEL-1 InstallDate  -- MON or any other day 
--          , TO_DATE('2013-02-25', 'YYYY-MM-DD') CompleteDate           -- MON or any other day
--          , TO_CHAR(TO_DATE('2013-02-18', 'YYYY-MM-DD') + LEVEL-1, 'DY') InstallDay   -- day of week
--       FROM dual 
--     CONNECT BY LEVEL <= (TO_DATE('2013-02-25', 'YYYY-MM-DD') - TO_DATE('2013-02-18', 'YYYY-MM-DD')) -- end_date - start_date 
--      )
--      WHERE InstallDay NOT IN ('SAT', 'SUN')
---------------------------------------------------------------
--        select count(*) into v_TONG_NGAY from (
--            SELECT TT.* FROM (
--            with dates as (
--               select trunc(sysdate,'MM') + level - 1 dt
--               from dual connect by level <=TO_CHAR(SYSDATE, 'DD')--(to_char(to_date(sysdate,'dd/MM/yyyy'),'ddd') - to_char(trunc(sysdate,'MM'),'ddd') )
--            )
--            select
--            to_char(dt,'dy')THU,to_char(dt,'DD')NGAY,to_char(dt,'MM')THANG,to_char(dt,'IYYY')NAM,
--            to_char(dt,'dd/MM/yyyy')NGAYGET,
--            to_char(dt, 'YYYY-MM-DD dy "IYYY"=IYYY "IW="IW "WW="WW') OUTPUT_TEMP
--            from dates
--            order by dt
--            )TT WHERE TT.THU NOT IN ('sat','sun')
--     );  
    ----------------------------
  FOR I IN 1..ARRAY.COUNT  
    LOOP
         if(array(I)=0) then --trong ngày
             vvTuNgay:=to_date(TO_CHAR(SYSDATE,'dd/MM/yyyy')||' 00:00:00','dd/MM/yyyy hh24:mi:ss');vvDenNgay:=to_date(TO_CHAR(SYSDATE,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy hh24:mi:ss');
         elsif(array(I)=1)then --trong tháng
           vvTuNgay:=to_date('01'||TO_CHAR(SYSDATE,'/MM/yyyy')||' 00:00:00','dd/MM/yyyy hh24:mi:ss');vvDenNgay:=to_date(TO_CHAR(SYSDATE,'dd/MM/yyyy')||' 23:59:59','dd/MM/yyyy hh24:mi:ss');
         elsif(array(I)=2)then  -- trong kỳ
           vvTuNgay:=to_date(vTuNgay||' 00:00:00','dd/MM/yyyy hh24:mi:ss');vvDenNgay:=to_date(vDenNgay||' 23:59:59','dd/MM/yyyy hh24:mi:ss');
         END IF;
          for item in  (
                        SELECT NSD.ID,D.nguoitao,CB.HOTEN,REPLACE(nsd.HOTEN,'--Chọn cán bộ--','')||' ('|| nsd.USERNAME||')' HOTEN_USERNAME From GDTTT_DON d
                        left join QT_NGUOISUDUNG nsd on nsd.USERNAME=D.nguoitao
                        left join DM_CANBO cb on cb.id=NSD.CANBOID
                        Where d.TOAANID=vToaAnID
                        AND ( V_XEM_ALL=1 OR(V_XEM_ALL=0 AND d.nguoitao=VstrUsername) )
                        AND(   (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
                            --Or  (d.TL_NGAY>=vvTuNgay  and d.TL_NGAY <= vvDenNgay )
                          )
                         AND  NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3)
                        GROUP BY NSD.ID,D.nguoitao,CB.HOTEN,REPLACE(nsd.HOTEN,'--Chọn cán bộ--','')||' ('|| nsd.USERNAME||')'
                     )
         LOOP
                  SELECT COUNT(*) INTO v_Tongso From GDTTT_DON d
                  Where d.TOAANID=vToaAnID And d.nguoitao=item.nguoitao --AND pb.ISGIAIQUYETDON=0
                   AND(      (d.NGAYTAO>=vvTuNgay AND d.NGAYTAO<=vvDenNgay)
                         --  Or (d.TL_NGAY>=vvTuNgay  and d.TL_NGAY <= vvDenNgay )
                      )
                    AND  NOT EXISTS(SELECT 'X' FROM VT_CHUYEN_NHAN WHERE GDTTT_DON_ID=D.ID AND TRANG_THAI_XLY=3)   
                      ;
                  -----
                  if(array(I)=0) then
                   v_table.extend;
                   v_table(v_table.count) := R_NGUOIDUNG_HCTP(
                            item.ID,item.nguoitao,item.HOTEN,item.HOTEN_USERNAME,
                             v_Tongso,0,0,0
                            );
                   -----         
                   elsif(array(I)=1)then 
                      if(v_TONG_NGAY>0) then
                      V_TRUNG_B:=ROUND((v_Tongso/v_TONG_NGAY),2);
                      else
                      V_TRUNG_B:=0;
                      end if;
                   v_table.extend;
                   v_table(v_table.count) := R_NGUOIDUNG_HCTP(
                            item.ID,item.nguoitao,item.HOTEN,item.HOTEN_USERNAME,
                             0,v_Tongso,0,V_TRUNG_B
                            );
                   --(v_Tongso/v_TONG_NGAY) tính trung bình ngày theo tháng
                   -----         
                   elsif(array(I)=2)then  
                   v_table.extend;
                   v_table(v_table.count) := R_NGUOIDUNG_HCTP(
                            item.ID,item.nguoitao,item.HOTEN,item.HOTEN_USERNAME,
                             0,0,v_Tongso,0
                            );
                  END IF;            
         END LOOP;
  END LOOP;   
    ------------------chỉ để lấy danh sách các user truyền vào dòng tổng phục vụ cho việc nhấn vào dòng tống
     SELECT  LISTAGG(TT.USERNAME, ',') WITHIN GROUP (ORDER BY TT.USERNAME)USERNAME_LIST INTO USERNAME_LIST
     FROM (
      SELECT PP.USERNAME FROM 
           (
              SELECT PA.USERNAME,SUM(PA.COLUMN_1+PA.COLUMN_2+PA.COLUMN_3+PA.COLUMN_4)COLUMN_26 FROM TABLE(v_table) PA
              left JOIN QT_NGUOISUDUNG nsd ON PA.USERNAME_ID=nsd.ID 
              group by 1,PA.HOTEN_USERNAME, PA.USERNAME, PA.HOTEN, PA.USERNAME_ID
           )PP WHERE PP.COLUMN_26!=0 AND PP.USERNAME NOT LIKE '%gdkt%'
          --PP.COLUMN_26!=0 loại bỏ như những loại án nào có tất cả các cột đều trống
          --AND PP.USERNAME NOT LIKE '%gdkt%' loại bỏ những vụ có USERNAME là các vụ giám đốc kiểm tra
        UNION ALL
        --lấy những vụ có USERNAME thuộc từ giám đốc kiểm tra, dữ liệu cũ
         SELECT PP.USERNAME FROM 
           (
              SELECT 'gdkt' USERNAME ,SUM(PA.COLUMN_1+PA.COLUMN_2+PA.COLUMN_3+PA.COLUMN_4)COLUMN_26  FROM TABLE(v_table) PA
              WHERE PA.USERNAME LIKE '%gdkt%' 
              group by 1, '(gdkt)', 'gdkt', 'gdkt', 0 
          )PP WHERE PP.COLUMN_26!=0
      )TT;
  ------------------------------------
    OPEN curReturn FOR
     SELECT PP.v_TT,PP.HOTEN_USERNAME,PP.HOTEN,PP.USERNAME_ID,PP.USERNAME,NULL USERNAME_LIST,nvl(PP.COLUMN_1,0)COLUMN_1,PP.COLUMN_2,PP.COLUMN_3,PP.COLUMN_4 FROM 
           (
              SELECT 1 v_TT,PA.HOTEN_USERNAME,PA.HOTEN,PA.USERNAME,PA.USERNAME_ID,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
              ,SUM(PA.COLUMN_1+PA.COLUMN_2+PA.COLUMN_3+PA.COLUMN_4)COLUMN_26 FROM TABLE(v_table) PA
              left JOIN QT_NGUOISUDUNG nsd ON PA.USERNAME_ID=nsd.ID 
              group by 1,PA.HOTEN_USERNAME, PA.USERNAME, PA.HOTEN, PA.USERNAME_ID
              ORDER BY SUBSTR(PA.HOTEN,INSTR(PA.HOTEN,' ',-1)+ 1)
          )PP WHERE PP.COLUMN_26!=0 AND PP.USERNAME NOT LIKE '%gdkt%'
          --PP.COLUMN_26!=0 loại bỏ như những loại án nào có tất cả các cột đều trống
          --AND PP.USERNAME NOT LIKE '%gdkt%' loại bỏ những vụ có USERNAME là các vụ giám đốc kiểm tra
    UNION ALL
        --lấy những vụ có USERNAME thuộc từ giám đốc kiểm tra, dữ liệu cũ
         SELECT PP.v_TT,PP.HOTEN_USERNAME,PP.HOTEN,PP.USERNAME_ID,PP.USERNAME,NULL USERNAME_LIST,PP.COLUMN_1,PP.COLUMN_2,PP.COLUMN_3,PP.COLUMN_4  FROM 
           (
              SELECT 1 v_TT,'(gdkt)' HOTEN_USERNAME,'gdkt' HOTEN,'gdkt' USERNAME,0 USERNAME_ID,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,SUM(PA.COLUMN_4)COLUMN_4
              ,SUM(PA.COLUMN_1+PA.COLUMN_2+PA.COLUMN_3+PA.COLUMN_4)COLUMN_26  FROM TABLE(v_table) PA
              WHERE PA.USERNAME LIKE '%gdkt%' 
              group by 1, '(gdkt)', 'gdkt', 'gdkt', 0 
          )PP WHERE PP.COLUMN_26!=0
     UNION ALL
          SELECT 0 v_TT,'<span class="tong_cong_tp">TỔNG CỘNG</span>' HOTEN_USERNAME,NULL HOTEN,NULL USERNAME_ID,NULL USERNAME,USERNAME_LIST,SUM(PA.COLUMN_1)COLUMN_1,SUM(PA.COLUMN_2)COLUMN_2,SUM(PA.COLUMN_3)COLUMN_3,DECODE(v_TONG_NGAY,0,0,ROUND(SUM(PA.COLUMN_2)/v_TONG_NGAY,2)) COLUMN_4
          FROM TABLE(v_table) PA
          GROUP BY 0,'<span class="tong_cong_tp">TỔNG CỘNG</span>',NULL;
     -----------------------------------
END TK_NGUOIDUNG_CREATE_DATA; 
END PKG_CC_HCTP;
