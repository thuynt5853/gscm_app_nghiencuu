using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.THA;
using Module.Common;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System.Data;
namespace WEB.GSTP.QLAN.THA.DacXa
{
    public partial class PopupDacXa : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        Decimal BiAnID = 0;
        THA_DACXA obj = new THA_DACXA();
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                    load_infor();
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }
        void load_infor()
        {
            decimal THAID_VuAn = Convert.ToDecimal(Request.QueryString["IDVUAN"]);
            THA_VUAN objVuAn = dt.THA_VUAN.Where(x => x.ID == THAID_VuAn).FirstOrDefault();
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            if(objVuAn != null)
            {
                THA_DACXA TM = dt.THA_DACXA.Where(x => x.VUANID == objVuAn.ID).FirstOrDefault();
                if (TM != null)
                {
                    rdYeuCau_XoaAn.SelectedValue = TM.LOAIXOAANTICH + "";
                    if (!String.IsNullOrEmpty(TM.KETQUA + ""))
                        rdKetQua.SelectedValue = TM.KETQUA + "";
                }
            }
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            decimal THAID_VuAn = Convert.ToDecimal(Request.QueryString["IDVUAN"]);
            THA_VUAN objVuAn = dt.THA_VUAN.Where(x => x.ID == THAID_VuAn).FirstOrDefault();
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            if (objVuAn != null)
            {
                THA_DACXA obj = dt.THA_DACXA.Where(x => x.VUANID == objVuAn.ID).FirstOrDefault();
                if (obj != null)
                {
                    obj.KETQUA = Convert.ToDecimal(rdKetQua.SelectedValue);
                    dt.SaveChanges();
                    lbthongbao.Text = "Cập nhật thành công!";
                }
            }
            else
            {
                lbthongbao.Text = "Mã vụ án không tồn tại!";
            }
        }
    }
}