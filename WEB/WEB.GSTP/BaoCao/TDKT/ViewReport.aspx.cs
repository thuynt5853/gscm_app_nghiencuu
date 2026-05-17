using BL.GSTP;
using DAL.GSTP;
using DevExpress.XtraPrinting.Caching;
using DevExpress.XtraReports.UI;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.BaoCao.TDKT
{
    public partial class ViewReport : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        private const int TAPTHE = 1, CANHAN = 2, THIDUA = 1, KHENTHUONG = 2, KYLUAT = 3;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                if (!IsPostBack)
                {
                    LoadDropDonVi_DeNghi();
                    //LoadPhongBan();
                    LoadDropDonVi_CapTren();
                    LoadDropDanhSach();
                    //LoadDanhSachDoiTuong();
                    //LoadReport();
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadDropDonVi_DeNghi()
        {
            decimal DonViLoginID = Session[ENUM_SESSION.SESSION_DONVIID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");
            string LoaiToa = "";
            DM_TOAAN ObjTA = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
            if (ObjTA != null)
            {
                LoaiToa = ObjTA.LOAITOA;
            }
            if (LoaiToa == "TOICAO")
            {
                DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                DropDonVi_DeNghi.DataSource = oBL.DM_TOAAN_GETBY(DonViLoginID);
                DropDonVi_DeNghi.DataTextField = "arrTEN";
                DropDonVi_DeNghi.DataValueField = "ID";
                DropDonVi_DeNghi.DataBind();

                DropDonVi_DeNghi.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            else
            {
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
                if (oT != null)
                    DropDonVi_DeNghi.Items.Add(new ListItem(oT.MA_TEN, oT.ID.ToString()));
                else
                    DropDonVi_DeNghi.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }
        private void LoadDropDonVi_CapTren()
        {
            decimal DonViID = Convert.ToDecimal(DropDonVi_DeNghi.SelectedValue);
            DM_TOAAN Obj = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
            if (Obj != null)
            {
                DM_TOAAN ObjCapTren = dt.DM_TOAAN.Where(x => x.ID == Obj.CAPCHAID).FirstOrDefault();
                if (ObjCapTren != null)
                {
                    DropDonVi_CapTren.Items.Add(new ListItem(ObjCapTren.TEN, ObjCapTren.ID.ToString()));
                    if (ObjCapTren.CAPCHAID > 0)
                    {
                        LoadParentDonVi((decimal)ObjCapTren.CAPCHAID);
                    }
                    DropDonVi_CapTren.SelectedIndex = DropDonVi_CapTren.Items.Count - 1;
                }
                else
                    DropDonVi_CapTren.Items.Add(new ListItem("--- Chọn ---", "0"));
            }
            else { DropDonVi_CapTren.Items.Add(new ListItem("--- Chọn ---", "0")); }
        }
        private void LoadParentDonVi(decimal ParentID)
        {
            DM_TOAAN ObjCapTren = dt.DM_TOAAN.Where(x => x.ID == ParentID).FirstOrDefault();
            if (ObjCapTren != null)
            {
                DropDonVi_CapTren.Items.Add(new ListItem(ObjCapTren.TEN, ObjCapTren.ID.ToString()));
                if (ObjCapTren.CAPCHAID > 0)
                {
                    LoadParentDonVi((decimal)ObjCapTren.CAPCHAID);
                }
            }
        }
        //private void LoadPhongBan()
        //{
        //    DropPhongBan.Items.Clear();
        //    decimal DonViID = Convert.ToDecimal(DropDonVi_DeNghi.SelectedValue);
        //    List<DM_PHONGBAN> lst = dt.DM_PHONGBAN.Where(x => x.TOAANID == DonViID).ToList();
        //    DropPhongBan.DataSource = lst;
        //    DropPhongBan.DataTextField = "TENPHONGBAN";
        //    DropPhongBan.DataValueField = "ID";
        //    DropPhongBan.DataBind();
        //    DropPhongBan.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        //}
        private void LoadDropDanhSach()
        {
            DropDanhSach.Items.Clear();
            decimal DonVi = Convert.ToDecimal(DropDonVi_DeNghi.SelectedValue);
            List<TDKT_DANH_SACH> lst = dt.TDKT_DANH_SACH.Where(x => x.TOAANID == DonVi && x.LOAI_DE_NGHI == THIDUA).ToList();
            if (lst.Count > 0)
            {
                DropDanhSach.DataSource = lst;
                DropDanhSach.DataTextField = "TEN_DANH_SACH";
                DropDanhSach.DataValueField = "ID";
                DropDanhSach.DataBind();
            }
            else DropDanhSach.Items.Add(new ListItem("--- Chọn ---", "0"));
        }
        protected void DropDonVi_DeNghi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                //LoadPhongBan();
                LoadDropDanhSach();
                LoadDropDonVi_CapTren();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        //protected void DropPhongBan_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    int PhongBanID = Convert.ToInt32(DropPhongBan.SelectedValue);
        //    if (PhongBanID > 0)
        //        RowDonViCapTren.Visible = false;
        //    else
        //        RowDonViCapTren.Visible = true;
        //}
        #region Đối tượng
        //protected void DropDanhSach_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    try
        //    {
        //        LoadDanhSachDoiTuong();
        //    }
        //    catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        //}
        //protected void chkAll_CheckedChanged(object sender, EventArgs e)
        //{
        //    foreach(RepeaterItem item in rpt.Items)
        //    {
        //        CheckBox chkChon = (CheckBox)item.FindControl("chkChon");
        //        chkChon.Checked = chkAll.Checked;
        //    }
        //}
        //private void LoadDanhSachDoiTuong()
        //{
        //    rpt.DataSource = null;
        //    rpt.DataBind();
        //    decimal Danh_Sach_ID = Convert.ToDecimal(DropDanhSach.SelectedValue);
        //    List<TDKT_DANH_SACH_DOI_TUONG> lst = dt.TDKT_DANH_SACH_DOI_TUONG.Where(x => x.DANH_SACH_ID == Danh_Sach_ID).OrderBy(x => x.LOAI_DOI_TUONG).ToList();
        //    if (lst.Count > 0)
        //    {
        //        rpt.DataSource = lst;
        //        rpt.DataBind();
        //    }
        //}
        //protected void rpt_ItemDataBound(object sender, RepeaterItemEventArgs e)
        //{
        //    if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        //    {
        //        TDKT_DANH_SACH_DOI_TUONG Obj = (TDKT_DANH_SACH_DOI_TUONG)e.Item.DataItem;
        //        Label LblLoaiDoiTuong = (Label)e.Item.FindControl("LblLoaiDoiTuong");
        //        int LoaiDoiTuong = Convert.ToInt32(Obj.LOAI_DOI_TUONG);
        //        if (LoaiDoiTuong == TAPTHE)
        //        {
        //            LblLoaiDoiTuong.Text = "Tập thể";
        //        }
        //        if (LoaiDoiTuong == CANHAN)
        //        {
        //            LblLoaiDoiTuong.Text = "Cá nhân";
        //        }
        //    }
        //}
        #endregion
        protected void BtnXem_Click(object sender, EventArgs e)
        {
            try
            {
                LoadReport();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void BtnLamMoi_Click(object sender, EventArgs e)
        {
            DropDonVi_DeNghi.SelectedIndex = 0;
            DropDonVi_DeNghi_SelectedIndexChanged(sender, e);
        }
        private void LoadReport()
        {
            Lblthongbao.Text = "";
            string vMaBC = Request["bm"] + "";
            #region Thông tư 01 - Mẫu số 01 - Đăng ký thia đua
            if (vMaBC == "BM_TT01_MS01_DKTD")
            {
                decimal Danh_SachID = Convert.ToDecimal(DropDanhSach.SelectedValue);
                OracleParameter[] parameters = new OracleParameter[] {
                    new OracleParameter("v_Danh_SachID",Danh_SachID),
                    new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
                };
                string DonViDangKy = DropDonVi_DeNghi.SelectedItem.Text;
                string[] spl = { "tỉnh", "thành phố" };
                string[] Arr_Tinh = DonViDangKy.Split(spl, StringSplitOptions.RemoveEmptyEntries);
                string p_Tinh = Arr_Tinh[1];
                if (DonViDangKy.Contains("tỉnh"))
                {
                    p_Tinh = "Tỉnh " + p_Tinh;
                }
                else
                {
                    p_Tinh = "Thành phố " + p_Tinh;
                }
                DataTable tbl = GetDataReport("PKG_TDKT_REPORT.BM_TT01_MS01", parameters);
                if (tbl.Rows.Count > 0)
                {
                    TT01_Mau_So_01_Dang_Ky_Thi_Dua rpt = new TT01_Mau_So_01_Dang_Ky_Thi_Dua();
                    rpt.Parameters["p_DonVi_CapTren"].Value = DropDonVi_CapTren.SelectedItem.Text.ToUpper();
                    rpt.Parameters["p_DonVi_DangKy"].Value = DonViDangKy.Replace(".", "").ToUpper();
                    rpt.Parameters["p_Tinh"].Value = p_Tinh;
                    rpt.Parameters["p_TenDanhSach"].Value = DropDanhSach.SelectedItem.Text.ToUpper();

                    DataRow row = tbl.Rows[0];
                    rpt.Parameters["p_NguoiLapBieu"].Value = row["nguoi_lap"];
                    rpt.Parameters["p_ThuTruongDonVi"].Value = row["nguoi_duyet_ten"];
                    string SqlSelect = "loai_doi_tuong=" + TAPTHE;
                    #region Tập thể
                    DataRow[] Row_TapThe = tbl.Select(SqlSelect);// Tập thể
                    if (Row_TapThe.Length > 0)
                    {
                        int ThuTu = 1;
                        foreach (DataRow item in Row_TapThe)
                        {
                            item["STT"] = ThuTu.ToString();
                            item["ArrThuTu"] = CreateArrThuTu(TAPTHE.ToString(), ThuTu);
                            ThuTu++;
                        }
                        DataRow NewRow = tbl.NewRow();
                        NewRow["loai_doi_tuong"] = TAPTHE.ToString();
                        NewRow["STT"] = "I";
                        NewRow["ArrThuTu"] = TAPTHE.ToString();
                        NewRow["nguoi_lap"] = "";
                        NewRow["nguoi_duyet_ten"] = "";
                        NewRow["Ten_Doi_Tuong"] = "TẬP THỂ";
                        NewRow["Tap_The_LDTT"] = "";
                        NewRow["Tap_The_LDSX"] = "";
                        NewRow["Tap_The_Co_TAND"] = "";
                        NewRow["Tap_The_Co_CP"] = "";
                        NewRow["Ca_Nhan_LDTT"] = "";
                        NewRow["Ca_Nhan_CSTD_CS"] = "";
                        NewRow["Ca_Nhan_CSTD_TAND"] = "";
                        NewRow["Ca_Nhan_CSTD_TQ"] = "";
                        tbl.Rows.Add(NewRow);
                    }
                    #endregion
                    #region Cá nhân
                    SqlSelect = "loai_doi_tuong=" + CANHAN;
                    DataRow[] Row_Ca_Nhan = tbl.Select(SqlSelect);// Cá nhân
                    if (Row_Ca_Nhan.Length > 0)
                    {
                        int ThuTu = 1;
                        foreach (DataRow item in Row_Ca_Nhan)
                        {
                            item["STT"] = ThuTu.ToString();
                            item["ArrThuTu"] = CreateArrThuTu(CANHAN.ToString(), ThuTu);
                            ThuTu++;
                        }
                        DataRow NewRow = tbl.NewRow();
                        NewRow["loai_doi_tuong"] = CANHAN.ToString();
                        NewRow["STT"] = "II";
                        NewRow["ArrThuTu"] = CANHAN.ToString();
                        NewRow["nguoi_lap"] = "";
                        NewRow["nguoi_duyet_ten"] = "";
                        NewRow["Ten_Doi_Tuong"] = "CÁ NHÂN";
                        NewRow["Tap_The_LDTT"] = "";
                        NewRow["Tap_The_LDSX"] = "";
                        NewRow["Tap_The_Co_TAND"] = "";
                        NewRow["Tap_The_Co_CP"] = "";
                        NewRow["Ca_Nhan_LDTT"] = "";
                        NewRow["Ca_Nhan_CSTD_CS"] = "";
                        NewRow["Ca_Nhan_CSTD_TAND"] = "";
                        NewRow["Ca_Nhan_CSTD_TQ"] = "";
                        tbl.Rows.Add(NewRow);
                    }
                    #endregion
                    DTBIEUMAU objds = new DTBIEUMAU();
                    DataRow[] dataRows = tbl.Select("", "ArrThuTu");
                    foreach (DataRow item in dataRows)
                    {
                        DTBIEUMAU.TT01_BM_TT01_MS01Row r = objds.TT01_BM_TT01_MS01.NewTT01_BM_TT01_MS01Row();
                        r.LOAI_DOI_TUONG = item["loai_doi_tuong"] + "";
                        r.STT = item["STT"] + "";
                        r.ARRTHUTU = item["ArrThuTu"] + "";
                        r.NGUOI_LAP = item["nguoi_lap"] + "";
                        r.NGUOI_DUYET_TEN = item["nguoi_duyet_ten"] + "";
                        r.TEN_DOI_TUONG = item["Ten_Doi_Tuong"] + "";
                        r.TAP_THE_LDTT = item["Tap_The_LDTT"] + "";
                        r.TAP_THE_LDSX = item["Tap_The_LDSX"] + "";
                        r.TAP_THE_CO_TAND = item["Tap_The_Co_TAND"] + "";
                        r.TAP_THE_CO_CP = item["Tap_The_Co_CP"] + "";
                        r.CA_NHAN_LDTT = item["Ca_Nhan_LDTT"] + "";
                        r.CA_NHAN_CSTD_CS = item["Ca_Nhan_CSTD_CS"] + "";
                        r.CA_NHAN_CSTD_TAND = item["Ca_Nhan_CSTD_TAND"] + "";
                        r.CA_NHAN_CSTD_TQ = item["Ca_Nhan_CSTD_TQ"] + "";
                        objds.TT01_BM_TT01_MS01.AddTT01_BM_TT01_MS01Row(r);
                    }
                    objds.AcceptChanges();
                    rpt.DataSource = objds;
                    rpt.CreateDocument();
                    rptView.OpenReport(rpt);
                }
                else { Lblthongbao.Text = "Không tìm thấy dữ liệu phù hợp. Hãy xem lại!"; }
            }
            #endregion
            #region Thông tư 01 - Mẫu số 02 - Đăng ký xây dựng điển hình tiên tiến
            if (vMaBC == "BM_TT01_MS02_XD_DHTT")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 03 - Tờ trình về việc đề nghị xét tặng danh hiệu thi đua, hình thức khen thưởng
            if (vMaBC == "BM_TT01_MS03_XT_TDKT")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 03 - Danh sách đề nghị khen thưởng cấp nhà nước
            if (vMaBC == "BM_TT01_MS03_KT_CNN")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 03 - Danh sách đề nghị khen thưởng TAND khác
            if (vMaBC == "BM_TT01_MS03_KT_TAND_KHAC")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 03 - Danh sách đề nghị khen thưởng cuối năm
            if (vMaBC == "BM_TT01_MS03_KT_CUOI_NAM")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 04 - Báo cáo thành tích đề nghị khen thưởng
            if (vMaBC == "BM_TT01_MS04_DNKT")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 05 - Báo cáo thành tích đề nghị tặng thưởng (Áp dụng với cá nhân)
            if (vMaBC == "BM_TT01_MS05_TT_CA_NHAN")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 06 - Báo cáo thành tích đề nghị tặng thưởng (Truy tặng) Huân chương
            if (vMaBC == "BM_TT01_MS06_TT_HC")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 07 - Báo cáo thành tích đề nghị phong tặng danh hiệu Anh hùng lao động
            if (vMaBC == "BM_TT01_MS07_PT_AHLD")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 08 - Báo cáo thành tích đề nghị tặng (Truy tặng) danh hiệu Anh hùng lao động
            if (vMaBC == "BM_TT01_MS08_T_AHLD")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 09 - Báo cáo thành tích đề nghị tặng thưởng (Truy tặng) về thành tích xuất sắc đột xuất
            if (vMaBC == "BM_TT01_MS09_TT_DX")
            {

            }
            #endregion
            #region Thông tư 01 - Mẫu số 10 - Báo cáo thành tích đề nghị tặng thưởng
            if (vMaBC == "BM_TT01_MS10_DNTT")
            {

            }
            #endregion
        }
        private DataTable GetDataReport(string Proc, OracleParameter[] parameters)
        {
            return Cls_Comon.GetTableByProcedurePaging(Proc, parameters);
        }
        private string CreateArrThuTu(string ArrThuTu, int ThuTu)
        {
            string temp = "";
            if (ThuTu < 10)
                temp += ArrThuTu + "/000" + ThuTu.ToString();
            else if (ThuTu < 100)
                temp += ArrThuTu + "/00" + ThuTu.ToString();
            else if (ThuTu < 1000)
                temp += ArrThuTu + "/0" + ThuTu.ToString();
            else
                temp += ArrThuTu + "/" + ThuTu.ToString();
            return temp;
        }
    }
}