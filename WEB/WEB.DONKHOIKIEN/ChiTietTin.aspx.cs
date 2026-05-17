using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK.DanhMuc;

namespace WEB.DONKHOIKIEN
{
    public partial class ChiTietTin : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!string.IsNullOrEmpty(Request["tID"]))
            {
                int CurrID = 0;
                CurrID = Convert.ToInt32(Request["tID"] + "");
                LoadInfo(CurrID);
            }
        }
        void LoadInfo(decimal ID)
        {
            DONKK_TINTUC oT = dt.DONKK_TINTUC.Where(x => x.ID == ID).FirstOrDefault();
            if (oT == null) return;
            {
                lstTieuDe.Text = oT.TIEUDE;
                lstTrichDan.Text = oT.TRICHDAN;
                lstNoiDung.Text = oT.NOIDUNG;
            }
        }
    }
}