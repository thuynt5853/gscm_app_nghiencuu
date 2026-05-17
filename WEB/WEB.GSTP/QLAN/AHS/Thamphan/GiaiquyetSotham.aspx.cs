using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.QLAN;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.Script.Serialization;

namespace WEB.GSTP.QLAN.AHS.Thamphan
{
    public partial class GiaiquyetSotham : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                    string current_id = Session[ENUM_LOAIAN.AN_HINHSU] + "";
                    if (current_id == "")
                        Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    LoadDataThuKy();
                    LoadDropThuLy();
                    CheckQuyen();
                    LoadGrid();
                }
                catch (Exception ex) { lbthongbao.Text = ex.Message; }
            }
        }
        protected void myListDropDown_Change(object sender, EventArgs e)
        {
            GetDataDefaultThuKy();
        }

        private void GetDataDefaultThuKy()
        {
            decimal value = decimal.Parse(ddlThamphan.SelectedValue);
            var obj = dt.CAUHINH_THAMPHAN_THUKY.FirstOrDefault(s => s.THAMPHAMID == value);
            if (obj != null)
            {

                ddlThuky.SelectedValue = obj.THUKYID.Value.ToString();

            }
            else
            {
                ddlThuky.SelectedValue = "0";
            }
        }
        private void LoadDataThuKy()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            //DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY);
            // Lay Thu ky và TTV
            DataTable oCBDT = oDMCBBL.DM_CANBO_GetAllThuKy_TTV(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), "");
            if (oCBDT != null)
            {
                if (oCBDT.Rows.Count > 0)
                {
                    ddlThuky.DataSource = oCBDT;
                    ddlThuky.DataTextField = "HOTEN";
                    ddlThuky.DataValueField = "ID";
                    ddlThuky.DataBind();
                    ddlThuky.Items.Insert(0, new ListItem("--Chọn thư ký--", "0"));
                    GetDataDefaultThuKy();
                }
                else
                {
                    ddlThuky.Items.Insert(0, new ListItem("--Chọn thư ký--", "0"));
                }
            }
        }
        void LoadDropThuLy()
        {
            dropThuLy.Items.Clear();
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_SOTHAM_THULY_BL obj = new AHS_SOTHAM_THULY_BL();
            DataTable tbl = obj.GetByVuAnID(VuAnID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                string SoThuLy = "", THThuLy = "", NgayThuLy = "";
                string temp = "";
                int count_item = tbl.Rows.Count;
                if (count_item > 1)
                {
                    dropThuLy.Items.Add(new ListItem("---Chọn---", "0"));
                    foreach (DataRow row in tbl.Rows)
                    {
                        SoThuLy = row["SoThuLy"] + "";
                        THThuLy = row["TruongHopThuLy"] + "";
                        NgayThuLy = Convert.ToDateTime(row["NgayThuLy"] + "").ToString("dd/MM/yyyy", cul);
                        temp = SoThuLy + " - " + THThuLy + " - " + NgayThuLy;
                        dropThuLy.Items.Add(new ListItem(temp, row["ID"] + ""));
                    }
                }
                else
                {
                    DataRow row = tbl.Rows[0];
                    SoThuLy = row["SoThuLy"] + "";
                    THThuLy = row["TruongHopThuLy"] + "";
                    NgayThuLy = Convert.ToDateTime(row["NgayThuLy"] + "").ToString("dd/MM/yyyy", cul);
                    temp = SoThuLy + " - " + THThuLy + " - " + NgayThuLy;
                    dropThuLy.Items.Add(new ListItem(temp, row["ID"] + ""));

                    hddNgayThuLy.Value = NgayThuLy;
                }
            }
            else
            {
                dropThuLy.Items.Add(new ListItem("---Chọn---", "0"));
                lbthongbao.Text = "Vụ việc chưa được thụ lý. Hãy kiểm tra lại !";
                cmdUpdate.Visible = cmdLammoi.Visible = false;
            }

            List<AHS_SOTHAM_THULY> tl = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VuAnID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();
            if (tl.Count != 0)
            {
                decimal THULYID = tl[0].ID;

                dropThuLy.SelectedValue = THULYID.ToString();
            }
            else
            {
                lbthongbao.Text = "Vụ việc chưa được thụ lý. Hãy kiểm tra lại !";
                cmdUpdate.Visible = cmdLammoi.Visible = false;
            }
        }
        private void ResetControls()
        {
            dropThuLy.SelectedIndex = ddlThamphan.SelectedIndex = ddlNguoiphancong.SelectedIndex = 0;
            txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgayketthuc.Text = txtSoQD.Text = txtNgayQD.Text = "";
            hddid.Value = "0";
            //MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            //Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
        }
        void CheckQuyen()
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);

            decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            AHS_VUAN oT = dt.AHS_VUAN.Where(x => x.ID == ID).FirstOrDefault();
            List<AHS_SOTHAM_THULY> tl = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == ID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();

            decimal THULYID;
            if (tl.Count != 0)
            {
                THULYID = tl[0].ID;
                dropThuLy.SelectedValue = THULYID.ToString();
            }
            else
            {
                lbthongbao.Text = " Chưa cập nhật thông tin thụ lý sơ thẩm !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            //check vu an ket thuc de thong bao khong cho sua
            Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
            if (anKetThuc)
            {
                lbthongbao.Text = "Vụ việc đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            AHS_SOTHAM_BANAN oBA = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == ID && x.THULYID == THULYID).FirstOrDefault();
            if (oBA != null)
            {
                lbthongbao.Text = "Vụ việc đã có bản án, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            DM_QUYETDINH_VUAN_KETTHUC oBL = new DM_QUYETDINH_VUAN_KETTHUC();
            DataTable oDT = oBL.DGLIST_BAQD_QUYETDINH_KETTHUC_ST(ENUM_LOAIVUVIEC_NUMBER.AN_HINHSU, ID, THULYID);
            if (oDT.Rows.Count > 0)
            {
                lbthongbao.Text = "Đã có quyết định gây kết thúc, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }

            if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
            {
                lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
        }
        private bool CheckValid()
        {
            if (dropThuLy.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn thụ lý. Hãy kiểm tra lại.";
                dropThuLy.Focus();
                return false;
            }
            int LengthSoQD = txtSoQD.Text.Trim().Length;
            if (LengthSoQD == 0)
            {
                lbthongbao.Text = "Chưa nhập số quyết định. Hãy kiểm tra lại.";
                txtSoQD.Focus();
                return false;
            }
            else if (LengthSoQD > 50)
            {
                lbthongbao.Text = "Số quyết định không quá 50 ký tự. Hãy kiểm tra lại.";
                txtSoQD.Focus();
                return false;
            }
            DateTime DNgayThuLy = hddNgayThuLy.Value == "" ? DateTime.MinValue : DateTime.Parse(hddNgayThuLy.Value, cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime NgayQD;
            if (txtNgayQD.Text == "")
            {
                lbthongbao.Text = "Chưa nhập ngày quyết định. Hãy kiểm tra lại.";
                txtNgayQD.Focus();
                return false;
            }
            else
            {
                if (!DateTime.TryParseExact(txtNgayQD.Text, "dd/MM/yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayQD))
                {
                    lbthongbao.Text = "Ngày quyết định chưa nhập đúng kiểu (Ngày/Tháng/Năm). Hãy nhập lại.";
                    txtNgayQD.Focus();
                    return false;
                }
            }

            if (ddlThamphan.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn thẩm phán. Hãy chọn lại.";
                ddlThamphan.Focus();
                return false;
            }

            if (ddlNguoiphancong.SelectedValue == "" || ddlNguoiphancong.SelectedValue == "0")
            {
                lbthongbao.Text = "Chưa chọn người phân công. Hãy chọn lại.";
                ddlNguoiphancong.Focus();
                return false;
            }

            DateTime NgayPhanCong;
            if (txtNgayphancong.Text == "")
            {
                lbthongbao.Text = "Chưa nhập ngày phân công. Hãy kiểm tra lại.";
                txtNgayphancong.Focus();
                return false;
            }
            else
            {
                if (!DateTime.TryParseExact(txtNgayphancong.Text, "dd/MM/yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayPhanCong))
                {
                    lbthongbao.Text = "Ngày phân công chưa nhập đúng kiểu (Ngày/Tháng/Năm). Hãy nhập lại.";
                    txtNgayphancong.Focus();
                    return false;
                }

                if (DateTime.Compare(NgayPhanCong, DateTime.Today) > 0)
                {
                    lbthongbao.Text = "Ngày phân công phải nhỏ hơn hoặc bằng ngày hiện tại. Hãy nhập lại.";
                    txtNgayphancong.Focus();
                    return false;
                }
            }
            DateTime NgayNhanPhanCong;
            if (txtNhanphancong.Text == "")
            {
                lbthongbao.Text = "Chưa nhập ngày nhận phân công. Hãy kiểm tra lại.";
                txtNhanphancong.Focus();
                return false;
            }
            else
            {
                if (!DateTime.TryParseExact(txtNhanphancong.Text, "dd/MM/yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayNhanPhanCong))
                {
                    lbthongbao.Text = "Ngày nhận phân công chưa nhập đúng kiểu (Ngày/Tháng/Năm). Hãy nhập lại.";
                    txtNhanphancong.Focus();
                    return false;
                }
                if (DateTime.Compare(NgayNhanPhanCong, NgayPhanCong) < 0)
                {
                    lbthongbao.Text = "Ngày nhận phân công phải lớn hơn hoặc bằng ngày phân công. Hãy nhập lại";
                    txtNhanphancong.Focus();
                    return false;
                }
            }
            DateTime NgayKetThuc;
            if (txtNgayketthuc.Text != "")
            {
                if (!DateTime.TryParseExact(txtNgayketthuc.Text, "dd/MM/yyyy", cul, DateTimeStyles.NoCurrentDateDefault, out NgayKetThuc))
                {
                    lbthongbao.Text = "Ngày kết thúc chưa nhập đúng kiểu (Ngày/Tháng/Năm). Hãy nhập lại.";
                    txtNgayketthuc.Focus();
                    return false;
                }
                if (DateTime.Compare(NgayKetThuc, NgayNhanPhanCong) < 0)
                {
                    lbthongbao.Text = "Ngày kết thúc phải lớn hơn hoặc bằng ngày nhận phân công. Hãy nhập lại";
                    txtNgayketthuc.Focus();
                    return false;
                }
            }
            return true;
        }
        public void LoadGrid()
        {
            AHS_THAMPHANGIAIQUYET_BL oBL = new AHS_THAMPHANGIAIQUYET_BL();
            decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            DataTable oDT = oBL.AHS_THAMPHANGIAIQUYET_GETBY(VuAnID, ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), Convert.ToInt32(20)).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion

                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }
        public void xoa(decimal id)
        {
            AHS_THAMPHANGIAIQUYET oND = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.ID == id).FirstOrDefault();
            //Luu thong tin Thẩm phán Sơ thẩm trước khi xoa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(oND);
            ADS_DON_BL oBL = new ADS_DON_BL();
            if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.VUANID), 1, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Thẩm phán Sơ thẩm án Hình sự", "Xóa", json) == false)
            {
                lbthongbao.Text = "Xóa không thành công!";
                return;
            }//Ket thuc
             //Xoa Thẩm phán Sơ thẩm
            dt.AHS_THAMPHANGIAIQUYET.Remove(oND);
            dt.SaveChanges();

            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            AHS_THAMPHANGIAIQUYET oND = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.ID == ID).FirstOrDefault();
            if (oND != null)
            {
                dropThuLy.SelectedValue = oND.THULYID.ToString();
                hddid.Value = oND.ID.ToString();
                try { dropThuLy.SelectedValue = oND.THULYID + ""; } catch (Exception ex) { }
                if (oND.CANBOID != null)
                    if (ddlThamphan.Items.FindByValue(oND.CANBOID.ToString()) != null)
                        ddlThamphan.SelectedValue = oND.CANBOID.ToString();
                if (oND.THUKYID != null)
                {
                    if (ddlThuky.Items.FindByValue(oND.THUKYID.ToString()) != null)
                        ddlThuky.SelectedValue = oND.THUKYID.ToString();
                    else
                        ddlThuky.SelectedValue = 0 + "";
                }

                ddlVaitro.SelectedValue = oND.MAVAITRO;
                txtSoQD.Text = oND.SOQD;
                txtNgayQD.Text = (String.IsNullOrEmpty(oND.NGAYQD + "") || (DateTime)oND.NGAYQD == DateTime.MinValue) ? "" : ((DateTime)oND.NGAYQD).ToString("dd/MM/yyyy", cul);

                txtNgayphancong.Text = (oND.NGAYPHANCONG == DateTime.MinValue || oND.NGAYPHANCONG + "" == "") ? "" : ((DateTime)oND.NGAYPHANCONG).ToString("dd/MM/yyyy", cul);
                txtNhanphancong.Text = (oND.NGAYNHANPHANCONG == DateTime.MinValue || oND.NGAYNHANPHANCONG + "" == "") ? "" : ((DateTime)oND.NGAYNHANPHANCONG).ToString("dd/MM/yyyy", cul);
                txtNgayketthuc.Text = (oND.NGAYKETTHUC == DateTime.MinValue || oND.NGAYKETTHUC + "" == "") ? "" : ((DateTime)oND.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);
                if (oND.NGUOIPHANCONGID != null)
                {
                    if (ddlNguoiphancong.Items.FindByValue(oND.NGUOIPHANCONGID.ToString()) != null)
                        ddlNguoiphancong.SelectedValue = oND.NGUOIPHANCONGID.ToString();
                }
            }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            decimal VUANID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            decimal TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string[] arr = e.CommandArgument.ToString().Split('#');
            decimal ND_id = Convert.ToDecimal(arr[0]),
                    TPID = Convert.ToDecimal(arr[1]);
           
            switch (e.CommandName)
            {
                case "Sua":
                    LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                    if (lblSua.Text == "Sửa")
                    {
                        Cls_Comon.SetButton(cmdUpdate, true);
                    }
                    else
                    {
                        Cls_Comon.SetButton(cmdUpdate, false);
                    }
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = ND_id + "";
                    break;
                case "Xoa":
                    if (oPer.XOA == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    
                    List<AHS_SOTHAM_THULY> tl = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VUANID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();
                    if (tl.Count != 0)
                    {
                        decimal THULYID = tl[0].ID;

                        if (!CheckQDofThamPhan(VUANID, TPID, THULYID))
                        {
                            return;
                        }

                        // Nếu có thì không được phép thêm thẩm phán chủ tọa phiên tòa                     
                        AHS_SOTHAM_HDXX oND = dt.AHS_SOTHAM_HDXX
                            .Where(x => x.VUANID == VUANID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN &&
                                        x.THULYID == THULYID && x.TOA_GIAIQUYET_ID == TOAANID).FirstOrDefault<AHS_SOTHAM_HDXX>();
                        if (oND != null)
                        {
                            lbthongbao.Text = "Vụ án đã có thẩm phán chủ tọa phiên tòa. Không được xóa!";
                            return;
                        }
                    }

                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AHS_CHUYEN_NHAN_AN_BL().Check_NhanAn(VUANID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    if (Result != "")
                    {
                        lbthongbao.Text = Result;
                        return;
                    }
                    xoa(ND_id);
                    ResetControls();
                    break;
            }

        }
        #region "Phân trang"

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            LoadGrid();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            LoadGrid();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            LoadGrid();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            LoadGrid();
        }

        #endregion
        protected void cmdUpdate_Click1(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string MaVaiTro = ddlVaitro.SelectedValue;
                decimal VUANID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + ""), CanBoID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                decimal ID = (string.IsNullOrEmpty(hddid.Value)) ? 0 : Convert.ToDecimal(hddid.Value);
                
                //List<AHS_SOTHAM_THULY> tl = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VUANID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();
                //decimal ThuLyID = tl[0].ID;
                decimal ThuLyID = Convert.ToDecimal(dropThuLy.SelectedValue);

                AHS_THAMPHANGIAIQUYET oND;
                if (ID == 0)
                {
                    // Kiểm tra nếu thẩm phán đã được phân công rồi thì không phân lại nữa. Chọn thẩm phán khác
                    oND = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.VUANID == VUANID && x.CANBOID == CanBoID && x.MAVAITRO == MaVaiTro && x.THULYID == ThuLyID).FirstOrDefault();
                    if (oND != null)
                    {
                        lbthongbao.Text = "Thẩm phán " + ddlThamphan.SelectedItem.Text + " đã được phân công. Hãy chọn lại!";
                        ddlThamphan.Focus();
                        return;
                    }
                    oND = new AHS_THAMPHANGIAIQUYET();
                }
                else
                    oND = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.ID == ID).FirstOrDefault();

                oND.VUANID = VUANID;
                oND.CANBOID = CanBoID;
                oND.MAVAITRO = MaVaiTro;
                oND.THUKYID = Convert.ToDecimal(ddlThuky.SelectedValue);
                oND.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);
                try
                {
                    oND.THULYID = ThuLyID;
                }
                catch { }
                oND.SOQD = txtSoQD.Text.Trim();
                oND.NGAYQD = (String.IsNullOrEmpty(txtNgayQD.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayQD.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime dNgayPhanCong = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYPHANCONG = dNgayPhanCong;

                DateTime dNgayNhanPhanCong = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYNHANPHANCONG = dNgayNhanPhanCong;

                DateTime dNgayKetthuc = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKETTHUC = dNgayKetthuc == DateTime.MinValue ? (DateTime?)null : dNgayKetthuc;
                oND.FILEID = UploadFileID(VUANID, "01-HS");

                if (ID == 0)
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";

                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AHS_THAMPHANGIAIQUYET.Add(oND);
                    dt.SaveChanges();
                    hddid.Value = ID.ToString();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                dt.SaveChanges();
                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                LoadGrid();
                ResetControls();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }
        protected void dropThuLy_SelectedIndexChanged(object sender, EventArgs e)
        {
            decimal VUANID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            decimal THULYID = Convert.ToDecimal(dropThuLy.SelectedValue);
            
            List<AHS_SOTHAM_QUYETDINH_VUAN> qd = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VUANID && x.THULYID == THULYID).ToList();
            List<AHS_SOTHAM_BANAN> qdBC = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VUANID && x.THULYID == THULYID).ToList();

            if (qd.Count == 0 && qdBC.Count == 0)
            {
                Cls_Comon.SetButton(cmdUpdate, true);
                Cls_Comon.SetButton(cmdLammoi, true);
            }
            else
            {
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
            }
            
            if (dropThuLy.SelectedValue != "0")
            {
                string TH_ThuLy = dropThuLy.SelectedItem.Text;
                String[] arrThuly = TH_ThuLy.Split('-');
                foreach (String item in arrThuly)
                {
                    if (item.Length > 0)
                        hddNgayThuLy.Value = item;
                }
            }
        }
        protected void txtNgayphancong_TextChanged(object sender, EventArgs e)
        {
            if (!String.IsNullOrEmpty(txtNgayphancong.Text.Trim()))
            {
                txtNhanphancong.Text = txtNgayphancong.Text;
                Cls_Comon.SetFocus(this, this.GetType(), ddlThamphan.ClientID);
            }
        }
        protected void txtNhanphancong_TextChanged(object sender, EventArgs e)
        {
            if (String.IsNullOrEmpty(txtNgayphancong.Text))
            {
                txtNhanphancong.Text = txtNgayphancong.Text;
                Cls_Comon.SetFocus(this, this.GetType(), txtNgayketthuc.ClientID);
            }
        }
        private void LoadCombobox()
        {
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable tbl = null;

            //--------------------------------------
            tbl = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlNguoiphancong.DataSource = tbl;
            ddlNguoiphancong.DataTextField = "MA_TEN";
            ddlNguoiphancong.DataValueField = "ID";
            ddlNguoiphancong.DataBind();

            //--------------------------------------
            //Load quốc tịch
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dtVaiTro = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.VAITROTHAMPHAN);

            //--------------------------------------
            tbl = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = tbl;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            //--------------------------------------
            ddlVaitro.DataSource = dtVaiTro;
            ddlVaitro.DataTextField = "TEN";
            ddlVaitro.DataValueField = "MA";
            ddlVaitro.DataBind();
            ddlVaitro.SelectedValue = ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETSOTHAM;
            ddlVaitro.Enabled = false;
        }
        private decimal UploadFileID(decimal VuAnID, string strMaBieumau)
        {
            decimal IDFIle = 0, IDBM = 0;
            AHS_VUAN oVuAn = dt.AHS_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oVuAn != null)
            {
                List<DM_BIEUMAU> lstBM = dt.DM_BIEUMAU.Where(x => x.MABM == strMaBieumau).ToList();
                if (lstBM.Count > 0)
                {
                    IDBM = lstBM[0].ID;
                }
                bool isNew = false;
                AHS_FILE objFile = dt.AHS_FILE.Where(x => x.VUANID == VuAnID && x.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && x.BIEUMAUID == IDBM).FirstOrDefault();
                if (objFile == null)
                {
                    isNew = true;
                    objFile = new AHS_FILE();
                }
                objFile.VUANID = VuAnID;
                objFile.TOAANID = oVuAn.TOAANID;
                objFile.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                objFile.LOAIFILE = 0;
                objFile.BIEUMAUID = IDBM;
                objFile.NAM = DateTime.Now.Year;
                objFile.NGAYTAO = DateTime.Now;
                objFile.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                //if (hddFilePath.Value != "")
                //{
                //    try
                //    {
                //        string strFilePath = "";
                //        if (chkKySo.Checked)
                //        {
                //            string[] arr = hddFilePath.Value.Split('/');
                //            strFilePath = arr[arr.Length - 1];
                //            strFilePath = Server.MapPath("~/TempUpload/") + strFilePath;
                //        }
                //        else
                //            strFilePath = hddFilePath.Value.Replace("/", "\\");

                //        byte[] buff = null;
                //        using (FileStream fs = File.OpenRead(strFilePath))
                //        {
                //            BinaryReader br = new BinaryReader(fs);
                //            FileInfo oF = new FileInfo(strFilePath);
                //            long numBytes = oF.Length;
                //            buff = br.ReadBytes((int)numBytes);
                //            objFile.NOIDUNG = buff;
                //            objFile.TENFILE = Cls_Comon.ChuyenTVKhongDau(oF.Name);
                //            objFile.KIEUFILE = oF.Extension;
                //        }
                //        File.Delete(strFilePath);
                //    }
                //    catch (Exception ex) { lbthongbao.Text = ex.Message; }
                //}
                if (isNew)
                {
                    dt.AHS_FILE.Add(objFile);
                }
                dt.SaveChanges();
                IDFIle = objFile.ID;
            }
            return IDFIle;
        }
        private bool CheckQDofThamPhan(decimal VuAnID, decimal TPID, decimal THULYID)
        {
            // kiểm tra các quyết định mà thẩm phán đã ký trong vụ án (nếu có)
            AHS_SOTHAM_QUYETDINH_BICAN obj_QDBiCan_BiCao = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.VUANID == VuAnID && x.NGUOIKYID == TPID && x.THULYID == THULYID).FirstOrDefault<AHS_SOTHAM_QUYETDINH_BICAN>();
            if (obj_QDBiCan_BiCao != null)
            {
                lbthongbao.Text = "Thẩm phán đã ký quyết định liên quan tới bị can, bị cáo. Không được xóa!";
                return false;
            }
            AHS_SOTHAM_QUYETDINH_VUAN obj_QD_VuAn = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VuAnID && x.NGUOIKYID == TPID && x.THULYID == THULYID).FirstOrDefault<AHS_SOTHAM_QUYETDINH_VUAN>();
            if (obj_QD_VuAn != null)
            {
                lbthongbao.Text = "Thẩm phán đã ký quyết định liên quan tới vụ án. Không được xóa!";
                return false;
            }
            AHS_SOTHAM_BANAN obj_BanAn = dt.AHS_SOTHAM_BANAN.Where(x => x.VUANID == VuAnID && x.NGUOIKY == TPID && x.THULYID == THULYID).FirstOrDefault<AHS_SOTHAM_BANAN>();
            if (obj_BanAn != null)
            {
                lbthongbao.Text = "Thẩm phán đã ký bản án sơ thẩm của vụ án. Không được xóa!";
                return false;
            }
            return true;
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            decimal VUANID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU] + "");
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                decimal donvi_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]?.ToString());
                //toancau Nhũng bản ghi được thêm sau khi nhận án lại để xét xử tiếp thì được áp dụng tuân theo quy trình xoá ngược ở giải đoạn sau 
                Decimal ID = Convert.ToDecimal(rowView["ID"].ToString());
                List<AHS_SOTHAM_THULY> thuly = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == VUANID).OrderByDescending(x => x.NGAYTHULY).ThenByDescending(x => x.ID).ToList();

                decimal THULYID = thuly[0].ID;
                
                AHS_THAMPHANGIAIQUYET obj = dt.AHS_THAMPHANGIAIQUYET.Where(x => x.ID == ID && x.THULYID == THULYID).FirstOrDefault();
                if (obj != null)
                {
                    AHS_CHUYEN_NHAN_AN chuyenan = dt.AHS_CHUYEN_NHAN_AN.Where(x => x.VUANID == VUANID).OrderByDescending(x => x.ID).FirstOrDefault();
                    if (chuyenan != null)
                    {
                        if (obj.NGAYTAO <= chuyenan.NGAYTAO)
                        {
                            List<AHS_SOTHAM_HDXX> NTHTT = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VUANID && x.THULYID == THULYID).ToList();
                            List<AHS_SOTHAM_QUYETDINH_VUAN> qd = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VUANID && x.THULYID == THULYID).ToList();
                            List<AHS_SOTHAM_QUYETDINH_BICAN> qdBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.VUANID == VUANID && x.THULYID == THULYID).ToList();
                            if ((NTHTT != null && NTHTT.Count > 0) || (qd != null && qd.Count > 0) || (qdBC != null && qdBC.Count > 0))
                            {
                                lblSua.Text = "Chi tiết";
                                lbtXoa.Visible = false;

                            }
                        }
                        else
                        {
                            List<AHS_SOTHAM_HDXX> NTHTT = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VUANID && x.NGAYTAO > chuyenan.NGAYTAO && x.THULYID == THULYID).ToList();
                            List<AHS_SOTHAM_QUYETDINH_VUAN> qd = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VUANID && x.NGAYTAO > chuyenan.NGAYTAO && x.THULYID == THULYID).ToList();
                            List<AHS_SOTHAM_QUYETDINH_BICAN> qdBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.VUANID == VUANID && x.NGAYTAO > chuyenan.NGAYTAO && x.THULYID == THULYID).ToList();
                            if ((NTHTT != null && NTHTT.Count > 0) || (qd != null && qd.Count > 0) || (qdBC != null && qdBC.Count > 0))
                            {
                                lblSua.Text = "Chi tiết";
                                lbtXoa.Visible = false;
                            }
                        }
                    }
                    else
                    {
                        AHS_SOTHAM_HDXX hdxx = dt.AHS_SOTHAM_HDXX.Where(x => x.VUANID == VUANID && x.TOA_GIAIQUYET_ID == donvi_ID && x.THULYID == THULYID).FirstOrDefault();
                        AHS_SOTHAM_QUYETDINH_BICAN qdBC = dt.AHS_SOTHAM_QUYETDINH_BICAN.Where(x => x.VUANID == VUANID && x.TOA_GIAIQUYET_ID == donvi_ID && x.THULYID == THULYID).FirstOrDefault();
                        AHS_SOTHAM_QUYETDINH_VUAN qdVA = dt.AHS_SOTHAM_QUYETDINH_VUAN.Where(x => x.VUANID == VUANID && x.TOA_GIAIQUYET_ID == donvi_ID && x.THULYID == THULYID).FirstOrDefault();
                        if (hdxx != null || qdBC != null || qdVA != null)
                        {
                            lblSua.Text = "Chi tiết";
                            lbtXoa.Visible = false;
                        }
                    }
                }
                else
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                // check quyền để hiển thị nút xoá
                HiddenField hddToaGiaiQuyetID = (HiddenField)e.Item.FindControl("hddToaGiaiQuyetID");
                string toaGiaiQuyetID = e.Item.Cells[9].Text.ToString();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toaGiaiQuyetID != donviID)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
            }
        }
    }
}
