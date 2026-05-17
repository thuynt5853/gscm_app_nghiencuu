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
namespace WEB.GSTP.QLAN.GDTTT.PCTP
{
    public partial class Nghiphep : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    DM_CANBO_BL oDMCBBL = new DM_CANBO_BL();
                    DataTable oCBDT = oDMCBBL.DM_CANBO_GETBYDONVI_CHUCDANH(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), ENUM_CHUCDANH.CHUCDANH_THAMPHAN);
                    ddlThamphan.DataSource = oCBDT;
                    ddlThamphan.DataTextField = "HOTEN";
                    ddlThamphan.DataValueField = "ID";
                    ddlThamphan.DataBind();
                    ddlThamphan.Items.Insert(0, new ListItem("--Chọn thẩm phán--", "0"));
                    //Load Nam
                    ddlNam.Items.Clear();
                    for (int i= 2018; i <= DateTime.Now.Year;i++)
                    {
                        ddlNam.Items.Add(new ListItem(i.ToString(), i.ToString()));
                    }
                    ddlNam.Items.Insert(0,new ListItem("--Năm--", "0"));
                    hddPageIndex.Value = "1";
                    Load_Data();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdLuu, oPer.TAOMOI);
                    Cls_Comon.SetButton(cmdLammoi, oPer.TAOMOI);
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
      
        private void Load_Data()
        {
            DM_CANBO_BL CanBoBL = new DM_CANBO_BL();
            decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string KeySearch = txttimkiem.Text;
            decimal vNam = Convert.ToDecimal(ddlNam.SelectedValue);
            int CurPage = Convert.ToInt32(hddPageIndex.Value), PageSize = Convert.ToInt32(hddPageSize.Value);
            DataTable oDT = CanBoBL.DM_CANBO_CONGTAC_SEARCH(ToaAnID, KeySearch, vNam);
            if (oDT != null && oDT.Rows.Count > 0)
            {
                int Total = Convert.ToInt32(oDT.Rows.Count);
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, PageSize).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }
            dgList.PageSize = PageSize;
            dgList.DataSource = oDT;
            dgList.DataBind();

        }

        private void ResetControl()
        {
            hddID.Value = "0";
            ddlThamphan.SelectedIndex = 0;
            ddlThamphan.Enabled = true;
            txtTuNgay.Text = "";
            txtDenNgay.Text = "";
        }

        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            try
            {
              if(ddlThamphan.SelectedValue=="0")
                {
                    lbtthongbao.Text = "Chưa chọn thẩm phán !";
                    return;
                }
                if (Cls_Comon.IsValidDate(txtTuNgay.Text) == false)
                {
                    lbtthongbao.Text = "Từ ngày chưa nhập hoặc không hợp lệ !";
                    return ;
                }
                if (Cls_Comon.IsValidDate(txtDenNgay.Text) == false)
                {
                    lbtthongbao.Text = "Đến ngày chưa nhập hoặc không hợp lệ !";
                    return;
                }

                DateTime dTuNgay = (String.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                DateTime dDenNgay = (String.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                if (dTuNgay > dDenNgay)
                {
                    lbtthongbao.Text = "Ngày bắt đầu không được lớn hơn ngày bắt kết thúc !";                  
                    return;
                }
                DM_CANBO_CONGTAC obj = new DM_CANBO_CONGTAC();
                if(hddID.Value=="0")
                {
                    obj.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    obj.CANBOID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                    obj.HINHTHUC = Convert.ToDecimal(ddlHinhthuc.SelectedValue);
                    obj.TUNGAY = dTuNgay;
                    obj.DENNGAY = dDenNgay;
                    obj.NGAYTAO = DateTime.Now;
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME]+"";
                    obj.SONGAY=(decimal)dDenNgay.Subtract(dTuNgay).TotalDays+1;
                    dt.DM_CANBO_CONGTAC.Add(obj);
                    dt.SaveChanges();
                }
                else
                {
                    decimal ID = Convert.ToDecimal(hddID.Value);
                    obj = dt.DM_CANBO_CONGTAC.Where(x => x.ID == ID).FirstOrDefault();
                    obj.CANBOID = Convert.ToDecimal(ddlThamphan.SelectedValue);
                    obj.HINHTHUC = Convert.ToDecimal(ddlHinhthuc.SelectedValue);
                    obj.TUNGAY = dTuNgay;
                    obj.DENNGAY = dDenNgay;
                    obj.SONGAY = (decimal)dDenNgay.Subtract(dTuNgay).TotalDays+1;
                    obj.NGAYSUA = DateTime.Now;
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    dt.SaveChanges();
                }
                lbtthongbao.Text = "Cập nhật thành công !";
                ResetControl();
                hddPageIndex.Value = "1";
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void cmdLammoi_Click(object sender, EventArgs e)
        {
            ResetControl();
        }
        protected void Btntimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            decimal ID = Convert.ToDecimal(e.CommandArgument);
            switch (e.CommandName)
            {
                case "Sua":
                    DM_CANBO_CONGTAC obj=dt.DM_CANBO_CONGTAC.Where(x => x.ID == ID).FirstOrDefault();
                    ddlThamphan.SelectedValue = obj.CANBOID.ToString();
                    ddlThamphan.Enabled = false;
                    ddlHinhthuc.SelectedValue = obj.HINHTHUC.ToString();
                    hddID.Value = ID.ToString();
                    txtTuNgay.Text = ((DateTime)obj.TUNGAY).ToString("dd/MM/yyyy");
                    txtDenNgay.Text = ((DateTime)obj.DENNGAY).ToString("dd/MM/yyyy");
                    break;
                case "Xoa":

                    DM_CANBO_CONGTAC cbo = dt.DM_CANBO_CONGTAC.Where(x => x.ID == ID).FirstOrDefault<DM_CANBO_CONGTAC>();
                    if (cbo != null)
                    {
                        dt.DM_CANBO_CONGTAC.Remove(cbo);
                        dt.SaveChanges();
                    }
                    hddPageIndex.Value = "1";
                    Load_Data();
                    lbtthongbao.Text = "Xóa thành công!";
                    ResetControl();
                    break;
            }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
                {
                    LinkButton lbtSua = (LinkButton)e.Item.FindControl("lbtSua");
                    LinkButton lbtXoa = (LinkButton)e.Item.FindControl("lbtXoa");
                    lbtSua.Visible = oPer.CAPNHAT; lbtXoa.Visible = oPer.XOA;
                }
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = "1";
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                hddPageIndex.Value = lbCurrent.Text;
                Load_Data();
            }
            catch (Exception ex) { lbtthongbao.Text = ex.Message; }
        }
        #endregion

    }
}