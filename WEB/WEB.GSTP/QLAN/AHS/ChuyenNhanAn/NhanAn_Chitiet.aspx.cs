using BL.GSTP;
using Module.Common;
using System;
using System.Data;

namespace WEB.GSTP.QLAN.AHS.ChuyenNhanAn
{
    public partial class NhanAn_Chitiet : System.Web.UI.Page
    {
        public static Decimal VuAnID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            VuAnID = (String.IsNullOrEmpty(Request["vuanid"] + "")) ? 0 : Convert.ToDecimal(Request["vuanid"] + "");
            Load_CHITIET(VuAnID);
        }

        private void Load_CHITIET(decimal VuAnID_)
        {
            TongHop_BL oBL = new TongHop_BL();
            string current_id = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            decimal ID = Convert.ToDecimal(current_id);
            DataTable tbl = oBL.HS_NHANAN_CHITIET(VuAnID_);
            DataRow row = tbl.NewRow();
            //-----------

            if (tbl != null && tbl.Rows.Count > 0)
            {
                row = tbl.Rows[0];
                lttChitiet.Text = row["TEXT_REPORT"] + "";
            }
        }
    }
}