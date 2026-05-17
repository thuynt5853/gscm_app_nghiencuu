using BL.GSTP;
using BL.GSTP.ADS;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.ADS.Phuctham
{
    public partial class Hoagiai : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                    if (current_id == "") Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx");
                    LoadCombobox();
                    hddPageIndex.Value = "1";
                    dgList.CurrentPageIndex = 0;
                    LoadGrid();
                    if (dgList.Items.Count > 0)
                    {
                        decimal ID = Convert.ToDecimal(current_id);
                        ADS_PHUCTHAM_BL oBL = new ADS_PHUCTHAM_BL();
                        DataTable oDT = oBL.ADS_PHUCTHAM_HOAGIAI_GETLIST(ID);
                        loadedit(Convert.ToDecimal(oDT.Rows[0]["ID"]));
                    }
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdUpdate, oPer.CAPNHAT);
                    Cls_Comon.SetButton(cmdLammoi, oPer.CAPNHAT);
                    //Kiểm tra thẩm phán giải quyết đơn             
                    decimal DONID = Convert.ToDecimal(current_id);
                    ADS_DON oT = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    List<ADS_PHUCTHAM_THULY> lstCount = dt.ADS_PHUCTHAM_THULY.Where(x => x.DONID == DONID).ToList();
                    if (lstCount.Count == 0 || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Chưa cập nhật thông tin thụ lý phúc thẩm!";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    List<ADS_DON_THAMPHAN> lstTP = dt.ADS_DON_THAMPHAN.Where(x => x.DONID == DONID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).ToList();
                    if (lstTP.Count == 0)
                    {
                        lbthongbao.Text = "Chưa phân công thẩm phán giải quyết !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển lên tòa án cấp trên, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                    {
                        lbthongbao.Text = "Vụ việc đã được chuyển xét xử lại cấp sơ thẩm, không được sửa đổi !";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                        return;
                    }
                    //DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                    //DataTable oCBDT = oDMCBBL.CHECK_CHUCDANH_THUKY_USER(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THUKY, (decimal)Session[ENUM_SESSION.SESSION_CANBOID]);
                    //int counttk = oCBDT.Rows.Count;
                    //if (counttk > 0)
                    //{
                    //    //là thư k
                    //    decimal IdNhomNguoiSuDung = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_NHOMNSDID]);
                    //    decimal CurrentUserId = (decimal)Session[ENUM_SESSION.SESSION_CANBOID];
                    //    //int count = dt.QT_NHOMNGUOIDUNG.Count(s => s.ID == IdNhomNguoiSuDung && (s.TEN.Contains("HCTP") || s.TEN.Contains("TAND")));
                    //    int countItem = dt.ADS_DON_THAMPHAN.Count(s => s.THUKYID == CurrentUserId && s.DONID == DONID && s.MAVAITRO == "VTTP_GIAIQUYETPHUCTHAM");
                    //    if (countItem > 0)
                    //    {
                    //        //được gán 
                    //    }
                    //    else
                    //    {
                    //        //không được gán
                    //        string StrMsg = "Người dùng không được sửa đổi thông tin của vụ việc do không được phân công giải quyết.";
                    //        lbthongbao.Text = StrMsg;
                    //        Cls_Comon.SetButton(cmdUpdate, false);
                    //        Cls_Comon.SetButton(cmdLammoi, false);
                    //        return;
                    //    }
                    //}

                    //check vụ án đã kết thúc không cho sửa xóa
                    Boolean anKetThuc = Session[ENUM_LOAIAN.AN_DA_KET_THUC] != null ? Convert.ToBoolean(Session[ENUM_LOAIAN.AN_DA_KET_THUC]) : false;
                    if (anKetThuc)
                    {
                        lbthongbao.Text = "Vụ án đã kết thúc tại tòa cũ, không thể chỉnh sửa tại tòa mới";
                        Cls_Comon.SetButton(cmdUpdate, false);
                        Cls_Comon.SetButton(cmdLammoi, false);
                      
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
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
                string toagiaiquyetID = e.Item.Cells[8].Text.Trim();
                string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
               
                string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                decimal DONID = Convert.ToDecimal(current_id);
                ADS_DON oT = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
                if (oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.THULYGDT || oT.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                {
                    lblSua.Text = "Chi tiết";
                    lbtXoa.Visible = false;
                }

                if (toagiaiquyetID != donviID)
                {
                    lbtXoa.Visible = false;
                    lblSua.Visible = false;                    
                }
            }
        }
        private void LoadCombobox()
        {
            //Load cán bộ
            DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
            DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]));
            ddlNguoiky.DataSource = oCBDT;
            ddlNguoiky.DataTextField = "MA_TEN";
            ddlNguoiky.DataValueField = "ID";
            ddlNguoiky.DataBind();
        }
        private void ResetControls()
        {
            ddlLoaithongbao.SelectedIndex = 0;
            ddlNguoiky.SelectedIndex = 0;
            txtSothongbao.Text = "";
            txtNgaythongbao.Text = "";
            hddid.Value = "0";
        }
        private bool CheckValid()
        {
            int lengthSoThongBao = txtSothongbao.Text.Trim().Length;
            if (lengthSoThongBao == 0)
            {
                lbthongbao.Text = "Bạn chưa nhập số thông báo!";
                txtSothongbao.Focus();
                return false;
            }
            else if (lengthSoThongBao > 50)
            {
                lbthongbao.Text = "Số thông báo không nhập quá 50 ký tự. Hãy nhập lại!";
                txtSothongbao.Focus();
                return false;
            }

            if (Cls_Comon.IsValidDate(txtNgaythongbao.Text) == false)
            {
                lbthongbao.Text = "Ngày thông báo chưa nhập hoặc không hợp lệ !";
                return false;
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
                string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
                decimal DONID = Convert.ToDecimal(current_id);

                ADS_PHUCTHAM_HOAGIAI oND;
                if (hddid.Value == "" || hddid.Value == "0")
                    oND = new ADS_PHUCTHAM_HOAGIAI();
                else
                {
                    decimal ID = Convert.ToDecimal(hddid.Value);
                    oND = dt.ADS_PHUCTHAM_HOAGIAI.Where(x => x.ID == ID).FirstOrDefault();
                }
                oND.DONID = DONID;
                oND.LOAITHONGBAO = Convert.ToDecimal(ddlLoaithongbao.SelectedValue);
                oND.NGAY = (String.IsNullOrEmpty(txtNgaythongbao.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgaythongbao.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oND.SO = txtSothongbao.Text;
                oND.NGUOIKY = Convert.ToDecimal(ddlNguoiky.SelectedValue);

                if (hddid.Value == "" || hddid.Value == "0")
                {
                    oND.NGAYTAO = DateTime.Now;
                    oND.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    oND.TOA_GIAIQUYET_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    dt.ADS_PHUCTHAM_HOAGIAI.Add(oND);
                }
                else
                {
                    oND.NGAYSUA = DateTime.Now;
                    oND.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                }
                dt.SaveChanges();
                lbthongbao.Text = "Lưu thành công!";
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
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
            lbthongbao.Text = "";
            ADS_PHUCTHAM_BL oBL = new ADS_PHUCTHAM_BL();
            string current_id = Session[ENUM_LOAIAN.AN_DANSU] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable oDT = oBL.ADS_PHUCTHAM_HOAGIAI_GETLIST(ID);

            if (oDT != null && oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Convert.ToInt32(oDT.Rows.Count), dgList.PageSize).ToString();
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
            ADS_PHUCTHAM_HOAGIAI oND = dt.ADS_PHUCTHAM_HOAGIAI.Where(x => x.ID == id).FirstOrDefault();

            //Anhpn 
            var currenttoaid = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            decimal DONID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU] + "");
            ADS_PHUCTHAM_QUYETDINH ADS_PHUCTHAM_QUYETDINH = dt.ADS_PHUCTHAM_QUYETDINH.Where(x => x.DONID == DONID && x.TOA_GIAIQUYET_ID == currenttoaid).FirstOrDefault<ADS_PHUCTHAM_QUYETDINH>();
            if (ADS_PHUCTHAM_QUYETDINH != null)
            {
                lbthongbao.Text = "Xóa không thành công! Do đang tồn tại quyết định vụ việc.";
                return;
            }
            ADS_PHUCTHAM_BANAN ADS_PHUCTHAM_BANAN = dt.ADS_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault<ADS_PHUCTHAM_BANAN>();
            if (ADS_PHUCTHAM_BANAN != null)
            {
                lbthongbao.Text = "Xóa không thành công! Do đang tồn tại bản án.";
                return;
            }

            dt.ADS_PHUCTHAM_HOAGIAI.Remove(oND);
            dt.SaveChanges();
            hddPageIndex.Value = "1";
            dgList.CurrentPageIndex = 0;
            LoadGrid();
            ResetControls();
            lbthongbao.Text = "Xóa thành công!";
        }
        public void loadedit(decimal ID)
        {
            lbthongbao.Text = "";
            ADS_PHUCTHAM_HOAGIAI oND = dt.ADS_PHUCTHAM_HOAGIAI.Where(x => x.ID == ID).FirstOrDefault();
            txtSothongbao.Text = oND.SO;
            ddlLoaithongbao.SelectedValue = oND.LOAITHONGBAO.ToString();
            txtNgaythongbao.Text = string.IsNullOrEmpty(oND.NGAY + "") ? "" : ((DateTime)oND.NGAY).ToString("dd/MM/yyyy", cul);
            ddlNguoiky.SelectedValue = oND.NGUOIKY.ToString();
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal ND_id = Convert.ToDecimal(e.CommandArgument.ToString());
                switch (e.CommandName)
                {
                    case "Sua":
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
                        xoa(ND_id);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
    }
}