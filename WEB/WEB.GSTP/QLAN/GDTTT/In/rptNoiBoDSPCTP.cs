using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.In
{
    public partial class rptNoiBoDSPCTP : DevExpress.XtraReports.UI.XtraReport
    {
        public rptNoiBoDSPCTP()
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

        private void GroupHeader2_BeforePrint(object sender, CancelEventArgs e)
        {
          
          
        }

        private void xrTable8_BeforePrint(object sender, CancelEventArgs e)
        {
            //xrTableCell14.Text = xrRichText1.Text;
            //xrTableCell1.Text = xrRichText2.Text;
            //xrRichText1.Visible = false;
            //xrRichText2.Visible = false;
        }

        private void xrTableCell7_BeforePrint(object sender, CancelEventArgs e)
        {
            //xrTableCell7.Text = xrRichText3.Text;
            //xrRichText3.Visible = false;
        }

        private void rptNoiBoDSPCTP_AfterPrint(object sender, EventArgs e)
        {
            
        }

        private void xrTableCell68_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell68.Text = System.Web.HttpUtility.HtmlDecode(xrTableCell68.Text);
        }
    }
}
