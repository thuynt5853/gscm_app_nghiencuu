using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.In
{
    public partial class rptNoiBoPhieuchuyen_Toicao : DevExpress.XtraReports.UI.XtraReport
    {
        public rptNoiBoPhieuchuyen_Toicao()
        {
            InitializeComponent();
        }

        private void xrTableCell12_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell12.Text = xrTableCell12.Text.ToUpper();
        }

        private void xrTableCell12_BeforePrint_1(object sender, CancelEventArgs e)
        {
            xrTableCell12.Text = xrTableCell12.Text.ToUpper();
        }

        private void xrTableCell1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell1.Text = xrTableCell1.Text.ToUpper();
        }
        
        private void xrTableCell8_BeforePrint(object sender, CancelEventArgs e)
        {
            string strChucVu = GetCurrentColumnValue("CHUCVU") + "";
            if (strChucVu.ToLower() == "chánh văn phòng")
            {
                xrTableCell8.Text = "TL. CHÁNH ÁN\r\n CHÁNH VĂN PHÒNG";
            }
            else
            {
                xrTableCell8.Text = "TL. CHÁNH ÁN\r\nKT. CHÁNH VĂN PHÒNG\r\nPHÓ CHÁNH VĂN PHÒNG";
            }
        }
    }
}
