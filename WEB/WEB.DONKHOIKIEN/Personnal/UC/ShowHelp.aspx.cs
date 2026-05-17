using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using DAL.DKK;
using BL.DonKK.DanhMuc;

namespace WEB.DONKHOIKIEN.Personnal.UC
{
    public partial class ShowHelp : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        protected void Page_Load(object sender, EventArgs e)
        {
           
                LoadInfo();
        }
        void LoadInfo()
        {
            try
            {
                String PageCode = Request["ma"].ToString().ToLower();
                DONKK_TINTUC oT = dt.DONKK_TINTUC.Where(x => x.PAGECODE.ToLower() == PageCode).FirstOrDefault();
                if (oT != null)
                {
                    lstTieuDe.Text = oT.TIEUDE;
                    lstTrichDan.Text = oT.TRICHDAN;
                    lstNoiDung.Text = oT.NOIDUNG;
                }
            }catch(Exception ex) { }
        }
    }
}