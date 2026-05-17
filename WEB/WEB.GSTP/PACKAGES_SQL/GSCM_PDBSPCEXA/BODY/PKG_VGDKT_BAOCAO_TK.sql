--------------------------------------------------------
--  DDL for Package Body PKG_VGDKT_BAOCAO_TK
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_VGDKT_BAOCAO_TK" AS
FUNCTION TC_LABO_DETAIL_DIS_CW
(  
    V_ToaAnID	in	VARCHAR2,
    V_PhongbanID	in	VARCHAR2,
    V_LOAIAN_ID in  VARCHAR2,
    v_LOAIXULY in	VARCHAR2,
    vTuNgay	in VARCHAR2,
    vDenNgay	in VARCHAR2
)RETURN SYS_REFCURSOR
AS
   v_cursor SYS_REFCURSOR; P_LIST_COUNT_NAME CLOB; hi_text_courts VARCHAR2(250);
   V_EXPORT_TEXT CLOB;v_TIME_FROM VARCHAR2(50);v_TIME_TO VARCHAR2(50);V_COLUMN_30 NUMBER;V_NAMES VARCHAR2(255);
BEGIN
    DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
    --tiêu đề-------------
    select ten into V_NAMES from dm_toaan where id=V_ToaAnID;
    DBMS_LOB.APPEND(V_EXPORT_TEXT,'
      <table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 10pt; text-align: center;">
            <tr>
                <td colspan="2" style="text-align: center; vertical-align: middle; height: 24px; font-weight: bold; font-size: 10pt">TOÀ ÁN NHÂN DÂN</td>
                <th colspan="27">THỐNG KÊ THỤ LÝ VÀ GIẢI QUYẾT ĐƠN ĐỀ NGHỊ GIÁM ĐỐC THẨM, TÁI THẨM</th>
                <th colspan="7" style="text-align: center; vertical-align: middle;">Mẫu 8A</th>
            </tr>
            <tr align="center">
                <th colspan="2" style="text-align: center; vertical-align: top; height: 35px">'||V_NAMES||'</th>
                <td colspan="27" style="text-align: center; vertical-align: top; font-style: italic;">Từ '||TO_CHAR(vTuNgay, 'dd/mm/yyyy')||' đến ngày '||TO_CHAR(vDenNgay, 'dd/mm/yyyy')||'</td>
                <td colspan="7" style="text-align: center; vertical-align: top; font-style: italic;">Dùng cho Tòa án nhân dân cấp cao và Tòa án nhân dân tối cao</td>
            </tr>
            <tr>
                <th rowspan="4" style="text-align: center; vertical-align: middle; border: 0.1pt solid Black;">LOẠI ÁN</th>
                <th colspan="7" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black; height: 30px;">Tổng số đơn đã nhận </th>
                <th colspan="9" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Số đơn thuộc thẩm quyền phải giải quyết</th>
                <th colspan="13" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Đã giải quyết</th>
                <th colspan="5" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Còn lại</th>
                <td rowspan="4" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Số vụ đương sự tiếp tục khiếu nại sau khi Tòa án đã trả lời đơn</td>
            </tr>
            <tr>
                <th colspan="3" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black; height: 30px;">Tổng số </th>
                <th colspan="3" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Đã xử lý</th>
                <td rowspan="3" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Đơn còn lại chưa xử lý</td>
                <td rowspan="3" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Cũ còn lại</td>
                <td rowspan="3" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Mới thụ lý</td>
                <td rowspan="3" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Chuyển đơn vị khác giải quyết hoặc VKS đã kháng nghị</td>
                <th colspan="6" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Tổng số</th>
                <th colspan="5" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Trả lời đơn</th>
                <th colspan="5" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Kháng nghị</th>
                <td rowspan="3" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Giải quyết khác</td>
                <th rowspan="3" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Cộng</th>
                <td rowspan="3" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Tỷ lệ giải quyết/ thụ lý</td>
                <th rowspan="3" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Tổng số</th>
                <td colspan="4" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black; font-style: italic;">Trong đó </td>
            </tr>
            <tr>
                <td rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Cũ còn lại</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Mới nhận trong kỳ thống kê</td>
                <th rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Cộng</th>
                <td rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Đơn trùng lặp hoặc không thuộc thẩm quyền hoặc chưa đủ điều kiện thụ lý</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Đơn thuộc thẩm quyền</td>
                <th rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Cộng</th>
                <th rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Cộng</th>
                <td colspan="5" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black; font-style: italic;">Trong đó </td>
                <th rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Tổng số</th>
                <td colspan="4" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black; font-style: italic;">Trong đó </td>
                <th rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Tổng số</th>
                <td colspan="4" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black; font-style: italic;">Trong đó </td>
                <td rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Có kiến nghị của đại biểu QH, đoàn ĐBQH</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Có kiến nghị của Ủy ban tư pháp của QH</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Các cơ quan khác của Quốc hội</td>
                <td rowspan="2" style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Các cơ quan Trung ương khác</td>
            </tr>
            <tr>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Có kiến nghị của đại biểu Quốc hội</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Có kiến nghị của Ủy ban tư pháp của QH</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Các cơ quan khác của Quốc hội</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Các cơ quan Trung ương khác</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black; font-style: italic;">Viện kiểm sát đang giải quyết</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Có kiến nghị của đại biểu QH, đoàn ĐBQH</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Có kiến nghị của Ủy ban tư pháp của QH</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Các cơ quan khác của Quốc hội</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Các cơ quan Trung ương khác</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Có kiến nghị của đại biểu QH, đoàn ĐBQH</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Có kiến nghị của Ủy ban tư pháp của QH</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Các cơ quan khác của Quốc hội</td>
                <td style="text-align: center; vertical-align: middle;border: 0.1pt solid Black;">Các cơ quan Trung ương khác</td>
            </tr>
            <tr align="center" style="font-style: italic;">
                <td style="border: 0.1pt solid Black; vertical-align: middle;">1</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">2</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">3</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">4</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">5</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">6</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">7</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">8</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">9</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">10</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">11</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">12</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">13</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">14</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">15</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">16</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">17</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">18</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">19</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">20</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">21</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">22</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">23</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">24</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">25</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">26</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">27</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">28</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">29</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">30</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">31</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">32</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">33</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">34</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">35</td>
                <td style="border: 0.1pt solid Black; vertical-align: middle;">36</td>
            </tr>
    ');
     
   
    --định nghĩa độ rộng của cột
    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
         <tr align="center">
               <td style="width: 160px;"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 55px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
                    <td style="width: 45px"></td>
            </tr>
         </table>
    ');
    OPEN v_cursor FOR
     SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
    ------------
    dbms_lob.freetemporary(V_EXPORT_TEXT);
    RETURN v_cursor;   
END;
END PKG_VGDKT_BAOCAO_TK;
