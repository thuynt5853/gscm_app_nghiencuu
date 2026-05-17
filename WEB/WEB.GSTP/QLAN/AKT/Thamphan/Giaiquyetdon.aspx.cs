using BL.GSTP;
using BL.GSTP.AKT;
using DAL.GSTP;
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

namespace WEB.GSTP.QLAN.AKT.Thamphan
{
    public partial class Giaiquyetdon : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Danhsach.aspx");
                
                decimal ID = Convert.ToDecimal(current_id);
                AKT_CHUYEN_NHAN_AN objCN = dt.AKT_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == ID && x.TRUONGHOPGIAONHANID == 266).FirstOrDefault();
                if (objCN != null)
                {
                    AKT_DON_XULY oldDonXuLy = dt.AKT_DON_XULY.Where(x => x.DONID == objCN.VUANID && x.LOAIGIAIQUYET == 1).FirstOrDefault();
                    if (oldDonXuLy == null)
                    {

                        LoadCombobox(Convert.ToDecimal(objCN.TOACHUYENID));

                    }
                    else
                    {
                        LoadCombobox(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                    }


                }
                else LoadCombobox(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
                CheckQuyen(ID);
                AKT_DON_XULY oDXuly = dt.AKT_DON_XULY.Where(x => x.DONID == ID && x.LOAIGIAIQUYET == 1).FirstOrDefault();
                if (oDXuly != null)
                {
                    lbthongbao.Text = "Đơn đã chuyển sang tòa án khác xử lý !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }
                LoadGrid();
            }
        }
        private void CheckQuyen(decimal ID)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            AKT_DON oT = dt.AKT_DON.Where(x => x.ID == ID).FirstOrDefault();
            if (oT != null)
            {
                hddNgayNhanDon.Value = oT.NGAYNHANDON + "" == "" ? "" : ((DateTime)oT.NGAYNHANDON).ToString("dd/MM/yyyy");
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lbthongbao.Text = "Vụ việc đã được chuyển lên tòa cấp trên, không được sửa đổi !";
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                    hddShowCommand.Value = "False";
                    return;
                }
            }
            List<AKT_SOTHAM_THULY> lstTL = dt.AKT_SOTHAM_THULY.Where(x => x.DONID == ID).ToList();
            if (lstTL.Count > 0)
            {
                lbthongbao.Text = "Đã thụ lý vụ việc không được sửa đổi !";
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
            string StrMsg = "Không được sửa đổi thông tin.";
            string Result = new AKT_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            if (Result != "")
            {
                lbthongbao.Text = Result;
                Cls_Comon.SetButton(cmdUpdate, false);
                Cls_Comon.SetButton(cmdLammoi, false);
                hddShowCommand.Value = "False";
                return;
            }
        }
        private void LoadCombobox(decimal toaID)
        {
            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
            ddlThamphan.DataSource = oCBDT;
            ddlThamphan.DataTextField = "HOTEN";
            ddlThamphan.DataValueField = "ID";
            ddlThamphan.DataBind();
            ddlThamphan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));

            ddlNguoiphancong.DataSource = oDMCBBL.DM_CANBO_GETBYDONVI_2CHUCVU(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCVU.CHUCVU_CA, ENUM_CHUCVU.CHUCVU_PCA);
            ddlNguoiphancong.DataTextField = "MA_TEN";
            ddlNguoiphancong.DataValueField = "ID";
            ddlNguoiphancong.DataBind();
           // ddlNguoiphancong.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));


            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dtVaiTro = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.VAITROTHAMPHAN);

            ddlVaitro.DataSource = dtVaiTro;
            ddlVaitro.DataTextField = "TEN";
            ddlVaitro.DataValueField = "MA";
            ddlVaitro.DataBind();
            ddlVaitro.SelectedValue = ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON;
            ddlVaitro.Enabled = false;
        }


        private void ResetControls()
        {

            txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
            txtNgayketthuc.Text = "";
            hddid.Value = "0";
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
            if (ddlThamphan.Items.Count > 0) ddlThamphan.SelectedValue = "0";
        }

        private bool CheckValid()
        {
            if (ddlThamphan.SelectedValue == "0")
            {
                lbthongbao.Text = "Bạn chưa chọn thẩm phán !";
                ddlThamphan.Focus();
                return false;
            }

            if (ddlVaitro.Items.Count == 0)
            {
                lbthongbao.Text = "Bạn chưa chọn vai trò thẩm phán !";
                ddlVaitro.Focus();
                return false;
            }
           /* if (Cls_Comon.IsValidDate(txtNgayphancong.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày phân công theo định dạng (dd/MM/yyyy) !";
                txtNgayphancong.Focus();
                return false;
            }
            DateTime DateNow = DateTime.Now;
            DateTime dNgayPC = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayPC > DateNow)
            {
                lbthongbao.Text = "Ngày phân công không được lớn hơn ngày hiện tại !";
                txtNgayphancong.Focus();
                return false;
            }
            if (hddNgayNhanDon.Value != "")
            {
                DateTime NgayNhanDon = DateTime.Parse(hddNgayNhanDon.Value, cul, DateTimeStyles.NoCurrentDateDefault);
                if (dNgayPC < NgayNhanDon)
                {
                    lbthongbao.Text = "Ngày phân công không được nhỏ hơn ngày nhận đơn " + hddNgayNhanDon.Value + " !";
                    txtNgayphancong.Focus();
                    return false;
                }
            }
            if (Cls_Comon.IsValidDate(txtNhanphancong.Text) == false)
            {
                lbthongbao.Text = "Bạn phải nhập ngày nhận phân công theo định dạng (dd/MM/yyyy) !";
                txtNhanphancong.Focus();
                return false;
            }
            DateTime dNgayNhan = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (dNgayNhan > DateNow)
            {
                lbthongbao.Text = "Ngày nhận phân công không được lớn hơn ngày hiện tại !";
                txtNhanphancong.Focus();
                return false;
            }
            if (dNgayNhan < dNgayPC)
            {
                lbthongbao.Text = "Ngày nhận phân công phải lớn hơn ngày phân công !";
                txtNhanphancong.Focus();
                return false;
            }
            */
            if (ddlNguoiphancong.Items.Count == 0)
            {
                lbthongbao.Text = "Bạn chưa chọn người phân công !";
                ddlNguoiphancong.Focus();
                return false;
            }
            return true;
        }
        protected void txtNgayphancong_TextChanged(object sender, EventArgs e)
        {
            txtNhanphancong.Text = txtNgayphancong.Text;
            txtNhanphancong.Focus();
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "", MaVaiTro = ddlVaitro.SelectedValue;
                decimal DONID = Convert.ToDecimal(current_id), CanBoID = Convert.ToDecimal(ddlThamphan.SelectedValue);

                AKT_DON_THAMPHAN oND;
                if (hddid.Value == "" || hddid.Value == "0")
                {
                    // Kiểm tra nếu thẩm phán đã được phân công rồi thì không phân lại nữa. Chọn thẩm phán khác
                    oND = dt.AKT_DON_THAMPHAN.Where(x => x.DONID == DONID && x.CANBOID == CanBoID && x.MAVAITRO == MaVaiTro).FirstOrDefault();
                    if (oND != null)
                    {
                        lbthongbao.Text = "Thẩm phán " + ddlThamphan.SelectedItem.Text + " đã được phân công. Hãy chọn lại!";
                        ddlThamphan.Focus();
                        return;
                    }
                    oND = new AKT_DON_THAMPHAN();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.AKT_DON_THAMPHAN.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.CANBOID = CanBoID;
                oND.MAVAITRO = MaVaiTro;
                oND.NGUOIPHANCONGID = Convert.ToDecimal(ddlNguoiphancong.SelectedValue);

                DateTime dNgayPhanCong = (String.IsNullOrEmpty(txtNgayphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYPHANCONG = dNgayPhanCong;

                DateTime dNgayNhanPhanCong = (String.IsNullOrEmpty(txtNhanphancong.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNhanphancong.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYNHANPHANCONG = dNgayNhanPhanCong;

                //DateTime dNgayThamGia = (String.IsNullOrEmpty(txtNgaythamgia.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaythamgia.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oND.NGAYTHAMGIA = dNgayThamGia == DateTime.MinValue ? (DateTime?)null : dNgayThamGia;

                DateTime dNgayKetthuc = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.NGAYKETTHUC = dNgayKetthuc == DateTime.MinValue ? (DateTime?)null : dNgayKetthuc;

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    if (oND.TOA_GIAIQUYET_ID == null)
                    {
                        oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    }
                    dt.AKT_DON_THAMPHAN.Add(oND);
                    dt.SaveChanges();
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }                
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
        public void LoadGrid()
        {
            AKT_DON_THAMPHAN_BL oBL = new AKT_DON_THAMPHAN_BL();
            string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.AKT_DON_THAMPHAN_GETBY(ID, ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON);

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
                txtNgayphancong.Text = txtNhanphancong.Text = DateTime.Now.ToString("dd/MM/yyyy", cul);
                pndata.Visible = false;
            }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            ResetControls();
        }

        public void xoa(decimal id)
        {

            AKT_DON_THAMPHAN oND = dt.AKT_DON_THAMPHAN.Where(x => x.ID == id).FirstOrDefault();
            AKT_DON_XULY xld = dt.AKT_DON_XULY.Where(x => x.DONID == oND.DONID).FirstOrDefault();

            if (xld != null)
            {
                lbthongbao.Text = "Đã có giải quyết đơn, xóa không thành công!";
                return;
            }

            //Luu thong tin Thẩm phán giải quyết đơn trước khi xoa
            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            var json = new JavaScriptSerializer().Serialize(oND);
            ADS_DON_BL oBL = new ADS_DON_BL();
            if (oBL.HISTORY_ALLDATA_BY_VUANID(Convert.ToDecimal(oND.DONID), 4, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Thẩm phán giải quyết đơn án Kinh tế", "Xóa", json) == false)
            {
                lbthongbao.Text = "Xóa không thành công!";
                return;
            }//Ket thuc
             //Xoa Thẩm phán giải quyết đơn 
            dt.AKT_DON_THAMPHAN.Remove(oND);
            dt.SaveChanges();
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }

        public void loadedit(decimal ID)
        {

            AKT_DON_THAMPHAN oND = dt.AKT_DON_THAMPHAN.Where(x => x.ID == ID).FirstOrDefault();
            hddid.Value = oND.ID.ToString();
            if (ddlThamphan.Items.FindByValue(oND.CANBOID + "") != null)
                ddlThamphan.SelectedValue = oND.CANBOID + "";
            ddlVaitro.SelectedValue = oND.MAVAITRO;
            txtNgayphancong.Text = (oND.NGAYPHANCONG == DateTime.MinValue || oND.NGAYPHANCONG + "" == "") ? "" : ((DateTime)oND.NGAYPHANCONG).ToString("dd/MM/yyyy", cul);
            txtNhanphancong.Text = (oND.NGAYNHANPHANCONG == DateTime.MinValue || oND.NGAYNHANPHANCONG + "" == "") ? "" : ((DateTime)oND.NGAYNHANPHANCONG).ToString("dd/MM/yyyy", cul);
            txtNgayketthuc.Text = (oND.NGAYKETTHUC == DateTime.MinValue || oND.NGAYKETTHUC + "" == "") ? "" : ((DateTime)oND.NGAYKETTHUC).ToString("dd/MM/yyyy", cul);
            if (ddlNguoiphancong.Items.FindByValue(oND.NGUOIPHANCONGID + "") != null)
                ddlNguoiphancong.SelectedValue = oND.NGUOIPHANCONGID + "";
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    loadedit(ND_id);
                    hddid.Value = e.CommandArgument.ToString();
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false || cmdUpdate.Enabled == false)
                    {
                        lbthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "");
                    string StrMsg = "Không được sửa đổi thông tin.";
                    string Result = new AKT_CHUYEN_NHAN_AN_BL().Check_NhanAn(ID, StrMsg, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
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
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;
                LinkButton lblSua = (LinkButton)e.Item.FindControl("lblSua");
                Cls_Comon.SetLinkButton(lblSua, oPer.CAPNHAT);
                LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                Cls_Comon.SetLinkButton(lbtXoa, oPer.XOA);
                string current_id = Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                AKT_DON oT = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();


                



                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                int CheckBanAnST = (string.IsNullOrEmpty(rowView["CheckBanAnST"] + "")) ? 0 : Convert.ToInt16(rowView["CheckBanAnST"] + "");
                if (CheckBanAnST > 0)
                    lbtXoa.Visible = false;
                if (hddShowCommand.Value == "False")
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }
                AKT_DON_XULY oXL = dt.AKT_DON_XULY.Where(x => x.DONID == DONID || x.DON_XULYID == DONID).FirstOrDefault();
                if (oXL != null)
                {
                    lbtXoa.Visible = false;
                }
                string toagiaiquyetID = e.Item.Cells[6].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                }


                //Nếu mà là án đã kết thúc ẩn nút lưu 
                Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                if (anKetThuc == true)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;
                    Cls_Comon.SetButton(cmdUpdate, false);
                    Cls_Comon.SetButton(cmdLammoi, false);
                }
            }
        }
    }
}