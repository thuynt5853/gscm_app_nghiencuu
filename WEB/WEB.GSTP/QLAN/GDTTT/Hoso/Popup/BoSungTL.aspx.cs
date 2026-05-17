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


namespace WEB.GSTP.QLAN.GDTTT.Hoso.Popup
{
    public partial class BoSungTL : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        Decimal CurrentUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrentUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrentUserID == 0)
                Response.Redirect("/Login.aspx");
            else
            {
                if (!IsPostBack)
                {
                    string strVID = Request["vid"] + "";
                    if (strVID != "")
                    {
                        GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                        decimal ID = Convert.ToDecimal(strVID);
                        LoadDSTL();
                        GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == ID).FirstOrDefault();
                        try
                        {
                            txtSoThuLy.Text = oBL.TL_GETMAXTT(Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), DateTime.Now.Year, Cls_Comon.GetNumber(oDon.BAQD_LOAIAN)).ToString();
                            txtNgaythuly.Text = DateTime.Now.ToString("dd/MM/yyyy");
                        }
                        catch (Exception ex) { }
                    }
                }
            }
        }
        private void LoadDSTL()
        {
            string strVID = Request["vid"] + "";
            if (strVID != "")
            {
                GDTTT_DON_BL oBL = new GDTTT_DON_BL();
                decimal ID = Convert.ToDecimal(strVID);
                dgDS.DataSource = oBL.BOSUNGTAILIEU(ID);
                dgDS.DataBind();
            }
        }
        protected void chkLydoCDDK_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (chkLydoCDDK.Items[2].Selected)
                trLydokhac.Visible = true;
            else
                trLydokhac.Visible = false;          

        }
        private bool CheckValid()
        {
            if (txtNgayBoSung.Text == "" || Cls_Comon.IsValidDate(txtNgayBoSung.Text) == false)
            {
                lbthongbao.Text = "Ngày bổ sung chưa nhập hoặc không hợp lệ. Hãy nhập lại!";
                txtNgayBoSung.Focus();
                return false;
            }
            if (rdbTrangThai.SelectedValue == "0")//Thụ lý
            {
                if (txtSoThuLy.Text == "")
                {
                    lbthongbao.Text = "Chưa nhập số thụ lý!";
                    txtSoThuLy.Focus();
                    return false;
                }
                if (txtNgaythuly.Text == "" || Cls_Comon.IsValidDate(txtNgaythuly.Text) == false)
                {
                    lbthongbao.Text = "Ngày thụ lý chưa nhập hoặc không hợp lệ. Hãy nhập lại!";
                    txtNgaythuly.Focus();
                    return false;
                }
            }
            else
            {
                if (chkLydoCDDK.Items[0].Selected==false && chkLydoCDDK.Items[1].Selected==false && chkLydoCDDK.Items[2].Selected==false)
                {
                    lbthongbao.Text = "Chưa chọn lý do!";
                    chkLydoCDDK.Focus();
                    return false;
                }
            }
            return true;
        }
        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            if (!CheckValid()) return;
            GDTTT_DON_BOSUNG oT;
            string strVID = Request["vid"] + "";
            GDTTT_DON_BL oBL = new GDTTT_DON_BL();
            decimal DONID = Convert.ToDecimal(strVID);
            GDTTT_DON oDon = dt.GDTTT_DON.Where(x => x.ID == DONID).FirstOrDefault();
            if (hddid.Value == "" || hddid.Value == "0")
            {
                oT = new GDTTT_DON_BOSUNG();
            }
            else
            {
                decimal ID = Convert.ToDecimal(hddid.Value);
                oT = dt.GDTTT_DON_BOSUNG.Where(x => x.ID == ID).FirstOrDefault();
            }
            oT.DONID = DONID;
            oT.NGAYBOSUNG = (String.IsNullOrEmpty(txtNgayBoSung.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayBoSung.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            oT.SOHIEU = txtSohieudon.Text;
            oT.TRANGTHAI = Convert.ToDecimal(rdbTrangThai.SelectedValue);
            //----05/07/2024
            oDon.NGAYSUA = DateTime.Now;
            oDon.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            //----05/07/2024 end
            if (rdbTrangThai.SelectedValue == "0")
            {//Thụ lý mới
                oDon.CD_TA_TRANGTHAI = 0;
                oDon.ISTHULY = 1;
                oDon.TL_SO = txtSoThuLy.Text;
                oDon.TL_SOTT = Cls_Comon.GetNumber(oDon.TL_SO);
                oDon.TL_NGAY = txtNgaythuly.Text == "" ? (DateTime?)null : DateTime.Parse(txtNgaythuly.Text, cul, DateTimeStyles.NoCurrentDateDefault);
                //Them nay xu ly don 
                if (oDon.CD_TA_TRANGTHAI != Convert.ToDecimal(rdbTrangThai.SelectedValue))
                    oDon.NGAYXULYDON = DateTime.Now;
            }
            else//Đơn vẫn chưa đủ điều kiện
            {
                oT.ISBA = chkLydoCDDK.Items[0].Selected ? 1 : 0;
                oT.ISXACNHAN = chkLydoCDDK.Items[1].Selected ? 1 : 0;
                oT.ISKHAC = chkLydoCDDK.Items[2].Selected ? 1 : 0;
                if (oT.ISKHAC == 1)
                    oT.LYDOKHAC = txtLydoCDDK_Khac.Text;
            }
            oT.GHICHU = txtGhichu.Text;
            if (hddid.Value == "" || hddid.Value == "0")
            {
                dt.GDTTT_DON_BOSUNG.Add(oT);
                dt.SaveChanges();
            }
            else
            {
                dt.SaveChanges();
            }
            lbthongbao.Text = "Cập nhật thành công!";
            LoadDSTL();
            txtNgayBoSung.Text = "";
            txtSohieudon.Text = "";
            txtSoThuLy.Text = "";
            txtNgaythuly.Text = "";
            txtGhichu.Text = "";
            hddid.Value = "0";
            txtLydoCDDK_Khac.Text = "";
            chkLydoCDDK.Items[0].Selected = false;
            chkLydoCDDK.Items[1].Selected = false;
            chkLydoCDDK.Items[2].Selected = false;
            //Cls_Comon.CallFunctionJS(this, this.GetType(), "Reload_KQ();");
        }
        protected void dgDS_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "Sua":
                    lbthongbao.Text = "";
                    decimal bsID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BOSUNG obsT = dt.GDTTT_DON_BOSUNG.Where(x => x.ID == bsID).FirstOrDefault();
                    hddid.Value = bsID.ToString();
                    txtNgayBoSung.Text = ((DateTime)obsT.NGAYBOSUNG).ToString("dd/MM/yyyy");
                    txtSohieudon.Text = obsT.SOHIEU+"";
                    txtGhichu.Text = obsT.GHICHU;
                    if(obsT.TRANGTHAI==0)
                    {
                        rdbTrangThai.SelectedValue = "0";
                    }
                    else
                    {
                        rdbTrangThai.SelectedValue = "1";
                        chkLydoCDDK.Items[0].Selected = obsT.ISBA == 1 ? true : false;
                        chkLydoCDDK.Items[1].Selected = obsT.ISXACNHAN == 1 ? true : false;
                        chkLydoCDDK.Items[2].Selected = obsT.ISKHAC == 1 ? true : false;
                        if (obsT.ISKHAC == 1)
                            txtLydoCDDK_Khac.Text = obsT.LYDOKHAC;
                    }
                    break;
                case "Xoa":
                    decimal ID = Convert.ToDecimal(e.CommandArgument.ToString());
                    GDTTT_DON_BOSUNG oT = dt.GDTTT_DON_BOSUNG.Where(x => x.ID == ID).FirstOrDefault();
                    dt.GDTTT_DON_BOSUNG.Remove(oT);
                    dt.SaveChanges();
                    lbthongbao.Text = "Xóa thành công!";
                    LoadDSTL();
                    break;
            }
        }
        protected void rdbTrangThai_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rdbTrangThai.SelectedValue == "0")
            {
                trThuly.Visible = true;
                pnKhac.Visible = false;
            }
            else
            {
                trThuly.Visible = false;
                pnKhac.Visible = true;
            }
        }
    }
}