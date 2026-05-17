--------------------------------------------------------
--  DDL for Package Body PKG_STPT_SEARCH_ALL
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "GSCM"."PKG_STPT_SEARCH_ALL" AS


FUNCTION NHAPLIEU_HS_DS_EXT_ALL_V2_TOICAO
(
    vDonViID  IN number,
    v_TINHTRANG_THULY IN VARCHAR2,
    v_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_TOAANID in VARCHAR2
)RETURN SYS_REFCURSOR
AS  
    V_CURSOR sys_refcursor;VV_TUNGAY DATE;VV_DENNGAY DATE;V_TOAAN_NAME NVARCHAR2(250 CHAR);V_HANHCHINH_NAME NVARCHAR2(250 CHAR);
    V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;
    SOLUONGCHUAGQ number;
    v_TongThuLyST number;
    v_DaGiaQuyetST number;
    v_TongThuLyPT number;
    v_DaGiaQuyetPT number;
    v_TongThuLyGDT number;
    v_DaGiaQuyetGDT number;
    v_ArrSapXep varchar2(250);
    v_TongcongTLST number;
    v_TongcongTLPT number;
    v_TongcongTLGDT number;
    v_TongcongGQST number;
    v_TongcongGQPT number;
    v_TongcongGQGDT number;
    
    V_TABLE  T_THUY_GQ_TOANQUOC;
    V_TABLE_TOICAO  T_THUY_GQ_TOANQUOC;
    
    v_STT number;
    v_LOAITOA varchar2(250);
BEGIN	
    V_TABLE :=  T_THUY_GQ_TOANQUOC();
    V_TABLE_TOICAO :=  T_THUY_GQ_TOANQUOC();
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    ----
     SELECT TA.TEN,TA.LOAITOA INTO V_TOAAN_NAME, v_LOAITOA FROM DM_TOAAN TA WHERE TA.ID=vDonViID;
     ----
     select ARRSAPXEP into v_ArrSapXep from DM_TOAAN where ID=vDonViID;
     -------------
--     SELECT HC.TEN INTO V_HANHCHINH_NAME FROM DM_HANHCHINH HC 
--     WHERE EXISTS(SELECT 'X' FROM DM_TOAAN TA WHERE TA.ID=vDonViID AND TA.HANHCHINHID=HC.ID);
     ----

     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 

     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="12" style="text-align: center; vertical-align: top; font-size: 11pt">TÒA ÁN NHÂN DÂN TỐI CAO</td>
                <td colspan="30"></td>
                <th colspan="12" style="text-align: center; vertical-align: top; font-size: 11pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr style="text-align: center;">
                <th colspan="12" style="vertical-align: top; font-size: 11pt;">'||UPPER(V_TOAAN_NAME)||'</th>
                <td colspan="30"></td>
                <th colspan="12" style="vertical-align: top; font-size: 13pt;">Độc lập - Tự do - Hạnh phúc </th>
            </tr>
            <tr>

                <td colspan="54" style="line-height: 100%; font-size: 13pt; text-align: center; height: 80px;"><b>BÁO CÁO SỐ LIỆU KẾT QUẢ CÔNG TÁC THỤ LÝ, GIẢI QUYẾT THEO LOẠI ÁN</b></td>
            </tr>
            <tr>
                <td colspan="54" style="line-height: 100%; font-size: 13pt; text-align: center; height: 60px; font-style: italic;">Tính từ ngày '||V_TUNGAY||' đến '||V_DENNGAY||'</td>
            </tr>
            <tr>
            <td></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:70px" rowspan="3">TT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"rowspan="3">Đơn Vị</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">Hình sự</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">Dân sự</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">HN</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">Hành Chính</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">KDTM</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">Lao động</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">Phá sản</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="4">BPXLHC</td>                
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" colspan ="6">Tổng <br> <i>(Số liệu không bao gồm Án Phá sản và các BPXLHC)</i></th>
            </tr>
            <tr style="font-weight: bold;">

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>              
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>


            </tr>
            <tr>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

            </tr>
                 '); 
          DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 50px">1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 300px">2</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">6</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">7</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">8</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">9</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">10</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">11</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">12</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">13</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">14</td>

               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">15</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">16</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">17</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">18</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">19</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">20</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">21</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">22</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">23</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">24</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">25</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">26</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">27</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">28</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">29</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">30</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">31</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">32</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">33</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">34</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">35</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">36</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">37</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">38</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">39</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">40</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">41</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">42</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">43</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">44</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">45</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">46</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">47</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">48</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">49</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">50</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">51</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">52</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">53</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">54</td>
            </tr>
      ');
      
       v_STT := 0;
       
--       So lieu tao phuc tham
        FOR v_DM_TOAAN IN (
            WITH TOAAN_IDS AS (
                SELECT TO_NUMBER(REGEXP_SUBSTR(v_TOAANID, '[^,]+', 1, LEVEL)) AS ID
                FROM dual
                CONNECT BY REGEXP_SUBSTR(v_TOAANID, '[^,]+', 1, LEVEL) IS NOT NULL
            )
            , ROOT_CHA AS (
                SELECT t.ID
                FROM TOAAN_IDS t
                WHERE NOT EXISTS (
                    SELECT 1 FROM DM_TOAAN d
                    JOIN TOAAN_IDS t2 ON d.ID = t2.ID
                    WHERE t.ID = d.CAPCHAID and d.LOAITOA = 'CAPCAO'
                )
            )
            SELECT d.ID,d.TEN,d.LOAITOA,d.CAPCHAID
            FROM DM_TOAAN d
            WHERE d.ID IN (SELECT ID FROM ROOT_CHA)
              AND d.HIEULUC = 1  
              and d.LOAITOA = 'CAPCAO'
            ORDER BY d.ID
        )
        LOOP
        
        
            v_STT := v_STT + 1;
            
            v_TongcongTLST :=0;
            v_TongcongTLPT :=0;
            v_TongcongTLGDT :=0;
            v_TongcongGQST :=0;
            v_TongcongGQPT :=0;
            v_TongcongGQGDT :=0;
            
        
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                      <tr>
                         <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:70px">'||v_STT||'</td>');
             
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                         <th style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DM_TOAAN.TEN||'</th>');
            
           ---1.Hinh Sụ Sơ thẩm 
            -- Thu ly moi
             select count(hs.id) into v_TongThuLyST from GSCM.ahs_sotham_thuly hs                                
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id 
                                    where 
                                    V.TOAANID = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
            v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;                             
           
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');                      
                                     
            --Da giai quyet
              select COUNT(DISTINCT v.id) into v_DaGiaQuyetST from GSCM.ahs_vuan v
                                LEFT JOIN GSCM.AHS_SOTHAM_BANAN T2 ON v.id=T2.vuanid and T2.NGAYBANAN  BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID, Q.thulyid,Q.TOA_GIAIQUYET_ID
                                                        FROM GSCM.AHS_SOTHAM_QUYETDINH_VUAN Q 
                                                                LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY
                                    where 
                                        v.TOAANID = v_DM_TOAAN.ID 
--                                      Da co ket qua giai quyet
                                     AND (T2.ID is not null  
                                            or T3.ID is not null      
                                         );

              v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                             
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');                            
            --2.Hình sự phúc thẩm
            select count(hs.id) into v_TongThuLyPT from GSCM.ahs_phuctham_thuly hs 
                                        LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id 
                                         where 
                                            hs.TOAANID = v_DM_TOAAN.ID 
                                            and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                                            
            v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;
           
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');
                            
            
             select  COUNT(DISTINCT v.id) INTO v_DaGiaQuyetPT from GSCM.ahs_phuctham_thuly hs
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id
                                LEFT JOIN GSCM.AHS_PHUCTHAM_BANAN T2 ON v.id=T2.vuanid and T2.NGAYBANAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                      FROM GSCM.AHS_PHUCTHAM_QUYETDINH_VUAN Q 
                                                             LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                            WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                 where 
                                    
                                    hs.TOAANID = v_DM_TOAAN.ID 
                                    AND
                                    ( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                    );


             v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;  
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');   
                            
