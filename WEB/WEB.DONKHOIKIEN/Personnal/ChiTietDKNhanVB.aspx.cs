using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using System.Globalization;

using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;

using BL.GSTP;
using DAL.GSTP;
using BL.GSTP.Danhmuc;
namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class ChiTietDKNhanVB : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
        Decimal UserID = 0;
        public String GroupDKyID = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            
            if (UserID > 0)
            {
                GroupDKyID = Request["group"] + "";
                 if (!IsPostBack)
                {
                    if (Request["group"] != null)
                        LoadInfo();
                }
            }
            else Response.Redirect("/Trangchu.aspx");
        }
        void LoadInfo()
        {            
            DOnKK_User_DKNhanVB_BL obj = new DOnKK_User_DKNhanVB_BL();
            DataTable tbl = obj.GetInfoDangKyNhanVB(GroupDKyID);
            if(tbl != null && tbl.Rows.Count>0)
            {
                DataRow root = tbl.Rows[0];

                lttDuongSu.Text = root["TenDuongSu"] + "";
                lttCMND.Text = root["CMND"] + "";
                lttToaAn.Text = root["TenToaAn"] + "";
                lttMaDangKy.Text = root["MaDangKy"] + "";
                lttNgayDK.Text = (Convert.ToDateTime(root["NgayTao"]+"")).ToString("dd/MM/yyyy", cul);
                //lttTrangThai.Text = root["TrangThaiDuyet"] + "";
               
                //-------------------------------
                int trangthai = 0;
                bool ShowGhiChu = false; 
                foreach(DataRow row in tbl.Rows)
                {
                    trangthai = Convert.ToInt16(row["TrangThai"] + "");
                    if (trangthai==0)
                    {
                        ShowGhiChu = true;
                        break;
                    }
                }
                int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
                if (MucDichSD == 2 && ShowGhiChu== true)
                    lttGhichu.Text += "Để nhận văn bản, thông báo mới từ Tòa án, bạn cần in đăng ký này và đem hồ sơ, giấy tờ tương ứng đến Tòa án để xác nhận đăng ký hợp lệ.";

                //------------------
                rpt.DataSource = tbl;
                rpt.DataBind();
            }
        }

        protected void lkQuayLai_Click(object sender, EventArgs e)
        {
            Response.Redirect("/Personnal/DsDangKyNhanVBTongDat.aspx");
        }
    }
}