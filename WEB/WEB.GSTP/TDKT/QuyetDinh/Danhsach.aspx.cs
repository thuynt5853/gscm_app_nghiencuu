using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.TDKT.QuyetDinh
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                if (!IsPostBack)
                {
                    LoadDropDonVi();
                    LoadDropSoDieu();
                    DropSoDieu_SelectedIndexChanged(sender, e);
                    LoadDropDanhSach();
                    hddPageIndex.Value = "1";
                    LoadData();
                }
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void LoadDropDonVi()
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
                DropDonVi.DataSource = oBL.DM_TOAAN_GETBY(DonViLoginID);
                DropDonVi.DataTextField = "arrTEN";
                DropDonVi.DataValueField = "ID";
                DropDonVi.DataBind();

                DropDonVi.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
            else
            {
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViLoginID).FirstOrDefault();
                if (oT != null)
                    DropDonVi.Items.Add(new ListItem(oT.MA_TEN, oT.ID.ToString()));
                else
                    DropDonVi.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
            }
        }
        private void LoadDropSoDieu()
        {
            DropSoDieu.Items.Clear();
            for (Int16 i = 1; i <= 10; i++)
                DropSoDieu.Items.Add(new ListItem(i.ToString(), i.ToString()));
        }
        private void LoadDropDanhSach()
        {
            decimal DonVi = Convert.ToDecimal(DropDonVi.SelectedValue);
            List<TDKT_DANH_SACH> lst = dt.TDKT_DANH_SACH.Where(x => x.TOAANID == DonVi).ToList();
            if (lst.Count > 0)
            {
                DropDanhSach.DataSource = lst;
                DropDanhSach.DataTextField = "TEN_DANH_SACH";
                DropDanhSach.DataValueField = "ID";
                DropDanhSach.DataBind();
            }
            DropDanhSach.Items.Insert(0, new ListItem("--- Chọn ---", "0"));
        }
        private void LoadData()
        {
            decimal ToaAnID = Convert.ToDecimal(DropDonVi.SelectedValue);
            string strKey = txtKey.Text.Trim().ToLower();
            int pageSize = Convert.ToInt32(HddPageSize.Value),
                pageIndex = Convert.ToInt32(hddPageIndex.Value);
            OracleParameter[] parameters = new OracleParameter[] {
                new OracleParameter("IN_TOAANID",ToaAnID),
                new OracleParameter("IN_TEXT_KEY",strKey),
                new OracleParameter("IN_PAGESIZE",pageSize),
                new OracleParameter("IN_PAGEINDEX",pageIndex),
                new OracleParameter("CurReturn",OracleDbType.RefCursor, ParameterDirection.Output )
            };
            DataTable tbl = Cls_Comon.GetTableByProcedurePaging("TDKT_QUYET_DINH_GETDATA", parameters);
            if (tbl.Rows.Count > 0)
            {
                int count_all = Convert.ToInt32(tbl.Rows[0]["Total"].ToString());
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, pageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString("#,0.###", cul)
                                                        + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
                PnlData.Visible = true;
            }
            else
            {
                PnlData.Visible = false;
            }
            dgList.PageSize = pageSize;
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        #endregion
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ID = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    BtnXoa.Visible = true;
                    hddID.Value = ID.ToString();
                    LoadInfo(ID);
                    break;
                case "Xoa":
                    Xoa(ID);
                    hddPageIndex.Value = "1";
                    LoadData();
                    Lblthongbao.Text = "Xóa thành công.";
                    break;
            }
        }
        private void LoadInfo(decimal ID)
        {
            TDKT_QUYET_DINH Obj = dt.TDKT_QUYET_DINH.Where(x => x.ID == ID).FirstOrDefault();
            if (Obj != null)
            {
                DropDonVi.SelectedValue = Obj.DONVIID.ToString();
                TxtSoQD.Text = Obj.SOQD;
                TxtNgayQD.Text = Obj.NGAYQD + "" == "" ? "" : ((DateTime)Obj.NGAYQD).ToString("dd/MM/yyyy");
                DropSoDieu.SelectedValue = Obj.SO_DIEU.ToString();
                TxtVeViec.Text = Obj.QD_VE_VIEC;
                TxtCanCu.Text = Obj.CAN_CU;
                int SoDieu = Convert.ToInt32(DropSoDieu.SelectedValue);
                ShowRows(SoDieu);
                TxtDieu1.Text = Obj.DIEU1;
                TxtDieu2.Text = Obj.DIEU2;
                TxtDieu3.Text = Obj.DIEU3;
                TxtDieu4.Text = Obj.DIEU4;
                TxtDieu5.Text = Obj.DIEU5;
                TxtDieu6.Text = Obj.DIEU6;
                TxtDieu7.Text = Obj.DIEU7;
                TxtDieu8.Text = Obj.DIEU8;
                TxtDieu9.Text = Obj.DIEU9;
                TxtDieu10.Text = Obj.DIEU10;
                TxtNoiNhan.Text = Obj.NOI_NHAN;
                TxtNguoiKy.Text = Obj.NGUOI_KY;
                TxtChucVu.Text = Obj.NGUOI_KY_CHUC_VU;
                LoadDropDanhSach();
                DropDanhSach.SelectedValue = Obj.DANH_SACH_ID.ToString();
            }
        }
        private void Xoa(decimal ID)
        {
            TDKT_QUYET_DINH Obj = dt.TDKT_QUYET_DINH.Where(x => x.ID == ID).FirstOrDefault();
            if (Obj != null)
            {
                dt.TDKT_QUYET_DINH.Remove(Obj);
                dt.SaveChanges();
            }
        }
        protected void BtnTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                LoadData();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void BtnThemMoi_Click(object sender, EventArgs e)
        {
            BtnXoa.Visible = false;
            TxtSoQD.Text = "";
            TxtNgayQD.Text = "";
            DropSoDieu.SelectedIndex = 0;
            DropSoDieu_SelectedIndexChanged(sender, e);
            TxtVeViec.Text = "";
            TxtCanCu.Text = "";
            TxtDieu1.Text = "";
            TxtDieu2.Text = "";
            TxtDieu3.Text = "";
            TxtDieu4.Text = "";
            TxtDieu5.Text = "";
            TxtDieu6.Text = "";
            TxtDieu7.Text = "";
            TxtDieu8.Text = "";
            TxtDieu9.Text = "";
            TxtDieu10.Text = "";
            TxtNguoiKy.Text = "";
            TxtChucVu.Text = "";
            DropDanhSach.SelectedIndex = 0;
            hddID.Value = "0";
            Lblthongbao.Text = "";
        }
        protected void BtnXoa_Click(object sender, EventArgs e)
        {
            try
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                Xoa(ID);
                hddPageIndex.Value = "1";
                LoadData();
                Lblthongbao.Text = "Xóa thành công.";
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void BtnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckInputData())
                {
                    return;
                }
                bool IsNew = false;
                decimal DonViID = Convert.ToDecimal(DropDonVi.SelectedValue)
                    , DanhSachID = Convert.ToDecimal(DropDanhSach.SelectedValue);
                TDKT_QUYET_DINH Obj = dt.TDKT_QUYET_DINH.Where(x => x.DONVIID == DonViID && x.DANH_SACH_ID == DanhSachID).FirstOrDefault();
                if (Obj == null)
                {
                    Obj = new TDKT_QUYET_DINH();
                    Obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    Obj.NGAYTAO = DateTime.Now;
                    IsNew = true;
                }
                else
                {
                    Obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                    Obj.NGAYSUA = DateTime.Now;
                }
                Obj.DONVIID = Convert.ToDecimal(DropDonVi.SelectedValue);
                Obj.SOQD = TxtSoQD.Text.Trim();
                Obj.NGAYQD = TxtNgayQD.Text == "" ? (DateTime?)null : Convert.ToDateTime(TxtNgayQD.Text, cul);
                Obj.QD_VE_VIEC = TxtVeViec.Text.Trim();
                Obj.CAN_CU = TxtCanCu.Text.Trim();
                decimal SoDieu = Convert.ToDecimal(DropSoDieu.SelectedValue);
                Obj.SO_DIEU = SoDieu;
                Obj.DIEU1 = TxtDieu1.Text.Trim();
                if (SoDieu >= 2)
                    Obj.DIEU2 = TxtDieu2.Text.Trim();
                else
                    Obj.DIEU2 = "";
                if (SoDieu >= 3)
                    Obj.DIEU3 = TxtDieu3.Text.Trim();
                else
                    Obj.DIEU3 = "";
                if (SoDieu >= 4)
                    Obj.DIEU4 = TxtDieu4.Text.Trim();
                else
                    Obj.DIEU4 = "";
                if (SoDieu >= 5)
                    Obj.DIEU5 = TxtDieu5.Text.Trim();
                else
                    Obj.DIEU5 = "";
                if (SoDieu >= 6)
                    Obj.DIEU6 = TxtDieu6.Text.Trim();
                else
                    Obj.DIEU6 = "";
                if (SoDieu >= 7)
                    Obj.DIEU7 = TxtDieu7.Text.Trim();
                else
                    Obj.DIEU7 = "";
                if (SoDieu >= 8)
                    Obj.DIEU8 = TxtDieu8.Text.Trim();
                else
                    Obj.DIEU8 = "";
                if (SoDieu >= 9)
                    Obj.DIEU9 = TxtDieu9.Text.Trim();
                else
                    Obj.DIEU9 = "";
                if (SoDieu >= 10)
                    Obj.DIEU10 = TxtDieu10.Text.Trim();
                else
                    Obj.DIEU10 = "";
                Obj.NOI_NHAN = TxtNoiNhan.Text.Trim();
                Obj.NGUOI_KY = TxtNguoiKy.Text.Trim();
                Obj.NGUOI_KY_CHUC_VU = TxtChucVu.Text.Trim();
                Obj.DANH_SACH_ID = Convert.ToDecimal(DropDanhSach.SelectedValue);
                if (IsNew)
                {
                    dt.TDKT_QUYET_DINH.Add(Obj);
                }
                dt.SaveChanges();
                hddPageIndex.Value = "1";
                LoadData();
                Lblthongbao.Text = "Lưu thành công.";
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void DropSoDieu_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                int SoDong = Convert.ToInt32(DropSoDieu.SelectedValue);
                ShowRows(SoDong);
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        protected void DropDonVi_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                LoadDropDanhSach();
            }
            catch (Exception ex) { Lblthongbao.Text = ex.Message; }
        }
        private void ShowRows(int SoDieu)
        {
            row_1.Visible = true;
            if (SoDieu >= 2)
                row_2.Visible = true;
            else
                row_2.Visible = false;
            if (SoDieu >= 3)
                row_3.Visible = true;
            else
                row_3.Visible = false;
            if (SoDieu >= 4)
                row_4.Visible = true;
            else
                row_4.Visible = false;
            if (SoDieu >= 5)
                row_5.Visible = true;
            else
                row_5.Visible = false;
            if (SoDieu >= 6)
                row_6.Visible = true;
            else
                row_6.Visible = false;
            if (SoDieu >= 7)
                row_7.Visible = true;
            else
                row_7.Visible = false;
            if (SoDieu >= 8)
                row_8.Visible = true;
            else
                row_8.Visible = false;
            if (SoDieu >= 9)
                row_9.Visible = true;
            else
                row_9.Visible = false;
            if (SoDieu >= 10)
                row_10.Visible = true;
            else
                row_10.Visible = false;
        }
        private bool CheckInputData()
        {
            //decimal Value = Convert.ToDecimal(DropDonVi.SelectedValue);
            //if (Value == 0)
            //{
            //    DropDonVi.Focus();
            //    Lblthongbao.Text = "Chưa chọn đơn vị. Hãy chọn lại.";
            //    return false;
            //}
            decimal Value = Convert.ToDecimal(DropDanhSach.SelectedValue);
            if (Value == 0)
            {
                DropDanhSach.Focus();
                Lblthongbao.Text = "Chưa chọn danh sách kèm theo. Hãy chọn lại.";
                return false;
            }
            int Length = TxtSoQD.Text.Trim().Length;
            if (Length == 0)
            {
                TxtSoQD.Focus();
                Lblthongbao.Text = "Số QĐ không được bỏ trống. Hãy nhập lại.";
                return false;
            }
            else if (Length > 100)
            {
                TxtSoQD.Focus();
                Lblthongbao.Text = "Số QĐ không được quá 100 ký tự. Hãy nhập lại.";
                return false;
            }
            Length = TxtNgayQD.Text.Trim().Length;
            if (Length == 0)
            {
                TxtNgayQD.Focus();
                Lblthongbao.Text = "Ngày QĐ không được để trống. Hãy nhập lại.";
                return false;
            }
            else
            {
                if (!Cls_Comon.IsValidDate(TxtNgayQD.Text))
                {
                    TxtNgayQD.Focus();
                    Lblthongbao.Text = "Ngày QĐ phải có kiểu ngày/tháng/năm. Hãy nhập lại.";
                    return false;
                }
                DateTime NgayQD = Convert.ToDateTime(TxtNgayQD.Text, cul);
                if (NgayQD > DateTime.Now)
                {
                    TxtNgayQD.Focus();
                    Lblthongbao.Text = "Ngày QĐ phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtVeViec.Text.Trim() != "")
            {
                Length = TxtVeViec.Text.Trim().Length;
                if (Length > 500)
                {
                    TxtVeViec.Focus();
                    Lblthongbao.Text = "Về việc không được quá 500 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtCanCu.Text.Trim() != "")
            {
                Length = TxtCanCu.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtCanCu.Focus();
                    Lblthongbao.Text = "Căn cứ không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtDieu1.Text.Trim() != "")
            {
                Length = TxtDieu1.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtDieu1.Focus();
                    Lblthongbao.Text = "Điều 1 không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtDieu2.Text.Trim() != "")
            {
                Length = TxtDieu2.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtDieu2.Focus();
                    Lblthongbao.Text = "Điều 2 không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtDieu3.Text.Trim() != "")
            {
                Length = TxtDieu3.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtDieu3.Focus();
                    Lblthongbao.Text = "Điều 3 không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtDieu4.Text.Trim() != "")
            {
                Length = TxtDieu4.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtDieu4.Focus();
                    Lblthongbao.Text = "Điều 4 không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtDieu5.Text.Trim() != "")
            {
                Length = TxtDieu5.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtDieu5.Focus();
                    Lblthongbao.Text = "Điều 5 không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtDieu6.Text.Trim() != "")
            {
                Length = TxtDieu6.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtDieu6.Focus();
                    Lblthongbao.Text = "Điều 6 không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtDieu7.Text.Trim() != "")
            {
                Length = TxtDieu7.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtDieu7.Focus();
                    Lblthongbao.Text = "Điều 7 không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtDieu8.Text.Trim() != "")
            {
                Length = TxtDieu8.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtDieu8.Focus();
                    Lblthongbao.Text = "Điều 8 không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtDieu9.Text.Trim() != "")
            {
                Length = TxtDieu9.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtDieu9.Focus();
                    Lblthongbao.Text = "Điều 9 không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtDieu10.Text.Trim() != "")
            {
                Length = TxtDieu10.Text.Trim().Length;
                if (Length > 4000)
                {
                    TxtDieu10.Focus();
                    Lblthongbao.Text = "Điều 10 không được quá 4000 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtNoiNhan.Text.Trim() != "")
            {
                Length = TxtNoiNhan.Text.Trim().Length;
                if (Length > 500)
                {
                    TxtNoiNhan.Focus();
                    Lblthongbao.Text = "Nơi nhận không được quá 500 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtNguoiKy.Text.Trim() != "")
            {
                Length = TxtNguoiKy.Text.Trim().Length;
                if (Length > 250)
                {
                    TxtNguoiKy.Focus();
                    Lblthongbao.Text = "Người ký không được quá 250 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            if (TxtChucVu.Text.Trim() != "")
            {
                Length = TxtChucVu.Text.Trim().Length;
                if (Length > 250)
                {
                    TxtChucVu.Focus();
                    Lblthongbao.Text = "Chức vụ không được quá 250 ký tự. Hãy nhập lại.";
                    return false;
                }
            }
            return true;
        }

    }
}