--            3. GDT
                select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 1 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;               
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 1 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;               
                V_TABLE_TOICAO.EXTEND;
                V_TABLE_TOICAO(V_TABLE_TOICAO.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,1, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');

--    An Dan su
                --1.So tham
                 select count(hs.id) INTO v_TongThuLyST from GSCM.ads_sotham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                where 
                                    D.TOAANID  = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                                    
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
              
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ads_sotham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ADS_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.ADS_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                 d.TOAANID = v_DM_TOAAN.ID 
                                AND
                                    (T2.ID is not null 
                                       or
                                       T3.ID is not null
                                    );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST; 
              
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
                --2.Phuc Tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ads_phuctham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;  
                 
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select COUNT(DISTINCT d.id) INTO v_DaGiaQuyetPT from GSCM.ads_phuctham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ADS_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.ADS_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                hs.TOAANID = v_DM_TOAAN.ID
                                AND 
                                    (T2.ID is not null 
                                       or
                                       T3.ID is not null       
                                     );
    
                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;    
                  
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');  
               -- 3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 2 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                 
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 2 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
                 V_TABLE_TOICAO.EXTEND;
                V_TABLE_TOICAO(V_TABLE_TOICAO.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,2, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               

--    An Hon Nhan  
                --1.So Tham
                 select count(hs.id) INTO v_TongThuLyST from GSCM.ahn_sotham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                where 
                                     D.TOAANID  = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;               
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ahn_sotham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHN_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.AHN_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                d.TOAANID = v_DM_TOAAN.ID
                                AND 
                                (
                                   T2.ID is not null 
                                   or
                                   T3.ID is not null
                                 );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST; 
               
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
                --2.Phuc tham
                 select count(DISTINCT hs.id) INTO v_TongThuLyPT from GSCM.ahn_phuctham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT; 
                  
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(hs.id) INTO v_DaGiaQuyetPT from GSCM.ahn_phuctham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHN_PHUCTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.AHN_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND
                                        (
                                         T2.ID is not null 
                                         or
                                           T3.ID is not null 
                                         );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT; 
                
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
                                
               --  3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 3 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 3
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
               
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
                V_TABLE_TOICAO.EXTEND;
                V_TABLE_TOICAO(V_TABLE_TOICAO.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,3, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
--      An Hanh chinh  
                ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.ahc_sotham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                where 
                                     D.TOAANID  = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ahc_sotham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHC_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.AHC_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                               
                                where 
                                     d.TOAANID = v_DM_TOAAN.ID
                                        AND
                                             (T2.ID is not null 
                                               or
                                                 T3.ID is not null 
                                               
                                             );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ahc_phuctham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.ahc_phuctham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHC_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.AHN_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where
                                
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND(T2.ID is not null 
                                            or
                                            T3.ID is not null 
                                         );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 6 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 6
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
                V_TABLE_TOICAO.EXTEND;
                V_TABLE_TOICAO(V_TABLE_TOICAO.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,6, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
--         an kinh te   

                ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.akt_sotham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.akt_sotham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Akt_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.Akt_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                     d.TOAANID = v_DM_TOAAN.ID
                                    AND( T2.ID is not null 
                                           or
                                           T3.ID is not null 
                                            
                                         );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.akt_phuctham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.akt_phuctham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Akt_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID ,Q.TOA_GIAIQUYET_ID
                                                                FROM GSCM.Akt_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                   hs.TOAANID = v_DM_TOAAN.ID
                                AND(
                                    T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                        
                                     );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 4 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 4
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
                V_TABLE_TOICAO.EXTEND;
                V_TABLE_TOICAO(V_TABLE_TOICAO.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,4, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
                 

--       An Lao dong
                 ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.ald_sotham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ald_sotham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ald_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.Ald_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                               
                                where 
                                    d.TOAANID = v_DM_TOAAN.ID
                                    AND( T2.ID is not null 
                                           or
                                           T3.ID is not null 
                                           
                                         );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ald_phuctham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.ald_phuctham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ald_PHUCTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.Ald_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND (T2.ID is not null
                                          or T3.ID is not null       
                                        ) ;

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 5 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 5
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
                V_TABLE_TOICAO.EXTEND;
                V_TABLE_TOICAO(V_TABLE_TOICAO.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,5, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
--    An Pha san                        
                     ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.aps_sotham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 --v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.aps_sotham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Aps_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                               FROM GSCM.Aps_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                 d.TOAANID = v_DM_TOAAN.ID
                                AND( T2.ID is not null  
                                       or
                                       T3.ID is not null 
                                       
                                     );

                --v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.aps_phuctham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 --v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.aps_phuctham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Aps_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                                FROM GSCM.Aps_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                     hs.TOAANID = v_DM_TOAAN.ID
                                AND(
                                    T2.ID is not null 
                                       or
                                        T3.ID is not null 
                                       
                                     );


                 --v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 7 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                --v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                 
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 7
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                --v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
                V_TABLE_TOICAO.EXTEND;
                V_TABLE_TOICAO(V_TABLE_TOICAO.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,7, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
        
  --  BPXLHC                       
                ---1.So tham
                select count(hs.id) INTO v_TongThuLyST from GSCM.XLHC_SOTHAM_THULY hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                where 
                                    d.TOAANID = v_DM_TOAAN.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.xlhc_sotham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.xlhc_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                               FROM GSCM.xlhc_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                              
                                where 
                                   d.TOAANID = v_DM_TOAAN.ID
                                AND( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                     );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.xlhc_phuctham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.xlhc_phuctham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.xlhc_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                                FROM GSCM.xlhc_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                   hs.TOAANID = v_DM_TOAAN.ID
                                AND( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                     );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
                V_TABLE_TOICAO.EXTEND;
                V_TABLE_TOICAO(V_TABLE_TOICAO.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,8, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,0,0);
               
--Tong so 
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLST||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQST||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLPT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQPT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLGDT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQGDT||'</td>
                      </tr>
                   '); 
        END LOOP;
        
--So lieu cho CAPTINH va Huyen
      FOR v_DM_TOAAN IN (
        WITH TOAAN_IDS AS (
            SELECT TO_NUMBER(REGEXP_SUBSTR(v_TOAANID, '[^,]+', 1, LEVEL)) AS ID
            FROM dual
            CONNECT BY REGEXP_SUBSTR(v_TOAANID, '[^,]+', 1, LEVEL) IS NOT NULL
        )
        , ROOT_CHA AS (
            SELECT t.ID
            FROM TOAAN_IDS t
            WHERE NOT EXISTS (
                SELECT 1 FROM DM_TOAAN d
                JOIN TOAAN_IDS t2 ON d.ID = t2.ID
                WHERE t.ID = d.CAPCHAID and d.LOAITOA = 'CAPTINH'
            )
        )
        SELECT d.ID,d.TEN,d.LOAITOA,d.CAPCHAID
        FROM DM_TOAAN d
        WHERE d.ID IN (SELECT ID FROM ROOT_CHA)
          AND d.HIEULUC = 1  
          and d.LOAITOA = 'CAPTINH'
        ORDER BY d.ID
    )
    LOOP
--        DBMS_OUTPUT.PUT_LINE('CHA: ' || cha_rec.ID || ' - ' || cha_rec.TEN_TOAAN);
         
            v_TongcongTLST :=0;
            v_TongcongTLPT :=0;
            v_TongcongTLGDT :=0;
            v_TongcongGQST :=0;
            v_TongcongGQPT :=0;
            v_TongcongGQGDT :=0;
            
            v_STT := v_STT + 1;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                      <tr>
                         <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:70px">'||v_STT||'</td>');
             
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                         <th style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DM_TOAAN.TEN||'</th>');
            
           ---1.Hinh Sụ Sơ thẩm 
            -- Thu ly moi
             select count(hs.id) into v_TongThuLyST from GSCM.ahs_sotham_thuly hs                                
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id 
                                    where 
                                   ( V.TOAANID = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR v.TOA_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
            v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;                              
            
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');                      
                                     
            --Da giai quyet
              select COUNT(DISTINCT v.id) into v_DaGiaQuyetST from GSCM.ahs_vuan v
                                LEFT JOIN GSCM.AHS_SOTHAM_BANAN T2 ON v.id=T2.vuanid and T2.NGAYBANAN  BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID, Q.thulyid,Q.TOA_GIAIQUYET_ID
                                                        FROM GSCM.AHS_SOTHAM_QUYETDINH_VUAN Q 
                                                                LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY
                                    where 
                                        v.TOAANID = v_DM_TOAAN.ID 
--                                      Da co ket qua giai quyet
                                     AND (T2.ID is not null  
                                            or T3.ID is not null      
                                         );

              v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                             
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');                            
            --2.Hình sự phúc thẩm
            select count(hs.id) into v_TongThuLyPT from GSCM.ahs_phuctham_thuly hs 
                                        LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id 
                                         where 
                                            hs.TOAANID = v_DM_TOAAN.ID 
                                            and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                                            
            v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;
           
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');
                            
            
             select  COUNT(DISTINCT v.id) INTO v_DaGiaQuyetPT from GSCM.ahs_phuctham_thuly hs
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id
                                LEFT JOIN GSCM.AHS_PHUCTHAM_BANAN T2 ON v.id=T2.vuanid and T2.NGAYBANAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                      FROM GSCM.AHS_PHUCTHAM_QUYETDINH_VUAN Q 
                                                             LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                            WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                 where 
                                    
                                    hs.TOAANID = v_DM_TOAAN.ID 
                                    AND
                                    ( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                    );


             v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;  
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');   
                            
--            3. GDT
                select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 1 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;               
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 1 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,1, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');

--    An Dan su
                --1.So tham
                 select count(hs.id) INTO v_TongThuLyST from GSCM.ads_sotham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                where 
                                    D.TOAANID  = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                                    
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
              
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ads_sotham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ADS_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.ADS_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                 d.TOAANID = v_DM_TOAAN.ID 
                                AND
                                    (T2.ID is not null 
                                       or
                                       T3.ID is not null
                                    );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST; 
              
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
                --2.Phuc Tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ads_phuctham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;  
                 
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select COUNT(DISTINCT d.id) INTO v_DaGiaQuyetPT from GSCM.ads_phuctham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ADS_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.ADS_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                hs.TOAANID = v_DM_TOAAN.ID
                                AND 
                                    (T2.ID is not null 
                                       or
                                       T3.ID is not null       
                                     );
    
                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;    
                  
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');  
               -- 3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 2 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                 
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 2 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
                 V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,2, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               

--    An Hon Nhan  
                --1.So Tham
                 select count(hs.id) INTO v_TongThuLyST from GSCM.ahn_sotham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                where 
                                     D.TOAANID  = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;               
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ahn_sotham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHN_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.AHN_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                d.TOAANID = v_DM_TOAAN.ID
                                AND 
                                (
                                   T2.ID is not null 
                                   or
                                   T3.ID is not null
                                 );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST; 
               
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
                --2.Phuc tham
                 select count(DISTINCT hs.id) INTO v_TongThuLyPT from GSCM.ahn_phuctham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT; 
                  
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(hs.id) INTO v_DaGiaQuyetPT from GSCM.ahn_phuctham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHN_PHUCTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.AHN_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND
                                        (
                                         T2.ID is not null 
                                         or
                                           T3.ID is not null 
                                         );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT; 
                
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
                                
               --  3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 3 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 3
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
               
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
                V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,3, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
--      An Hanh chinh  
                ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.ahc_sotham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                where 
                                     D.TOAANID  = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ahc_sotham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHC_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.AHC_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                               
                                where 
                                     d.TOAANID = v_DM_TOAAN.ID
                                        AND
                                             (T2.ID is not null 
                                               or
                                                 T3.ID is not null 
                                               
                                             );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ahc_phuctham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.ahc_phuctham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHC_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.AHN_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where
                                
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND(T2.ID is not null 
                                            or
                                            T3.ID is not null 
                                         );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 6 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 6
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
             V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,6, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
--         an kinh te   

                ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.akt_sotham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.akt_sotham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Akt_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.Akt_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                     d.TOAANID = v_DM_TOAAN.ID
                                    AND( T2.ID is not null 
                                           or
                                           T3.ID is not null 
                                            
                                         );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.akt_phuctham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.akt_phuctham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Akt_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID ,Q.TOA_GIAIQUYET_ID
                                                                FROM GSCM.Akt_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                   hs.TOAANID = v_DM_TOAAN.ID
                                AND(
                                    T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                        
                                     );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 4 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 4
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
                V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,4, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
                 

--       An Lao dong
                 ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.ald_sotham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ald_sotham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ald_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.Ald_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                               
                                where 
                                    d.TOAANID = v_DM_TOAAN.ID
                                    AND( T2.ID is not null 
                                           or
                                           T3.ID is not null 
                                           
                                         );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ald_phuctham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.ald_phuctham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ald_PHUCTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.Ald_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND (T2.ID is not null
                                          or T3.ID is not null       
                                        ) ;

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 5 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 5
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
                 V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,5, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
--    An Pha san                        
                     ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.aps_sotham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 --v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.aps_sotham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Aps_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                               FROM GSCM.Aps_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                 d.TOAANID = v_DM_TOAAN.ID
                                AND( T2.ID is not null  
                                       or
                                       T3.ID is not null 
                                       
                                     );

                --v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.aps_phuctham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 --v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.aps_phuctham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Aps_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                                FROM GSCM.Aps_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                     hs.TOAANID = v_DM_TOAAN.ID
                                AND(
                                    T2.ID is not null 
                                       or
                                        T3.ID is not null 
                                       
                                     );


                 --v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 7 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                --v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                 
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 7
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                --v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
                 V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,7, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
        
  --  BPXLHC                       
                ---1.So tham
                select count(hs.id) INTO v_TongThuLyST from GSCM.XLHC_SOTHAM_THULY hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                where 
                                    d.TOAANID = v_DM_TOAAN.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.xlhc_sotham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.xlhc_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                               FROM GSCM.xlhc_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                              
                                where 
                                   d.TOAANID = v_DM_TOAAN.ID
                                AND( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                     );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.xlhc_phuctham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.xlhc_phuctham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.xlhc_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                                FROM GSCM.xlhc_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                   hs.TOAANID = v_DM_TOAAN.ID
                                AND( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                     );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
                
                V_TABLE.EXTEND;
                V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN.ID,v_DM_TOAAN.LOAITOA,v_DM_TOAAN.CAPCHAID,8, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
--Tong so 
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLST||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQST||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLPT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQPT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLGDT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQGDT||'</td>
                      </tr>
                   '); 


           
        -- Vòng lặp CON cho từng CHA
        FOR v_DM_TOAAN_CON IN (
            SELECT d.ID,
                   d.TEN,d.LOAITOA,d.CAPCHAID,
                   LEVEL AS CAP
            FROM DM_TOAAN d
            WHERE d.HIEULUC = 1  
                AND d.ID <> v_DM_TOAAN.ID
            START WITH d.ID = v_DM_TOAAN.ID
            CONNECT BY PRIOR d.ID = d.CAPCHAID
              AND d.HIEULUC = 1
            ORDER SIBLINGS BY d.ID
        )
        LOOP
             
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                      <tr>
                         <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:70px"></td>');
            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                         <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;width:600px">'||v_DM_TOAAN_CON.TEN||'</td>');
           
           ---1.Hinh Sụ Sơ thẩm 
            -- Thu ly moi
             select count(hs.id) into v_TongThuLyST from GSCM.ahs_sotham_thuly hs                                
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id 
                                    where 
                                   ( V.TOAANID = v_DM_TOAAN_CON.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR v.TOA_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN_CON.ID )
                                        )
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
            v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;         
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');                      
                                     
            --Da giai quyet
              select COUNT(DISTINCT v.id) into v_DaGiaQuyetST from GSCM.ahs_vuan v
                                LEFT JOIN GSCM.AHS_SOTHAM_BANAN T2 ON v.id=T2.vuanid and T2.NGAYBANAN  BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID, Q.thulyid,Q.TOA_GIAIQUYET_ID
                                                        FROM GSCM.AHS_SOTHAM_QUYETDINH_VUAN Q 
                                                                LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY
                                    where 
                                        v.TOAANID = v_DM_TOAAN_CON.ID 
--                                      Da co ket qua giai quyet
                                     AND (T2.ID is not null  
                                            or T3.ID is not null      
                                         );

              v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');                            
            --2.Hình sự phúc thẩm
            select count(hs.id) into v_TongThuLyPT from GSCM.ahs_phuctham_thuly hs 
                                        LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id 
                                         where 
                                            hs.TOAANID = v_DM_TOAAN_CON.ID 
                                            and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                                            
            v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');
                            
            
             select  COUNT(DISTINCT v.id) INTO v_DaGiaQuyetPT from GSCM.ahs_phuctham_thuly hs
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id
                                LEFT JOIN GSCM.AHS_PHUCTHAM_BANAN T2 ON v.id=T2.vuanid and T2.NGAYBANAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                      FROM GSCM.AHS_PHUCTHAM_QUYETDINH_VUAN Q 
                                                             LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                            WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                 where 
                                    
                                    hs.TOAANID = v_DM_TOAAN_CON.ID 
                                    AND
                                    ( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                    );


             v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');   
                            
--            3. GDT
                select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 1 
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 1 
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');

            V_TABLE.EXTEND;
            V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN_CON.ID,v_DM_TOAAN_CON.LOAITOA,v_DM_TOAAN_CON.CAPCHAID,1, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
--    An Dan su
                --1.So tham
                 select count(hs.id) INTO v_TongThuLyST from GSCM.ads_sotham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                where 
                                    D.TOAANID  = v_DM_TOAAN_CON.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                                    
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ads_sotham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ADS_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.ADS_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                 d.TOAANID = v_DM_TOAAN_CON.ID 
                                AND
                                    (T2.ID is not null 
                                       or
                                       T3.ID is not null
                                    );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
                --2.Phuc Tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ads_phuctham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN_CON.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select COUNT(DISTINCT d.id) INTO v_DaGiaQuyetPT from GSCM.ads_phuctham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ADS_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.ADS_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                hs.TOAANID = v_DM_TOAAN_CON.ID
                                AND 
                                    (T2.ID is not null 
                                       or
                                       T3.ID is not null       
                                     );
    
                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');  
               -- 3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 2 
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 2 
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
            
            V_TABLE.EXTEND;
            V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN_CON.ID,v_DM_TOAAN_CON.LOAITOA,v_DM_TOAAN_CON.CAPCHAID,2, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               

--    An Hon Nhan  
                --1.So Tham
                 select count(hs.id) INTO v_TongThuLyST from GSCM.ahn_sotham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                where 
                                     D.TOAANID  = v_DM_TOAAN_CON.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ahn_sotham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHN_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.AHN_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                d.TOAANID = v_DM_TOAAN_CON.ID
                                AND 
                                (
                                   T2.ID is not null 
                                   or
                                   T3.ID is not null
                                 );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
                --2.Phuc tham
                 select count(DISTINCT hs.id) INTO v_TongThuLyPT from GSCM.ahn_phuctham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN_CON.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(hs.id) INTO v_DaGiaQuyetPT from GSCM.ahn_phuctham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHN_PHUCTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.AHN_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                    hs.TOAANID = v_DM_TOAAN_CON.ID
                                    AND
                                        (
                                         T2.ID is not null 
                                         or
                                           T3.ID is not null 
                                         );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
                                
               --  3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 3 
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 3
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
         V_TABLE.EXTEND;
            V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN_CON.ID,v_DM_TOAAN_CON.LOAITOA,v_DM_TOAAN_CON.CAPCHAID,3, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
--      An Hanh chinh  
                ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.ahc_sotham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                where 
                                     D.TOAANID  = v_DM_TOAAN_CON.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ahc_sotham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHC_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.AHC_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                               
                                where 
                                     d.TOAANID = v_DM_TOAAN_CON.ID
                                        AND
                                             (T2.ID is not null 
                                               or
                                                 T3.ID is not null 
                                               
                                             );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ahc_phuctham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN_CON.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.ahc_phuctham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHC_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.AHN_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where
                                
                                    hs.TOAANID = v_DM_TOAAN_CON.ID
                                    AND(T2.ID is not null 
                                            or
                                            T3.ID is not null 
                                         );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 6 
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 6
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
         V_TABLE.EXTEND;
            V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN_CON.ID,v_DM_TOAAN_CON.LOAITOA,v_DM_TOAAN_CON.CAPCHAID,6, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
        
        
--         an kinh te   

                ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.akt_sotham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN_CON.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.akt_sotham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Akt_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.Akt_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                     d.TOAANID = v_DM_TOAAN_CON.ID
                                    AND( T2.ID is not null 
                                           or
                                           T3.ID is not null 
                                            
                                         );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.akt_phuctham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN_CON.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.akt_phuctham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Akt_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID ,Q.TOA_GIAIQUYET_ID
                                                                FROM GSCM.Akt_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                   hs.TOAANID = v_DM_TOAAN_CON.ID
                                AND(
                                    T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                        
                                     );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 4 
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 4
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
           V_TABLE.EXTEND;
            V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN_CON.ID,v_DM_TOAAN_CON.LOAITOA,v_DM_TOAAN_CON.CAPCHAID,4, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
                      

--       An Lao dong
                 ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.ald_sotham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN_CON.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ald_sotham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ald_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.Ald_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                               
                                where 
                                    d.TOAANID = v_DM_TOAAN_CON.ID
                                    AND( T2.ID is not null 
                                           or
                                           T3.ID is not null 
                                           
                                         );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ald_phuctham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN_CON.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.ald_phuctham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ald_PHUCTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.Ald_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                    hs.TOAANID = v_DM_TOAAN_CON.ID
                                    AND (T2.ID is not null
                                          or T3.ID is not null       
                                        ) ;

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 5 
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 5
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
             V_TABLE.EXTEND;
            V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN_CON.ID,v_DM_TOAAN_CON.LOAITOA,v_DM_TOAAN_CON.CAPCHAID,5, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
                   
--    An Pha san                        
                     ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.aps_sotham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN_CON.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 --v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.aps_sotham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Aps_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                               FROM GSCM.Aps_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                 d.TOAANID = v_DM_TOAAN_CON.ID
                                AND( T2.ID is not null  
                                       or
                                       T3.ID is not null 
                                       
                                     );

                --v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.aps_phuctham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN_CON.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 --v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.aps_phuctham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Aps_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                                FROM GSCM.Aps_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                     hs.TOAANID = v_DM_TOAAN_CON.ID
                                AND(
                                    T2.ID is not null 
                                       or
                                        T3.ID is not null 
                                       
                                     );


                 --v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 7 
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                --v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                 
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 7
                                     AND hs.toaanid = v_DM_TOAAN_CON.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                --v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
         V_TABLE.EXTEND;
            V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN_CON.ID,v_DM_TOAAN_CON.LOAITOA,v_DM_TOAAN_CON.CAPCHAID,7, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
               
  --  BPXLHC                       
                ---1.So tham
                select count(hs.id) INTO v_TongThuLyST from GSCM.XLHC_SOTHAM_THULY hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                where 
                                    d.TOAANID = v_DM_TOAAN_CON.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.xlhc_sotham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.xlhc_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                               FROM GSCM.xlhc_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                              
                                where 
                                   d.TOAANID = v_DM_TOAAN_CON.ID
                                AND( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                     );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.xlhc_phuctham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN_CON.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.xlhc_phuctham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.xlhc_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                                FROM GSCM.xlhc_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                   hs.TOAANID = v_DM_TOAAN_CON.ID
                                AND( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                     );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
                V_TABLE.EXTEND;
             V_TABLE(V_TABLE.COUNT) := R_THUY_GQ_TOANQUOC(v_DM_TOAAN_CON.ID,v_DM_TOAAN_CON.LOAITOA,v_DM_TOAAN_CON.CAPCHAID,8, v_TongThuLyST, v_DaGiaQuyetST, v_TongThuLyPT,v_DaGiaQuyetPT,v_TongThuLyGDT,v_DaGiaQuyetGDT);
                 
--Tong so 
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLST||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQST||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLPT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQPT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLGDT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQGDT||'</td>
                      </tr>
                   '); 

        END LOOP;
        --Tong khu vuc
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 50px;height:70px"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 300px">Tổng khu vực '||
                                CASE 
                                        WHEN INSTR(v_DM_TOAAN.TEN, 'tỉnh') > 0 
                                             THEN SUBSTR(v_DM_TOAAN.TEN, INSTR(v_DM_TOAAN.TEN, 'tỉnh', -1))
                                        WHEN INSTR(lower(v_DM_TOAAN.TEN), 'thành phố') > 0 
                                             THEN SUBSTR(v_DM_TOAAN.TEN, INSTR(lower(v_DM_TOAAN.TEN), 'thành phố', -1))
                                        ELSE v_DM_TOAAN.TEN
                                    END ||'</td>
            ');
            --Theo loai an
             FOR ITEM_KhuVuc IN (  SELECT 
                                    L.ID  AS LOAIAN,
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM DM_LOAIAN L
                                     LEFT JOIN TABLE(V_TABLE) V 
                                         ON L.ID = V.LOAIAN
                                        AND V.CHA_ID = v_DM_TOAAN.ID
                                GROUP BY V.CHA_ID, L.ID
                                ORDER BY L.ID
            ) 
            LOOP       
                IF (ITEM_KhuVuc.LOAIAN = 8) THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                       
                        ');                

                ELSE
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDGQ||'</td>
                        ');
                END IF;
            END LOOP;
            --Cot tong cac loai an
             FOR ITEM_KhuVuc_LoaiAN IN (
                                SELECT 
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM TABLE(V_TABLE) V 
                                    WHERE V.CHA_ID = v_DM_TOAAN.ID
                                GROUP BY V.CHA_ID
                               
                               
            ) 
            LOOP      
               
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDGQ||'</td>
                ');                
            END LOOP;
            
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                </tr>
          ');
          
        --Tong hai cap
        DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 50px;height:70px"></td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 300px">Tổng hai cấp '||
                                CASE 
                                        WHEN INSTR(v_DM_TOAAN.TEN, 'tỉnh') > 0 
                                             THEN SUBSTR(v_DM_TOAAN.TEN, INSTR(v_DM_TOAAN.TEN, 'tỉnh', -1))
                                        WHEN INSTR(lower(v_DM_TOAAN.TEN), 'thành phố') > 0 
                                             THEN SUBSTR(v_DM_TOAAN.TEN, INSTR(lower(v_DM_TOAAN.TEN), 'thành phố', -1))
                                        ELSE v_DM_TOAAN.TEN
                                    END ||'</td>
            ');
            --Theo loai an
             FOR ITEM_KhuVuc IN (  SELECT 
                                    L.ID  AS LOAIAN,
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM DM_LOAIAN L
                                     LEFT JOIN TABLE(V_TABLE) V 
                                         ON L.ID = V.LOAIAN
                                        AND (V.CHA_ID = v_DM_TOAAN.ID OR V.COURT_ID  = v_DM_TOAAN.ID)
                                GROUP BY L.ID
                                ORDER BY L.ID
            ) 
            LOOP       
                IF (ITEM_KhuVuc.LOAIAN = 8) THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                       
                        ');                

                ELSE
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDGQ||'</td>
                        ');
                END IF;
            END LOOP;
            --Cot tong cac loai an
             FOR ITEM_KhuVuc_LoaiAN IN (
                                SELECT 
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM TABLE(V_TABLE) V 
                                    WHERE V.CHA_ID = v_DM_TOAAN.ID OR V.COURT_ID  = v_DM_TOAAN.ID
                           
            ) 
            LOOP      
               
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDGQ||'</td>
                ');                
            END LOOP;
            
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                </tr>
          ');
     
        
    END LOOP;
    
    
    --        Tong 3 Toa phuc tham
         DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 50px;height:70px"></td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;width: 300px">Tổng 3 Tòa phúc thẩm </td>
            ');
            --Theo loai an
             FOR ITEM_KhuVuc IN (  SELECT 
                                    L.ID  AS LOAIAN,
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM DM_LOAIAN L
                                     LEFT JOIN TABLE(V_TABLE_TOICAO) V 
                                         ON L.ID = V.LOAIAN
                                GROUP BY L.ID
                                ORDER BY L.ID
            ) 
            LOOP       
                IF (ITEM_KhuVuc.LOAIAN = 8) THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                       ');                

                ELSE
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDGQ||'</td>
                        ');
                END IF;
            END LOOP;
            --Cot tong cac loai an
             FOR ITEM_KhuVuc_LoaiAN IN (
                                SELECT 
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM TABLE(V_TABLE_TOICAO) V 
                           
            ) 
            LOOP      
               
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDGQ||'</td>
                ');                
            END LOOP;
            
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                </tr>
          ');
    
    
    --Tổng tỉnh
     DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 50px;height:70px"></td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;width: 300px">Tổng cấp tỉnh </td>
            ');
            --Theo loai an
             FOR ITEM_KhuVuc IN (  SELECT 
                                    L.ID  AS LOAIAN,
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM DM_LOAIAN L
                                     LEFT JOIN TABLE(V_TABLE) V 
                                         ON L.ID = V.LOAIAN
                                        AND V.LOAITOA = 'CAPTINH'
                                GROUP BY L.ID
                                ORDER BY L.ID
            ) 
            LOOP       
                IF (ITEM_KhuVuc.LOAIAN = 8) THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                       
                        ');                

                ELSE
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDGQ||'</td>
                        ');
                END IF;
            END LOOP;
            --Cot tong cac loai an
             FOR ITEM_KhuVuc_LoaiAN IN (
                                SELECT 
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM TABLE(V_TABLE) V 
                                    WHERE V.LOAITOA = 'CAPTINH'
                           
            ) 
            LOOP      
               
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDGQ||'</td>
                ');                
            END LOOP;
            
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                </tr>
          ');
    --Tổng khu vực
      DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 50px;height:70px"></td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;width: 300px">Tổng cấp khu vực</td>
            ');
            --Theo loai an
             FOR ITEM_KhuVuc IN (  SELECT 
                                    L.ID  AS LOAIAN,
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM DM_LOAIAN L
                                     LEFT JOIN TABLE(V_TABLE) V 
                                         ON L.ID = V.LOAIAN
                                        AND V.LOAITOA = 'CAPHUYEN'
                                GROUP BY L.ID
                                ORDER BY L.ID
            ) 
            LOOP       
                IF (ITEM_KhuVuc.LOAIAN = 8) THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                       
                        ');                

                ELSE
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDGQ||'</td>
                        ');
                END IF;
            END LOOP;
            --Cot tong cac loai an
             FOR ITEM_KhuVuc_LoaiAN IN (
                                SELECT 
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM TABLE(V_TABLE) V 
                                    WHERE V.LOAITOA = 'CAPHUYEN'
                           
            ) 
            LOOP      
               
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDGQ||'</td>
                ');                
            END LOOP;
            
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                </tr>
          ');
    
    --Tổng hai cấp
        DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 50px;height:70px"></td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;width: 300px">Tổng hai cấp địa phương</td>
            ');
            --Theo loai an
             FOR ITEM_KhuVuc IN (  SELECT 
                                    L.ID  AS LOAIAN,
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM DM_LOAIAN L
                                     LEFT JOIN TABLE(V_TABLE) V 
                                         ON L.ID = V.LOAIAN
                                GROUP BY L.ID
                                ORDER BY L.ID
            ) 
            LOOP       
                IF (ITEM_KhuVuc.LOAIAN = 8) THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                       
                        ');                

                ELSE
                     DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongSTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongPTGQ||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDTL||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc.TongGDGQ||'</td>
                        ');
                END IF;
            END LOOP;
            --Cot tong cac loai an
             FOR ITEM_KhuVuc_LoaiAN IN (
                                SELECT 
                                    SUM(NVL(V.COLUMN_1,0)) AS TongSTTL,
                                    SUM(NVL(V.COLUMN_2,0)) AS TongSTGQ,
                                    SUM(NVL(V.COLUMN_3,0)) AS TongPTTL,
                                    SUM(NVL(V.COLUMN_4,0)) AS TongPTGQ,
                                    SUM(NVL(V.COLUMN_5,0)) AS TongGDTL,
                                    SUM(NVL(V.COLUMN_6,0)) AS TongGDGQ
                                FROM TABLE(V_TABLE) V 
                           
            ) 
            LOOP      
               
             DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongSTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongPTGQ||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDTL||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">'||ITEM_KhuVuc_LoaiAN.TongGDGQ||'</td>
                ');                
            END LOOP;
            
         DBMS_LOB.APPEND(V_EXPORT_TEXT,'    
                </tr>
          ');
          
          DBMS_LOB.APPEND(V_EXPORT_TEXT,'<tr><td Colspan="56" style=" text-align: left; vertical-align: middle;"> Thời gian xuất báo cáo: ' || TO_CHAR(SYSDATE, 'HH24:MI:SS - DD/MM/YYYY') || '</td></tr>');

    
      
        DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        </table>
      ');

    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;  

END NHAPLIEU_HS_DS_EXT_ALL_V2_TOICAO;



FUNCTION NHAPLIEU_HS_DS_EXT_ALL_V2
(
    vDonViID  IN number,
    v_TINHTRANG_THULY IN VARCHAR2,
    v_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_TOAANID in VARCHAR2
)RETURN SYS_REFCURSOR
AS  
    V_CURSOR sys_refcursor;VV_TUNGAY DATE;VV_DENNGAY DATE;V_TOAAN_NAME NVARCHAR2(250 CHAR);V_HANHCHINH_NAME NVARCHAR2(250 CHAR);
    V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;
    SOLUONGCHUAGQ number;
    v_TongThuLyST number;
    v_DaGiaQuyetST number;
    v_TongThuLyPT number;
    v_DaGiaQuyetPT number;
    v_TongThuLyGDT number;
    v_DaGiaQuyetGDT number;
    v_ArrSapXep varchar2(250);
    v_TongcongTLST number;
    v_TongcongTLPT number;
    v_TongcongTLGDT number;
    v_TongcongGQST number;
    v_TongcongGQPT number;
    v_TongcongGQGDT number;
    v_STT number;
    v_LOAITOA varchar2(250);
BEGIN	
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    ----
     SELECT TA.TEN,TA.LOAITOA INTO V_TOAAN_NAME, v_LOAITOA FROM DM_TOAAN TA WHERE TA.ID=vDonViID;
     ----
     select ARRSAPXEP into v_ArrSapXep from DM_TOAAN where ID=vDonViID;
     -------------
     SELECT HC.TEN INTO V_HANHCHINH_NAME FROM DM_HANHCHINH HC 
     WHERE EXISTS(SELECT 'X' FROM DM_TOAAN TA WHERE TA.ID=vDonViID AND TA.HANHCHINHID=HC.ID);
     ----

     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 

     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="12" style="text-align: center; vertical-align: top; font-size: 11pt">TÒA ÁN NHÂN DÂN TỐI CAO</td>
                <td colspan="30"></td>
                <th colspan="12" style="text-align: center; vertical-align: top; font-size: 11pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr style="text-align: center;">
                <th colspan="12" style="vertical-align: top; font-size: 11pt;">'||UPPER(V_TOAAN_NAME)||'</th>
                <td colspan="30"></td>
                <th colspan="12" style="vertical-align: top; font-size: 13pt;">Độc lập - Tự do - Hạnh phúc </th>
            </tr>
            <tr>

                <td colspan="54" style="line-height: 100%; font-size: 13pt; text-align: center; height: 80px;"><b>BÁO CÁO SỐ LIỆU KẾT QUẢ CÔNG TÁC THỤ LÝ, GIẢI QUYẾT THEO LOẠI ÁN</b></td>
            </tr>
            <tr>
                <td colspan="54" style="line-height: 100%; font-size: 13pt; text-align: center; height: 60px; font-style: italic;">Tính từ ngày '||V_TUNGAY||' đến '||V_DENNGAY||'</td>
            </tr>
            <tr>
            <td></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:70px" rowspan="3">TT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"rowspan="3">Đơn Vị</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">Hình sự</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">Dân sự</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">HN</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">Hành Chính</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">KDTM</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">Lao động</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="6">Phá sản</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="4">BPXLHC</td>                
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" colspan ="6">Tổng <br> <i>(Số liệu không bao gồm Án Phá sản và các BPXLHC)</i></th>
            </tr>
            <tr style="font-weight: bold;">

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>              
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 350px;"colspan ="2">GDTT,TT</td>


            </tr>
            <tr>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Thụ lý mới</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đã giải quyết</td>

            </tr>
                 '); 
          DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 50px">1</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 300px">2</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">3</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">4</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">5</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">6</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">7</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">8</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">9</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">10</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">11</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">12</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">13</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">14</td>

               <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">15</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">16</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">17</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">18</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">19</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">20</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">21</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">22</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">23</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">24</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">25</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">26</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">27</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">28</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">29</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">30</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">31</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">32</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">33</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">34</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">35</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">36</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">37</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">38</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">39</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">40</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">41</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">42</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">43</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 100px">44</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">45</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">46</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">47</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">48</td>
                
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">49</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">50</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">51</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">52</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">53</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;width: 120px">54</td>
            </tr>
      ');        
        
        v_STT := 0;
       FOR v_DM_TOAAN In (
                 SELECT TC.* FROM  
                 (SELECT CO.* FROM DM_TOAAN CO 
                        LEFT JOIN DM_TOAAN CC ON CC.ID=CO.CAPCHAID
                          WHERE (((CO.ID IN( SELECT SS.ID 
                                              FROM DM_TOAAN SS
                                              LEFT JOIN DM_TOAAN K ON K.ID=SS.CAPCHAID
                                              CONNECT BY PRIOR SS.CAPCHAID = SS.ID
                                            )  
                                      ))
                                )  AND CO.HIEULUC = 1
                            AND (instr(','||v_TOAANID||',',','||CO.ID||',')>0 AND v_TOAANID IS NOT NULL)
                               -- AND (instr(',3931,7,1710,1711,1712,1713,1714,1715,1716,1717,1718,1719,1720,1721,21,217,224,1789,1790,1791,1792,48,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,46,1972,1973,1974,1975,1976,1977,1978,1979,1980,1981,1982,1983,1984,1985,49,2001,2002,2003,2004,2005,2006,2007,2008,43,1961,1962,1963,1964,1965,1966,1967,1968,1969,1970,1971,20,1781,1782,1783,1784,1785,1786,1787,1788,3932,66,1916,1917,1918,1919,1920,1921,1922,1923,1924,1925,1926,1927,1928,1929,28,1834,1835,1836,1837,1838,1839,1840,1841,1842,1843,1844,1845,1846,1847,1848,1849,1850,1851,1852,41,1952,1953,1954,1955,1956,1957,1958,1959,1960,55,2038,2039,2040,2041,2042,2043,2044,2045,2046,2047,2048,2049,2050,2051,62,1889,1890,1891,1892,1893,1894,1895,1896,1897,1898,1899,1900,50,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2009,53,2026,2027,2028,2029,2030,2031,2032,2033,2034,2035,2036,2037,31,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1877,1878,1879,63,1901,1902,1903,1904,1905,1906,1907,1908,1909,1910,1911,1912,1913,1914,1915,3930,12,1740,1741,1742,1743,1744,1745,1746,1747,27,1822,1823,1824,1825,1826,1827,1828,1829,1830,1831,1832,1833,29,1853,1854,1855,1856,1857,1858,1859,1860,1861,1862,1863,1864,1865,36,1937,1938,1939,1940,1941,1942,1943,1935,1936,9,109,1722,1723,1724,1725,1726,68,1930,1931,1932,1933,1934,18,200,1777,1778,1779,1780,1776,37,1944,1945,1946,1947,1948,1949,1950,1951,10,1727,1728,1729,1730,13,1748,1749,1750,1751,1752,11,1731,1732,1733,1734,1735,1736,1737,1738,1739,26,179,1810,1811,1812,1813,1814,1815,1816,1817,1818,1819,1820,1821,25,1799,1800,1801,1802,1803,1804,1805,1806,1807,1808,1809,17,1759,1760,1761,1762,1763,1764,1765,1766,1767,1768,1769,1770,1771,1772,1773,1774,1775,22,1798,1793,1794,1795,1796,1797,16,1753,1754,1755,1756,1757,1758,35,1880,1881,1882,1883,1884,1885,1886,1887,1888,61,653,2052,2053,2054,2055,2056,2057,2058,2059,2060,2061,2062,2063,2064,3971,3972,',','||CO.ID||',')>0)
                  ) TC
--                   LEFT JOIN DM_TOAAN_TACH_NHAP_MAPPING M  ON M.TOAANID = TC.ID
--                         where M.TOAANID IS NULL
                    ORDER BY TC.ARRTHUTU 
                )
            LOOP
            v_TongcongTLST :=0;
            v_TongcongTLPT :=0;
            v_TongcongTLGDT :=0;
            v_TongcongGQST :=0;
            v_TongcongGQPT :=0;
            v_TongcongGQGDT :=0;
            
            v_STT := v_STT + 1;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                      <tr>
                         <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:70px">'||v_STT||'</td>');
            IF (v_DM_TOAAN.LOAITOA = 'CAPHUYEN') THEN
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                         <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;width:600px">'||v_DM_TOAAN.TEN||'</td>');
            ELSE       
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                         <th style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DM_TOAAN.TEN||'</th>');
            END IF;
           ---1.Hinh Sụ Sơ thẩm 
            -- Thu ly moi
             select count(hs.id) into v_TongThuLyST from GSCM.ahs_sotham_thuly hs                                
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id 
                                    where 
                                   ( V.TOAANID = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR v.TOA_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
            v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');                      
                                     
            --Da giai quyet
              select COUNT(DISTINCT v.id) into v_DaGiaQuyetST from GSCM.ahs_vuan v
                                LEFT JOIN GSCM.AHS_SOTHAM_BANAN T2 ON v.id=T2.vuanid and T2.NGAYBANAN  BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID, Q.thulyid,Q.TOA_GIAIQUYET_ID
                                                        FROM GSCM.AHS_SOTHAM_QUYETDINH_VUAN Q 
                                                                LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY
                                    where 
                                        v.TOAANID = v_DM_TOAAN.ID 
--                                      Da co ket qua giai quyet
                                     AND (T2.ID is not null  
                                            or T3.ID is not null      
                                         );
--                                    (
--                                       (T2.ID is not null 
--                                        and T2.TOA_GIAIQUYET_ID = v_DM_TOAAN.ID 
--                                        and T2.NGAYBANAN BETWEEN VV_TUNGAY and VV_DENNGAY
--                                       )
--                                       or
--                                       (T3.ID is not null 
--                                        and T3.TOA_GIAIQUYET_ID = v_DM_TOAAN.ID 
--                                        and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
--                                       )
--                                    );
              v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');                            
            --2.Hình sự phúc thẩm
            select count(hs.id) into v_TongThuLyPT from GSCM.ahs_phuctham_thuly hs 
                                        LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id 
                                         where 
                                            hs.TOAANID = v_DM_TOAAN.ID 
                                            and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                                            
            v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');
                            
            
             select  COUNT(DISTINCT v.id) INTO v_DaGiaQuyetPT from GSCM.ahs_phuctham_thuly hs
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id
                                LEFT JOIN GSCM.AHS_PHUCTHAM_BANAN T2 ON v.id=T2.vuanid and T2.NGAYBANAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                      FROM GSCM.AHS_PHUCTHAM_QUYETDINH_VUAN Q 
                                                             LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                            WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                 where 
                                    
                                    hs.TOAANID = v_DM_TOAAN.ID 
                                    AND
                                    ( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                    );
--                                     (
--                                       (T2.ID is not null 
--                                        and T2.TOA_GIAIQUYET_ID = v_DM_TOAAN.ID 
--                                        and T2.NGAYBANAN BETWEEN VV_TUNGAY and VV_DENNGAY
--                                       )
--                                       or
--                                       (T3.ID is not null 
--                                        and T3.TOA_GIAIQUYET_ID = v_DM_TOAAN.ID 
--                                        and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
--                                       )
--                                    );

             v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
              DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');   
                            
--            3. GDT
                select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 1 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 1 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');

--    An Dan su
                --1.So tham
                 select count(hs.id) INTO v_TongThuLyST from GSCM.ads_sotham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                where 
                                    D.TOAANID  = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                                    
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ads_sotham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ADS_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.ADS_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                 d.TOAANID = v_DM_TOAAN.ID 
                                AND
                                    (T2.ID is not null 
                                       or
                                       T3.ID is not null
                                    );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
                --2.Phuc Tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ads_phuctham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select COUNT(DISTINCT d.id) INTO v_DaGiaQuyetPT from GSCM.ads_phuctham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ADS_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.ADS_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                hs.TOAANID = v_DM_TOAAN.ID
                                AND 
                                    (T2.ID is not null 
                                       or
                                       T3.ID is not null       
                                     );
    
                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');  
               -- 3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 2 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 2 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');


--    An Hon Nhan  
                --1.So Tham
                 select count(hs.id) INTO v_TongThuLyST from GSCM.ahn_sotham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                where 
                                     D.TOAANID  = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ahn_sotham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHN_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.AHN_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                d.TOAANID = v_DM_TOAAN.ID
                                AND 
                                (
                                   T2.ID is not null 
                                   or
                                   T3.ID is not null
                                 );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
                --2.Phuc tham
                 select count(DISTINCT hs.id) INTO v_TongThuLyPT from GSCM.ahn_phuctham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(hs.id) INTO v_DaGiaQuyetPT from GSCM.ahn_phuctham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHN_PHUCTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.AHN_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND
                                        (
                                         T2.ID is not null 
                                         or
                                           T3.ID is not null 
                                         );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
                                
               --  3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 3 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 3
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
--      An Hanh chinh  
                ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.ahc_sotham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                where 
                                     D.TOAANID  = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ahc_sotham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHC_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.AHC_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                               
                                where 
                                     d.TOAANID = v_DM_TOAAN.ID
                                        AND
                                             (T2.ID is not null 
                                               or
                                                 T3.ID is not null 
                                               
                                             );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ahc_phuctham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.ahc_phuctham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHC_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                                FROM GSCM.AHN_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where
                                
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND(T2.ID is not null 
                                            or
                                            T3.ID is not null 
                                         );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 6 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 6
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
--         an kinh te   

                ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.akt_sotham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.akt_sotham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Akt_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.Akt_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                     d.TOAANID = v_DM_TOAAN.ID
                                    AND( T2.ID is not null 
                                           or
                                           T3.ID is not null 
                                            
                                         );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.akt_phuctham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.akt_phuctham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Akt_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID ,Q.TOA_GIAIQUYET_ID
                                                                FROM GSCM.Akt_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                   hs.TOAANID = v_DM_TOAAN.ID
                                AND(
                                    T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                        
                                     );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 4 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 4
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
                 

--       An Lao dong
                 ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.ald_sotham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.ald_sotham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ald_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOA_GIAIQUYET_ID 
                                                               FROM GSCM.Ald_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                               
                                where 
                                    d.TOAANID = v_DM_TOAAN.ID
                                    AND( T2.ID is not null 
                                           or
                                           T3.ID is not null 
                                           
                                         );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.ald_phuctham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.ald_phuctham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ald_PHUCTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.Ald_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND (T2.ID is not null
                                          or T3.ID is not null       
                                        ) ;

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 5 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                  
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 5
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
                
--    An Pha san                        
                     ---1.So tham
                      select count(hs.id) INTO v_TongThuLyST from GSCM.aps_sotham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                where 
                                     D.TOAANID = v_DM_TOAAN.ID 
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 --v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.aps_sotham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Aps_SOTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                               FROM GSCM.Aps_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                                
                                where 
                                 d.TOAANID = v_DM_TOAAN.ID
                                AND( T2.ID is not null  
                                       or
                                       T3.ID is not null 
                                       
                                     );

                --v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.aps_phuctham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 --v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.aps_phuctham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Aps_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                                FROM GSCM.Aps_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid  and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                     hs.TOAANID = v_DM_TOAAN.ID
                                AND(
                                    T2.ID is not null 
                                       or
                                        T3.ID is not null 
                                       
                                     );


                 --v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
  
  
               --3.GDT
                 select  count(hs.id) INTO v_TongThuLyGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 7 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;

                --v_TongcongTLGDT := v_TongcongTLGDT + v_TongThuLyGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyGDT||'</td>');
                 
                  select  count(hs.id) INTO v_DaGiaQuyetGDT from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 7
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                     AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY
                                     ;
                --v_TongcongGQGDT := v_TongcongGQGDT + v_DaGiaQuyetGDT;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetGDT||'</td>');
        
  --  BPXLHC                       
                ---1.So tham
                select count(hs.id) INTO v_TongThuLyST from GSCM.XLHC_SOTHAM_THULY hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                where 
                                    d.TOAANID = v_DM_TOAAN.ID
                                    AND hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY;
                 v_TongcongTLST := v_TongcongTLST + v_TongThuLyST;
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'|| v_TongThuLyST ||'</td>');   
                   
                 select count(DISTINCT hs.id) INTO v_DaGiaQuyetST from GSCM.xlhc_sotham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.xlhc_SOTHAM_BANAN T2 ON d.id=T2.donid  and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                               FROM GSCM.xlhc_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY                              
                                where 
                                   d.TOAANID = v_DM_TOAAN.ID
                                AND( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                     );

                v_TongcongGQST := v_TongcongGQST + v_DaGiaQuyetST;                            
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetST||'</td>');   
            --2.Phuc tham
                 select count(hs.id) INTO v_TongThuLyPT from GSCM.xlhc_phuctham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                where 
                                    hs.TOAANID = v_DM_TOAAN.ID
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    ;

                 v_TongcongTLPT := v_TongcongTLPT + v_TongThuLyPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongThuLyPT||'</td>');  
                                
                  select count(DISTINCT hs.id) INTO v_DaGiaQuyetPT from GSCM.xlhc_phuctham_thuly hs
                                LEFT JOIN GSCM.xlhc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.xlhc_PHUCTHAM_BANAN T2 ON d.id=T2.donid and T2.NGAYTUYENAN BETWEEN VV_TUNGAY and VV_DENNGAY
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID,Q.TOAANID 
                                                                FROM GSCM.xlhc_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid and T3.NGAYQD BETWEEN VV_TUNGAY and VV_DENNGAY
                                where 
                                   hs.TOAANID = v_DM_TOAAN.ID
                                AND( T2.ID is not null 
                                       or
                                       T3.ID is not null 
                                     );

                 v_TongcongGQPT := v_TongcongGQPT + v_DaGiaQuyetPT;                            
                  DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DaGiaQuyetPT||'</td>');
                 
--Tong so 
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLST||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQST||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLPT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQPT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongTLGDT||'</td>
                        <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_TongcongGQGDT||'</td>
                      </tr>
                   '); 
            
        END LOOP;

        DBMS_LOB.APPEND(V_EXPORT_TEXT,'<tr><td Colspan="56" style=" text-align: left; vertical-align: middle;"> Thời gian xuất báo cáo: ' || TO_CHAR(SYSDATE, 'HH24:MI:SS - DD/MM/YYYY') || '</td></tr>');

        DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
        </table>
      ');

    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;  

END NHAPLIEU_HS_DS_EXT_ALL_V2;


PROCEDURE HS_DS_AN_DATHULY
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
    PAGE_INDEX              IN INT,
    PAGE_SIZE	            IN INT,
    CURRETURN               OUT SYS_REFCURSOR
)
AS

    CountAll_LOAIAN         NUMBER DEFAULT 0;
    CountAll_S              NUMBER DEFAULT 0;

    CURSOR_RETURN           SYS_REFCURSOR;

    V_TABLE_EXPORT          T_TIMKIEM_BAOCAO_DANHSACHCHUNG;
    V_TABLE_EXPORT_BAOCAO   T_TYPE_OF_20_COLUMN_VARCHAR;
    V_TABLE_EXPORT_BAOCAO_HS   T_TYPE_OF_20_COLUMN_VARCHAR;

    V_EXPORT_TEXT           CLOB;
    V_EXPORT_TEXT_DATA      CLOB;
    TEN_LOAI_AN_DA_XU       VARCHAR2(200);

    V_TABLE_ID_ADS              T_ID;
    V_TABLE_ID_AHN              T_ID;
    V_TABLE_ID_AKT              T_ID;
    V_TABLE_ID_ALD              T_ID;
    V_TABLE_ID_AHC              T_ID;
    V_TABLE_ID_AHS              T_ID;

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
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_DATA,true);
        V_TABLE_EXPORT := T_TIMKIEM_BAOCAO_DANHSACHCHUNG();
        V_TABLE_EXPORT_BAOCAO := T_TYPE_OF_20_COLUMN_VARCHAR();
        V_TABLE_EXPORT_BAOCAO_HS := T_TYPE_OF_20_COLUMN_VARCHAR();

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

        --Lấy dữ liệu như Tìm kiếm báo cáo
        HS_DS_EXT_SEARCH_ALL(V_CAP_XET_XU_LOGIN, V_TEN_VU_AN, V_TOIDANH, V_MA_VU_AN, V_BI_CAN, V_CAPXX,
                             V_TOAAN_ID, V_TINHTRANG_THULY, V_NGAYTHULY_TU, V_NGAYTHULY_DEN, V_SOTHULY, V_TINHTRANG_GIAIQUYET,
                             V_TUNGAY, V_DENNGAY, V_KETQUA, V_SO_QD, V_NGAY_QD, V_THAMPHAN_ID, V_VAITRO_THAMPHAN, V_THUKY_ID, V_THOIHAN_GQ, V_QD_TAMGIAM, V_UTTP,
                             V_LOAIAN_ID, 0, 0,0,
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

                FOR ITEM IN (

                WITH 
--                CTE_PCTP_GQ AS (
--                    SELECT ROW_NUMBER() OVER (PARTITION BY TP.VUANID ORDER BY TP.NGAYNHANPHANCONG DESC, TP.NGAYTAO DESC) AS ROWNUMBER,
--                           TP.ID, CB.HOTEN, TP.VUANID, TP.NGAYTAO, TP.NGAYNHANPHANCONG, NPC.HOTEN HOTEN_LD, TP.NGUOIPHANCONGID, TP.CANBOID, TP.NGAYPHANCONG,
--                           TP.NGAYQD, TP.SOQD, TP.THULYID
--                    FROM AHS_THAMPHANGIAIQUYET TP
--                    LEFT JOIN DM_CANBO CB ON CB.ID = TP.CANBOID
--                    LEFT JOIN DM_CANBO NPC ON NPC.ID = TP.NGUOIPHANCONGID
--                    WHERE ((v_Capxx = 2 AND TP.MAVAITRO = 'VTTP_GIAIQUYETSOTHAM') OR (v_Capxx = 3 AND TP.MAVAITRO = 'VTTP_GIAIQUYETPHUCTHAM'))
--                      AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
--                ),
                CTE_BC2 AS (
                    SELECT TS.VUANID, '<br style="mso-data-placement:same-cell;" /><i>Bị cáo:</i> <br />' || REPLACE(REPLACE(REPLACE(REPLACE(TS.HOTEN, '_BOLD', '<b>'), '_GHACH_NOI', ' - '), '_DAUVU', ' (đầu vụ)</b>'), ';', '<br/>') HOTEN
                    FROM (
                        SELECT TT.VUANID, RTRIM(SUBSTR(TT.HOTEN, 0, INSTR(TT.HOTEN, ';', 1, DECODE(TT.COUNT_BC, 1, 1, 2, 2, 3, 3, 3))), ';') HOTEN
                        FROM (
                            SELECT COUNT(*) COUNT_BC, BC.VUANID,
                                   RTRIM(XMLAGG(XMLELEMENT(E, DECODE(BC.BICANDAUVU, 1, '_BOLD' || BC.HOTEN || '_GHACH_NOI' || c.TenToiDanh || '_DAUVU', 0, BC.HOTEN || DECODE(c.TenToiDanh, NULL, NULL, '_GHACH_NOI') || c.TenToiDanh), ';').EXTRACT('//text()') ORDER BY BC.BICANDAUVU DESC).GetClobVal(), ';') || ';' HOTEN
                            FROM AHS_BICANBICAO BC
                            LEFT JOIN (SELECT CD.BICANID, CD.TENTOIDANH, CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN = 1) C ON BC.ID = C.BICANID
                            GROUP BY BC.VUANID
                        ) TT
                    ) TS
                ),
                CTE_BC_KC AS (
                    SELECT NDBD.VUANID, LISTAGG(NDBD.NOIDUNGKHANGCAO, ', ') WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) BCKC
                    FROM (
                        SELECT TO_NUMBER(SUBSTR(FF.VUAN_ND, 0, INSTR(FF.VUAN_ND, ';') - 1)) VUANID,
                               SUBSTR(FF.VUAN_ND, INSTR(FF.VUAN_ND, ';') + 1, LENGTH(FF.VUAN_ND)) NOIDUNGKHANGCAO
                        FROM (
                            SELECT F.VUAN_ND
                            FROM (
                                SELECT KC.VUANID || ';' || COUNT(*) || ' ' || DECODE(KC.NGUOIKCLOAI, 0, 'BC', 1, I.TEN) || ' k/c' VUAN_ND
                                FROM AHS_SOTHAM_KHANGCAO KC
                                LEFT JOIN AHS_NGUOITHAMGIATOTUNG TT ON KC.NGUOIKCID = TT.ID
                                LEFT JOIN AHS_NGUOITHAMGIATOTUNG_TUCACH TC ON TC.NGUOIID = TT.ID
                                LEFT JOIN DM_DataItem I ON I.ID = TC.TUCACHID
                                GROUP BY KC.VUANID, KC.NGUOIKCLOAI, I.TEN
                            ) F
                            GROUP BY F.VUAN_ND
                        ) FF
                    ) NDBD
                    GROUP BY NDBD.VUANID
                ),
                CTE_BC3 AS (
                    SELECT MM.VUANID, SUBSTR(MM.HOTEN, 0, INSTR(MM.HOTEN, ';') - 1) HOTEN
                    FROM (
                        SELECT KK.VUANID, LISTAGG(KK.HOTEN, ';') WITHIN GROUP (ORDER BY KK.STT) || ';' HOTEN
                        FROM (
                            SELECT CC.VUANID, TO_CHAR(REPLACE(TS1.HOTEN, ';', '')) HOTEN, 1 STT
                            FROM (
                                SELECT FF.VUANID, SUBSTR(FF.NGUOIKCID, 0, INSTR(FF.NGUOIKCID, ';') - 1) NGUOIKC_ID, FF.NGUOIKCID
                                FROM (
                                    SELECT KC.VUANID, LISTAGG(KC.NGUOIKCID, ';') WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO) || ';' NGUOIKCID
                                    FROM AHS_SOTHAM_KHANGCAO KC
                                    WHERE KC.NGUOIKCLOAI = 0
                                      AND NOT EXISTS (SELECT 'X' FROM AHS_SOTHAM_RUTKHANGCAO RK WHERE RK.KHANGCAOID = KC.ID AND RK.TINHTRANG = 2 AND (RK.CAPRUTKN IS NULL OR RK.CAPRUTKN = 2))
                                    GROUP BY KC.VUANID
                                ) FF
                            ) CC
                            LEFT JOIN AHS_BICANBICAO TS1 ON TS1.ID = CC.NGUOIKC_ID AND TS1.VUANID = CC.VUANID
                            UNION ALL
                            SELECT DD.VUANID, TO_CHAR(DD.HOTEN) HOTEN, 2 STT
                            FROM (
                                SELECT TS.VUANID, LISTAGG(REPLACE(TS.HOTEN, ';', ''), ',') WITHIN GROUP (ORDER BY TS.HOTEN) HOTEN
                                FROM AHS_BICANBICAO TS
                                WHERE TS.BICANDAUVU = 1
                                GROUP BY TS.VUANID
                            ) DD
                        ) KK
                        GROUP BY KK.VUANID
                    ) MM
                ),
                CTE_TD AS (
                    SELECT MM.VUANID, SUBSTR(MM.TENTOIDANH, 0, INSTR(MM.TENTOIDANH, ';') - 1) TENTOIDANH
                    FROM (
                        SELECT KK.VUANID, LISTAGG(KK.TENTOIDANH, ';') WITHIN GROUP (ORDER BY KK.STT DESC) || ';' TENTOIDANH
                        FROM (
                            SELECT CC.VUANID, TO_CHAR(C.TENTOIDANH) TENTOIDANH, 1 STT
                            FROM (
                                SELECT FF.VUANID, SUBSTR(FF.NGUOIKCID, 0, INSTR(FF.NGUOIKCID, ';') - 1) NGUOIKC_ID, FF.NGUOIKCID
                                FROM (
                                    SELECT KC.VUANID, LISTAGG(KC.NGUOIKCID, ';') WITHIN GROUP (ORDER BY KC.NGAYKHANGCAO) || ';' NGUOIKCID
                                    FROM AHS_SOTHAM_KHANGCAO KC
                                    WHERE KC.NGUOIKCLOAI = 0
                                    GROUP BY KC.VUANID
                                ) FF
                            ) CC
                            LEFT JOIN (SELECT CD.BICANID, CD.TENTOIDANH, CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN = 1) C ON CC.NGUOIKC_ID = C.BICANID
                            UNION ALL
                            SELECT DD.VUANID, SUBSTR(DD.TENTOIDANH, 0, INSTR(DD.TENTOIDANH, ';') - 1) TENTOIDANH, 2 STT
                            FROM (
                                SELECT TS.VUANID, LISTAGG(C.TENTOIDANH, ';') WITHIN GROUP (ORDER BY C.TENTOIDANH) || ';' TENTOIDANH
                                FROM AHS_BICANBICAO TS
                                LEFT JOIN (SELECT CD.BICANID, CD.TENTOIDANH, CD.ISMAIN FROM AHS_SOTHAM_CAOTRANG_DIEULUAT CD WHERE ISMAIN = 1) C ON TS.ID = C.BICANID
                                WHERE TS.BICANDAUVU = 1
                                GROUP BY TS.VUANID
                            ) DD
                        ) KK
                        GROUP BY KK.VUANID
                    ) MM
                ),
                CTE_TONG_BC AS (
                    SELECT COUNT(*) TONG, TS.VUANID
                    FROM AHS_BICANBICAO TS
                    GROUP BY TS.VUANID
                ),
                CTE_STKN AS (
                    SELECT NDKN.VUANID, LISTAGG(NDKN.NOIDUNGKN, ', ') WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN) NOIDUNGKN
                    FROM (
                        SELECT KC.VUANID, DECODE(KC.DONVIKN, 0, 'CA', 'VKS') || ' k/n' NOIDUNGKN
                        FROM AHS_SOTHAM_KHANGNGHI KC
                        LEFT JOIN AHS_SOTHAM_KHANGCAO_YEUCAU T5 ON T5.KHANGCAOID = KC.ID
                        WHERE NOT EXISTS (SELECT 'X' FROM AHS_SOTHAM_RUTKHANGNGHI RK WHERE RK.KHANGNGHIID = KC.ID AND RK.TINHTRANG = 2 AND (RK.CAPRUTKN IS NULL OR RK.CAPRUTKN = 2))
                    ) NDKN
                    GROUP BY NDKN.VUANID
                )
                SELECT ROW_NUMBER() OVER (ORDER BY DECODE(v_Capxx, 2, THTL.SOTHULY, 3, TO_NUMBER(REGEXP_REPLACE(THTLPT.SOTHULY, '[^[:digit:]]', '')))) STT,
                       COUNT(*) OVER () AS CountAll,
                       DECODE(GD.MAGIAIDOAN, 3, BC3.HOTEN, BC2.HOTEN) HoTenBiCan,
                       DECODE(GD.MAGIAIDOAN, 3, B.TEN, NULL) TenToaSoTham,
                       DECODE(v_Capxx, 2, THTL.SOTHULY, 3, THTLPT.SOTHULY) SOTHULY,
                       DECODE(v_Capxx, 2, THTL.NGAYTHULY, 3, THTLPT.NGAYTHULY) NGAYTHULY,
                       TONG_BC.TONG,
                       BC_KC.BCKC || '<br style="mso-data-placement:same-cell;" />' || STKN.NOIDUNGKN BCKC,
                       TD.TENTOIDANH,
                       --PCTP_GQ.HOTEN THAMPHAN_TEN,
                       A.ID,
                       A.MAVUAN MAVUVIEC
                FROM AHS_VUAN A

                INNER JOIN ( SELECT G.* 
                             FROM AHS_VUAN_GIAIDOAN G 
                             WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = V_TOAAN_ID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = V_TOAAN_ID)
                           ) GD  ON A.ID=GD.VUANID

                LEFT JOIN (
                    SELECT TL.SOTHULY, TO_CHAR(TL.NGAYTHULY, 'dd/MM/yyyy') NGAYTHULY, TL.VUANID, TL.ID
                    FROM AHS_SOTHAM_THULY TL
                ) THTL ON THTL.VUANID = A.ID AND GD.MAGIAIDOAN=2
                LEFT JOIN (
                    SELECT TL.SOTHULY, TO_CHAR(TL.NGAYTHULY, 'dd/MM/yyyy') NGAYTHULY, TL.VUANID, TL.ID
                    FROM AHS_PHUCTHAM_THULY TL
                ) THTLPT ON THTLPT.VUANID = A.ID AND GD.MAGIAIDOAN=2


                LEFT JOIN DM_TOAAN B ON A.TOAANID = B.ID

                --LEFT JOIN CTE_PCTP_GQ PCTP_GQ ON PCTP_GQ.VUANID = A.ID AND PCTP_GQ.ROWNUMBER = 1
                LEFT JOIN CTE_BC2 BC2 ON BC2.VUANID = A.ID
                LEFT JOIN CTE_BC_KC BC_KC ON BC_KC.VUANID = A.ID
                LEFT JOIN CTE_BC3 BC3 ON BC3.VUANID = A.ID
                LEFT JOIN CTE_TD TD ON TD.VUANID = A.ID
                LEFT JOIN CTE_TONG_BC TONG_BC ON TONG_BC.VUANID = A.ID
                LEFT JOIN CTE_STKN STKN ON STKN.VUANID = A.ID

                WHERE A.ID IN (SELECT v_ID ID FROM TABLE(V_TABLE_ID_AHS))

                )
                LOOP
                       CountAll_S:=item.CountAll;

                       DBMS_LOB.APPEND(V_EXPORT_TEXT_DATA,' 
                           <tr style="font-size: 12pt;padding:3pt;">
                           <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULY||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;">'||item.NGAYTHULY||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TenToaSoTham||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.HoTenBiCan||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TONG||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BCKC||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTOIDANH||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.MAVUVIEC||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;"></td>
                        </tr>
                            ');

                END LOOP;

          DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" style="font-family: times New Roman; font-size: 12pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="9" style="line-height: 100%; font-size: 14pt; text-align: center;"><b>DANH SÁCH ÁN HÌNH SỰ THỤ LÝ MỚI</b>
                </td>
            </tr>
            <tr>
                <td colspan="9" style="height: 15pt; text-align: left;"><b>Tổng số: '||CountAll_S||' bản ghi</b></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">Stt</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số TL</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày TL</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tỉnh / TP</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Đầu vụ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số BC</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">KC/KN</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tội danh</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Mã vụ việc</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
                 ');                
            DBMS_LOB.APPEND(V_EXPORT_TEXT, V_EXPORT_TEXT_DATA);

            DBMS_LOB.APPEND(V_EXPORT_TEXT,'

                    <tr style="height: 1px;">
                    <td style="width: 43px"></td>
                    <td style="width: 72px"></td>
                    <td style="width: 83px"></td>
                    <td style="width: 135px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 60px"></td>
                    <td style="width: 142px"></td>
                    <td style="width: 176px"></td>
                    <td style="width: 100px"></td>
                    <td style="width: 90px"></td>
                </tr>
            </table>');



            ELSE

                IF(INSTR(V_LOAIAN_ID,ADS) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (

                    SELECT 
                            ROW_NUMBER() OVER (ORDER BY DECODE(v_Capxx,2,TLS.SOTHULY,3,to_number(regexp_replace(TLPT.SOTHULY, '[^[:digit:]]', '')) )ASC ) STT,
                            COUNT(*) OVER () as CountAll,

                            ----- BC mới ------------------
                            CASE WHEN v_Capxx = 2 THEN TLS.SOTHULY ELSE TLPT.SOTHULY END SOTHULY,
                            T.Ten TENTOASOTHAM,

                            TO_CHAR(
                                CASE 
                                    WHEN v_Capxx = 2 THEN TLS.NGAYTHULY
                                    WHEN v_Capxx = 3 THEN TLPT.NGAYTHULY
                                END, 
                                'dd/MM/yyyy'
                            ) NGAYTHULY,

                            CASE WHEN v_Capxx = 2 THEN NDST.TENDUONGSU ELSE NDPT.TENDUONGSU END NGUYENDON,
                            CASE WHEN v_Capxx = 2 THEN BDST.TENDUONGSU ELSE BDPT.TENDUONGSU END BIDON,

                            NDKNS.NOIDUNGKN NDBD_NOIDUNG,

                            NVL(i.TEN, A.QUANHEPHAPLUAT_NAME) QHPL_TEN -- CASE WHEN A.QUANHEPHAPLUAT_NAME IS NULL THEN i.TEN ELSE A.QUANHEPHAPLUAT_NAME END QHPL_TEN,

                            --,PCTP_GQ.HOTEN THAMPHAN_TEN
                            , A.MAVUVIEC
                        FROM 
                            ADS_DON A
                             INNER JOIN ( SELECT G.* 
                             FROM ADS_DON_GIAIDOAN G 
                             WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = V_TOAAN_ID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = V_TOAAN_ID)
                            ) GD  ON A.ID=GD.DONID

                            LEFT JOIN DM_DATAITEM i ON A.QUANHEPHAPLUATID = i.ID
                            LEFT JOIN DM_TOAAN T ON A.TOAANID = T.ID

                            ----- Trạng thái giải quyết trong danh sách
                            LEFT JOIN (
                                SELECT TL.DONID, TL.SOTHULY, TL.NGAYTHULY, '</br>- Đã thụ lý' TINHTRANG_GQ 
                                FROM ADS_SOTHAM_THULY TL 
                                GROUP BY TL.DONID, TL.SOTHULY, TL.NGAYTHULY
                            ) TLS ON A.ID = TLS.DONID AND GD.MAGIAIDOAN = 2

                            LEFT JOIN (
                                SELECT TL.DONID, TL.SOTHULY, TL.NGAYTHULY, '</br>- Đã thụ lý' TINHTRANG_GQ 
                                FROM ADS_PHUCTHAM_THULY TL 
                                GROUP BY TL.DONID, TL.SOTHULY, TL.NGAYTHULY
                            ) TLPT ON A.ID = TLPT.DONID AND GD.MAGIAIDOAN = 3


                            LEFT JOIN (
                                SELECT DS.TENDUONGSU, DS.DONID  
                                FROM ADS_DON_DUONGSU DS 
                                WHERE DS.ISDAIDIEN = 1 
                                  AND DS.TUCACHTOTUNG_MA = 'NGUYENDON'
                            ) NDST ON NDST.DONID = A.ID AND GD.MAGIAIDOAN = 2

                            LEFT JOIN (
                                SELECT DS.TENDUONGSU, DS.DONID  
                                FROM ADS_DON_DUONGSU DS 
                                WHERE DS.ISDAIDIEN = 1 
                                  AND DS.TUCACHTOTUNG_MA = 'NGUYENDON'
                            ) NDPT ON NDPT.DONID = A.ID AND GD.MAGIAIDOAN = 3

                            LEFT JOIN (
                                SELECT DS.TENDUONGSU, DS.DONID  
                                FROM ADS_DON_DUONGSU DS 
                                WHERE DS.ISDAIDIEN = 1 
                                  AND DS.TUCACHTOTUNG_MA = 'BIDON'
                            ) BDST ON BDST.DONID = A.ID AND GD.MAGIAIDOAN = 2

                            LEFT JOIN (
                                SELECT DS.TENDUONGSU, DS.DONID  
                                FROM ADS_DON_DUONGSU DS 
                                WHERE DS.ISDAIDIEN = 1 
                                  AND DS.TUCACHTOTUNG_MA = 'BIDON'
                            ) BDPT ON BDPT.DONID = A.ID AND GD.MAGIAIDOAN = 3

                            LEFT JOIN (
                                SELECT NDBD.DONID, 
                                       RTRIM(XMLAGG(XMLELEMENT(E, NDBD.NOIDUNGKHANGCAO, '//BR').EXTRACT('//text()') 
                                       ORDER BY NDBD.NOIDUNGKHANGCAO DESC).GetClobVal(), '//BR') NDBD_NOIDUNG
                                FROM (
                                    SELECT TO_NUMBER(SUBSTR(FF.DON_ND, 0, INSTR(FF.DON_ND, ';') - 1)) DONID,
                                           SUBSTR(FF.DON_ND, INSTR(FF.DON_ND, ';') + 1, LENGTH(FF.DON_ND)) NOIDUNGKHANGCAO
                                    FROM (
                                        SELECT F.DON_ND 
                                        FROM (
                                            SELECT KC.DONID || ';' || DECODE(DS.TUCACHTOTUNG_MA, 'BIDON', 'BĐ', 'NGUYENDON', 'NĐ', 'QUYENNVLQ', 'NLQ') || ' kc: ' || KC.NOIDUNGKHANGCAO DON_ND
                                            FROM ADS_SOTHAM_KHANGCAO KC 
                                            LEFT JOIN ADS_DON_DUONGSU DS ON DS.ID = KC.DUONGSUID
                                            WHERE KC.NOIDUNGKHANGCAO IS NOT NULL
                                        ) F
                                        GROUP BY F.DON_ND
                                    ) FF
                                    UNION ALL
                                    SELECT KC.DONID, 'kc:' NOIDUNGKHANGCAO 
                                    FROM ADS_SOTHAM_KHANGCAO KC
                                    LEFT JOIN ADS_DON_DUONGSU DS ON DS.ID = KC.DUONGSUID
                                    WHERE KC.NOIDUNGKHANGCAO IS NULL
                                    GROUP BY KC.DONID, 'kc:'
                                ) NDBD 
                                GROUP BY NDBD.DONID
                            ) NDBDS ON NDBDS.DONID = A.ID

                            LEFT JOIN (
                                SELECT NDKN.DONID, 
                                       LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />') 
                                       WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN) NOIDUNGKN
                                FROM (
                                    SELECT KC.DONID, ' kn: ' || KC.NOIDUNGKN NOIDUNGKN 
                                    FROM ADS_SOTHAM_KHANGNGHI KC
                                    WHERE KC.NOIDUNGKN IS NOT NULL
                                    UNION ALL
                                    SELECT KC.DONID, 'kn:' NOIDUNGKN 
                                    FROM ADS_SOTHAM_KHANGNGHI KC
                                    WHERE KC.NOIDUNGKN IS NULL
                                    GROUP BY KC.DONID, 'kn:'
                                ) NDKN 
                                GROUP BY NDKN.DONID
                            ) NDKNS ON NDKNS.DONID = A.ID

                    WHERE A.ID IN (SELECT v_ID ID FROM TABLE(V_TABLE_ID_ADS))
                    )
                    LOOP
                        CountAll_LOAIAN := item.CountAll;
                        DBMS_LOB.APPEND(V_EXPORT_TEXT_DATA,' 
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Dân sự</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULY||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;">'||item.NGAYTHULY||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTOASOTHAM||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPL_TEN||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.MAVUVIEC||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NDBD_NOIDUNG||'</td>
                        </tr>
                            ');
                    END LOOP;
                END IF;
                CountAll_S:= CountAll_S + CountAll_LOAIAN;
                CountAll_LOAIAN := 0;
                
                IF(INSTR(V_LOAIAN_ID,AHN) > 0 OR V_LOAIAN_ID IS NULL) THEN 

                    FOR ITEM IN (     
                            SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_Capxx,2,TLS.SOTHULY,3,to_number(regexp_replace(TLPT.SOTHULY, '[^[:digit:]]', '')) )ASC ) STT
                              ,COUNT(*) OVER () as CountAll
                                ------BC mới------------------
                                ,DECODE(v_Capxx,2,TLS.SOTHULY,3,TLPT.SOTHULY)SOTHULY
                                ,T.Ten TENTOASOTHAM 
                                ,to_char(DECODE(v_Capxx,2,TLS.NGAYTHULY,3,TLPT.NGAYTHULY),'dd/MM/yyyy')NGAYTHULY
                                ,DECODE(v_Capxx,2,NDST.TENDUONGSU,3,NDPT.TENDUONGSU)NGUYENDON
                                ,DECODE(v_Capxx,2,BDST.TENDUONGSU,3,BDPT.TENDUONGSU)BIDON
                                ,NDBDS.NOIDUNGKHANGCAO||'<br style="mso-data-placement:same-cell;" />'||NDKNS.NOIDUNGKN NOIDUNGKHANGCAO
                                ,DECODE(A.QUANHEPHAPLUAT_NAME,NULL,i.TEN,QUANHEPHAPLUAT_NAME) QHPL_TEN
                                --,PCTP_GQ.HOTEN THAMPHAN_TEN
                                , A.MAVUVIEC
                              FROM AHN_DON A
                              INNER JOIN (SELECT G.* FROM AHN_DON_GIAIDOAN G WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = V_TOAAN_ID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = V_TOAAN_ID)) GD ON A.ID=GD.DONID
                              left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
                              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                                ------Trạng thái giải quyết trong danh sách
                                    LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHN_SOTHAM_THULY TL 
                                               GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý',TL.NGAYTHULY)TLS ON A.ID=TLS.DONID AND GD.MAGIAIDOAN=2
                                    LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHN_PHUCTHAM_THULY TL 
                                              GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý',TL.NGAYTHULY)TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3

                                  LEFT JOIN (
                                         SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AHN_DON_DUONGSU DS WHERE  DS.TUCACHTOTUNG_MA='NGUYENDON'          
                                         GROUP BY DS.DONID
                                  )NDST ON NDST.DONID=A.ID AND GD.MAGIAIDOAN=2
                                 LEFT JOIN (
                                        SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU FROM AHN_DON_DUONGSU DS WHERE DS.TUCACHTOTUNG_MA='NGUYENDON'     
                                        GROUP BY DS.DONID
                                  )NDPT ON NDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                                 LEFT JOIN (
                                         SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AHN_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
                                         GROUP BY DS.DONID
                                  )BDST ON BDST.DONID=A.ID AND GD.MAGIAIDOAN=2
                                 LEFT JOIN (
                                        SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AHN_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
                                        GROUP BY DS.DONID
                                  )BDPT ON BDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                                  -- SO LƯƠNG + TUCACHTOTUNG_MA
                                  LEFT JOIN (     
                                            SELECT NDBD.DONID,LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NOIDUNGKHANGCAO
                                                FROM (
                                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
                                                        FROM (   
                                                              SELECT F.DON_ND FROM (
                                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND
                                                                    from AHN_SOTHAM_KHANGCAO kc 
                                                                    LEFT JOIN AHN_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA
                                                                   )F
                                                              GROUP BY F.DON_ND
                                                          )FF
                                                 )NDBD  GROUP BY NDBD.DONID
                                     )NDBDS ON NDBDS.DONID=A.ID
                                ---KHANG NGHI - TOAAN - VIEN KIEM SOAT       
                                LEFT JOIN (
                                        SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                                                    FROM (
                                                            SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN FROM AHN_SOTHAM_KHANGNGHI KC
                                                     )NDKN  GROUP BY NDKN.DONID
                                       )NDKNS ON NDKNS.DONID=A.ID

                    WHERE A.ID IN (SELECT v_ID ID FROM TABLE(V_TABLE_ID_AHN))
                    )
                    LOOP
                        CountAll_LOAIAN := item.CountAll;
                        DBMS_LOB.APPEND(V_EXPORT_TEXT_DATA,' 
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Hôn nhân gia đình</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULY||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;">'||item.NGAYTHULY||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTOASOTHAM||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPL_TEN||'</td>
                            <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.MAVUVIEC||'</td>
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NOIDUNGKHANGCAO||'</td>
                         </tr>
                            ');

                    END LOOP; 
                END IF;

                CountAll_S:= CountAll_S + CountAll_LOAIAN;
                CountAll_LOAIAN := 0;

                IF(INSTR(V_LOAIAN_ID,AKT) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (
                        SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_Capxx,2,TLS.SOTHULY,3,to_number(regexp_replace(TLPT.SOTHULY, '[^[:digit:]]', '')) )ASC ) STT
                          ,COUNT(*) OVER () as CountAll
                            ------BC mới------------------
                            ,DECODE(v_Capxx,2,TLS.SOTHULY,3,TLPT.SOTHULY)SOTHULY
                            ,T.Ten TENTOASOTHAM 
                            ,to_char(DECODE(v_Capxx,2,TLS.NGAYTHULY,3,TLPT.NGAYTHULY),'dd/MM/yyyy')NGAYTHULY
                            ,DECODE(v_Capxx,2,NDST.TENDUONGSU,3,NDPT.TENDUONGSU)NGUYENDON
                            ,DECODE(v_Capxx,2,BDST.TENDUONGSU,3,BDPT.TENDUONGSU)BIDON
                            ,NDBDS.NOIDUNGKHANGCAO||'<br style="mso-data-placement:same-cell;" />'||NDKNS.NOIDUNGKN NOIDUNGKHANGCAO
                            ,DECODE(A.QUANHEPHAPLUAT_NAME,NULL,i.TEN,QUANHEPHAPLUAT_NAME) QHPL_TEN
                            , A.MAVUVIEC
                          FROM AKT_DON A
                          
                             INNER JOIN ( SELECT G.* 
                             FROM AKT_DON_GIAIDOAN G 
                             WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = V_TOAAN_ID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = V_TOAAN_ID)
                            ) GD  ON A.ID=GD.DONID
                          
                          left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
                          LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                            ------Trạng thái giải quyết trong danh sách
                                LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AKT_SOTHAM_THULY TL 
                                           GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý',TL.NGAYTHULY)TLS ON A.ID=TLS.DONID AND GD.MAGIAIDOAN=2
                                LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AKT_PHUCTHAM_THULY TL 
                                          GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý',TL.NGAYTHULY)TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3
                              LEFT JOIN (
                                     SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AKT_DON_DUONGSU DS WHERE  DS.TUCACHTOTUNG_MA='NGUYENDON'          
                                     GROUP BY DS.DONID
                              )NDST ON NDST.DONID=A.ID AND GD.MAGIAIDOAN=2
                             LEFT JOIN (
                                    SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU FROM AKT_DON_DUONGSU DS WHERE DS.TUCACHTOTUNG_MA='NGUYENDON'     
                                    GROUP BY DS.DONID
                              )NDPT ON NDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                             LEFT JOIN (
                                     SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AKT_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
                                     GROUP BY DS.DONID
                              )BDST ON BDST.DONID=A.ID AND GD.MAGIAIDOAN=2
                             LEFT JOIN (
                                    SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AKT_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
                                    GROUP BY DS.DONID
                              )BDPT ON BDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                              -- SO LƯƠNG + TUCACHTOTUNG_MA
                              LEFT JOIN (     
                                        SELECT NDBD.DONID,LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NOIDUNGKHANGCAO
                                            FROM (
                                                    SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                                       SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
                                                    FROM (   
                                                          SELECT F.DON_ND FROM (
                                                                select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND
                                                                from AKT_SOTHAM_KHANGCAO kc 
                                                                LEFT JOIN AKT_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                                GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA
                                                               )F
                                                          GROUP BY F.DON_ND
                                                      )FF
                                             )NDBD  GROUP BY NDBD.DONID
                                 )NDBDS ON NDBDS.DONID=A.ID
                            ---KHANG NGHI - TOAAN - VIEN KIEM SOAT       
                            LEFT JOIN (
                                    SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                                                FROM (
                                                        SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN FROM AKT_SOTHAM_KHANGNGHI KC
                                                 )NDKN  GROUP BY NDKN.DONID
                                   )NDKNS ON NDKNS.DONID=A.ID
                    WHERE A.ID IN (SELECT v_ID ID FROM TABLE(V_TABLE_ID_AKT))
                    )
                    LOOP
                        CountAll_LOAIAN := item.CountAll;
                        DBMS_LOB.APPEND(V_EXPORT_TEXT_DATA,' 
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Kinh tế</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULY||'</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;">'||item.NGAYTHULY||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTOASOTHAM||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPL_TEN||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.MAVUVIEC||'</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NOIDUNGKHANGCAO||'</td>
                            </tr>
                            ');

                    END LOOP; 

                END IF;

                CountAll_S:= CountAll_S + CountAll_LOAIAN;
                CountAll_LOAIAN := 0;

                IF(INSTR(V_LOAIAN_ID,ALD) > 0 OR V_LOAIAN_ID IS NULL) THEN
                   FOR ITEM IN (
                              SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_Capxx,2,TLS.SOTHULY,3,to_number(regexp_replace(TLPT.SOTHULY, '[^[:digit:]]', '')) )ASC ) STT
                              ,COUNT(*) OVER () as CountAll
                                ------BC mới------------------
                                ,DECODE(v_Capxx,2,TLS.SOTHULY,3,TLPT.SOTHULY)SOTHULY
                                ,T.Ten TENTOASOTHAM 
                                ,to_char(DECODE(v_Capxx,2,TLS.NGAYTHULY,3,TLPT.NGAYTHULY),'dd/MM/yyyy')NGAYTHULY
                                ,DECODE(v_Capxx,2,NDST.TENDUONGSU,3,NDPT.TENDUONGSU)NGUYENDON
                                ,DECODE(v_Capxx,2,BDST.TENDUONGSU,3,BDPT.TENDUONGSU)BIDON
                                ,NDBDS.NOIDUNGKHANGCAO||'<br style="mso-data-placement:same-cell;" />'||NDKNS.NOIDUNGKN NOIDUNGKHANGCAO
                                ,DECODE(A.QUANHEPHAPLUAT_NAME,NULL,i.TEN,QUANHEPHAPLUAT_NAME) QHPL_TEN
                                , A.MAVUVIEC
                              
                              FROM ALD_DON A
                             INNER JOIN ( SELECT G.* 
                             FROM ALD_DON_GIAIDOAN G 
                             WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = V_TOAAN_ID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = V_TOAAN_ID)
                            ) GD  ON A.ID=GD.DONID
                          
                              left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
                              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                                ------Trạng thái giải quyết trong danh sách
                                    LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM ALD_SOTHAM_THULY TL 
                                               GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý',TL.NGAYTHULY)TLS ON A.ID=TLS.DONID AND GD.MAGIAIDOAN=2
                                    LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM ALD_PHUCTHAM_THULY TL 
                                              GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý',TL.NGAYTHULY)TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3

                                  LEFT JOIN (
                                         SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM ALD_DON_DUONGSU DS WHERE  DS.TUCACHTOTUNG_MA='NGUYENDON'          
                                         GROUP BY DS.DONID
                                  )NDST ON NDST.DONID=A.ID AND GD.MAGIAIDOAN=2
                                 LEFT JOIN (
                                        SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU FROM ALD_DON_DUONGSU DS WHERE DS.TUCACHTOTUNG_MA='NGUYENDON'     
                                        GROUP BY DS.DONID
                                  )NDPT ON NDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                                 LEFT JOIN (
                                         SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM ALD_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
                                         GROUP BY DS.DONID
                                  )BDST ON BDST.DONID=A.ID AND GD.MAGIAIDOAN=2
                                 LEFT JOIN (
                                        SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM ALD_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
                                        GROUP BY DS.DONID
                                  )BDPT ON BDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                                  -- SO LƯƠNG + TUCACHTOTUNG_MA
                                  LEFT JOIN (     
                                            SELECT NDBD.DONID,LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NOIDUNGKHANGCAO
                                                FROM (
                                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
                                                        FROM (   
                                                              SELECT F.DON_ND FROM (
                                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND
                                                                    from ALD_SOTHAM_KHANGCAO kc 
                                                                    LEFT JOIN ALD_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA
                                                                   )F
                                                              GROUP BY F.DON_ND
                                                          )FF
                                                 )NDBD  GROUP BY NDBD.DONID
                                     )NDBDS ON NDBDS.DONID=A.ID
                                ---KHANG NGHI - TOAAN - VIEN KIEM SOAT       
                                LEFT JOIN (
                                        SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                                                    FROM (
                                                            SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN FROM ALD_SOTHAM_KHANGNGHI KC
                                                     )NDKN  GROUP BY NDKN.DONID
                                       )NDKNS ON NDKNS.DONID=A.ID                   
                   WHERE A.ID IN (SELECT v_ID ID FROM TABLE(V_TABLE_ID_ALD))
                   )
                   LOOP
                        CountAll_LOAIAN := item.CountAll;
                        DBMS_LOB.APPEND(V_EXPORT_TEXT_DATA,' 
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Lao động</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULY||'</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;">'||item.NGAYTHULY||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTOASOTHAM||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPL_TEN||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.MAVUVIEC||'</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NOIDUNGKHANGCAO||'</td>
                            </tr>
                            ');

                   END LOOP;                


                END IF;

                CountAll_S:= CountAll_S + CountAll_LOAIAN;
                CountAll_LOAIAN := 0;

                IF(INSTR(V_LOAIAN_ID,AHC) > 0 OR V_LOAIAN_ID IS NULL) THEN
                    FOR ITEM IN (
                              SELECT  ROW_NUMBER() OVER (ORDER BY DECODE(v_Capxx,2,TLS.SOTHULY,3,to_number(regexp_replace(TLPT.SOTHULY, '[^[:digit:]]', '')) )ASC ) STT
                              ,COUNT(*) OVER () as CountAll
                                ------BC mới------------------
                                ,DECODE(v_Capxx,2,TLS.SOTHULY,3,TLPT.SOTHULY)SOTHULY
                                ,T.Ten TENTOASOTHAM 
                                ,to_char(DECODE(v_Capxx,2,TLS.NGAYTHULY,3,TLPT.NGAYTHULY),'dd/MM/yyyy')NGAYTHULY
                                ,DECODE(v_Capxx,2,NDST.TENDUONGSU,3,NDPT.TENDUONGSU)NGUYENDON
                                ,DECODE(v_Capxx,2,BDST.TENDUONGSU,3,BDPT.TENDUONGSU)BIDON
                                ,NDBDS.NOIDUNGKHANGCAO||'<br style="mso-data-placement:same-cell;" />'||NDKNS.NOIDUNGKN NOIDUNGKHANGCAO
                                ,DECODE(A.QUANHEPHAPLUAT_NAME,NULL,i.TEN,QUANHEPHAPLUAT_NAME) QHPL_TEN
                                --,PCTP_GQ.HOTEN THAMPHAN_TEN
                                , A.MAVUVIEC
                              FROM AHC_DON A
                              --INNER JOIN AHC_DON_GIAIDOAN GD ON A.ID=GD.DONID
                             INNER JOIN ( SELECT G.* 
                             FROM AHC_DON_GIAIDOAN G 
                             WHERE (G.MAGIAIDOAN = 2 AND G.TOAANID = V_TOAAN_ID) OR (G.MAGIAIDOAN = 3 AND G.TOAPHUCTHAMID = V_TOAAN_ID)
                            ) GD  ON A.ID=GD.DONID
                          
                              left join DM_DATAITEM i on A.QUANHEPHAPLUATID=i.ID
                              LEFT JOIN DM_TOAAN T ON A.TOAANID=T.ID
                                ------Trạng thái giải quyết trong danh sách
                                    LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_SOTHAM_THULY TL 
                                               GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý',TL.NGAYTHULY)TLS ON A.ID=TLS.DONID AND GD.MAGIAIDOAN=2
                                    LEFT JOIN (SELECT TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý' TINHTRANG_GQ FROM AHC_PHUCTHAM_THULY TL 
                                              GROUP BY TL.DONID,TL.SOTHULY,TL.NGAYTHULY,'</br>- Đã thụ lý',TL.NGAYTHULY)TLPT ON A.ID=TLPT.DONID AND GD.MAGIAIDOAN=3
--                                    LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM' 
--                                               GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPC ON TPPC.DONID=A.ID AND GD.MAGIAIDOAN=2 
--                                    LEFT JOIN (SELECT TP.DONID,'</br>- Đã phân công Thẩm phán' TINHTRANG_GQ FROM AHC_DON_THAMPHAN TP WHERE TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM' 
--                                               GROUP BY TP.DONID,'</br>- Đã phân công Thẩm phán')TPPCPT ON TPPCPT.DONID=A.ID AND GD.MAGIAIDOAN=3   
--                                     ----lấy 1 bản ghi mới nhất 27/12/2023
--                                    LEFT JOIN (
--                                             SELECT FIRST_VALUE(TP.ID) OVER (PARTITION BY TP.DONID ORDER BY TP.NGAYNHANPHANCONG DESC,TP.NGAYTAO DESC) ID,
--                                             CB.HOTEN,TP.DONID,TP.NGAYTAO,TP.NGAYNHANPHANCONG,NPC.HOTEN HOTEN_LD,TP.NGUOIPHANCONGID,TP.CANBOID,TP.NGAYPHANCONG
--                                             FROM  AHC_DON_THAMPHAN TP
--                                             LEFT JOIN DM_CANBO CB ON CB.ID=TP.CANBOID
--                                             LEFT JOIN DM_CANBO NPC ON NPC.ID=TP.NGUOIPHANCONGID 
--                                             WHERE ( (v_Capxx = 2 AND TP.MAVAITRO='VTTP_GIAIQUYETSOTHAM') OR (v_Capxx = 3 AND TP.MAVAITRO='VTTP_GIAIQUYETPHUCTHAM')  ) 
--                                             AND TP.NGAYPHANCONG IS NOT NULL AND TP.NGAYNHANPHANCONG IS NOT NULL AND TP.NGUOIPHANCONGID IS NOT NULL
--                                   )PCTP_GQ ON PCTP_GQ.DONID = A.ID 
                                  LEFT JOIN (
                                         SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AHC_DON_DUONGSU DS WHERE  DS.TUCACHTOTUNG_MA='NGUYENDON'          
                                         GROUP BY DS.DONID
                                  )NDST ON NDST.DONID=A.ID AND GD.MAGIAIDOAN=2
                                 LEFT JOIN (
                                        SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU FROM AHC_DON_DUONGSU DS WHERE DS.TUCACHTOTUNG_MA='NGUYENDON'     
                                        GROUP BY DS.DONID
                                  )NDPT ON NDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                                 LEFT JOIN (
                                         SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AHC_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
                                         GROUP BY DS.DONID
                                  )BDST ON BDST.DONID=A.ID AND GD.MAGIAIDOAN=2
                                 LEFT JOIN (
                                        SELECT DS.DONID,LISTAGG (DS.TENDUONGSU, ', ') WITHIN GROUP (ORDER BY DS.TENDUONGSU)TENDUONGSU  FROM AHC_DON_DUONGSU DS WHERE DS.ISDAIDIEN=1 AND DS.TUCACHTOTUNG_MA='BIDON'          
                                        GROUP BY DS.DONID
                                  )BDPT ON BDPT.DONID=A.ID AND GD.MAGIAIDOAN=3
                                  -- SO LƯƠNG + TUCACHTOTUNG_MA
                                  LEFT JOIN (     
                                            SELECT NDBD.DONID,LISTAGG(NDBD.NOIDUNGKHANGCAO, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDBD.NOIDUNGKHANGCAO) NOIDUNGKHANGCAO
                                                FROM (
                                                        SELECT  TO_NUMBER(SUBSTR(FF.DON_ND,0,INSTR(FF.DON_ND,';')-1))DONID,
                                                           SUBSTR(FF.DON_ND,INSTR(FF.DON_ND,';')+1, LENGTH(FF.DON_ND))NOIDUNGKHANGCAO
                                                        FROM (   
                                                              SELECT F.DON_ND FROM (
                                                                    select KC.DONID||';'||count(*)||' '||decode(DS.TUCACHTOTUNG_MA,'BIDON','BĐ','NGUYENDON','NĐ','QUYENNVLQ','NLQ')||' k/c' DON_ND
                                                                    from AHC_SOTHAM_KHANGCAO kc 
                                                                    LEFT JOIN AHC_DON_DUONGSU DS ON DS.ID=KC.DUONGSUID
                                                                    GROUP BY KC.DONID,DS.TUCACHTOTUNG_MA
                                                                   )F
                                                              GROUP BY F.DON_ND
                                                          )FF
                                                 )NDBD  GROUP BY NDBD.DONID
                                     )NDBDS ON NDBDS.DONID=A.ID
                                ---KHANG NGHI - TOAAN - VIEN KIEM SOAT       
                                LEFT JOIN (
                                        SELECT NDKN.DONID,LISTAGG(NDKN.NOIDUNGKN, '<br style="mso-data-placement:same-cell;" />')  WITHIN GROUP (ORDER BY NDKN.NOIDUNGKN)NOIDUNGKN
                                                    FROM (
                                                            SELECT KC.DONID,decode(KC.DONVIKN,0,'CA','VKS')||' k/n' NOIDUNGKN FROM AHC_SOTHAM_KHANGNGHI KC
                                                     )NDKN  GROUP BY NDKN.DONID
                                       )NDKNS ON NDKNS.DONID=A.ID                    

                    WHERE A.ID IN (SELECT v_ID ID FROM TABLE(V_TABLE_ID_AHC))
                    )
                    LOOP
                        CountAll_LOAIAN := item.CountAll;
                        DBMS_LOB.APPEND(V_EXPORT_TEXT_DATA,' 
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.STT||'</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Hành chính</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.SOTHULY||'</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;mso-number-format:\@;">'||item.NGAYTHULY||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.TENTOASOTHAM||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NGUYENDON||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.BIDON||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.QHPL_TEN||'</td>
                                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||item.MAVUVIEC||'</td>
                                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||item.NOIDUNGKHANGCAO||'</td>
                            </tr>
                            ');

                    END LOOP;
                END IF;

                CountAll_S:= CountAll_S + CountAll_LOAIAN;
                CountAll_LOAIAN := 0;


                IF(V_LOAIAN_ID='2,3,4,5,6') THEN -- DS
                    TEN_LOAI_AN_DA_XU := 'DÂN SỰ CÁC LOẠI';
                ELSE
                    SELECT UPPER(A.LOAI_AN_TEN) INTO TEN_LOAI_AN_DA_XU
                    FROM DM_LOAIAN A
                    WHERE ID = TO_NUMBER(V_LOAIAN_ID);
                END IF;

                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <table cellpadding="1" style="font-family: times New Roman; font-size: 12pt; text-align: center; border-collapse: collapse;">
                <tr>
                    <td colspan="9" style="line-height: 100%; font-size: 14pt; text-align: center;"><b>DANH SÁCH ÁN '||TEN_LOAI_AN_DA_XU||' THỤ LÝ MỚI</b>
                    </td>
                </tr>
                <tr>
                    <td colspan="9" style="height: 15pt; text-align: left;"><b>Tổng số: '||CountAll_S||' bản ghi</b></td>
                </tr>
                <tr style="font-weight: bold;">
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Loại án</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số TL</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ngày TL</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tỉnh / TP</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Nguyên đơn</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Bị đơn</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Vụ việc</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Mã Vụ việc</td>
                    <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">KC/KN</td>
                </tr>
                     '); 

               DBMS_LOB.APPEND(V_EXPORT_TEXT, V_EXPORT_TEXT_DATA); 

               DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                        <tr style="height: 1px;">
                        <td style="width: 43px"></td>
                        <td style="width: 72px"></td>
                        <td style="width: 61px"></td>
                        <td style="width: 90px"></td>
                        <td style="width: 115px"></td>
                        <td style="width: 115px"></td>
                        <td style="width: 166px"></td>
                        <td style="width: 185px"></td>
                        <td style="width: 100px"></td>
                        <td style="width: 90px"></td>
                    </tr>
                </table>');   

            END IF;


    OPEN curReturn FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
            dbms_lob.freetemporary(V_EXPORT_TEXT);
END HS_DS_AN_DATHULY;

FUNCTION NHAPLIEU_HS_DS_EXT_ALL
(
    vDonViID  IN number,
    v_TINHTRANG_THULY IN VARCHAR2,
    v_TINHTRANG_GIAIQUYET IN VARCHAR2,
    V_TUNGAY IN VARCHAR2,
    V_DENNGAY IN VARCHAR2,
    v_TOAANID in VARCHAR2
)RETURN SYS_REFCURSOR
AS  
    V_CURSOR sys_refcursor;VV_TUNGAY DATE;VV_DENNGAY DATE;V_TOAAN_NAME NVARCHAR2(250 CHAR);V_HANHCHINH_NAME NVARCHAR2(250 CHAR);
    V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB;
    SOLUONGCHUAGQ number;
    v_ArrSapXep varchar2(250);
    v_Tongcong number;
    v_STT number;
    v_LOAITOA varchar2(250);
BEGIN	
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);
    ----
     SELECT TA.TEN,TA.LOAITOA INTO V_TOAAN_NAME, v_LOAITOA FROM DM_TOAAN TA WHERE TA.ID=vDonViID;
     ----
     select ARRSAPXEP into v_ArrSapXep from DM_TOAAN where ID=vDonViID;
     -------------
     SELECT HC.TEN INTO V_HANHCHINH_NAME FROM DM_HANHCHINH HC 
     WHERE EXISTS(SELECT 'X' FROM DM_TOAAN TA WHERE TA.ID=vDonViID AND TA.HANHCHINHID=HC.ID);
     ----

     if(V_TUNGAY IS NOT NULL) then  VV_TUNGAY:=to_date(trim(V_TUNGAY)||' 00:00:00','dd/MM/yyyy HH24:MI:SS');  end if;  
     if(V_DENNGAY IS NOT NULL) then  VV_DENNGAY:=to_date(trim(V_DENNGAY)||' 23:59:59','dd/MM/yyyy HH24:MI:SS'); end if; 

     DBMS_LOB.APPEND(V_EXPORT_TEXT,'
          <table cellpadding="1" style="font-family: times New Roman; font-size: 11pt; text-align: center; border-collapse: collapse;">
            <tr>
                <td colspan="10" style="text-align: center; vertical-align: top; font-size: 11pt">TÒA ÁN NHÂN DÂN TỐI CAO</td>
                <td colspan="2"></td>
                <th colspan="12" style="text-align: center; vertical-align: top; font-size: 11pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
            </tr>
            <tr style="text-align: center;">
                <th colspan="10" style="vertical-align: top; font-size: 11pt;">'||UPPER(V_TOAAN_NAME)||'</th>
                <td colspan="2"></td>
                <th colspan="12" style="vertical-align: top; font-size: 13pt;">Độc lập - Tự do - Hạnh phúc </th>
            </tr>
            <tr>

                <td colspan="24" style="line-height: 100%; font-size: 13pt; text-align: center; height: 80px;"><b>BÁO CÁO NHẬP LIỆU TẠI CÁC ĐƠN VỊ</b></td>
            </tr>
            <tr>
                <td colspan="24" style="line-height: 100%; font-size: 13pt; text-align: center; height: 60px; font-style: italic;">Tính từ ngày '||V_TUNGAY||' đến '||V_DENNGAY||'</td>
            </tr>
            <tr>
            <td></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:70px" rowspan="2">TT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">Đơn Vị</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" colspan ="3">Hình sự</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" colspan ="3">Dân sự</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="3">HN</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="3">Hành Chính</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="3">KDTM</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="3">Lao động</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;"colspan ="3">Phá sản</td>
                <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;" rowspan="2">Tổng</th>
            </tr>
             <tr style="font-weight: bold;">

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>

                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Sơ thẩm</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Phúc thẩm</td>  
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">GDTT,TT</td>

            </tr>
                 '); 
        v_Tongcong:=0;
        v_STT := 0;
       FOR v_DM_TOAAN In (
                 SELECT TC.* FROM  
                 (SELECT CO.* FROM DM_TOAAN CO 
                        LEFT JOIN DM_TOAAN CC ON CC.ID=CO.CAPCHAID
                          WHERE (((CO.ID IN( SELECT SS.ID 
                                              FROM DM_TOAAN SS
                                              LEFT JOIN DM_TOAAN K ON K.ID=SS.CAPCHAID
                                              CONNECT BY PRIOR SS.CAPCHAID = SS.ID
                                            )  
                                      ))
                                )  AND CO.HIEULUC = 1
                                --AND (instr(','||v_TOAANID||',',','||CO.ID||',')>0 AND v_TOAANID IS NOT NULL)
                                AND (instr(',3931,7,1710,1711,1712,1713,1714,1715,1716,1717,1718,1719,1720,1721,21,217,224,1789,1790,1791,1792,48,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,46,1972,1973,1974,1975,1976,1977,1978,1979,1980,1981,1982,1983,1984,1985,49,2001,2002,2003,2004,2005,2006,2007,2008,43,1961,1962,1963,1964,1965,1966,1967,1968,1969,1970,1971,20,1781,1782,1783,1784,1785,1786,1787,1788,3932,66,1916,1917,1918,1919,1920,1921,1922,1923,1924,1925,1926,1927,1928,1929,28,1834,1835,1836,1837,1838,1839,1840,1841,1842,1843,1844,1845,1846,1847,1848,1849,1850,1851,1852,41,1952,1953,1954,1955,1956,1957,1958,1959,1960,55,2038,2039,2040,2041,2042,2043,2044,2045,2046,2047,2048,2049,2050,2051,62,1889,1890,1891,1892,1893,1894,1895,1896,1897,1898,1899,1900,50,2010,2011,2012,2013,2014,2015,2016,2017,2018,2019,2020,2021,2022,2023,2024,2025,2009,53,2026,2027,2028,2029,2030,2031,2032,2033,2034,2035,2036,2037,31,1866,1867,1868,1869,1870,1871,1872,1873,1874,1875,1876,1877,1878,1879,63,1901,1902,1903,1904,1905,1906,1907,1908,1909,1910,1911,1912,1913,1914,1915,3930,12,1740,1741,1742,1743,1744,1745,1746,1747,27,1822,1823,1824,1825,1826,1827,1828,1829,1830,1831,1832,1833,29,1853,1854,1855,1856,1857,1858,1859,1860,1861,1862,1863,1864,1865,36,1937,1938,1939,1940,1941,1942,1943,1935,1936,9,109,1722,1723,1724,1725,1726,68,1930,1931,1932,1933,1934,18,200,1777,1778,1779,1780,1776,37,1944,1945,1946,1947,1948,1949,1950,1951,10,1727,1728,1729,1730,13,1748,1749,1750,1751,1752,11,1731,1732,1733,1734,1735,1736,1737,1738,1739,26,179,1810,1811,1812,1813,1814,1815,1816,1817,1818,1819,1820,1821,25,1799,1800,1801,1802,1803,1804,1805,1806,1807,1808,1809,17,1759,1760,1761,1762,1763,1764,1765,1766,1767,1768,1769,1770,1771,1772,1773,1774,1775,22,1798,1793,1794,1795,1796,1797,16,1753,1754,1755,1756,1757,1758,35,1880,1881,1882,1883,1884,1885,1886,1887,1888,61,653,2052,2053,2054,2055,2056,2057,2058,2059,2060,2061,2062,2063,2064,3971,3972,',','||CO.ID||',')>0)
                  ) TC
                   LEFT JOIN DM_TOAAN_TACH_NHAP_MAPPING M  ON M.TOAANID = TC.ID
                         where M.TOAANID IS NULL
                    ORDER BY TC.ARRTHUTU 
                )
            LOOP
            v_Tongcong:=0;
            v_STT := v_STT + 1;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                      <tr>
                         <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;height:50px">'||v_STT||'</td>');
            IF (v_DM_TOAAN.LOAITOA = 'CAPHUYEN') THEN
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                         <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;width:600px">'||v_DM_TOAAN.MA_TEN||'</td>');
            ELSE       
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                         <th style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||v_DM_TOAAN.TEN||'</th>');
            END IF;
--  An Hinh Su       Tong so an So tham 
                        select count(hs.id) into SOLUONGCHUAGQ from GSCM.ahs_sotham_thuly hs                                
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id 
                                LEFT JOIN GSCM.AHS_SOTHAM_BANAN T2 ON v.id=T2.vuanid and hs.id = t2.thulyid
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID, Q.thulyid
                                                        FROM GSCM.AHS_SOTHAM_QUYETDINH_VUAN Q 
                                                                LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid and t3.id = t3.thulyid
                                    where 
                                   ( v.toaanid = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR v.TOA_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYBANAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYBANAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
--                Phuc tham   
                    select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ahs_phuctham_thuly hs
                                LEFT JOIN GSCM.ahs_vuan v on hs.vuanid = v.id
                                LEFT JOIN GSCM.AHS_PHUCTHAM_BANAN T2 ON v.id=T2.vuanid
                                LEFT JOIN (SELECT Q.id, Q.SOQUYETDINH, Q.NGAYQD,Q.VUANID,Q.QUYETDINHID 
                                                      FROM GSCM.AHS_PHUCTHAM_QUYETDINH_VUAN Q 
                                                             LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                            WHERE D.KET_THUC = 1) T3 ON v.id=T3.vuanid
                                 where 
                                    ( v.TOAPHUCTHAMID = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR v.TOA_PHUCTHAM_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                    and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYBANAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYBANAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
--                GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 1 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');

--    An Dan su

                    select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ads_sotham_thuly hs
                                LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ADS_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                               FROM GSCM.ADS_SOTHAM_QUYETDINH Q 
                                                                    LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid                                 
                                where 
                                     ( d.toaanid = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                    and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;


                             v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;               
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
                   select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ads_phuctham_thuly hs 
                                 LEFT JOIN GSCM.ads_don d on hs.donid = d.id
                                 LEFT JOIN GSCM.ADS_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                 LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.ADS_PHUCTHAM_QUYETDINH Q 
                                                                  LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                                WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                  where 
                                     ( d.TOAPHUCTHAMID = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_PHUCTHAM_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;


                             v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;               
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');                     

               --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 2 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                      AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');


--    An Hon Nhan                      
                    select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ahn_sotham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ahn_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                  FROM GSCM.AHN_SOTHAM_QUYETDINH Q 
                                                                       LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                  WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    (d.toaanid = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;                   

                                v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
                     select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ahn_phuctham_thuly hs
                                LEFT JOIN GSCM.ahn_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHN_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                            FROM GSCM.AHN_PHUCTHAM_QUYETDINH Q 
                                                                 LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                     WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    ( d.TOAPHUCTHAMID = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_PHUCTHAM_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;

                                v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');         
             --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 3 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');


--      An Hanh chinh                      
                        select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ahc_sotham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Ahc_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                            FROM GSCM.AHC_SOTHAM_QUYETDINH Q 
                                                                 LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                            WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                   ( d.toaanid = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;  

                            v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');

                     select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ahc_phuctham_thuly hs
                                LEFT JOIN GSCM.ahc_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AHC_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.AHC_PHUCTHAM_QUYETDINH Q 
                                                                      LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                    WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    ( d.TOAPHUCTHAMID = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_PHUCTHAM_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;

                            v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');

                        --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 6 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');


--         an kinh te   

                      select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.akt_sotham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Akt_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                              FROM GSCM.AKT_SOTHAM_QUYETDINH Q 
                                                                       LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                             WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    ( d.toaanid = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;  

                            v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');

                  select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.akt_phuctham_thuly hs
                                LEFT JOIN GSCM.akt_don d on hs.donid = d.id
                                LEFT JOIN GSCM.AKT_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.AKT_PHUCTHAM_QUYETDINH Q 
                                                                     LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                               WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    ( d.TOAPHUCTHAMID = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_PHUCTHAM_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ; 

                            v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');
              --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 4 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY;

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');



--       An Lao dong
                select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ald_sotham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ALD_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM GSCM.ALD_SOTHAM_QUYETDINH Q 
                                                                   LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                               WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    ( d.toaanid = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;  

                        v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');

                   select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.ald_phuctham_thuly hs
                                LEFT JOIN GSCM.ald_don d on hs.donid = d.id
                                LEFT JOIN GSCM.ALD_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                                FROM  GSCM.ALD_PHUCTHAM_QUYETDINH Q 
                                                                   LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                  WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    ( d.TOAPHUCTHAMID = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_PHUCTHAM_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ; 

                        v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');         
              --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 5 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');



--    An Pha san                        
                    select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.aps_sotham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.Aps_SOTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                             FROM GSCM.APS_SOTHAM_QUYETDINH Q 
                                                                   LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                                WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    ( d.toaanid = v_DM_TOAAN.ID 
--                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
--                                        OR d.TOA_GIAIQUYET_ID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;  

                        v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td> ');

                        select count(hs.id) INTO SOLUONGCHUAGQ from GSCM.aps_phuctham_thuly hs
                                LEFT JOIN GSCM.aps_don d on hs.donid = d.id
                                LEFT JOIN GSCM.APS_PHUCTHAM_BANAN T2 ON d.id=T2.donid
                                LEFT JOIN (SELECT Q.id, Q.SOQD, Q.NGAYQD,Q.DONID,Q.QUYETDINHID 
                                                        FROM GSCM.APS_PHUCTHAM_QUYETDINH Q 
                                                             LEFT JOIN  GSCM.DM_QD_QUYETDINH D ON D.ID=Q.QUYETDINHID 
                                                                         WHERE D.KET_THUC = 1) T3 ON d.id=T3.donid
                                where 
                                    ( d.TOAPHUCTHAMID = v_DM_TOAAN.ID 
                                        -- Du lieu cua cac toan sáp nhập vào Tòa này
                                        OR d.TOAPHUCTHAMID in (select toaanid from DM_TOAAN_TACH_NHAP_MAPPING where TOTOAANID = v_DM_TOAAN.ID )
                                        )
                                     and hs.ngaythuly BETWEEN VV_TUNGAY and VV_DENNGAY
                                     and (v_TINHTRANG_GIAIQUYET is null 
--                                      Chua giai quyet xong
                                        OR (v_TINHTRANG_GIAIQUYET = 1 
                                                AND ((T2.ID is null And T3.ID is null) Or
                                                            ((T2.ID is not null and T2.NGAYTUYENAN  > VV_DENNGAY) 
                                                                or ( T3.ID is not null and T3.NGAYQD  > VV_DENNGAY))))
--                                      Da co ket qua giai quyet
                                        OR (v_TINHTRANG_GIAIQUYET = 7 
                                                AND ((T2.ID is not null and T2.NGAYTUYENAN  BETWEEN VV_TUNGAY and VV_DENNGAY) 
                                                            or ( T3.ID is not null and T3.NGAYQD  BETWEEN VV_TUNGAY and VV_DENNGAY)))        
                                        ) ;

                        v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
             DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>
                   ');
              --        GDT
                select  count(hs.id) INTO SOLUONGCHUAGQ from GSCM.gdttt_vuan hs
                                    where hs.LOAIAN = 7 
                                     AND hs.toaanid = v_DM_TOAAN.ID
                                     AND hs.NGAYTHULYXXGDT is not null
                                     AND hs.NGAYTHULYXXGDT BETWEEN VV_TUNGAY and VV_DENNGAY
                                     AND (v_TINHTRANG_GIAIQUYET is null 
                                            Or (v_TINHTRANG_GIAIQUYET = 7 --Da co ket qua
                                                AND hs.TrangThaiId = 15
                                                AND NVL(hs.XXGDTTT_ISKETQUA,0)>0
                                                AND hs.NGAYXUGIAMDOCTHAM BETWEEN VV_TUNGAY and VV_DENNGAY)
                                            Or (v_TINHTRANG_GIAIQUYET = 1 
--                                                  Chua co ket qua
                                                AND (NVL(hs.XXGDTTT_ISKETQUA,0) = 0 
--                                                Hoac da co ket qua nhung sau ngay tim kiem
                                                    Or NVL(hs.XXGDTTT_ISKETQUA,0) > 0 AND hs.NGAYXUGIAMDOCTHAM > VV_DENNGAY )
                                                )
                                        );

                     v_Tongcong := v_Tongcong + SOLUONGCHUAGQ;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'                      
                            <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||SOLUONGCHUAGQ||'</td>');




            DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
                        <th style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||v_Tongcong||'</th>
                      </tr>
                   '); 
        END LOOP;

        DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
            <tr style="height: 1px;">
                <td style="width: 50px"></td>
                <td style="width: 500px"></td>

                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>

                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>

                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>

                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>

                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>

                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>

                <td style="width: 80px"></td>
                <td style="width: 80px"></td>
                <td style="width: 100px"></td>

                <td style="width: 80px"></td>
            </tr>
        </table>
      ');

    OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);
        RETURN V_CURSOR;  

END NHAPLIEU_HS_DS_EXT_ALL;


FUNCTION HS_DS_AN_CHUYENVKS
(
    V_DON_ID  IN varchar2,
    V_DONVIID IN NUMBER
)RETURN SYS_REFCURSOR
AS  
    V_CURSOR sys_refcursor;
    V_EXPORT_TEXT CLOB;V_EXPORT_TEXT_ITEM CLOB; 
    V_TABLE T_STPT_6LOAIAN_GIAOVKS;
     V_LOAIAN_ID varchar2(100); vDonid number; vDon_id varchar2(200); vLoaian_id varchar2(100);Don_loaian varchar2(200);
     CountAll_S number;
     V_TENDONVI varchar2(250);V_TENDONVI_FULL varchar2(250);V_DONVI_CV varchar2(250);V_TENDONVI_HC varchar2(250);
     V_TENDONVI_CHA varchar2(250);V_CAP  varchar2(250);
BEGIN	
     DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT_ITEM,true);

    v_table := T_STPT_6LOAIAN_GIAOVKS();
    --- TEN DON VI
    SELECT REPLACE(REPLACE(TA.TEN,'Tòa án nhân dân cấp cao',''),'Tòa án nhân dân',''),DECODE(TA.LOAITOA,'TOICAO','TANDTC','CAPCAO','TANDCC'),TA.TEN
     ,replace(HC.TEN,'thành phố ',''),CAPCHA.TEN,TA.SOCAP INTO V_TENDONVI,V_DONVI_CV,V_TENDONVI_FULL,V_TENDONVI_HC,V_TENDONVI_CHA,V_CAP FROM DM_TOAAN TA 
     LEFT JOIN DM_HANHCHINH HC ON HC.ID=TA.HANHCHINHID
      LEFT JOIN DM_TOAAN CAPCHA ON TA.CAPCHAID = CAPCHA.ID
     WHERE TA.ID=V_DONVIID;

    ---------------------------------------
    FOR item IN ( select  COLUMN_VALUE from  TABLE ( split_String(V_DON_ID,';')) 
            )
        LOOP 
            -- Duyet tung Don theo Loai an
            vDon_id := SUBSTR(item.COLUMN_VALUE,1,instr(item.COLUMN_VALUE,',')-1);
            V_LOAIAN_ID := SUBSTR(item.COLUMN_VALUE,instr(item.COLUMN_VALUE,',')+1);
                ----HS-----
                IF(TO_NUMBER(V_LOAIAN_ID) = 1) THEN
                     FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                             DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                             BA.SOBANAN,BA.NGAYBANAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                        FROM AHS_VUAN v
                                        LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.VUANID FROM AHS_SOTHAM_THULY TL) TLST ON V.ID=TLST.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.VUANID FROM AHS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.VUANID 
                                        LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYBANAN,TA.TEN,STBA.VUANID FROM AHS_SOTHAM_BANAN STBA 
                                                                LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.VUANID = V.ID
                                        where v.id = TO_NUMBER(vDon_id))
                        LOOP
                        --Lay thong tin thu ly

                            v_table.extend;
                            v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                item.ID,item.MAVUAN,'Hình sự',V_LOAIAN_ID,item.TENVUAN,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                              ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                               item.TEN,item.SOBANAN,to_char(item.NGAYBANAN,'dd/MM/yyyy'),
                               item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);
                        END LOOP;
                ELSIF (TO_NUMBER(V_LOAIAN_ID) = 2) THEN    
                       -----ds----
                       FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                             DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                             BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS  
                                        FROM ADS_DON v
                                        LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ADS_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ADS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                        LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM ADS_SOTHAM_BANAN STBA 
                                                                LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                        where id = TO_NUMBER(vDon_id))
                        LOOP
                            v_table.extend;
                            v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                item.ID,item.MAVUVIEC,'Dân sự',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                                item.TEN,item.SOBANAN,to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),
                                item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);   
                        END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 3) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN , 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM AHN_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AHN_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AHN_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM AHN_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Hôn nhân gia Đình',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                   ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                                   item.TEN,item.SOBANAN,to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),
                                   item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);  
                            END LOOP;
                ELSIF (TO_NUMBER(V_LOAIAN_ID) = 4) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS  
                                            FROM AKT_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AKT_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AKT_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM AKT_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Kinh doanh Thương mại',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                                  item.TEN,item.SOBANAN,to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),
                                  item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);    
                            END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 5) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS  
                                            FROM ALD_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ALD_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ALD_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM ALD_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Lao động',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                                   item.TEN,item.SOBANAN,to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),
                                   item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null); 
                            END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 6) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM APS_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM APS_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM APS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM APS_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Phá sản',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ,to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),
                                   item.TEN,item.SOBANAN,to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),
                                   item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);
                            END LOOP;
                END IF;
         END LOOP;
      ---------- 
       FOR vDATA IN ( 
            SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAY_TAO desc) STT,COUNT(*) OVER () as CountAll,A.*
                FROM TABLE(v_table) A )
        LOOP
          CountAll_S:=vDATA.CountAll;
          DBMS_LOB.APPEND(V_EXPORT_TEXT_ITEM,' 
            <tr><td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.STT||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.SOTHULY||'<br/> '||vDATA.NGAYTHULY||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.LOAIAN||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.TOAANXX||'</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.SOBA||'<br/> '||vDATA.NGAYBA||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.SOBUTLUC||'</td>
                <td style="text-align: left; vertical-align: middle; border: 0.1pt solid #000000;">'||vDATA.GHICHU||'</td>
            </tr>
                ');
        END LOOP;

       DBMS_LOB.APPEND(V_EXPORT_TEXT,'
           <table cellpadding="1" style="font-family: times New Roman; font-size: 12pt; text-align: center; border-collapse: collapse;">

                <tr>
                    <td colspan="4" style="text-align: center; vertical-align: top; font-size: 12pt">');
                    IF(V_CAP = '2' OR V_CAP = '3') THEN 
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'TÒA ÁN NHÂN DÂN TỐI CAO');
                    ELSE 
                        DBMS_LOB.APPEND(V_EXPORT_TEXT, UPPER(V_TENDONVI_CHA));
                    END IF;

                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'</td>
                    <td></td>
                    <th colspan="2" style="text-align: center; vertical-align: top; font-size: 12pt;">CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</th>
                </tr>
                 <tr style="text-align: center;">
                    <th colspan="4" style="vertical-align: top; font-size: 13pt;">');
                    IF(V_CAP = '2') THEN 
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'TÒA ÁN NHÂN DÂN CẤP CAO');
                    ELSE 
                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'TÒA ÁN NHÂN DÂN '||UPPER(V_TENDONVI));
                    END IF;

                    DBMS_LOB.APPEND(V_EXPORT_TEXT,'</th>
                    <td></td>
                    <th colspan="2" style="vertical-align: top;font-size: 13pt; text-decoration: underline;">Độc lập - Tự do - Hạnh phúc</th>
                </tr>  
                <tr style="text-align: center;">
                    <th colspan="4" style="vertical-align: top; font-size: 13pt;">');
                            IF(V_DONVIID = 4) THEN 
                                DBMS_LOB.APPEND(V_EXPORT_TEXT,'<u>TẠI HÀ NỘI</u>');
                            ELSIF(V_DONVIID = 5) THEN 
                                DBMS_LOB.APPEND(V_EXPORT_TEXT,'<u>TẠI ĐÀ NẴNG</u>');
                            ELSIF(V_DONVIID = 6) THEN 
                                DBMS_LOB.APPEND(V_EXPORT_TEXT,'TẠI THÀ<u>NH PHỐ HỒ C</u>HÍ MINH');
                            END IF;

                        DBMS_LOB.APPEND(V_EXPORT_TEXT,'</th>
                    <td></td>
                    <th colspan="2" style="vertical-align: top;font-size: 13pt; text-decoration: underline;"></th>
                </tr>   
                <tr>
                    <td ></td>
                    <td colspan="6" style="line-height: 100%;text-align: left; padding-left: 2px; color: #ffffff;">-------</td>
                </tr>

            <tr>
                <td colspan="7" style="line-height: 100%; font-size: 14pt; text-align: center;"><b>DANH SÁCH CÁC VỤ ÁN GIAO VIỆN KIỂM SÁT NGÀY '|| TO_CHAR(SYSDATE,'dd/MM/yyyy') ||'</b>
                </td>
            </tr>
            <tr>
                <td colspan="7" style="line-height: 100%;text-align: left; padding-left: 2px; color: #ffffff;">-------</td>
            </tr>
            <tr>
                <td colspan="7" style="height: 15pt; text-align: left;"><b>Tổng số: ');
                IF CountAll_S <10 THEN
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' 0'||CountAll_S);
                ELSE
                    DBMS_LOB.APPEND(V_EXPORT_TEXT,' '||CountAll_S);
                END IF;
            DBMS_LOB.APPEND(V_EXPORT_TEXT,' hồ sơ</b></td>
            </tr>
            <tr style="font-weight: bold;">
                <td style="height: 20pt;text-align: center; vertical-align: middle; border: 0.1pt solid #000000; height: 50pt;">STT</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số, ngày thụ lý</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Loại VA</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Địa phương</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Số, ngày BA/QĐ</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Tổng số bút lục</td>
                <td style="text-align: center; vertical-align: middle; border: 0.1pt solid #000000;">Ghi chú</td>
            </tr>
                 '); 
       ------ADD DỮ LIỆU VÀO THÂN BÁO CÁO
       DBMS_LOB.APPEND(V_EXPORT_TEXT,V_EXPORT_TEXT_ITEM );
       --------------------------------
       DBMS_LOB.APPEND(V_EXPORT_TEXT,' 
          <tr style="height: 1px;">
                <td style="width: 40px"></td>
                <td style="width: 100px"></td>
                <td style="width: 100px"></td>
                <td style="width: 200px"></td>
                <td style="width: 100px"></td>
                <td style="width: 80px"></td>
                <td style="width: 300px"></td>
            </tr>
        </table>
      ');
       OPEN V_CURSOR FOR
        SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
        dbms_lob.freetemporary(V_EXPORT_TEXT);

        RETURN V_CURSOR;       
 END HS_DS_AN_CHUYENVKS;  

PROCEDURE HS_DS_GIAO_HOSO_VKS
(
    V_DON_ID  IN varchar2,
    curReturn OUT sys_refcursor
)
AS
    TotalItem number;  MinIndex number; MaxIndex number; V_TABLE T_STPT_6LOAIAN_GIAOVKS;
    V_LOAIAN_ID varchar2(100); vDonid number; vDon_id varchar2(200); vLoaian_id varchar2(100);Don_loaian varchar2(200);

BEGIN	
     v_table := T_STPT_6LOAIAN_GIAOVKS();
    ---------------------------------------
    FOR item IN ( select  COLUMN_VALUE from  TABLE ( split_String(V_DON_ID,';')) 
            )
        LOOP 
            -- Duyet tung Don theo Loai an
            vDon_id := SUBSTR(item.COLUMN_VALUE,1,instr(item.COLUMN_VALUE,',')-1);
            V_LOAIAN_ID := SUBSTR(item.COLUMN_VALUE,instr(item.COLUMN_VALUE,',')+1);

               ----HS-----
                IF(TO_NUMBER(V_LOAIAN_ID) = 1) THEN
                     FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                             DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                             BA.SOBANAN,BA.NGAYBANAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS
                                        FROM AHS_VUAN v
                                        LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.VUANID FROM AHS_SOTHAM_THULY TL) TLST ON V.ID=TLST.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.VUANID FROM AHS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.VUANID 
                                        LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYBANAN,TA.TEN,STBA.VUANID FROM AHS_SOTHAM_BANAN STBA 
                                                                LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.VUANID = V.ID
                                        where v.id = TO_NUMBER(vDon_id))
                        LOOP
                        --Lay thong tin thu ly

                            v_table.extend;
                            v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                item.ID,item.MAVUAN,'Hình sự',V_LOAIAN_ID,item.TENVUAN,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                               ITEM.SOTHULY ||' </br> '||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                               item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYBANAN,'dd/MM/yyyy'),null,
                               item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                               null, null); 
                        END LOOP;
                ELSIF (TO_NUMBER(V_LOAIAN_ID) = 2) THEN    
                       -----ds----
                       FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                             DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                             BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN,
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS
                                        FROM ADS_DON v
                                        LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ADS_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                        LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ADS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                        LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM ADS_SOTHAM_BANAN STBA 
                                                                LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                        where id = TO_NUMBER(vDon_id))
                        LOOP
                            v_table.extend;
                            v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                item.ID,item.MAVUVIEC,'Dân sự',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                ITEM.SOTHULY ||'</br>'||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                                 item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),null,
                                 item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                null, null);
                        END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 3) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                              HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM AHN_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AHN_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AHN_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM AHN_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Hôn nhân gia Đình',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                   ITEM.SOTHULY ||'</br>'||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                                    item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),null,
                                    item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null); 
                            END LOOP;
                ELSIF (TO_NUMBER(V_LOAIAN_ID) = 4) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                             HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM AKT_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AKT_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM AKT_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM AKT_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Kinh doanh Thương mại',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ||'</br>'||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                                    item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),null,
                                    item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);
                            END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 5) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                                HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM ALD_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ALD_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM ALD_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM ALD_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Lao động',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ||'</br>'||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                                    item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),null,
                                    item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null);
                            END LOOP;
                 ELSIF (TO_NUMBER(V_LOAIAN_ID) = 6) THEN    
                       -----ds----
                           FOR item IN (SELECT v.*,DECODE(V.MAGIAIDOAN,2,TLST.SOTHULY,TLPT.SOTHULY) SOTHULY,
                                                DECODE(V.MAGIAIDOAN,2,TLST.NGAYTHULY,TLPT.NGAYTHULY) NGAYTHULY, 
                                                BA.SOBANAN,BA.NGAYTUYENAN,REPLACE(BA.TEN,'Tòa án nhân dân','') TEN, 
                                                HS.NGAY_NC NGAYCHUYENVKS,HS.CANBOID,HS.DV_GUI_NHAN,HS.NGUOI_NHAN_VKS 
                                            FROM APS_DON v
                                            LEFT JOIN ( SELECT h.NGAY_NC,h.CANBOID,h.DV_GUI_NHAN,h.NGUOI_NHAN_VKS,h.VUANID   FROM HOSO_PT h WHERE h.LOAIAN = V_LOAIAN_ID and h.LOAI_CN = 1 and h.LOAI_DV = 2) HS on v.ID = HS.VUANID 
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM APS_SOTHAM_THULY TL) TLST ON V.ID=TLST.DONID
                                            LEFT JOIN ( SELECT TL.SOTHULY, TL.NGAYTHULY,TL.DONID FROM APS_PHUCTHAM_THULY TL) TLPT ON V.ID=TLPT.DONID
                                            LEFT JOIN (SELECT STBA.SOBANAN,STBA.NGAYTUYENAN,TA.TEN,STBA.DONID FROM APS_SOTHAM_BANAN STBA 
                                                                    LEFT JOIN (SELECT * FROM DM_TOAAN) TA ON STBA.TOAANID = TA.ID
                                                                    WHERE  STBA.SOBANAN IS NOT NULL) BA ON BA.DONID = V.ID
                                            where id = TO_NUMBER(vDon_id))
                            LOOP
                                v_table.extend;
                                v_table(v_table.count) := R_STPT_6LOAIAN_GIAOVKS(
                                    item.ID,item.MAVUVIEC,'Phá sản',V_LOAIAN_ID,item.TENVUVIEC,item.NGAYTAO,item.NGUOITAO,item.MAGIAIDOAN,
                                    ITEM.SOTHULY ||'</br>'||to_char(ITEM.NGAYTHULY,'dd/MM/yyyy'),null,
                                    item.TEN,item.SOBANAN||' </br> '||to_char(item.NGAYTUYENAN,'dd/MM/yyyy'),null,
                                    item.NGAYCHUYENVKS,item.CANBOID,item.DV_GUI_NHAN,item.NGUOI_NHAN_VKS,
                                    null, null); 
                            END LOOP;
                END IF;
         END LOOP;
      ---------- 
      OPEN curReturn FOR
        select tt.* from (   
            SELECT  ROW_NUMBER() OVER (ORDER BY a.NGAY_TAO desc) STT,COUNT(*) OVER () as CountAll,A.*
                FROM TABLE(v_table)A
         )tt ; 
END HS_DS_GIAO_HOSO_VKS;  


END PKG_STPT_SEARCH_ALL;

/
