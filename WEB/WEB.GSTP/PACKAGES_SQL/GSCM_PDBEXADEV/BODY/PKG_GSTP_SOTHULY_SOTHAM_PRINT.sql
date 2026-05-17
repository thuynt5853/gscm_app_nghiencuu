--------------------------------------------------------
--  DDL for Package Body PKG_GSTP_SOTHULY_SOTHAM_PRINT
--------------------------------------------------------

  CREATE OR REPLACE NONEDITIONABLE PACKAGE BODY "GSCM"."PKG_GSTP_SOTHULY_SOTHAM_PRINT" AS

PROCEDURE SO_HINHSU_SOTHAM
	(
		 in_TOAANID     IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU  IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn      OUT SYS_REFCURSOR
	) AS
        V_EXPORT_TEXT   CLOB;

		v_ARRAY T_HINHSU_SOTHAM;
		v_IDS T_ID;

	BEGIN	

		--TÒA ÁN CẤP CON
		v_IDS:=T_ID();
		IF (in_TOAANCAPCON='TRUE') THEN
			SELECT R_ID(ID) BULK COLLECT INTO v_IDS FROM DM_TOAAN WHERE CAPCHAID=in_TOAANID;
		END IF;
		v_IDS.EXTEND();
		v_IDS(v_IDS.COUNT):=R_ID(in_TOAANID); 

		SELECT R_HINHSU_SOTHAM(
			v_STT=>row_number() over (order by nvl(TL.ID,0)),
			v_THULYID=>nvl(TL.ID,0),
			v_VUANID=>nvl(TL.VUANID,0),
			v_TOAANID=>nvl(T2.TOAANID,0),
			v_TL_1=>NULL,
			v_HOTENBICAO_2=>NULL,
			v_THOIHANTAMGIAM_3=>NULL,
			v_CAOTRANG_4=>NULL,
			v_NGUOITHAMGIATOTUNG_5=>NULL,
			v_NGUOIBC_NGUOIBV_QLIHP_DS_6=>NULL,
			v_GQ_TRAHOSOCHOVKS_7=>NULL,
			v_GQ_TRAHOSOCHOVKS_8=>NULL,
			v_GQ_TA_XMTT_BSCC_9=>NULL,
			v_GQ_TA_DENGHI_BPBAOVE_10=>NULL,
			v_GQ_TDC_11=>NULL,
			v_GQ_DC_12=>NULL,
			v_GQ_CHUYENHS_VA_13=>NULL,
			v_GQ_TAPHUCHOIVA_14=>NULL,
			v_GQ_LYDO_15=>NULL,
			v_XX_NGUOITIENHANHTOTUNG_16=>NULL,
			v_XX_TAYCVKS_BXTLCC_17=>NULL,
			v_XX_BA_QDST_18=>NULL,
			v_XX_QDCUABA_QDST_19=>NULL,
			v_XX_KHOITOVATAIPHIENTOA_20=>NULL,
			v_XX_THIETHAI_21=>NULL,
			v_XX_ANLQDENBAOLUCGD_22=>NULL,
			v_XX_AD_ALD_ARG_23=>NULL,
			v_PTNTBICAO_Tremocoi_24=>NULL,
			v_PTNTBICAO_Bomelyhon_25=>NULL,
			v_PTNTBICAO_Trebohoc_26=>NULL,
			v_PTNTBICAO_Trelangthang_27=>NULL,
			v_PTNTBICAO_Coxuigiuc_28=>NULL,
			v_PTNTBIHAI_Tttl16tuoi_29=>NULL,
			v_PTNTBIHAI_Tttl18tuoi_30=>NULL,
			v_KC_31=>NULL,
			v_KN_32=>NULL,
			v_CHUYENHS_TA_PT_33=>NULL,
			v_QD_TA_PT_34=>NULL,
			v_APDUNGANLE_35=>NULL,
			v_GHICHU_36=>NULL,
            V_NGAYTHULY=>NULL,
            V_SOTHULY=>NULL
		)	
        BULK COLLECT INTO v_ARRAY
		FROM
            (SELECT TL.ID, TL.VUANID
             FROM AHS_SOTHAM_THULY TL 
		     WHERE NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY')
             GROUP BY TL.ID,TL.VUANID

             UNION
             SELECT TL.ID, TL.VUANID
             FROM AHS_SOTHAM_THULY TL 
		     WHERE NGAYTHULY < TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND (NOT EXISTS (SELECT  STQD.* 
                                                                                    FROM AHS_SOTHAM_QUYETDINH_VUAN STQD 
                                                                                        INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = STQD.QUYETDINHID AND DMQD.KET_THUC = 1 
                                                                                    WHERE TL.VUANID = STQD.VUANID)
                                                                        AND NOT EXISTS (SELECT BA.* 
                                                                                       FROM AHS_SOTHAM_BANAN BA 
                                                                                       WHERE TL.VUANID = BA.VUANID))

             GROUP BY TL.ID,TL.VUANID

             UNION
             SELECT TL.ID, TL.VUANID
             FROM AHS_SOTHAM_THULY TL 
		     WHERE NGAYTHULY < TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND ( EXISTS (SELECT  STQD.* 
                                                                                    FROM AHS_SOTHAM_QUYETDINH_VUAN STQD 
                                                                                        INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = STQD.QUYETDINHID AND DMQD.KET_THUC = 1 
                                                                                    WHERE TL.VUANID = STQD.VUANID AND STQD.NGAYQD BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY'))
                                                                        OR EXISTS (SELECT BA.* 
                                                                                       FROM AHS_SOTHAM_BANAN BA 
                                                                                       WHERE TL.VUANID = BA.VUANID AND BA.NGAYBANAN BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY')))

             GROUP BY TL.ID,TL.VUANID
             ) TL
			     INNER JOIN AHS_VUAN T2 ON T2.ID=TL.VUANID-->CHÚ Ý TRƯỜNG HỢP CHUYỂN ÁN
			     INNER JOIN TABLE(v_IDS) I ON I.v_ID=T2.TOAANID
            GROUP BY TL.ID, TL.VUANID, T2.TOAANID;

		PKG_GSTP_SOTHULY_HINHSU.FILL_HINHSU_SOTHAM(v_ARRAY);        




        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'<table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">');           
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <tr align="center" style="text-align: center;">
                <td colspan="1" rowspan="3" height="234" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>THỤ LÝ HỒ SƠ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>                
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>HỌ TÊN BỊ CÁO</b><br style="mso-data-placement:same-cell;" /><i>Năm sinh,nơi cư trú,  giới tính, quốc tịch, dân tộc, nghề nghiệp,<br style="mso-data-placement:same-cell;" /> Công chức, viên chức, đảng viên, tái phạm, tái phạm nguy hiểm, nghiện ma túy (nếu có)</i></td>                
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>THỜI HẠN TẠM GIAM</b><br style="mso-data-placement:same-cell;" /><i>(Nguyên nhân vi phạm nếu có)</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>CÁO TRẠNG</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm<br style="mso-data-placement:same-cell;" />Điều luật, Tội danh, hình phạt theo đề nghị của Kiểm sát viên tại phiên tòa</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>NGƯỜI THAM GIA TỐ TỤNG</b><br style="mso-data-placement:same-cell;" /><i>(Người bị hại, nguyên đơn, bị đơn dân sự, người có quyền lợi, nghĩa vụ liên quan, người đại diện hợp pháp của người bị hại)<br style="mso-data-placement:same-cell;" />Họ tên, năm sinh, nơi cư trú, giới tính</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>NGƯỜI BÀO CHỮA, NGƯỜI BẢO VỆ QUYỀN VÀ LỢI ÍCH HỢP PHÁP CHO ĐƯƠNG SỰ</b><br style="mso-data-placement:same-cell;" /><i>Họ tên, địa chỉ hoặc đơn vị hành nghề</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>CHUYỂN HỒ SƠ VỤ ÁN</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>TẠM ĐÌNH CHỈ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="5" rowspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>GIẢI QUYẾT</b></td>
                <td colspan="4" rowspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>XÉT XỬ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>PHÂN TÍCH ĐẶC ĐIỂM NHÂN THÂN CỦA BỊ CÁO ĐÃ XÉT XỬ LÀ NGƯỜI DƯỚI 18 TUỔI ĐÃ XÉT XỬ</b><br style="mso-data-placement:same-cell;" /><i>(Ghi rõ: mồ côi cha hoặc mẹ; bố mẹ ly hôn; bỏ học; lang thang; có người đủ 18 tuổi trở lên xúi giục).</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>HẬU QUẢ ĐỐI VỚI NGƯỜI BỊ HẠI DƯỚI 18 TUỔI</b><br style="mso-data-placement:same-cell;" /><i>(Ghi rõ: tử vong; bị nhiễm HIV/bị thương tích hoặc tổn hại sức khỏe; bị rối loạn tâm thần (tỷ lệ %); có thai)</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Mối quan hệ giữa bị cáo, bị hại</b><br style="mso-data-placement:same-cell;" /><i>(Người thân thích, quen biết)</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>ĐỊA BÀN PHẠM TỘI</b><br style="mso-data-placement:same-cell;" /><i>(Nông thôn, vùng núi, vùng sâu, vùng xa, hải đảo)</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>KHÁNG CÁO</b><br style="mso-data-placement:same-cell;" /><i>Ngày, tháng, năm</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>KHÁNG NGHỊ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>CHUYỂN HỒ SƠ CHO TÒA PHÚC THẨM</b><br style="mso-data-placement:same-cell;" /><i>Ngày, tháng, năm</i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>QUYẾT ĐỊNH CỦA TÒA ÁN CẤP PHÚC THẨM</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm<br style="mso-data-placement:same-cell;" />Tóm tắt phần quyết định </i></td>
                <td colspan="1" rowspan="3" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>GHI CHÚ</td>
            </tr>');

        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <tr align="center" style="text-align: center;">
                <td colspan="2" height="75" rowspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>TRẢ HỒ SƠ CHO VIỆN KIỂM SÁT</b></td>                
                <td colspan="1" rowspan="2" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>ĐÌNH CHỈ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>                
                <td colspan="1" rowspan="2" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>TÒA ÁN PHỤC HỒI VỤ ÁN</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" rowspan="2" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>LÝ DO</b></td>
                <td colspan="1" rowspan="2" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>NGƯỜI TIẾN HÀNH TỐ TỤNG</b><br style="mso-data-placement:same-cell;" /><i>(Hội đồng xét xử, Kiểm sát viên, Thư ký phiên tòa)<br style="mso-data-placement:same-cell;" />Ghi đầy đủ họ tên</i></td>
                <td colspan="1" rowspan="2" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>TÒA ÁN YÊU CẦU VKS BỔ SUNG TÀI LIỆU, CHỨNG CỨ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" rowspan="2" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" rowspan="2" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>QUYẾT ĐỊNH CỦA BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM</b><br style="mso-data-placement:same-cell;" /><i>Điều luật, Tội danh, Hình phạt, Hình phạt bổ sung<br style="mso-data-placement:same-cell;" />(Ngoài ra còn bao gồm: Miễn trách nhiệm hình sự, miễn hình phạt, giáo dục tại trường giáo dưỡng)</i></td>
            </tr>');

        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <tr align="center" style="text-align: center;">
                <td colspan="1" height="114" rowspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Số, ngày, tháng, năm</b></td>                
                <td colspan="1" rowspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>Kết quả trả hồ sơ<br style="mso-data-placement:same-cell;" />(Chấp nhận/không chấp nhận)</b></td>
            </tr>'); 

        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr align="center" style="text-align: center;">
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>1</i></td>                
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>2</i></td>                
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>3</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>4</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>5</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>6</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>7</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>8</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>9</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>10</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>11</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>12</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>13</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>14</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>15</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>16</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>17</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>18</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>19</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>20</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>21</i></td>  
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>22</i></td>   
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>23</i></td>   
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>24</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>25</i></td>   
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>26</i></td>     
            </tr>');

        FOR ITEM IN (SELECT * 
                     FROM TABLE(v_ARRAY)
                     ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY
                     )
        LOOP
            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                <tr align="center" style="text-align: center;">                     
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_TL_1||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_HOTENBICAO_2||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_THOIHANTAMGIAM_3||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_CAOTRANG_4||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_NGUOITHAMGIATOTUNG_5||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_NGUOIBC_NGUOIBV_QLIHP_DS_6||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_GQ_CHUYENHS_VA_13||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_GQ_TDC_11||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_GQ_TRAHOSOCHOVKS_7||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_GQ_TRAHOSOCHOVKS_8||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_GQ_DC_12||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_GQ_TAPHUCHOIVA_14||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_GQ_LYDO_15||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_XX_NGUOITIENHANHTOTUNG_16||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_XX_TAYCVKS_BXTLCC_17||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_XX_BA_QDST_18||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_XX_QDCUABA_QDST_19||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_PTNTBICAO_TREMOCOI_24||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"></td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"></td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"></td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_KC_31||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_KN_32||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_CHUYENHS_TA_PT_33||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_QD_TA_PT_34||'</td>
                    <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_GHICHU_36||'</td>
                </tr>');
        END LOOP;

            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr style="height: 0px;">
                <td style="width: 113px"></td>
                <td style="width: 189px"></td>
                <td style="width: 76px"></td>
                <td style="width: 189px"></td>
                <td style="width: 189px"></td>
                <td style="width: 151px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 189px"></td>
                <td style="width: 151px"></td>
                <td style="width: 76px"></td>
                <td style="width: 113px"></td>
                <td style="width: 189px"></td>
                <td style="width: 113px"></td>
                <td style="width: 113px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 189px"></td>
                <td style="width: 151px"></td>
            </tr>');

        V_EXPORT_TEXT := REPLACE(V_EXPORT_TEXT, CHR(10) , '<br style="mso-data-placement:same-cell;" />');
        V_EXPORT_TEXT := REPLACE(V_EXPORT_TEXT, CHR(13) , '<br style="mso-data-placement:same-cell;" />');

        OPEN curReturn FOR
            SELECT V_EXPORT_TEXT || '</table>' TEXT_REPORT FROM dual;  
                dbms_lob.freetemporary(V_EXPORT_TEXT);
	END;

PROCEDURE SO_DANSU_SOTHAM
	(
		 in_TOAANID     IN NUMBER,
		 in_TOAANCAPCON IN NVARCHAR2,
		 in_NGAYBATDAU  IN NVARCHAR2,
		 in_NGAYKETTHUC IN NVARCHAR2,
		 curReturn      OUT SYS_REFCURSOR
	) AS
        V_EXPORT_TEXT   CLOB;

		v_ARRAY T_DANSU_SOTHAM;
		v_IDS T_ID;       
	BEGIN	

		--TÒA ÁN CẤP CON
		v_IDS:=T_ID();
		IF (in_TOAANCAPCON='TRUE') THEN
			SELECT R_ID(ID) BULK COLLECT INTO v_IDS FROM DM_TOAAN WHERE CAPCHAID=in_TOAANID;
		END IF;
		v_IDS.EXTEND();
		v_IDS(v_IDS.COUNT):=R_ID(in_TOAANID);

    SELECT R_DANSU_SOTHAM(
			v_STT=>row_number() over (order by TL.ID),
			v_THULYID=>TL.ID,
			v_VUANID=>TL.DONID,
			v_TOAANID=>TL.TOAANID,
			v_QUANHEPHAPLUATID=>NULL,
			v_TL_1=>NULL,
			v_ND_NYC_2=>NULL,
			v_BD_NLQ_DS_3=>NULL,
			v_DKK_CQTC_4=>NULL,
			v_NGUOI_QLNVLQ_5=>NULL,
			v_NGUOIBV_QLIHP_DS_6=>NULL,
			v_QHPLKHITL_7=>NULL,
			v_ADBPKCTT_8=>NULL,
			v_CHUYENHS_VUVIEC_9=>NULL,
			v_TDC_10=>NULL,
			v_DC_11=>NULL,
			v_LYDO_12=>NULL,
			v_CONGNHAN_THOATHUAN_DS_13=>NULL,
			v_HDXX_VKS_TKPT_14=>NULL,
			v_BA_QDST_15=>NULL,
			v_QHPLMATAGQ_16=>NULL,
			v_TTND_BA_QD_TA_ST_17=>NULL,
			v_KQGQYC_HUYQDCABIET_18=>NULL,
			v_XETXULUUDONG_19=>NULL,
			v_APDUNGANLE_20=>NULL,
			v_GQ_TTRG_21=>NULL,
			v_COYEUTONUOCNGOAI_22=>NULL,
			v_VIECDS_23=>NULL,
			v_KC_24=>NULL,
			v_KN_25=>NULL,
			v_CHUYENHS_TA_PT_26=>NULL,
			v_QD_TA_PT_27=>NULL,
			v_GHICHU_28=>NULL,
            V_NGAYTHULY=>NULL,
            V_SOTHULY=>NULL,
            V_QUANHEPHAPLUAT_NAME=>TL.QUANHEPHAPLUAT_NAME,
            V_PT_RUTKINHNGHIEM=>NULL
		) 
		BULK COLLECT INTO v_ARRAY
        FROM (  SELECT TL.*
                FROM ADS_SOTHAM_THULY TL 
                    INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
                WHERE
                    NGAYTHULY BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY')

                UNION 
                SELECT TL.*
                FROM ADS_SOTHAM_THULY TL 
                    INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
                WHERE
                    NGAYTHULY < TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND 
                    (NOT EXISTS (SELECT  STQD.* FROM ADS_SOTHAM_QUYETDINH STQD 
                        INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = STQD.QUYETDINHID AND DMQD.KET_THUC = 1 WHERE TL.DONID = STQD.DONID)
                    AND NOT EXISTS (SELECT BA.* FROM ADS_SOTHAM_BANAN BA WHERE TL.DONID = BA.DONID))

                UNION 
                SELECT TL.*
                FROM ADS_SOTHAM_THULY TL 
                    INNER JOIN TABLE(v_IDS) I ON I.v_ID=TL.TOAANID
                WHERE
                    NGAYTHULY < TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND  
                    (EXISTS (SELECT  STQD.* FROM ADS_SOTHAM_QUYETDINH STQD 
                        INNER JOIN DM_QD_QUYETDINH DMQD ON DMQD.ID = STQD.QUYETDINHID AND DMQD.KET_THUC = 1 
                        WHERE TL.DONID = STQD.DONID AND STQD.NGAYQD BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY')
                        )
                    OR EXISTS (SELECT BA.* FROM ADS_SOTHAM_BANAN BA 
                               WHERE TL.DONID = BA.DONID AND BA.NGAYTUYENAN BETWEEN TO_DATE(in_NGAYBATDAU,'DD/MM/YYYY') AND TO_DATE(in_NGAYKETTHUC,'DD/MM/YYYY')))
            ) TL;

		PKG_GSTP_SOTHULY_SOTHAM.FILL_DANSU_SOTHAM(v_ARRAY);


        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'<table cellpadding="0" cellspacing="1" style="font-family: times New Roman; font-size: 11pt; text-align: center;">');           
        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
             <tr align="center" style="text-align: center;">
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>THỤ LÝ </b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>                
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>NGUYÊN ĐƠN HOẶC NGƯỜI YÊU CẦU</b><br style="mso-data-placement:same-cell;" /><i>Họ tên, năm sinh, địa chỉ</i></td>                
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>BỊ ĐƠN HOẶC NGƯỜI LIÊN QUAN TRONG VIỆC DÂN SỰ</b><br style="mso-data-placement:same-cell;" /><i>Họ tên, năm sinh, địa chỉ</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>ĐƠN KHỞI KIỆN CỦA CƠ QUAN, TỔ CHỨC</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>NGƯỜI CÓ QUYỀN LỢI, NGHĨA VỤ LIÊN QUAN</b><br style="mso-data-placement:same-cell;" /><i>Họ tên, năm sinh, địa chỉ</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>NGƯỜI BẢO VỆ QUYỀN, LỢI ÍCH HỢP PHÁP CHO ĐƯƠNG SỰ</b><br style="mso-data-placement:same-cell;" /><i>Họ tên, địa chỉ hoặc đơn vị hành nghề</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>QUAN HỆ PHÁP LUẬT KHI THỤ LÝ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>ÁP DỤNG BIỆN PHÁP KHẨN CẤP TẠM THỜI</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>CHUYỂN HỒ SƠ VỤ VIỆC</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm và nơi nhận</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>TẠM ĐÌNH CHỈ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>ĐÌNH CHỈ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>LÝ DO</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>CÔNG NHẬN SỰ THỎA THUẬN CỦA ĐƯƠNG SỰ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>HỘI ĐỒNG XÉT XỬ, ĐẠI DIỆN VIỆN KIỂM SÁT, THƯ KÝ PHIÊN TÒA</b><br style="mso-data-placement:same-cell;" /><i>Ghi đầy đủ họ tên</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>BẢN ÁN, QUYẾT ĐỊNH SƠ THẨM</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>QUAN HỆ PHÁP LUẬT TOÀ ÁN GIẢI QUYẾT</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>TÓM TẮT NỘI DUNG BẢN ÁN, QUYẾT ĐỊNH CỦA TOÀ ÁN CẤP SƠ THẨM</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>KẾT QUẢ GIẢI QUYẾT YÊU CẦU HỦY QUYẾT ĐỊNH CÁ BIỆT</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm, cơ quan ban hành (nếu có)</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>ÁP DỤNG ÁN LỆ</b><br style="mso-data-placement:same-cell;" /><i>Số án lệ</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>GIẢI QUYẾT  THEO THỦ TỤC RÚT GỌN</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>TÒA ÁN TỔ CHỨC PHIÊN TÒA RÚT KINH NGHIỆM</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>CÓ YẾU TỐ NƯỚC NGOÀI</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>VIỆC DÂN SỰ</b></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>KHÁNG CÁO</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>KHÁNG NGHỊ</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>CHUYỂN HỒ SƠ CHO TÒA ÁN CẤP PHÚC THẨM</b><br style="mso-data-placement:same-cell;" /><i>Ngày, tháng, năm</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>QUYẾT ĐỊNH CỦA TÒA ÁN CẤP PHÚC THẨM</b><br style="mso-data-placement:same-cell;" /><i>Số, ngày, tháng, năm;<br style="mso-data-placement:same-cell;" />Tóm tắt phần quyết định</i></td>
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><b>GHI CHÚ</b></td>
            </tr>');

        DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr align="center" style="text-align: center;">
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>1</i></td>                
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>2</i></td>                
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>3</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>4</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>5</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>6</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>7</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>8</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>9</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>10</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>11</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>12</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>13</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>14</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>15</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>16</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>17</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>18</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>19</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>20</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>21</i></td>  
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>22</i></td>   
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>23</i></td>   
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>24</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>25</i></td>   
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>26</i></td>    
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>27</i></td>   
                <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;"><i>28</i></td>    
            </tr>');

            FOR ITEM IN (SELECT PA.* 
                         FROM TABLE(v_ARRAY) PA 
                         ORDER by EXTRACT(YEAR FROM  V_NGAYTHULY),to_number(REGEXP_REPLACE(V_SOTHULY, '[^0-9]')),V_NGAYTHULY
                         )
            LOOP
                DBMS_LOB.APPEND(V_EXPORT_TEXT,'
                    <tr align="center" style="text-align: center;">                     
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_TL_1||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_ND_NYC_2||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_BD_NLQ_DS_3||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_DKK_CQTC_4||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_NGUOI_QLNVLQ_5||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_NGUOIBV_QLIHP_DS_6||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_QHPLKHITL_7||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_ADBPKCTT_8||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_CHUYENHS_VUVIEC_9||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_TDC_10||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_DC_11||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_LYDO_12||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_CONGNHAN_THOATHUAN_DS_13||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_HDXX_VKS_TKPT_14||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_BA_QDST_15||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_QHPLMATAGQ_16||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_TTND_BA_QD_TA_ST_17||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_KQGQYC_HUYQDCABIET_18||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_APDUNGANLE_20||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_GQ_TTRG_21||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.V_PT_RUTKINHNGHIEM||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_COYEUTONUOCNGOAI_22||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_VIECDS_23||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_KC_24||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_KN_25||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_CHUYENHS_TA_PT_26||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_QD_TA_PT_27||'</td>
                        <td colspan="1" style="text-align: center; vertical-align: middle; font-size: 11pt; border: 0.1pt solid Black;">'||ITEM.v_GHICHU_28||'</td>
                    </tr>');
            END LOOP;

--            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
--            <tr style="height: 0px;">
--                <td style="width: 114px"></td>
--                <td style="width: 189px"></td>
--                <td style="width: 189px"></td>
--                <td style="width: 151px"></td>
--                <td style="width: 151px"></td>
--                <td style="width: 151px"></td>
--                <td style="width: 114px"></td>
--                <td style="width: 76px"></td>
--                <td style="width: 114px"></td>
--                <td style="width: 76px"></td>
--                <td style="width: 76px"></td>
--                <td style="width: 151px"></td>
--                <td style="width: 76px"></td>
--                <td style="width: 151px"></td>
--                <td style="width: 114px"></td>
--                <td style="width: 151px"></td>
--                <td style="width: 227px"></td>
--                <td style="width: 114px"></td>
--                <td style="width: 38px"></td>
--                <td style="width: 76px"></td>
--                <td style="width: 38px"></td>
--                <td style="width: 38px"></td>
--                <td style="width: 38px"></td>
--                <td style="width: 38px"></td>
--                <td style="width: 76px"></td>
--                <td style="width: 114px"></td>
--                <td style="width: 151px"></td>
--                <td style="width: 76px"></td>
--            </tr>');

            DBMS_LOB.APPEND(V_EXPORT_TEXT,'
            <tr style="height: 0px;">
                <td style="width: 114px"></td>
                <td style="width: 189px"></td>
                <td style="width: 189px"></td>
                <td style="width: 151px"></td>
                <td style="width: 151px"></td>
                <td style="width: 151px"></td>
                <td style="width: 114px"></td>
                <td style="width: 76px"></td>
                <td style="width: 114px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 151px"></td>
                <td style="width: 76px"></td>
                <td style="width: 151px"></td>
                <td style="width: 114px"></td>
                <td style="width: 151px"></td>
                <td style="width: 227px"></td>
                <td style="width: 114px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 76px"></td>
                <td style="width: 114px"></td>
                <td style="width: 151px"></td>
                <td style="width: 76px"></td>
            </tr>');

        V_EXPORT_TEXT := REPLACE(V_EXPORT_TEXT, CHR(10) , '<br style="mso-data-placement:same-cell;" />');
        V_EXPORT_TEXT := REPLACE(V_EXPORT_TEXT, CHR(13) , '<br style="mso-data-placement:same-cell;" />');

        OPEN curReturn FOR
            SELECT V_EXPORT_TEXT || '</table>' TEXT_REPORT FROM dual;  
                dbms_lob.freetemporary(V_EXPORT_TEXT);

	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);
	END;

PROCEDURE SO_HONNHAN_SOTHAM
    (
     in_TOAANID IN NUMBER,
     in_TOAANCAPCON IN NVARCHAR2,
     in_NGAYBATDAU IN NVARCHAR2,
     in_NGAYKETTHUC IN NVARCHAR2,
     curReturn OUT SYS_REFCURSOR
    ) AS
        V_EXPORT_TEXT           CLOB;

    BEGIN
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);

        OPEN curReturn FOR
            SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
                dbms_lob.freetemporary(V_EXPORT_TEXT);

	EXCEPTION 
		WHEN OTHERS THEN 
			RAISE_APPLICATION_ERROR(-20000, sqlerrm);            
    END;

PROCEDURE SO_KINHTE_SOTHAM
    (
     in_TOAANID IN NUMBER,
     in_TOAANCAPCON IN NVARCHAR2,
     in_NGAYBATDAU IN NVARCHAR2,
     in_NGAYKETTHUC IN NVARCHAR2,
     curReturn OUT SYS_REFCURSOR
    ) AS
        V_EXPORT_TEXT           CLOB;

    BEGIN
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);

        OPEN curReturn FOR
            SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
                dbms_lob.freetemporary(V_EXPORT_TEXT);

    EXCEPTION 
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20000, sqlerrm);
    END;

