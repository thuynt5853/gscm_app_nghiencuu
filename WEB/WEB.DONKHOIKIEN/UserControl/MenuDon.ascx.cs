using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK;
using BL.DonKK.DanhMuc;
using Module.Common;
using System.Globalization;
using System.Data;

namespace WEB.DONKHOIKIEN.UserControl
{
    public partial class MenuDon : System.Web.UI.UserControl
    {
        DKKContextContainer dt = new DKKContextContainer();
        public Decimal UserID = 0;
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (UserID>0)
            {
                int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
                if (MucDichSD != 2)
                    LoadData();
                else
                    pn.Visible = false;
            }   
            else
                pn.Visible = false;
        }
        public void LoadData()
        {
            Decimal SoLuong = 0;
            string temp = "";
            pn.Visible = true;
            DONKK_DON_BL obj = new DONKK_DON_BL();
            DataTable tbl = obj.CountByTrangThai(UserID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach(DataRow row in tbl.Rows)
                {
                    SoLuong += Convert.ToInt32(row["CountItem"] + "");
                }
                temp += "<li><a href='Dsdon.aspx' class='menu_countall'>Tổng số đơn<span>" + SoLuong + "</span></a></li>";

                //-----------------------------------------
                SoLuong = CountByTrangThai(tbl, 10);
                temp += "<li><a href='Dsdon.aspx?status=10'><div class='menu_dkk_title'>Đơn chưa gửi</div><span>" + SoLuong + "</span ></a></li>";

                SoLuong = CountByTrangThai(tbl, 0);
                temp += "<li><a href='Dsdon.aspx?status=0'><div class='menu_dkk_title'>Đơn đã gửi và chờ giải quyết</div><span>" + SoLuong + "</span></a></li>";
  
                SoLuong = CountByTrangThai(tbl, Convert.ToInt16(ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon));
                temp += "<li><a href='Dsdon.aspx?status=" + ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon + "'><div class='menu_dkk_title'>Đơn chờ bổ sung theo yêu cầu của Tòa án</div><span>" + SoLuong + "</span></a></li>";

                SoLuong = CountByTrangThai(tbl, Convert.ToInt16(ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon));
                temp += "<li><a href='Dsdon.aspx?status=" + ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon + "'><div class='menu_dkk_title'>Đơn bị Tòa án trả lại</div><span>" + SoLuong + "</span></a></li>";

                SoLuong = CountByTrangThai(tbl, Convert.ToInt16(ENUM_ADS_BIENPHAPGQ.ADS_ThuLy));
                temp += "<li><a href='Dsdon.aspx?status=" + ENUM_ADS_BIENPHAPGQ.ADS_ThuLy + "'><div class='menu_dkk_title'>Đơn đã thụ lý</div><span>" + SoLuong + "</span></a></li>";
                ltt.Text = temp;              
            }
            else
            {
                SoLuong = 0;
                temp += "<li><a href='Dsdon.aspx?status=10'><div class='menu_dkk_title'>Đơn chưa gửi</div><span>" + SoLuong + "</span></a></li>";
                temp += "<li><a href='Dsdon.aspx?status=0'><div class='menu_dkk_title'>Đơn đã gửi và chờ giải quyết</div><span>" + SoLuong + "</span></a></li>";                
                temp += "<li><a href='Dsdon.aspx?status=" + ENUM_ADS_BIENPHAPGQ.ADS_YCBoSungDon + "'><div class='menu_dkk_title'>Đơn chờ bổ sung theo yêu cầu của Tòa án</div><span>" + SoLuong + "</span></a></li>";                
                temp += "<li><a href='Dsdon.aspx?status=" + ENUM_ADS_BIENPHAPGQ.ADS_TraLaiDon + "'><div class='menu_dkk_title'>Đơn bị Tòa án trả lại</div><span>" + SoLuong + "</span></a></li>";                
                temp += "<li><a href='Dsdon.aspx?status=" + ENUM_ADS_BIENPHAPGQ.ADS_ThuLy + "'><div class='menu_dkk_title'>Đơn đã thụ lý</div><span>" + SoLuong + "</span></a></li>";
                ltt.Text = temp;
            }
        }
        int CountByTrangThai(DataTable tbl, int Trangthai)
        {
            DataRow[] arr = tbl.Select("TrangThai=" + Trangthai);
            if (arr != null && arr.Length > 0)
                return Convert.ToInt32(arr[0]["CountItem"] + "");
            else
                return 0;
        }
    }
}