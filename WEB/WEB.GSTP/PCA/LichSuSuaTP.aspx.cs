using BL.GSTP.PCTP;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.PCA
{
    public partial class LichSuSuaTP : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {              
                Load_Data();
            }
        }
        private void Load_Data()
        {
            PCANN_BL pca = new PCANN_BL();
            decimal pcaID = Convert.ToInt32(Request["pcaid"]);
            DataTable tbl = pca.PCANN_LICHSU_SUATP(pcaID);
            if(tbl.Rows.Count > 0)
            {
                dgList.PageSize = Convert.ToInt32(tbl.Rows.Count);
                dgList.CurrentPageIndex = 0;
            }          
            dgList.DataSource = tbl;
            dgList.DataBind();
        }
    }
}