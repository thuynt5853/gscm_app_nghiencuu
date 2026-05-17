using BL.GSTP.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.GSTP.HoatDongCongBoBAQD
{
    public partial class BAQDDaCongBo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

            if (!IsPostBack)
            {
                GSTP_APP_BL oBL = new GSTP_APP_BL();
                DataTable tbl = new DataTable();
                DataRow row = tbl.NewRow();
                //-------------
                tbl = oBL.Get_TP_CongBBA(Session[ENUM_LOAIAN.AN_GSTP] + "", null, null);
                //-----------
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    row = tbl.Rows[0];
                    li_DSTP_CBBA.Text = row["TEXT_REPORT"] + "";
                }
            }
        }
    }
}