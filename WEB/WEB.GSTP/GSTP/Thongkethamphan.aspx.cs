using BL.GSTP;
using BL.GSTP.GSTP;
using DAL.GSTP;
using DevExpress.Utils;
using DevExpress.Web;
using DevExpress.XtraCharts;
using DevExpress.XtraCharts.Web;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP
{
    public partial class Thongkethamphan : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
            if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
            string strMaHeThong = Session["MaHeThong"] + "";
            if (strMaHeThong == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Launcher.aspx");
            if (!IsPostBack)
            {
                decimal IDHethong = Session["MaHeThong"] + "" == "" ? 0 : Convert.ToDecimal(Session["MaHeThong"] + "");
                lstUserName.Text = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();
                DataTable lstHT;
                string strSessionKeyHT = "HETHONGGETBY_" + strUserID;
                decimal USERID = Convert.ToDecimal(strUserID);
                if (Session[strSessionKeyHT] == null)
                    lstHT = oBL.QT_HETHONG_GETBYUSER(USERID);
                else
                    lstHT = (DataTable)Session[strSessionKeyHT];
                liGSTP.Visible = liQLA.Visible = liTDKT.Visible = liTCCB.Visible = liQTHT.Visible = false;
                if (lstHT.Rows.Count == 1) lbtChonPhanHe.Visible = false;
                if (lstHT.Rows.Count > 0)
                {
                    foreach (DataRow r in lstHT.Rows)
                    {
                        switch (r["MA"] + "")
                        {
                            case "GSTP":
                                liGSTP.Visible = true;
                                break;
                            case "QLA":
                                liQLA.Visible = true;
                                break;
                            case "GDT":
                                liGDT.Visible = true;
                                break;
                            case "TDKT":
                                liTDKT.Visible = true;
                                break;
                            case "TCCB":
                                liTCCB.Visible = true;
                                break;
                            case "QTHT":
                                liQTHT.Visible = true;
                                break;
                        }
                    }
                }
                QT_HETHONG oHT = dt.QT_HETHONG.Where(x => x.ID == IDHethong).FirstOrDefault();
                decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
                string TenToaAn = "", Ma_Ten_ToaAn = "";
                DM_TOAAN otToaAN = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
                if (otToaAN != null)
                {
                    TenToaAn = otToaAN.TEN + "";
                    Ma_Ten_ToaAn = otToaAN.MA_TEN + "";
                }
                lstHethong.Text = oHT.TEN.ToString().ToUpper() + "&nbsp;&nbsp; -&nbsp;&nbsp; " + Ma_Ten_ToaAn.ToUpper();
                if (!TenToaAn.ToLower().Contains("tối cao") & !TenToaAn.ToLower().Contains("cấp cao") && !TenToaAn.ToLower().Contains("quân sự"))
                {
                    ltrSoLieu.Text = TenToaAn.Replace("Tòa án nhân dân ", "").Replace("tỉnh ", "").Replace("thành phố ", "").Replace("quận", "Quận").Replace("huyện", "Huyện").Replace("thị xã", "Thị xã");
                }
                if (Session[ENUM_LOAIAN.AN_GSTP] + "" != "")
                {
                    decimal ThamPhanID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP] + "");
                    DM_CANBO tp = dt.DM_CANBO.Where(x => x.ID == ThamPhanID).FirstOrDefault();
                    if (tp != null)
                    {
                        ltrTenTP.Text = tp.HOTEN;
                        DM_DATAITEM ChucDanh = dt.DM_DATAITEM.Where(x => x.ID == tp.CHUCDANHID).FirstOrDefault();
                        if (ChucDanh != null)
                        {
                            ltrChucDanh.Text = ChucDanh.TEN;
                        }
                        ltrToaAn.Text = TenToaAn.Replace("Tòa án nhân dân", "TAND");
                        ltrQuyetDinhBoNhiem.Text = tp.QDBONHIEM + "" == "" ? "" : "Số " + tp.QDBONHIEM + "," + tp.NGAYBONHIEM + "" == "" ? "" : "Ngày " + ((DateTime)tp.NGAYBONHIEM).ToString("dd/MM/yyyy");
                    }
                    else
                    {
                        ltrTenTP.Text = "Chưa có thẩm phán!";
                        ltrChucDanh.Text = ltrToaAn.Text = ltrQuyetDinhBoNhiem.Text = "";
                    }
                }
                else
                {
                    ltrTenTP.Text = "Chưa có thẩm phán!";
                    ltrChucDanh.Text = ltrToaAn.Text = ltrQuyetDinhBoNhiem.Text = "";
                }
                ThongKe_TP_Nam_HienTai_By_DonVi(DonViLoginID);
                ThongKe_TP_3Nam_3TieuChi(DonViLoginID);
                hddPageIndex.Value = "1";
                LoadDSThamPhan();
            }
        }
        private void LoadDSThamPhan()
        {
            int PageSize = dgList_ThamPhan_DonVi.PageSize, PageIndex = Convert.ToInt32(hddPageIndex.Value);
            decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
            OracleParameter[] prm = new OracleParameter[]
            {
                new OracleParameter("in_DonVi",DonViLoginID),
                new OracleParameter("in_PageSize",PageSize),
                new OracleParameter("in_PageIndex",PageIndex),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("DM_CANBO_GETTP_BYDONVI", prm);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                int Total = Convert.ToInt32(tbl.Rows[0]["Total"] + "");
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                dgList_ThamPhan_DonVi.CurrentPageIndex = 0;
                dgList_ThamPhan_DonVi.DataSource = tbl;
                dgList_ThamPhan_DonVi.DataBind();
            }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadDSThamPhan();
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            LoadDSThamPhan();
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadDSThamPhan();
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadDSThamPhan();
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            LoadDSThamPhan();
        }
        #endregion
        private void ThongKe_TP_Nam_HienTai_By_DonVi(decimal DonViID)
        {
            GSTP_BL bl = new GSTP_BL();
            DataTable tblTKTP = bl.THONGKE_TP_HOMEPAGE(DonViID);
            if (tblTKTP != null && tblTKTP.Rows.Count > 0)
            {
                foreach (DataRow row in tblTKTP.Rows)
                {
                    decimal stt = row["v_STT"] + "" == "" ? 0 : Convert.ToDecimal(row["v_STT"] + "")
                        , TP_Nam = row["v_NAM"] + "" == "" ? 0 : Convert.ToDecimal(row["v_NAM"] + "")
                        , Tong_Nam = row["v_TONG_NAM"] + "" == "" ? 0 : Convert.ToDecimal(row["v_TONG_NAM"] + "")
                        , TyLe_Nam = row["v_TYLENAM"] + "" == "" ? 0 : Convert.ToDecimal(row["v_TYLENAM"] + "")
                        , Point2 = Tong_Nam - TP_Nam
                        , length_Num = Point2.ToString().Length
                        , length_Per = TyLe_Nam.ToString().Length;
                    string strTyLe_Nam = TyLe_Nam.ToString("#,0.#", cul) + "%", strSpan_Num = "", strSpan_Per = "";
                    if (TP_Nam == 0)
                    {
                        TP_Nam = 0;
                        Point2 = 1;
                    }

                    if (length_Num == 1)
                    {
                        strSpan_Num = "<span class=\"Legend_Num1\">" + TP_Nam + "</span>";
                    }
                    else if (length_Num == 2)
                    {
                        strSpan_Num = "<span class=\"Legend_Num2\">" + TP_Nam + "</span>";
                    }
                    else if (length_Num == 3)
                    {
                        strSpan_Num = "<span class=\"Legend_Num3\">" + TP_Nam + "</span>";
                    }
                    else if (length_Num == 4)
                    {
                        strSpan_Num = "<span class=\"Legend_Num4\">" + TP_Nam + "</span>";
                    }
                    else if (length_Num == 5)
                    {
                        strSpan_Num = "<span class=\"Legend_Num5\">" + TP_Nam + "</span>";
                    }
                    else if (length_Num == 6)
                    {
                        strSpan_Num = "<span class=\"Legend_Num6\">" + TP_Nam + "</span>";
                    }
                    //
                    if (length_Per == 1)
                    {
                        strSpan_Per = "<span class=\"Legend_Per1\">" + strTyLe_Nam + "</span>";
                    }
                    else if (length_Per == 2)
                    {
                        strSpan_Per = "<span class=\"Legend_Per2\">" + strTyLe_Nam + "</span>";
                    }
                    else if (length_Per == 3)
                    {
                        strSpan_Per = "<span class=\"Legend_Per3\">" + strTyLe_Nam + "</span>";
                    }
                    else if (length_Per == 4)
                    {
                        strSpan_Per = "<span class=\"Legend_Per4\">" + strTyLe_Nam + "</span>";
                    }
                    else if (length_Per == 5)
                    {
                        strSpan_Per = "<span class=\"Legend_Per5\">" + strTyLe_Nam + "</span>";
                    }
                    else if (length_Per == 6)
                    {
                        strSpan_Per = "<span class=\"Legend_Per6\">" + strTyLe_Nam + "</span>";
                    }
                    if (stt == 1)// Đang công tác
                    {
                        webchart_TP_DangCongTac.Series[0].Points.Add(new SeriesPoint("ĐANG CÔNG TÁC", TP_Nam));
                        webchart_TP_DangCongTac.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_DangCongTac.Series[0].Points[0].Color = Color.FromArgb(254, 79, 51);
                        webchart_TP_DangCongTac.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_dangct_num.InnerHtml = strSpan_Num;
                        div_tp_dangct_per.InnerHtml = strSpan_Per;
                    }
                    else if (stt == 2)// Bổ nhiệm mới
                    {
                        webchart_TP_BoNhiemMoi.Series[0].Points.Add(new SeriesPoint("BỔ NHIỆM MỚI", TP_Nam));
                        webchart_TP_BoNhiemMoi.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_BoNhiemMoi.Series[0].Points[0].Color = Color.FromArgb(84, 242, 252);
                        webchart_TP_BoNhiemMoi.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_bonhiemmoi_num.InnerHtml = strSpan_Num;
                        div_tp_bonhiemmoi_per.InnerHtml = strSpan_Per;
                    }
                    else if (stt == 3)// Sắp hết nhiệm kỳ
                    {
                        webchart_TP_SapHetNhiemKy.Series[0].Points.Add(new SeriesPoint("SẮP HẾT NHIỆM KỲ", TP_Nam));
                        webchart_TP_SapHetNhiemKy.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_SapHetNhiemKy.Series[0].Points[0].Color = Color.FromArgb(245, 174, 40);
                        webchart_TP_SapHetNhiemKy.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_saphetnhiemky_num.InnerHtml = strSpan_Num;
                        div_tp_saphetnhiemky_per.InnerHtml = strSpan_Per;
                    }
                    else if (stt == 4)// Bị dừng xét xử
                    {
                        webchart_TP_DungXetXu.Series[0].Points.Add(new SeriesPoint("BỊ DỪNG XÉT XỬ", TP_Nam));
                        webchart_TP_DungXetXu.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_DungXetXu.Series[0].Points[0].Color = Color.FromArgb(64, 72, 139);
                        webchart_TP_DungXetXu.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_Dungxetxu_num.InnerHtml = strSpan_Num;
                        div_tp_Dungxetxu_per.InnerHtml = strSpan_Per;
                    }
                    else if (stt == 5)// Bị khiếu nại, tố cáo
                    {
                        webchart_TP_KhieuNaiToCao.Series[0].Points.Add(new SeriesPoint("KHIẾU NẠI, TỐ CÁO", TP_Nam));
                        webchart_TP_KhieuNaiToCao.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_KhieuNaiToCao.Series[0].Points[0].Color = Color.FromArgb(117, 55, 172);
                        webchart_TP_KhieuNaiToCao.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_khieunaitocao_num.InnerHtml = strSpan_Num;
                        div_tp_khieunaitocao_per.InnerHtml = strSpan_Per;
                    }
                    else if (stt == 6)// Có án áp dụng biện pháp tạm thời
                    {
                        webchart_TP_BPTT.Series[0].Points.Add(new SeriesPoint("CÓ ÁP DỤNG BPTT", TP_Nam));
                        webchart_TP_BPTT.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_BPTT.Series[0].Points[0].Color = Color.FromArgb(204, 204, 102);
                        webchart_TP_BPTT.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_bptt_num.InnerHtml = strSpan_Num;
                        div_tp_bptt_per.InnerHtml = strSpan_Per;
                    }
                    else if (stt == 7)// Có án bị hủy
                    {
                        webchart_TP_Huy.Series[0].Points.Add(new SeriesPoint("CÓ ÁN HỦY", TP_Nam));
                        webchart_TP_Huy.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_Huy.Series[0].Points[0].Color = Color.FromArgb(124, 102, 80);
                        webchart_TP_Huy.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_huy_num.InnerHtml = strSpan_Num;
                        div_tp_huy_per.InnerHtml = strSpan_Per;
                    }
                    else if (stt == 8)// Có án bị sửa
                    {
                        webchart_TP_Sua.Series[0].Points.Add(new SeriesPoint("CÓ ÁN SỬA", TP_Nam));
                        webchart_TP_Sua.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_Sua.Series[0].Points[0].Color = Color.FromArgb(255, 102, 102);
                        webchart_TP_Sua.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_sua_num.InnerHtml = strSpan_Num;
                        div_tp_sua_per.InnerHtml = strSpan_Per;
                    }
                    else if (stt == 9)// Có án quá hạn
                    {
                        webchart_TP_QuaHan.Series[0].Points.Add(new SeriesPoint("CÓ ÁN QUÁ HẠN", TP_Nam));
                        webchart_TP_QuaHan.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_QuaHan.Series[0].Points[0].Color = Color.FromArgb(2, 123, 118);
                        webchart_TP_QuaHan.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_quahan_num.InnerHtml = strSpan_Num;
                        div_tp_quahan_per.InnerHtml = strSpan_Per;
                    }
                    else if (stt == 10)// Có án treo
                    {
                        webchart_TP_Treo.Series[0].Points.Add(new SeriesPoint("CÓ ÁN TREO", TP_Nam));
                        webchart_TP_Treo.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_Treo.Series[0].Points[0].Color = Color.FromArgb(250, 133, 38);
                        webchart_TP_Treo.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_treo_num.InnerHtml = strSpan_Num;
                        div_tp_treo_per.InnerHtml = strSpan_Per;
                    }
                    else if (stt == 11)// Có án bị tạm đình chỉ
                    {
                        webchart_TP_TDC.Series[0].Points.Add(new SeriesPoint("CÓ ÁN TẠM ĐÌNH CHỈ", TP_Nam));
                        webchart_TP_TDC.Series[0].Points.Add(new SeriesPoint("Còn lại", Point2));
                        webchart_TP_TDC.Series[0].Points[0].Color = Color.FromArgb(153, 102, 102);
                        webchart_TP_TDC.Series[0].Points[1].Color = Color.FromArgb(166, 182, 202);// màu (xám)
                        div_tp_tdc_num.InnerHtml = strSpan_Num;
                        div_tp_tdc_per.InnerHtml = strSpan_Per;
                    }
                }
            }
        }
        private void ThongKe_TP_3Nam_3TieuChi(decimal DonViID)
        {
            // 3 tiêu chí: Đang công tác, Sắp hết nhiệm kỳ, Bổ nhiệm mới
            // 3 năm: năm hiện tại(2019) và 2 năm trước năm hiện tại (2018,2017)
            // v_ARRAY.v_NAM : Lưu năm hiện tại 
            // v_ARRAY.v_THANG : Lưu trước năm hiện tại 1 năm
            // v_ARRAY.v_TONG_NAM : Lưu trước năm hiện tại 2 năm
            // v_ARRAY.v_TONG_THANG : Lưu số biến động(chỉ trong tiêu chí đang công tác)
            // v_ARRAY.v_TYLENAM : Lưu Tỷ lệ biến động(chỉ trong tiêu chí đang công tác)
            string strYearNow = DateTime.Now.Year.ToString()
                , strYearPast1 = (DateTime.Now.Year - 1).ToString()
                , strYearPast2 = (DateTime.Now.Year - 2).ToString();
            GSTP_BL bl = new GSTP_BL();
            DataTable tblTKTP = bl.ThongKe_TP_3Nam_3TieuChi(DonViID);
            if (tblTKTP != null && tblTKTP.Rows.Count > 0)
            {
                foreach (DataRow row in tblTKTP.Rows)
                {
                    double stt = row["v_STT"] + "" == "" ? 0 : Convert.ToDouble(row["v_STT"] + "")
                        , ValueNow = row["v_NAM"] + "" == "" ? 0 : Convert.ToDouble(row["v_NAM"] + "")
                        , ValuePast1 = row["v_THANG"] + "" == "" ? 0 : Convert.ToDouble(row["v_THANG"] + "")
                        , ValuePast2 = row["v_TONG_NAM"] + "" == "" ? 0 : Convert.ToDouble(row["v_TONG_NAM"] + "");

                    if (stt == 1)//Đang công tác
                    {
                        double BienDong = row["v_TONG_THANG"] + "" == "" ? 0 : Convert.ToDouble(row["v_TONG_THANG"] + "")
                            , TyLeBienDong = row["v_TYLENAM"] + "" == "" ? 0 : Convert.ToDouble(row["v_TYLENAM"] + "");
                        ltrDangcongtac.Text = ValueNow.ToString();
                        if (BienDong < 0)
                        {
                            ltrTangGiam.Text = "Giảm";
                            ltrBienDong.Text = (BienDong * (-1)).ToString();
                            ltrPerTyLeBienDong.Text = (TyLeBienDong * (-1)).ToString() + "%";
                        }
                        else
                        {
                            ltrTangGiam.Text = "Tăng";
                            ltrBienDong.Text = BienDong.ToString();
                            ltrPerTyLeBienDong.Text = TyLeBienDong.ToString() + "%";
                        }

                        SeriesPoint point1 = new SeriesPoint();
                        point1.Argument = strYearPast2;
                        point1.Values = new Double[] { ValuePast2 };
                        point1.Color = Color.FromArgb(228, 57, 60);
                        WebChart_ThamPhan.Series[0].Points.Add(point1);

                        SeriesPoint point2 = new SeriesPoint();
                        point2.Argument = strYearPast1;
                        point2.Values = new Double[] { ValuePast1 };
                        point2.Color = Color.FromArgb(228, 57, 60);
                        WebChart_ThamPhan.Series[0].Points.Add(point2);

                        SeriesPoint point3 = new SeriesPoint();
                        point3.Argument = strYearNow;
                        point3.Values = new Double[] { ValueNow };
                        point3.Color = Color.FromArgb(228, 57, 60);
                        WebChart_ThamPhan.Series[0].Points.Add(point3);
                    }
                    else if (stt == 2)// Sắp hết nhiệm kỳ
                    {
                        //ValueNow = 120; ValuePast1 = 90; ValuePast2 = 60;
                        SeriesPoint point1 = new SeriesPoint();
                        point1.Argument = strYearPast2;
                        point1.Values = new Double[] { ValuePast2 };
                        point1.Color = Color.FromArgb(16, 129, 156);
                        WebChart_ThamPhan.Series[1].Points.Add(point1);

                        SeriesPoint point2 = new SeriesPoint();
                        point2.Argument = strYearPast1;
                        point2.Values = new Double[] { ValuePast1 };
                        point2.Color = Color.FromArgb(16, 129, 156);
                        WebChart_ThamPhan.Series[1].Points.Add(point2);

                        SeriesPoint point3 = new SeriesPoint();
                        point3.Argument = strYearNow;
                        point3.Values = new Double[] { ValueNow };
                        point3.Color = Color.FromArgb(16, 129, 156);
                        WebChart_ThamPhan.Series[1].Points.Add(point3);
                    }
                    else if (stt == 3) // Bổ nhiệm mới
                    {
                        //ValueNow = 100; ValuePast1 = 80; ValuePast2 = 70;
                        SeriesPoint point1 = new SeriesPoint();
                        point1.Argument = strYearPast2;
                        point1.Values = new Double[] { ValuePast2 };
                        point1.Color = Color.FromArgb(64, 72, 139);
                        WebChart_ThamPhan.Series[2].Points.Add(point1);

                        SeriesPoint point2 = new SeriesPoint();
                        point2.Argument = strYearPast1;
                        point2.Values = new Double[] { ValuePast1 };
                        point2.Color = Color.FromArgb(64, 72, 139);
                        WebChart_ThamPhan.Series[2].Points.Add(point2);

                        SeriesPoint point3 = new SeriesPoint();
                        point3.Argument = strYearNow;
                        point3.Values = new Double[] { ValueNow };
                        point3.Color = Color.FromArgb(64, 72, 139);
                        WebChart_ThamPhan.Series[2].Points.Add(point3);
                    }
                }
            }
        }
        protected void cmd_MenuLeft_Home_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Danhsachtonghop.aspx");
        }
        protected void cmd_MenuLeft_DanhGiaThamPhan_Click(object sender, EventArgs e)
        {
            Session["MaChuongTrinh"] = "GSTP";
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Thongtintonghop.aspx");
        }
        protected void cmd_MenuLeft_ThongKe_Click(object sender, EventArgs e)
        {
            Session["MaChuongTrinh"] = "GSTP_BCTK";
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void cmd_MenuLeft_HDSD_Click(object sender, EventArgs e)
        {
            //Session["MaChuongTrinh"] = "GSTP_HDSD";
            //Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            Session["MaChuongTrinh"] = "HDSD_APP";
            Response.Redirect(Cls_Comon.GetRootURL() + "/HDSD/HDSD.aspx");
        }
        protected void cmd_TraCuu_Click(object sender, EventArgs e)
        {
            decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
            DM_CANBO_BL bl = new DM_CANBO_BL();
            string Ten = txtSearch.Text.Trim();
            DataTable tbl = bl.DM_CANBO_GET_THAMPHAN_TEN_DV(Ten, DonViLoginID, ENUM_DANHMUC.CHUCDANH);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                ltrTenTP.Text = tbl.Rows[0]["HOTEN"].ToString();
                ltrChucDanh.Text = tbl.Rows[0]["CHUCDANH"].ToString();
                ltrToaAn.Text = tbl.Rows[0]["TENTOAAN"].ToString();
                ltrQuyetDinhBoNhiem.Text = tbl.Rows[0]["QDBONHIEM"].ToString();
                Session[ENUM_LOAIAN.AN_GSTP] = tbl.Rows[0]["ID"].ToString();
                Session["MaChuongTrinh"] = ENUM_LOAIAN.AN_GSTP;
            }
            else
            {
                ltrTenTP.Text = "Chưa có thẩm phán!";
                ltrChucDanh.Text = ltrToaAn.Text = ltrQuyetDinhBoNhiem.Text = "";
            }
        }
        protected void cmd_DanhSach_Click(object sender, EventArgs e)
        {
            Session["MaChuongTrinh"] = null;
            Session["HSC"] = "1";
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Danhsach.aspx");
        }
        protected void lbtChonPhanHe_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/Launcher.aspx");
        }
        protected void btnGSTP_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "GSTP").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnQLA_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "QLA").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnGDT_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "GDT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnTDKT_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "TDKT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnTCCB_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "TCCB").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnQTHT_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "QTHT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void lkSignout_Click(object sender, EventArgs e)
        {
            int so = int.Parse(Application.Get("OnlineNow").ToString());
            if (so > 0) so--;
            else
                so = 0;
            Application.Set("OnlineNow", so);
            // Xóa file js khi hết phiên Logout
            string strFileName_js = "mapdata_" + Session[ENUM_SESSION.SESSION_DONVIID] + ".js";
            string path_js = Server.MapPath("~/GSTP/") + strFileName_js;
            FileInfo oF_js = new FileInfo(path_js);
            if (oF_js.Exists)// Nếu file đã tồn tại
            {
                File.Delete(path_js);
            }
            //
            Session.Clear();
            Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
        }
        protected void dgList_ThamPhan_DonVi_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ThamPhanID = Convert.ToDecimal(e.CommandArgument.ToString());
            decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID].ToString());
            if (e.CommandName == "ChiTiet")
            {
                string Ten = "";
                DM_CANBO ThamPhan = dt.DM_CANBO.Where(x => x.ID == ThamPhanID).FirstOrDefault();
                if (ThamPhan != null)
                {
                    Ten = (ThamPhan.HOTEN + "").Trim();
                }
                DM_CANBO_BL bl = new DM_CANBO_BL();
                DataTable tbl = bl.DM_CANBO_GET_THAMPHAN_TEN_DV(Ten, DonViLoginID, ENUM_DANHMUC.CHUCDANH);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    ltrTenTP.Text = tbl.Rows[0]["HOTEN"].ToString();
                    ltrChucDanh.Text = tbl.Rows[0]["CHUCDANH"].ToString();
                    ltrToaAn.Text = tbl.Rows[0]["TENTOAAN"].ToString();
                    ltrQuyetDinhBoNhiem.Text = tbl.Rows[0]["QDBONHIEM"].ToString();
                    Session[ENUM_LOAIAN.AN_GSTP] = tbl.Rows[0]["ID"].ToString();
                    Session["MaChuongTrinh"] = ENUM_LOAIAN.AN_GSTP;
                    Response.Redirect("Thongtintonghop.aspx");
                }
            }
        }

    }
}