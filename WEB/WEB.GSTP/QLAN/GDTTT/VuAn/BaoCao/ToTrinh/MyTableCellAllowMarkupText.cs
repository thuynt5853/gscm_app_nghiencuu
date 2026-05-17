using DevExpress.XtraReports.UI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.ToTrinh
{
    public class MyTableCellAllowMarkupText : XRTableCell
    {
        public MyTableCellAllowMarkupText()
        {
            this.AllowMarkupText = true; // cho phép hiển thị HTML markup
        }
    }
}