PROCEDURE SO_LAODONG_SOTHAM
    (
     in_TOAANID IN NUMBER,
     in_TOAANCAPCON IN NVARCHAR2,
     in_NGAYBATDAU IN NVARCHAR2,
     in_NGAYKETTHUC IN NVARCHAR2,
     curReturn OUT SYS_REFCURSOR
    ) AS
        V_EXPORT_TEXT           CLOB;

    BEGIN
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);

        OPEN curReturn FOR
            SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
                dbms_lob.freetemporary(V_EXPORT_TEXT);

    EXCEPTION 
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20000, sqlerrm);
    END;

PROCEDURE SO_HANHCHINH_SOTHAM
    (
     in_TOAANID IN NUMBER,
     in_TOAANCAPCON IN NVARCHAR2,
     in_NGAYBATDAU IN NVARCHAR2,
     in_NGAYKETTHUC IN NVARCHAR2,
     curReturn OUT SYS_REFCURSOR
    ) AS
        V_EXPORT_TEXT           CLOB;

    BEGIN
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);

        OPEN curReturn FOR
            SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
                dbms_lob.freetemporary(V_EXPORT_TEXT);

    EXCEPTION 
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20000, sqlerrm);
    END;

PROCEDURE SO_PHASAN_SOTHAM
    (
     in_TOAANID IN NUMBER,
     in_TOAANCAPCON IN NVARCHAR2,
     in_NGAYBATDAU IN NVARCHAR2,
     in_NGAYKETTHUC IN NVARCHAR2,
     curReturn OUT SYS_REFCURSOR
    ) AS
        V_EXPORT_TEXT           CLOB;

    BEGIN
        DBMS_LOB.CREATETEMPORARY(V_EXPORT_TEXT,true);

        OPEN curReturn FOR
            SELECT V_EXPORT_TEXT TEXT_REPORT FROM dual;  
                dbms_lob.freetemporary(V_EXPORT_TEXT);

    EXCEPTION 
    WHEN OTHERS THEN 
        RAISE_APPLICATION_ERROR(-20000, sqlerrm);
    END;

END PKG_GSTP_SOTHULY_SOTHAM_PRINT;

/
