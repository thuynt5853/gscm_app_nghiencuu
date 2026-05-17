using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using BL.DonKK;
using System.Data;
namespace WEB.DONKHOIKIEN.UserControl
{
    public partial class TraCuu_Gray : System.Web.UI.UserControl
    {
        Decimal UserID = 0;
        String Email = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            CheckQuyen();
            CountVBTongDatMoi();
        }
        void CountVBTongDatMoi()
        {
            UserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");

            if (UserID > 0)
            {
                //pnVBMoi.Visible = true;
                DonKK_VBTongDat_BL objBL = new DonKK_VBTongDat_BL();
                DataTable tbl = objBL.CountByTrangThaiDoc(UserID, ENUM_ISREAD.CHUADOC, ENUM_DKNHANVBTONGDAT.KHONGDK);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    //lttCount.Text = tbl.Rows[0]["CountAll"].ToString();
                }
            }
            //else pnVBMoi.Visible = false;
        }
        void CheckQuyen()
        {
            int MucDichSD = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "")) ? 0 : Convert.ToInt16(Session[ENUM_SESSION.SESSION_MUCDICHSD] + "");
            if (MucDichSD == 2)
                pnTaoDKK.Visible = true;
            else
                pnTaoDKK.Visible = false;
        }
    }
}