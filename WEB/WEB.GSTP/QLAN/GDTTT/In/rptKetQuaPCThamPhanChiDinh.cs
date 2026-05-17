using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.In
{
    public partial class rptKetQuaPCThamPhanChiDinh : DevExpress.XtraReports.UI.XtraReport
    {
        public rptKetQuaPCThamPhanChiDinh()
        {
            InitializeComponent();
        }
        private string getTenToa(string strTenToa)
        {
            try
            {
                if (strTenToa.Contains("CẤP CAO"))
                {
                    strTenToa = strTenToa.Replace("CẤP CAO", "CẤP CAO\n");
                }

                return strTenToa;
            }
            catch { return ""; }
        }
        private void xrTableCell12_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell12.Text = getTenToa(xrTableCell12.Text.ToUpper());
        }
    }
}
