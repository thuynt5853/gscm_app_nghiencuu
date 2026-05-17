using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.THA;
using Module.Common;
using BL.GSTP.Danhmuc;
using System.Globalization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;

namespace WEB.GSTP.QLAN.THA.DacXa
{
    public partial class KetQua : System.Web.UI.Page
    {
        CultureInfo cul = new CultureInfo("vi-VN");
        GSTPContext dt = new GSTPContext();
        Decimal BiAnID = 0;
        THA_DACXA obj = new THA_DACXA();
        Decimal CurrUserID = 0;
        public string NgaySoSanh;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                    if (BiAnID > 0)
                    {
                        pn.Visible = true;
                        BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                        load_infor();
                        CheckQuyen();
                    }
                    else
                    {
                        pn.Visible = false;
                        lbthongbao_top.Text = "Bạn cần chọn bị án để xử lý!";
                    }
                }
            }
            else
                Response.Redirect("/Login.aspx");
        }

        void CheckQuyen()
        {
            Boolean IsOk = true;
            try
            {
                THA_THULY obj = dt.THA_THULY.Where(x => x.BIANID == BiAnID).FirstOrDefault<THA_THULY>();
                if (obj != null)
                {
                    NgaySoSanh = ((DateTime)obj.NGAYTHULY).ToString("dd/MM/yyyy", cul);
                    IsOk = false;
                }
                else
                {
                    lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                    cmdUpdateVuAn.Visible = false;
                    IsOk = false;
                }
            }
            catch (Exception ex)
            {
                lttMsg.Text = "Bị án chưa có thông tin thụ lý. Bạn hãy kiểm tra lại!";
                cmdUpdateVuAn.Visible = false;
                IsOk = false;
            }
            //-----------------------------
            if (!IsOk)
            {
                try
                {
                    THA_BIAN_QUYETDINH objQD = dt.THA_BIAN_QUYETDINH.Where(x => x.BIANID == BiAnID).FirstOrDefault();
                    if (objQD != null)
                        NgaySoSanh = ((DateTime)objQD.NGAYTHIHANH).ToString("dd/MM/yyyy", cul);
                    else
                    {
                        lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                        cmdUpdateVuAn.Visible = false;
                        IsOk = false;
                    }
                }
                catch (Exception ex)
                {
                    lttMsg.Text = "Bị án chưa có quyết định thi hành án. Bạn hãy kiểm tra lại!";
                    cmdUpdateVuAn.Visible = false;
                    IsOk = false;
                }
            }
        }
        void load_infor()
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_DACXA TM = dt.THA_DACXA.Where(x => x.BIANID == BiAnID).FirstOrDefault();
            if (TM != null)
            {
                rdYeuCau_XoaAn.SelectedValue = TM.LOAIXOAANTICH + "";
                if (!String.IsNullOrEmpty(TM.KETQUA + ""))
                    rdKetQua.SelectedValue = TM.KETQUA + "";
            }
            // Kiểm tra TOA_GIAIQUYET_ID
            string donviID = Session[ENUM_SESSION.SESSION_DONVIID]?.ToString();
            if (!string.IsNullOrEmpty(donviID) && TM != null && TM.TOA_GIAIQUYET_ID.HasValue)
            {
                if (TM.TOA_GIAIQUYET_ID.ToString() != donviID)
                {
                    cmdUpdateVuAn.Visible = false;
                    lbthongbao.Text = "Đơn đã chuyển sang tòa khác, không thể chỉnh sửa.";
                }
            }
        }

        protected void cmdUpdate_Click(object sender, EventArgs e)
        {
            BiAnID = (String.IsNullOrEmpty(Session[ENUM_LOAIAN.AN_THA] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_DACXA obj = dt.THA_DACXA.Where(x => x.BIANID == BiAnID).FirstOrDefault();
            if (obj != null)
            {
                obj.KETQUA = Convert.ToDecimal(rdKetQua.SelectedValue);
                dt.SaveChanges();
                lbthongbao.Text = "Cập nhật thành công!";
            }
        }
    }
}