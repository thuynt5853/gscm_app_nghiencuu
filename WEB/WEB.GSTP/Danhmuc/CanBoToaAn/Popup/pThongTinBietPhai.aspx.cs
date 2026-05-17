using BL.GSTP;
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

namespace WEB.GSTP.Danhmuc.CanBoToaAn.Popup
{
    public partial class pThongTinBietPhai : System.Web.UI.Page
    {
        private string PUBLIC_DEPT = "..";
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        private const int ROOT = 0;
        public decimal CanBoID = 0, hddBietPhaiID = 0;
        public DateTime minDate = new DateTime();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    CanBoID = (String.IsNullOrEmpty(Request["cbID"] + "")) ? 0 : Convert.ToDecimal(Request["cbID"] + "");
                    hddBietPhaiID = (String.IsNullOrEmpty(Request["bpID"] + "")) ? 0 : Convert.ToDecimal(Request["bpID"] + "");
                    txtNgaybatdau.Text = "";
                    txtNgayketthuc.Text = "";
                    LoadDdlToaAn();
                    LoadDdlChucVu();
                    LoadDdlChucDanh();
                    Load_Data();
                    ddlPhongBan.Items.Insert(0, new ListItem("Chọn", "0"));
                    if (hddBietPhaiID > 0)
                    {
                        DM_CANBO_BIETPHAI bietPhai = dt.DM_CANBO_BIETPHAI.Where(x => x.ID == hddBietPhaiID).FirstOrDefault();
                        ddlToaAn.SelectedValue = Convert.ToString(bietPhai.TOAANID);
                        LoadPhongBan();
                        ddlPhongBan.SelectedValue = Convert.ToString(bietPhai.PHONGBANID);
                        ddlChucDanh.SelectedValue = Convert.ToString(bietPhai.CHUCDANH);
                        ddlChucVu.SelectedValue = Convert.ToString(bietPhai.CHUCVU);
                        txtNgaybatdau.Text = ((DateTime)bietPhai.TUNGAY).ToString("dd/MM/yyyy");
                        txtNgayketthuc.Text = bietPhai.DENNGAY == null ? "" : ((DateTime)bietPhai.DENNGAY).ToString("dd/MM/yyyy");
                    }
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }

        }
        private void LoadDdlToaAn()
        {
            ddlToaAn.Items.Clear();
            ddlToaAn.DataSource = null;
            ddlToaAn.DataBind();
            ddlToaAn.Items.Add(new ListItem("Chọn", ROOT.ToString()));
            LoadDropParentListChild(0, "");
        }
        private void LoadDdlChucVu()
        {
            ddlChucVu.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dmChucVu = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.CHUCVU);
            if (dmChucVu != null && dmChucVu.Rows.Count > 0)
            {
                ddlChucVu.DataSource = dmChucVu;
                ddlChucVu.DataTextField = "TEN";
                ddlChucVu.DataValueField = "ID";
                ddlChucVu.DataBind();
            }
            ddlChucVu.Items.Insert(0, new ListItem("Không có chức vụ", "0"));
        }
        private void LoadDdlChucDanh()
        {
            ddlChucDanh.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dmChucDanh = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.CHUCDANH);
            if (dmChucDanh != null && dmChucDanh.Rows.Count > 0)
            {
                ddlChucDanh.DataSource = dmChucDanh;
                ddlChucDanh.DataTextField = "TEN";
                ddlChucDanh.DataValueField = "ID";
                ddlChucDanh.DataBind();
            }
            ddlChucDanh.Items.Insert(0, new ListItem("--Chọn--", "0"));
        }
        private void Load_Data()
        {
            CanBoID = (String.IsNullOrEmpty(Request["cbID"] + "")) ? 0 : Convert.ToDecimal(Request["cbID"] + "");
            DM_CANBO_BL CanBoBL = new DM_CANBO_BL();
            DataTable oDT = CanBoBL.DM_CANBO_BIETPHAI_SEARCH(CanBoID);
            if (oDT != null)
            {
                dgList.DataSource = oDT;
                dgList.DataBind();
                pndata.Visible = true;
            }
            else
            {
                pndata.Visible = false;
            }
        }
        private void LoadDropParentListChild(decimal pID, string dept)
        {
            List<DM_TOAAN> listchild = dt.DM_TOAAN.Where(x => x.CAPCHAID == pID).OrderBy(y => y.THUTU).ToList();
            if (listchild != null && listchild.Count > 0)
            {
                foreach (DM_TOAAN child in listchild)
                {
                    if(child.LOAITOA == "CAPHUYEN")
                    {
                        ddlToaAn.Items.Add(new ListItem(dept + child.MA_TEN, child.ID.ToString()));
                        LoadDropParentListChild(child.ID, PUBLIC_DEPT + dept);
                    }
                    else
                    {
                        ddlToaAn.Items.Add(new ListItem(dept + child.TEN, child.ID.ToString()));
                        LoadDropParentListChild(child.ID, PUBLIC_DEPT + dept);
                    }
                }
            }
        }
        protected void ddlToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            try { LoadPhongBan(); } catch (Exception ex) { /*lbthongbao.Text = ex.Message;*/ }
        }

        protected void txtNgaybatdau_TextChanged(object sender, EventArgs e)
        {
            try
            {
                txtNgayketthuc.Text = DateTime.Parse(this.txtNgaybatdau.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault).AddDays(30).ToString("dd/MM/yyyy");
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        private void LoadPhongBan()
        {
            decimal taID = Convert.ToDecimal(ddlToaAn.SelectedValue);
            List<DM_PHONGBAN> tbl = dt.DM_PHONGBAN.Where(x => x.TOAANID == taID).OrderBy(y => y.THUTU).ToList();
            if (tbl != null)
            {
                ddlPhongBan.DataSource = tbl;
                ddlPhongBan.DataTextField = "TENPHONGBAN";
                ddlPhongBan.DataValueField = "ID";
                ddlPhongBan.DataBind();
                ddlPhongBan.Items.Insert(0, new ListItem("Chọn", "0"));
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                CanBoID = (String.IsNullOrEmpty(Request["cbID"] + "")) ? 0 : Convert.ToDecimal(Request["cbID"] + "");
                DM_CANBO dmCanbo = dt.DM_CANBO.Where(x => x.ID == CanBoID).FirstOrDefault();
                
                if(ddlToaAn.SelectedIndex == 0)
                {
                    lbthongbao.Text = "Bạn chưa chọn đơn vị được biệt phái đến!";
                    Cls_Comon.SetFocus(this, this.GetType(), ddlToaAn.ClientID);
                    return;
                }
                else if (dmCanbo.TOAANID == Convert.ToDecimal(ddlToaAn.SelectedValue))
                {
                    lbthongbao.Text = "Không được biệt phái đến đơn vị hiện tại đang công tác!";
                    Cls_Comon.SetFocus(this, this.GetType(), ddlToaAn.ClientID);
                    return;
                }

                if (ddlChucDanh.SelectedIndex == 0)
                {
                    lbthongbao.Text = "Bạn chưa chọn chức danh!";
                    Cls_Comon.SetFocus(this, this.GetType(), ddlChucDanh.ClientID);
                    return;
                }
                if (Cls_Comon.IsValidDate(txtNgaybatdau.Text) == false)
                {
                    lbthongbao.Text = "Ngày bắt đầu chưa nhập hoặc không hợp lệ !";
                    txtNgaybatdau.Focus();
                    return;
                }
                if (Cls_Comon.IsValidDate(txtNgayketthuc.Text) == false)
                {
                    lbthongbao.Text = "Ngày kết thúc chưa nhập hoặc không hợp lệ !";
                    txtNgayketthuc.Focus();
                    return;
                }

                DateTime dTuNgay = (String.IsNullOrEmpty(txtNgaybatdau.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgaybatdau.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime dDenNgay = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dDenNgay != DateTime.MinValue && dTuNgay > dDenNgay)
                {
                    lbthongbao.Text = "Ngày bắt đầu không được lớn hơn ngày bắt kết thúc !";
                    return;
                }
                DM_CANBO_BIETPHAI obj = new DM_CANBO_BIETPHAI();
                hddBietPhaiID = (String.IsNullOrEmpty(Request["bpID"] + "")) ? 0 : Convert.ToDecimal(Request["bpID"] + "");
                if (hddBietPhaiID == 0)
                {
                    obj.TOAANID = Convert.ToDecimal(ddlToaAn.SelectedValue);
                    obj.CANBOID = (String.IsNullOrEmpty(Request["cbID"] + "")) ? 0 : Convert.ToDecimal(Request["cbID"] + "");
                    obj.PHONGBANID = Convert.ToDecimal(ddlPhongBan.SelectedValue);
                    obj.CHUCVU = Convert.ToDecimal(ddlChucVu.SelectedValue);
                    obj.CHUCDANH = Convert.ToDecimal(ddlChucDanh.SelectedValue);
                    obj.TUNGAY = dTuNgay;
                    obj.DENNGAY = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGAYTAO = DateTime.Now;
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.DM_CANBO_BIETPHAI.Add(obj);
                    dt.SaveChanges();
                }
                else
                {
                    obj = dt.DM_CANBO_BIETPHAI.Where(x => x.ID == hddBietPhaiID).FirstOrDefault();
                    obj.TOAANID = Convert.ToDecimal(ddlToaAn.SelectedValue);
                    obj.PHONGBANID = Convert.ToDecimal(ddlPhongBan.SelectedValue);
                    obj.CHUCVU = Convert.ToDecimal(ddlChucVu.SelectedValue);
                    obj.CHUCDANH = Convert.ToDecimal(ddlChucDanh.SelectedValue);
                    obj.TUNGAY = dTuNgay;
                    obj.DENNGAY = (String.IsNullOrEmpty(txtNgayketthuc.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayketthuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                lbthongbao.Text = "Cập nhật thành công !";
                Response.Write("<script>window.opener.location.reload();</" + "script>");

                reSetControl();
                Load_Data();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void btnLammoi_Click(object sender, EventArgs e)
        {
            try
            {
                reSetControl();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        private void reSetControl()
        {
            hddBietPhaiID = 0;
            ddlToaAn.SelectedIndex = 0;
            ddlChucVu.SelectedIndex = 0;
            ddlChucDanh.SelectedIndex = 0;
            LoadPhongBan();
            ddlPhongBan.SelectedIndex = 0;
            txtNgaybatdau.Text = "";
            txtNgayketthuc.Text = "";
            ddlToaAn.Focus();
            lbthongbao.Text = "";
        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ID = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    DM_CANBO_BIETPHAI bietPhai = dt.DM_CANBO_BIETPHAI.Where(x => x.ID == ID).FirstOrDefault();
                    ddlToaAn.SelectedValue = Convert.ToString(bietPhai.TOAANID);
                    LoadPhongBan();
                    hddBietPhaiID = ID;
                    ddlPhongBan.SelectedValue = Convert.ToString(bietPhai.PHONGBANID);
                    ddlChucVu.SelectedValue = Convert.ToString(bietPhai.CHUCVU);
                    ddlChucDanh.SelectedValue = Convert.ToString(bietPhai.CHUCDANH);
                    txtNgaybatdau.Text = ((DateTime)bietPhai.TUNGAY).ToString("dd/MM/yyyy");
                    txtNgayketthuc.Text = bietPhai.DENNGAY == null ? "" : ((DateTime)bietPhai.DENNGAY).ToString("dd/MM/yyyy");
                    break;
                case "Xoa":
                    DM_CANBO_BIETPHAI bp = dt.DM_CANBO_BIETPHAI.Where(x => x.ID == ID).FirstOrDefault();
                    if (bp != null)
                    {
                        dt.DM_CANBO_BIETPHAI.Remove(bp);
                        dt.SaveChanges();

                    }
                    Load_Data();
                    reSetControl();
                    lbthongbao.Text = "Xóa thành công!";
                    break;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
    }
}