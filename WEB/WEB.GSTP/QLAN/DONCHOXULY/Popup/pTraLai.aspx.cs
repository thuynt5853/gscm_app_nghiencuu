using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.DONCHOXULY.Popup
{
    public partial class pTraLai : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        decimal DonID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
                if (DonID == 0)
                {
                    Response.Redirect("/Login.aspx");
                }
            }
        }

        protected void cmdTraLai_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtLyDoTra.Text))
            {
                lbthongbao.Text = "Bạn chưa nhập lý do trả. Hãy nhập lại!";
                txtLyDoTra.Focus();
                return;
            }
            else
            {
                DonID = String.IsNullOrEmpty(Request["ID"] + "") ? 0 : Convert.ToDecimal(Request["ID"] + "");
                //Thêm vào DON_GUINHAN_LICHSU
                DON_GUINHAN_LICHSU ls = new DON_GUINHAN_LICHSU();
                ls.ID_VBDH = DonID;
                ls.THAOTAC = 2;
                ls.LYDOTRA = txtLyDoTra.Text;
                ls.NGAYTAO = DateTime.Now;
                ls.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.DON_GUINHAN_LICHSU.Add(ls);
                //Cập nhật lại trạng thái DON_GUINHAN
                DON_GUINHAN don = dt.DON_GUINHAN.Where(x => x.ID == DonID).FirstOrDefault();
                don.TRANGTHAI = 0;
                don.NGAYSUA = DateTime.Now;
                don.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
                Response.Write("<script>window.close();</" + "script>");
                Response.End();
            }
        }
    }
}