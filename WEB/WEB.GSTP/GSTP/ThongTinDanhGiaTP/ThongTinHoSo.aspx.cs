using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP.ThongTinDanhGiaTP
{
    public partial class ThongTinHoSo : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    LoadData();
                }
            }
            catch (Exception ex) { lbthongbaoUpdate.Text = ex.Message; }
        }
        private void LoadData()
        {
            decimal ThamPhanID = Session[ENUM_LOAIAN.AN_GSTP] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP] + "");
            GSTP_DANHGIAHOSO_TP obj = dt.GSTP_DANHGIAHOSO_TP.Where(x => x.THAMPHANID == ThamPhanID).FirstOrDefault();
            if (obj != null)
            {
                txtDanhGia_TP.Text = obj.NOIDUNGDANHGIA_TP;
                txtDanhGia_UBTP.Text = obj.NOIDUNGDANHGIA_UBTP;
            }
        }
        protected void cmdCapNhat_Click(object sender, EventArgs e)
        {
            try
            {
                lbthongbaoUpdate.Text = "";
                if (txtDanhGia_TP.Text.Trim() == "")
                {
                    lbthongbaoUpdate.Text = "Bạn chưa nhập lý do. Hãy nhập lại!";
                    txtDanhGia_TP.Focus();
                    return;
                }
                if (txtDanhGia_UBTP.Text.Trim() == "")
                {
                    lbthongbaoUpdate.Text = "Bạn chưa nhập lý do. Hãy nhập lại!";
                    txtDanhGia_UBTP.Focus();
                    return;
                }
                decimal ThamPhanID = Session[ENUM_LOAIAN.AN_GSTP] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP] + "");
                bool isNew = false;
                GSTP_DANHGIAHOSO_TP obj = dt.GSTP_DANHGIAHOSO_TP.Where(x => x.THAMPHANID == ThamPhanID).FirstOrDefault();
                if (obj == null)
                {
                    isNew = true;
                    obj = new GSTP_DANHGIAHOSO_TP();
                    obj.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj.NGAYTAO = DateTime.Now;
                    obj.THAMPHANID = ThamPhanID;
                }
                else
                {
                    obj.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    obj.NGAYSUA = DateTime.Now;
                }
                obj.NOIDUNGDANHGIA_TP = txtDanhGia_TP.Text.Trim();
                obj.NOIDUNGDANHGIA_UBTP = txtDanhGia_UBTP.Text.Trim();
                if (isNew)
                {
                    dt.GSTP_DANHGIAHOSO_TP.Add(obj);
                }
                dt.SaveChanges();
                lbthongbaoUpdate.Text = "Lưu thành công!";
            }
            catch (Exception ex) { lbthongbaoUpdate.Text = ex.Message; }
        }
    }
}