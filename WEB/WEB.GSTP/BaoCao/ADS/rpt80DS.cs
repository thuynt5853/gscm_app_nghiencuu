using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt80DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt80DS()
        {
            InitializeComponent();
        }

        private void xrLabel4_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel4.Text = xrLabel4.Text.ToUpper();
        }

        private void xrTableCell36_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell36.Text = xrTableCell36.Text.Replace("Ông", "").Replace("Bà", "");
        }

        private void DetailReport2_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport2.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable5.Visible = false;
                xrTable7.Visible = false;
            }
        }

        private void DetailReport7_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport7.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable12.Visible = false;
                xrTable15.Visible = false;
            }
        }

        private void xrTableCell4_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell4.Text = xrTableCell4.Text.ToUpper();
        }

        private void DetailReport_ThamPhan_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_ThamPhan.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                GroupHeader_ThamPhan.Visible = false;
                Detail_ThamPhan.Visible = false;
            }
        }

        private void DetailReport_ThuKy_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("THUKY") + ""))
            {
                DetailReport_ThuKy.Visible = false;
            }
        }

        private void DetailReport_KSV_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_KSV.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                GroupHeader_KSV.Visible = false;
                Detail_KSV.Visible = false;
            }
        }
    }
}
