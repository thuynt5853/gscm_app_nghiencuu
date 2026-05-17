using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;

using DAL.GSTP;
using BL.GSTP;
using BL.GSTP.Danhmuc;
using BL.DonKK.DanhMuc;

using BL.DonKK;
using Module.Common;



namespace WEB.DONKHOIKIEN.UserControl
{
    public partial class Home_ThongBao : System.Web.UI.UserControl
    {
        GSTPContext gsdt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
           if (!IsPostBack)
            {
                LoadThongBao();
                LoadHuongDan();
                SearchToaAn();
                //LoadThongTinHoTro();
            }
        }
        void LoadThongBao()
        {
            DonKK_TinTuc_BL obj = new DonKK_TinTuc_BL();
            int soluong = Convert.ToInt16(hddSoLuong.Value);
            DataTable tbl = obj.GetTopByGroupCM(soluong, hddGroupNewsTT.Value);
            if (tbl != null && tbl.Rows.Count>0)
            {
                lstThongBao.Text = "<a href='DStin.aspx?cID=" + tbl.Rows[0]["CHUYENMUCID"] + "'>"+ tbl.Rows[0]["TENCHUYENMUC"] + "</a>";
                rpt.DataSource = tbl;
                rpt.DataBind();
            }            
        }
        void LoadHuongDan()
        {
            DonKK_TinTuc_BL obj = new DonKK_TinTuc_BL();
            int soluong = Convert.ToInt16(hddSoLuong.Value);
            DataTable tbl1 = obj.GetTopByGroupCM(soluong, hddGroupNewsHH.Value);
            if (tbl1 != null && tbl1.Rows.Count > 0)
            {
                lstHuongDan.Text = "<a href='DStin.aspx?cID=" + tbl1.Rows[0]["CHUYENMUCID"] + "'>" + tbl1.Rows[0]["TENCHUYENMUC"] + "</a>";
                rpt2.DataSource = tbl1;
                rpt2.DataBind();
            }
        }
        //void LoadThongTinHoTro()
        //{
        //    DM_TRANGTINH_BL obj = new DM_TRANGTINH_BL();
        //    string str_tthotro = obj.GetNoiDungByMaTrang("thongtinhotro");
        //    lstThongtinHT.Text = str_tthotro;
        //}
        void SearchToaAn()
        {
            int Soluong = 0;            
            List<string> arr = new List<string>();
            String textsearch = "";
            dropToaAn.Items.Clear(); 
            dropToaAn.Items.Add(new ListItem("---Chọn Tòa án---", "0"));

            DM_TOAAN_BL obj = new DM_TOAAN_BL();
            DataTable tbl = obj.GetAllToaSoTham(textsearch, Soluong);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                foreach (DataRow row in tbl.Rows)
                    dropToaAn.Items.Add(new ListItem(row["MA_TEN"]+"", row["ID"]+""));
            }
            //---------------------
            String Str = "<div class='thongtin_hd' style='width:48%;float:left;margin-right:2%;'>";
            Str += "<div class='thongtin_hd_icon_dt'>&nbsp;</div>";
            Str += "<div class='thongtin_hd_top'><b>Điện thoại</b></div>";
            Str += "<div class='thongtin_hd_bottom'></div>";
            Str += "</div>";
            //---------------------
            Str += "<div class='thongtin_hd' style='width:49%;'>";
            Str += "<div class='thongtin_hd_icon_em'>&nbsp;</div>";
            Str += "<div class='thongtin_hd_top'><b>Email</b></div>";
            Str += "<div class='thongtin_hd_bottom'></div>";
            Str += "</div>";
            //---------------------
            Str += "<div class='thongtin_hd_2'>";
            Str += "<div class='thongtin_hd_icon_dc'>&nbsp;</div>";
            Str += "<div class='thongtin_hd_top'><b>Địa chỉ</b></div>";
            Str += "<div class='thongtin_hd_bottom'></div>";
            Str += "</div>";
            lstThongtinHT.Text = Str;
        }
        protected void dropToaAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            String Str = "";
            String DIENTHOAI = "", EMAIL = "", DIACHI = "";
            if (dropToaAn.SelectedValue != "0")
            {               
                Decimal ToaAnID = Convert.ToDecimal(dropToaAn.SelectedValue);
                DM_TOAAN obj = gsdt.DM_TOAAN.Where(x=>x.ID== ToaAnID).Single<DM_TOAAN>();
                if (obj != null)
                {
                    DIENTHOAI = obj.DIENTHOAI;
                    EMAIL = obj.EMAIL;
                    DIACHI = obj.DIACHI;
                }
            }
            Str = "<div class='thongtin_hd' style='width:48%;float:left;margin-right:2%;'>";
            Str += "<div class='thongtin_hd_icon_dt'>&nbsp;</div>";
            Str += "<div class='thongtin_hd_top'><b>Điện thoại</b></div>";
            Str += "<div class='thongtin_hd_bottom'>" + DIENTHOAI + "</div>";
            Str += "</div>";
            //---------------------
            Str += "<div class='thongtin_hd' style='width:49%;'>";
            Str += "<div class='thongtin_hd_icon_em'>&nbsp;</div>";
            Str += "<div class='thongtin_hd_top'><b>Email</b></div>";
            Str += "<div class='thongtin_hd_bottom'>" + EMAIL + "</div>";
            Str += "</div>";
            //---------------------
            Str += "<div class='thongtin_hd_2'>";
            Str += "<div class='thongtin_hd_icon_dc'>&nbsp;</div>";
            Str += "<div class='thongtin_hd_top'><b>Địa chỉ</b></div>";
            Str += "<div class='thongtin_hd_bottom'>" + DIACHI + "</div>";
            Str += "</div>";
            lstThongtinHT.Text = Str;
        }
    }
}